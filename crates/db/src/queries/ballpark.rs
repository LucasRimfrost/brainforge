use shared::error::{AppError, AppResult};
use sqlx::PgPool;
use uuid::Uuid;

use crate::models::{
    BallparkArchiveRow, BallparkBestGuess, BallparkChallenge, BallparkChallengeHistory,
    BallparkStats, BallparkSubmission, BallparkSubmitOutcome, Difficulty, Feedback, LeaderboardRow,
};

// ── Ballpark challenges ─────────────────────────────────────────────────────

/// Finds the ballpark challenge scheduled for a given date.
///
/// Returns the full row including the answer; callers must apply the
/// `scheduled_date <= today` filter and never send the answer before reveal.
#[tracing::instrument(skip(pool))]
pub async fn find_ballpark_challenge_by_date(
    pool: &PgPool,
    scheduled_date: chrono::NaiveDate,
) -> AppResult<Option<BallparkChallenge>> {
    let result = sqlx::query_as!(
        BallparkChallenge,
        r#"
        SELECT id, title, question, unit, answer, decimals, tolerance_pct,
               difficulty as "difficulty: Difficulty",
               explanation, source_url, max_attempts,
               scheduled_date, created_at
        FROM ballpark_challenges
        WHERE scheduled_date = $1
        "#,
        scheduled_date,
    )
    .fetch_optional(pool)
    .await
    .map_err(AppError::from)?;

    tracing::debug!(
        found = result.is_some(),
        %scheduled_date,
        "ballpark challenge lookup by date"
    );
    Ok(result)
}

/// Finds a ballpark challenge by its primary key.
///
/// Returns the full row including the answer; callers must apply the
/// `scheduled_date <= today` filter and never send the answer before reveal.
#[tracing::instrument(skip(pool))]
pub async fn find_ballpark_challenge_by_id(
    pool: &PgPool,
    id: Uuid,
) -> AppResult<Option<BallparkChallenge>> {
    let result = sqlx::query_as!(
        BallparkChallenge,
        r#"
        SELECT id, title, question, unit, answer, decimals, tolerance_pct,
               difficulty as "difficulty: Difficulty",
               explanation, source_url, max_attempts,
               scheduled_date, created_at
        FROM ballpark_challenges
        WHERE id = $1
        "#,
        id
    )
    .fetch_optional(pool)
    .await
    .map_err(AppError::from)?;

    tracing::debug!(found = result.is_some(), "ballpark challenge lookup by id");
    Ok(result)
}

// ── Ballpark submissions ────────────────────────────────────────────────────

/// Returns a user's guesses for a ballpark challenge, in attempt order.
#[tracing::instrument(skip(pool))]
pub async fn find_ballpark_submissions(
    pool: &PgPool,
    user_id: Uuid,
    challenge_id: Uuid,
) -> AppResult<Vec<BallparkSubmission>> {
    let results = sqlx::query_as!(
        BallparkSubmission,
        r#"
        SELECT guess, feedback as "feedback: Feedback", error_pct, attempt_number
        FROM ballpark_submissions
        WHERE user_id = $1 AND challenge_id = $2
        ORDER BY attempt_number
        "#,
        user_id,
        challenge_id
    )
    .fetch_all(pool)
    .await
    .map_err(AppError::from)?;

    tracing::debug!(count = results.len(), "fetched ballpark submissions");
    Ok(results)
}

/// Atomically validates attempt limits and records a ballpark guess.
///
/// Uses a transaction with a row lock on the **user** (never the shared
/// challenge row) to serialise that user's concurrent requests, so the
/// attempt limit and the duplicate check can't be bypassed. Also increments
/// the user's attempt counter and, when `solved_date` is provided, upserts
/// their streak / solve stats.
///
/// When the guess finishes the challenge (it is correct or uses the last
/// attempt), the outcome also carries the user's closest guess.
///
/// # Errors
///
/// Returns [`AppError::BadRequest`] if the challenge is already solved, the
/// maximum number of attempts has been reached, or the same value was
/// already guessed (no attempt is used in that case).
#[allow(clippy::too_many_arguments)]
#[tracing::instrument(skip(pool, guess))]
pub async fn create_ballpark_submission_atomic(
    pool: &PgPool,
    user_id: Uuid,
    challenge_id: Uuid,
    guess: f64,
    feedback: Feedback,
    error_pct: f64,
    max_attempts: i32,
    solved_date: Option<chrono::NaiveDate>,
) -> AppResult<BallparkSubmitOutcome> {
    let mut tx = pool.begin().await.map_err(AppError::from)?;

    // Lock the user's row to serialise this user's concurrent submissions.
    // Locking the shared challenge row instead would serialise every user's
    // submissions to the daily challenge. `NO KEY UPDATE` doesn't block
    // foreign-key checks from other inserts referencing the user.
    let locked = sqlx::query_scalar!(
        "SELECT id FROM users WHERE id = $1 FOR NO KEY UPDATE",
        user_id
    )
    .fetch_optional(&mut *tx)
    .await
    .map_err(AppError::from)?;

    if locked.is_none() {
        return Err(AppError::NotFound);
    }

    // Aggregate the existing submissions *inside* the transaction.
    let existing = sqlx::query!(
        r#"
        SELECT count(*) as "count!",
               COALESCE(bool_or(is_correct), false) as "solved!",
               COALESCE(bool_or(guess = $3), false) as "duplicate!"
        FROM ballpark_submissions
        WHERE user_id = $1 AND challenge_id = $2
        "#,
        user_id,
        challenge_id,
        guess,
    )
    .fetch_one(&mut *tx)
    .await
    .map_err(AppError::from)?;

    if existing.solved {
        return Err(AppError::BadRequest("Challenge already solved".into()));
    }

    if existing.count >= i64::from(max_attempts) {
        return Err(AppError::BadRequest("No attempts remaining".into()));
    }

    if existing.duplicate {
        return Err(AppError::BadRequest("You already guessed that".into()));
    }

    let attempt_number = existing.count as i32 + 1;

    sqlx::query!(
        r#"
        INSERT INTO ballpark_submissions (user_id, challenge_id, guess,
                                          feedback, error_pct, attempt_number)
        VALUES ($1, $2, $3, $4, $5, $6)
        "#,
        user_id,
        challenge_id,
        guess,
        feedback.as_str(),
        error_pct,
        attempt_number,
    )
    .execute(&mut *tx)
    .await
    .map_err(AppError::from)?;

    // Increment lifetime attempt counter.
    sqlx::query!(
        r#"
        INSERT INTO ballpark_stats (user_id, total_attempts)
        VALUES ($1, 1)
        ON CONFLICT (user_id) DO UPDATE SET
            total_attempts = ballpark_stats.total_attempts + 1
        "#,
        user_id,
    )
    .execute(&mut *tx)
    .await
    .map_err(AppError::from)?;

    // Update streak / solve stats when today's challenge is solved.
    if let Some(date) = solved_date {
        sqlx::query!(
            r#"
            INSERT INTO ballpark_stats (user_id, current_streak, longest_streak, total_solved, last_solved_date)
            VALUES ($1, 1, 1, 1, $2)
            ON CONFLICT (user_id) DO UPDATE SET
                current_streak = CASE
                    WHEN ballpark_stats.last_solved_date = $2 THEN ballpark_stats.current_streak
                    WHEN ballpark_stats.last_solved_date = $2 - 1 THEN ballpark_stats.current_streak + 1
                    ELSE 1
                END,
                longest_streak = GREATEST(
                    ballpark_stats.longest_streak,
                    CASE
                        WHEN ballpark_stats.last_solved_date = $2 THEN ballpark_stats.current_streak
                        WHEN ballpark_stats.last_solved_date = $2 - 1 THEN ballpark_stats.current_streak + 1
                        ELSE 1
                    END
                ),
                total_solved = CASE
                    WHEN ballpark_stats.last_solved_date = $2 THEN ballpark_stats.total_solved
                    ELSE ballpark_stats.total_solved + 1
                END,
                last_solved_date = $2
            "#,
            user_id,
            date,
        )
        .execute(&mut *tx)
        .await
        .map_err(AppError::from)?;
    }

    let is_correct = feedback == Feedback::Within;
    let finished = is_correct || attempt_number >= max_attempts;

    let best = if finished {
        let best = sqlx::query_as!(
            BallparkBestGuess,
            r#"
            SELECT guess, error_pct
            FROM ballpark_submissions
            WHERE user_id = $1 AND challenge_id = $2
            ORDER BY error_pct ASC, attempt_number ASC
            LIMIT 1
            "#,
            user_id,
            challenge_id,
        )
        .fetch_one(&mut *tx)
        .await
        .map_err(AppError::from)?;
        Some(best)
    } else {
        None
    };

    tx.commit().await.map_err(AppError::from)?;

    tracing::info!(
        %user_id,
        %challenge_id,
        is_correct,
        attempt_number,
        "ballpark submission recorded (atomic)"
    );
    Ok(BallparkSubmitOutcome {
        attempt_number,
        best,
    })
}

// ── Ballpark history ────────────────────────────────────────────────────────

/// Returns a user's progress per ballpark challenge up to `today`, most
/// recent first.
///
/// `best_error_pct` is only returned for finished challenges (solved or out
/// of attempts), so history never reveals closeness before the reveal.
#[tracing::instrument(skip(pool))]
pub async fn find_ballpark_history(
    pool: &PgPool,
    user_id: Uuid,
    today: chrono::NaiveDate,
    limit: i64,
) -> AppResult<Vec<BallparkChallengeHistory>> {
    let results = sqlx::query_as!(
        BallparkChallengeHistory,
        r#"
        SELECT c.id as challenge_id, c.title,
               c.difficulty as "difficulty: Difficulty",
               c.scheduled_date,
               bool_or(s.is_correct) as "is_correct!",
               max(s.attempt_number) as "attempt_number!",
               max(s.submitted_at) as "submitted_at!",
               CASE
                   WHEN bool_or(s.is_correct) OR count(*) >= c.max_attempts
                   THEN min(s.error_pct)
               END as "best_error_pct?"
        FROM ballpark_submissions s
        JOIN ballpark_challenges c ON c.id = s.challenge_id
        WHERE s.user_id = $1 AND c.scheduled_date <= $2
        GROUP BY c.id
        ORDER BY c.scheduled_date DESC
        LIMIT $3
        "#,
        user_id,
        today,
        limit
    )
    .fetch_all(pool)
    .await
    .map_err(AppError::from)?;

    tracing::debug!(count = results.len(), "fetched ballpark history");
    Ok(results)
}

// ── Ballpark stats ──────────────────────────────────────────────────────────

/// Returns the ballpark stats row for a user, if one exists.
#[tracing::instrument(skip(pool))]
pub async fn find_ballpark_stats(pool: &PgPool, user_id: Uuid) -> AppResult<Option<BallparkStats>> {
    let result = sqlx::query_as!(
        BallparkStats,
        r#"
        SELECT user_id, current_streak, longest_streak,
               total_solved, total_attempts, last_solved_date
        FROM ballpark_stats
        WHERE user_id = $1
        "#,
        user_id
    )
    .fetch_optional(pool)
    .await
    .map_err(AppError::from)?;

    tracing::debug!(found = result.is_some(), "ballpark stats lookup");
    Ok(result)
}

// ── Ballpark leaderboard ────────────────────────────────────────────────────

/// Returns the top ballpark players ranked by current streak, then total solved.
#[tracing::instrument(skip(pool))]
pub async fn find_ballpark_leaderboard(
    pool: &PgPool,
    limit: i64,
) -> AppResult<Vec<LeaderboardRow>> {
    let results = sqlx::query_as!(
        LeaderboardRow,
        r#"
        SELECT u.username, s.current_streak, s.longest_streak, s.total_solved
        FROM ballpark_stats s
        JOIN users u ON u.id = s.user_id
        ORDER BY s.current_streak DESC, s.total_solved DESC
        LIMIT $1
        "#,
        limit
    )
    .fetch_all(pool)
    .await
    .map_err(AppError::from)?;

    tracing::debug!(count = results.len(), "fetched ballpark leaderboard");
    Ok(results)
}

// ── Ballpark archive ────────────────────────────────────────────────────────

/// Returns all ballpark challenges scheduled before `today`, annotated with
/// the user's solve status and attempt count.
#[tracing::instrument(skip(pool))]
pub async fn find_ballpark_past_challenges(
    pool: &PgPool,
    user_id: Uuid,
    today: chrono::NaiveDate,
) -> AppResult<Vec<BallparkArchiveRow>> {
    let results = sqlx::query_as!(
        BallparkArchiveRow,
        r#"
        SELECT c.id, c.title,
               c.difficulty as "difficulty: Difficulty",
               c.scheduled_date, c.max_attempts,
               COALESCE(bool_or(s.is_correct), false) as "is_solved!",
               COUNT(s.id) as "attempts_used!"
        FROM ballpark_challenges c
        LEFT JOIN ballpark_submissions s ON s.challenge_id = c.id AND s.user_id = $1
        WHERE c.scheduled_date < $2
        GROUP BY c.id
        ORDER BY c.scheduled_date DESC
        LIMIT 365
        "#,
        user_id,
        today
    )
    .fetch_all(pool)
    .await
    .map_err(AppError::from)?;

    tracing::debug!(count = results.len(), "fetched ballpark past challenges");
    Ok(results)
}

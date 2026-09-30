//! Ballpark: a daily estimation game. The player guesses a number, learns
//! whether the answer is higher or lower, and wins by landing within the
//! challenge's tolerance.
//!
//! Leak contract: before the reveal (solved or out of attempts), no response
//! contains the answer, the tolerance bounds or any per-guess distance —
//! only `too_low` / `too_high` / `within`, plus the magnitude hint once it
//! unlocks.

use axum::{
    Json, Router,
    extract::{Path, Query, State},
    http::StatusCode,
    response::IntoResponse,
    routing::{get, post},
};
use chrono::{NaiveDate, Utc};
use db::{
    models::{BallparkChallenge, Difficulty, Feedback},
    queries::{
        create_ballpark_submission_atomic, find_ballpark_challenge_by_date,
        find_ballpark_challenge_by_id, find_ballpark_history, find_ballpark_past_challenges,
        find_ballpark_submissions,
    },
};
use serde::{Deserialize, Serialize};
use shared::error::{AppError, AppResult};
use uuid::Uuid;
use validator::Validate;

use crate::{AppState, middleware::AuthUser};

/// Number of unsolved attempts after which the magnitude hint is revealed.
const HINT_AFTER_ATTEMPTS: i32 = 2;

/// Largest accepted guess. A global constant, never derived from the answer.
const MAX_GUESS: f64 = 1e15;

/// Maximum digits before / after the decimal point in a guess.
const MAX_INT_DIGITS: usize = 16;
const MAX_FRAC_DIGITS: usize = 6;

/// Relative slack on the tolerance comparison, so binary floating-point
/// representation error can't flip a guess that is exactly on the boundary.
const TOLERANCE_EPSILON: f64 = 1e-9;

// ── Request types ──────────────────────────────────────────────────────────

/// Payload for `POST /ballpark/submit`.
///
/// `guess` is a JSON string (not a number) so that every malformed number
/// goes through [`parse_guess`] and gets a stable 422 message.
#[derive(Deserialize, Validate)]
pub struct SubmitRequest {
    pub challenge_id: Uuid,
    #[validate(length(min = 1, max = 32, message = "Guess must be 1 to 32 characters"))]
    pub guess: String,
}

// ── Response types ──────────────────────────────────────────────────────────

/// Where the user stands on a challenge.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize)]
#[serde(rename_all = "snake_case")]
pub enum ChallengeStatus {
    InProgress,
    Solved,
    Failed,
}

/// One of the user's guesses. Deliberately has no distance / error field.
#[derive(Serialize)]
pub struct GuessView {
    pub value: f64,
    pub feedback: Feedback,
}

/// Order-of-magnitude band containing the answer: `low <= answer < high`.
#[derive(Debug, PartialEq, Serialize)]
pub struct Hint {
    pub low: f64,
    pub high: f64,
}

/// Everything about the answer. Only sent once the challenge is finished.
#[derive(Serialize)]
pub struct Reveal {
    pub answer: f64,
    pub best_guess: f64,
    pub best_error_pct: f64,
    pub explanation: String,
    pub source_url: Option<String>,
}

/// Full challenge view returned to the client, including user progress.
#[derive(Serialize)]
pub struct ChallengeView {
    pub id: Uuid,
    pub title: String,
    pub question: String,
    pub unit: String,
    pub difficulty: Difficulty,
    pub decimals: i16,
    pub tolerance_pct: f64,
    pub max_attempts: i32,
    pub scheduled_date: NaiveDate,
    pub attempts_used: i32,
    pub is_solved: bool,
    pub status: ChallengeStatus,
    pub guesses: Vec<GuessView>,
    pub hint: Option<Hint>,
    pub reveal: Option<Reveal>,
}

/// Outcome of a guess.
#[derive(Serialize)]
pub struct SubmitResponse {
    pub feedback: Feedback,
    pub is_correct: bool,
    pub attempt_number: i32,
    pub attempts_remaining: i32,
    /// Set after the second unsolved guess while attempts remain.
    pub hint: Option<Hint>,
    /// Set when this guess solved the challenge or used the last attempt.
    pub reveal: Option<Reveal>,
}

/// Optional query parameters for the history endpoint.
#[derive(Deserialize)]
pub struct HistoryParams {
    pub limit: Option<i64>,
}

/// Summary of a past ballpark challenge for the archive view.
#[derive(Serialize)]
pub struct ArchiveEntry {
    pub id: Uuid,
    pub title: String,
    pub difficulty: Difficulty,
    pub scheduled_date: NaiveDate,
    pub is_solved: bool,
    pub attempts_used: i32,
    pub max_attempts: i32,
}

// ── Router ──────────────────────────────────────────────────────────

/// Mounts ballpark routes: `today`, `submit`, `history`, `archive`, `{date}`.
pub fn router() -> Router<AppState> {
    Router::new()
        .route("/today", get(today))
        .route("/submit", post(submit))
        .route("/history", get(history))
        .route("/archive", get(archive))
        .route("/{date}", get(by_date))
}

// ── Handlers ──────────────────────────────────────────────────────────

/// GET /api/v1/ballpark/today
pub async fn today(
    State(state): State<AppState>,
    auth_user: AuthUser,
) -> AppResult<impl IntoResponse> {
    let today = Utc::now().date_naive();

    tracing::debug!(user_id = %auth_user.id, %today, "fetching today's ballpark challenge");

    let view = build_view(&state, auth_user.id, today, today).await?;

    Ok((StatusCode::OK, Json(view)))
}

/// GET /api/v1/ballpark/:date
pub async fn by_date(
    State(state): State<AppState>,
    auth_user: AuthUser,
    Path(date): Path<NaiveDate>,
) -> AppResult<impl IntoResponse> {
    let today = Utc::now().date_naive();

    tracing::debug!(user_id = %auth_user.id, %date, "fetching ballpark by date");

    let view = build_view(&state, auth_user.id, date, today).await?;

    Ok((StatusCode::OK, Json(view)))
}

/// POST /api/v1/ballpark/submit
pub async fn submit(
    State(state): State<AppState>,
    auth_user: AuthUser,
    Json(payload): Json<SubmitRequest>,
) -> AppResult<impl IntoResponse> {
    payload.validate()?;
    let parsed = parse_guess(&payload.guess)?;

    let user_id = auth_user.id;
    let challenge_id = payload.challenge_id;

    tracing::info!(
        user_id = %user_id,
        challenge_id = %challenge_id,
        "ballpark submission attempt"
    );

    let today = Utc::now().date_naive();

    // Future challenges are treated as nonexistent until their scheduled date.
    let challenge = find_ballpark_challenge_by_id(&state.pool, challenge_id)
        .await?
        .filter(|c| c.scheduled_date <= today)
        .ok_or_else(|| {
            tracing::warn!(challenge_id = %challenge_id, "ballpark challenge not found");
            AppError::NotFound
        })?;

    let guess = round_to_decimals(parsed, decimals_of(&challenge));
    let (feedback, error_pct) = judge(guess, &challenge);
    let is_correct = feedback == Feedback::Within;

    let solved_date = (is_correct && challenge.scheduled_date == today).then_some(today);

    // Atomic check-and-insert: locks the user row so concurrent requests
    // cannot bypass the attempt limit or the duplicate check.
    let outcome = create_ballpark_submission_atomic(
        &state.pool,
        user_id,
        challenge.id,
        guess,
        feedback,
        error_pct,
        challenge.max_attempts,
        solved_date,
    )
    .await?;

    let attempt_number = outcome.attempt_number;
    let attempts_remaining = (challenge.max_attempts - attempt_number).max(0);

    let hint = (!is_correct && attempt_number >= HINT_AFTER_ATTEMPTS && attempts_remaining > 0)
        .then(|| magnitude_hint(challenge.answer));

    let reveal = outcome
        .best
        .filter(|_| is_correct || attempts_remaining == 0)
        .map(|best| Reveal {
            answer: challenge.answer,
            best_guess: best.guess,
            best_error_pct: best.error_pct,
            explanation: challenge.explanation,
            source_url: challenge.source_url,
        });

    Ok((
        StatusCode::OK,
        Json(SubmitResponse {
            feedback,
            is_correct,
            attempt_number,
            attempts_remaining,
            hint,
            reveal,
        }),
    ))
}

/// GET /api/v1/ballpark/history
pub async fn history(
    State(state): State<AppState>,
    auth_user: AuthUser,
    Query(params): Query<HistoryParams>,
) -> AppResult<impl IntoResponse> {
    let limit = params.limit.unwrap_or(30).clamp(1, 100);
    let today = Utc::now().date_naive();

    tracing::debug!(user_id = %auth_user.id, limit, "fetching ballpark history");

    let history = find_ballpark_history(&state.pool, auth_user.id, today, limit).await?;

    Ok((StatusCode::OK, Json(history)))
}

/// GET /api/v1/ballpark/archive
pub async fn archive(
    State(state): State<AppState>,
    auth_user: AuthUser,
) -> AppResult<impl IntoResponse> {
    let today = Utc::now().date_naive();

    tracing::debug!(user_id = %auth_user.id, "fetching ballpark archive");

    let rows = find_ballpark_past_challenges(&state.pool, auth_user.id, today).await?;

    let entries: Vec<ArchiveEntry> = rows
        .into_iter()
        .map(|r| ArchiveEntry {
            id: r.id,
            title: r.title,
            difficulty: r.difficulty,
            scheduled_date: r.scheduled_date,
            is_solved: r.is_solved,
            attempts_used: r.attempts_used as i32,
            max_attempts: r.max_attempts,
        })
        .collect();

    Ok((StatusCode::OK, Json(entries)))
}

// ── View building ───────────────────────────────────────────────────────────

/// Builds the challenge view for `date`, shared by `today` and `by_date` so
/// there is exactly one future-date filter.
async fn build_view(
    state: &AppState,
    user_id: Uuid,
    date: NaiveDate,
    today: NaiveDate,
) -> AppResult<ChallengeView> {
    // Future challenges are treated as nonexistent until their scheduled date.
    let challenge = find_ballpark_challenge_by_date(&state.pool, date)
        .await?
        .filter(|c| c.scheduled_date <= today)
        .ok_or_else(|| {
            tracing::warn!(%date, "no ballpark challenge found for date");
            AppError::NotFound
        })?;

    let submissions = find_ballpark_submissions(&state.pool, user_id, challenge.id).await?;

    let attempts_used = submissions.len() as i32;
    let is_solved = submissions.iter().any(|s| s.feedback == Feedback::Within);
    let status = if is_solved {
        ChallengeStatus::Solved
    } else if attempts_used >= challenge.max_attempts {
        ChallengeStatus::Failed
    } else {
        ChallengeStatus::InProgress
    };

    let hint = (status == ChallengeStatus::InProgress && attempts_used >= HINT_AFTER_ATTEMPTS)
        .then(|| magnitude_hint(challenge.answer));

    let reveal = if status == ChallengeStatus::InProgress {
        None
    } else {
        // Closest guess; ties go to the earliest attempt (submissions are in
        // attempt order and `min_by` keeps the first minimum).
        submissions
            .iter()
            .min_by(|a, b| a.error_pct.total_cmp(&b.error_pct))
            .map(|best| Reveal {
                answer: challenge.answer,
                best_guess: best.guess,
                best_error_pct: best.error_pct,
                explanation: challenge.explanation.clone(),
                source_url: challenge.source_url.clone(),
            })
    };

    let guesses = submissions
        .iter()
        .map(|s| GuessView {
            value: s.guess,
            feedback: s.feedback,
        })
        .collect();

    Ok(ChallengeView {
        id: challenge.id,
        title: challenge.title,
        question: challenge.question,
        unit: challenge.unit,
        difficulty: challenge.difficulty,
        decimals: challenge.decimals,
        tolerance_pct: challenge.tolerance_pct,
        max_attempts: challenge.max_attempts,
        scheduled_date: challenge.scheduled_date,
        attempts_used,
        is_solved,
        status,
        guesses,
        hint,
        reveal,
    })
}

// ── Game rules (pure functions) ─────────────────────────────────────────────

/// Strictly parses a guess: `^[0-9]{1,16}(\.[0-9]{1,6})?$`, finite and
/// `<= 1e15`. Everything else (`NaN`, `inf`, `1e5`, `-3`, `""`, separators)
/// is rejected with 422.
fn parse_guess(raw: &str) -> AppResult<f64> {
    const INVALID: &str =
        "Guess must be a plain number: digits with an optional decimal point and up to 6 decimals";

    let (int_part, frac_part) = match raw.split_once('.') {
        Some((i, f)) => (i, Some(f)),
        None => (raw, None),
    };

    let all_digits = |s: &str| s.bytes().all(|b| b.is_ascii_digit());

    let int_ok = (1..=MAX_INT_DIGITS).contains(&int_part.len()) && all_digits(int_part);
    let frac_ok =
        frac_part.is_none_or(|f| (1..=MAX_FRAC_DIGITS).contains(&f.len()) && all_digits(f));

    if !int_ok || !frac_ok {
        return Err(AppError::UnprocessableEntity(INVALID.to_string()));
    }

    let value: f64 = raw
        .parse()
        .map_err(|_| AppError::UnprocessableEntity(INVALID.to_string()))?;

    if !value.is_finite() {
        return Err(AppError::UnprocessableEntity(INVALID.to_string()));
    }

    if value > MAX_GUESS {
        return Err(AppError::UnprocessableEntity(
            "Guess must not exceed 1,000,000,000,000,000".to_string(),
        ));
    }

    Ok(value)
}

/// The challenge's display precision, clamped to the DB's 0–3 range.
fn decimals_of(c: &BallparkChallenge) -> u32 {
    c.decimals.clamp(0, 3) as u32
}

/// Rounds half away from zero to `decimals` places, in decimal (not binary)
/// arithmetic, so `312.45` at 1 decimal becomes `312.5` as a person expects.
///
/// Works on the shortest round-trip decimal form of `value` (Rust's `Display`
/// for `f64` never uses exponent notation) and re-parses the rounded string,
/// so equal inputs always produce the identical `f64` (the duplicate check
/// relies on this).
fn round_to_decimals(value: f64, decimals: u32) -> f64 {
    let s = value.to_string();
    let (int_part, frac_part) = s.split_once('.').unwrap_or((&s, ""));
    let d = decimals as usize;

    if frac_part.len() <= d {
        return value;
    }

    let mut digits: Vec<u8> = int_part
        .bytes()
        .chain(frac_part.bytes().take(d))
        .map(|b| b - b'0')
        .collect();

    if frac_part.as_bytes()[d] >= b'5' {
        let mut i = digits.len();
        loop {
            if i == 0 {
                digits.insert(0, 1);
                break;
            }
            i -= 1;
            if digits[i] == 9 {
                digits[i] = 0;
            } else {
                digits[i] += 1;
                break;
            }
        }
    }

    let int_len = digits.len() - d;
    let mut out = String::with_capacity(digits.len() + 1);
    for (i, digit) in digits.iter().enumerate() {
        if i == int_len {
            out.push('.');
        }
        out.push(char::from(b'0' + digit));
    }

    out.parse().unwrap_or(value)
}

/// Judges a (rounded) guess against the challenge.
///
/// `within ⇔ |g − a| ≤ max(a·p/100, 0.5·10^-decimals)`; otherwise `too_low`
/// when `g < a` and `too_high` when `g > a`. The half-unit floor means typing
/// the displayed answer always wins, even for small answers. Returns the
/// feedback and `error_pct = |g − a| / a × 100`.
fn judge(guess: f64, c: &BallparkChallenge) -> (Feedback, f64) {
    let answer = c.answer;
    let diff = (guess - answer).abs();
    let half_unit = 0.5 * 10f64.powi(-(decimals_of(c) as i32));
    let tolerance = (answer * c.tolerance_pct / 100.0).max(half_unit);

    let feedback = if diff <= tolerance * (1.0 + TOLERANCE_EPSILON) {
        Feedback::Within
    } else if guess < answer {
        Feedback::TooLow
    } else {
        Feedback::TooHigh
    };

    (feedback, diff / answer * 100.0)
}

/// Order-of-magnitude band `{10^k, 10^(k+1)}` with `k = floor(log10(answer))`.
fn magnitude_hint(answer: f64) -> Hint {
    let pow10 = |k: i32| -> f64 { format!("1e{k}").parse().unwrap_or(f64::NAN) };

    // `log10` can be off by one ulp at exact powers of ten; correct for it.
    let mut k = answer.log10().floor() as i32;
    while k > -20 && pow10(k) > answer {
        k -= 1;
    }
    while k < 20 && pow10(k + 1) <= answer {
        k += 1;
    }

    Hint {
        low: pow10(k),
        high: pow10(k + 1),
    }
}

// ── Unit tests ──────────────────────────────────────────────────────────────

#[cfg(test)]
mod tests {
    use super::*;

    fn challenge(answer: f64, tolerance_pct: f64, decimals: i16) -> BallparkChallenge {
        BallparkChallenge {
            id: Uuid::nil(),
            title: "t".into(),
            question: "q".into(),
            unit: "u".into(),
            answer,
            decimals,
            tolerance_pct,
            difficulty: Difficulty::Easy,
            explanation: "e".into(),
            source_url: None,
            max_attempts: 5,
            scheduled_date: NaiveDate::from_ymd_opt(2026, 1, 1).unwrap(),
            created_at: Utc::now(),
        }
    }

    fn feedback(guess: f64, c: &BallparkChallenge) -> Feedback {
        judge(round_to_decimals(guess, decimals_of(c)), c).0
    }

    #[test]
    fn judge_within_too_low_too_high() {
        let c = challenge(330.0, 10.0, 0);
        assert_eq!(feedback(330.0, &c), Feedback::Within);
        assert_eq!(feedback(312.0, &c), Feedback::Within);
        assert_eq!(feedback(100.0, &c), Feedback::TooLow);
        assert_eq!(feedback(1000.0, &c), Feedback::TooHigh);
    }

    #[test]
    fn judge_exact_boundary_is_inclusive() {
        let c = challenge(100.0, 10.0, 3);
        assert_eq!(feedback(110.0, &c), Feedback::Within);
        assert_eq!(feedback(90.0, &c), Feedback::Within);
        assert_eq!(feedback(110.001, &c), Feedback::TooHigh);
        assert_eq!(feedback(89.999, &c), Feedback::TooLow);

        let c = challenge(4321.5, 10.0, 1);
        assert_eq!(feedback(4753.6, &c), Feedback::Within);
        assert_eq!(feedback(4753.7, &c), Feedback::TooHigh);
        assert_eq!(feedback(3889.4, &c), Feedback::Within);
        assert_eq!(feedback(3889.3, &c), Feedback::TooLow);
    }

    #[test]
    fn judge_half_unit_floor_for_small_answers() {
        // 10% of 8 is 0.8, so 9 is out; the exact answer always wins.
        let c = challenge(8.0, 10.0, 0);
        assert_eq!(feedback(8.0, &c), Feedback::Within);
        assert_eq!(feedback(9.0, &c), Feedback::TooHigh);
        assert_eq!(feedback(7.0, &c), Feedback::TooLow);

        // 10% of 3 is 0.3 < half a unit (0.5): only 3 wins, 2.6 rounds to 3.
        let c = challenge(3.0, 10.0, 0);
        assert_eq!(feedback(3.0, &c), Feedback::Within);
        assert_eq!(feedback(2.6, &c), Feedback::Within);
        assert_eq!(feedback(2.4, &c), Feedback::TooLow);
        assert_eq!(feedback(4.0, &c), Feedback::TooHigh);

        // 1 decimal: half unit is 0.05.
        let c = challenge(0.3, 10.0, 1);
        assert_eq!(feedback(0.3, &c), Feedback::Within);
        assert_eq!(feedback(0.2, &c), Feedback::TooLow);
        assert_eq!(feedback(0.4, &c), Feedback::TooHigh);
    }

    #[test]
    fn judge_rounds_guess_to_decimals() {
        assert_eq!(round_to_decimals(312.45, 1), 312.5);
        assert_eq!(round_to_decimals(312.44, 1), 312.4);
        assert_eq!(round_to_decimals(2.5, 0), 3.0);
        assert_eq!(round_to_decimals(9.99, 1), 10.0);
        assert_eq!(round_to_decimals(999.5, 0), 1000.0);
        assert_eq!(round_to_decimals(0.0005, 3), 0.001);
        assert_eq!(round_to_decimals(42.0, 2), 42.0);
        assert_eq!(round_to_decimals(1e15, 0), 1e15);
    }

    #[test]
    fn judge_error_pct() {
        let c = challenge(200.0, 10.0, 0);
        let (_, err) = judge(150.0, &c);
        assert!((err - 25.0).abs() < 1e-9);
        let (_, err) = judge(200.0, &c);
        assert_eq!(err, 0.0);
    }

    #[test]
    fn parse_guess_accepts_valid_numbers() {
        assert_eq!(parse_guess("0").unwrap(), 0.0);
        assert_eq!(parse_guess("312.5").unwrap(), 312.5);
        assert_eq!(parse_guess("1000000000000000").unwrap(), 1e15);
        assert_eq!(parse_guess("0.123456").unwrap(), 0.123456);
        assert_eq!(parse_guess("007").unwrap(), 7.0);
    }

    #[test]
    fn parse_guess_rejects_everything_else() {
        for raw in [
            "",
            "NaN",
            "nan",
            "inf",
            "Infinity",
            "-1",
            "+1",
            "1e5",
            "1.1234567",
            "10000000000000001",
            "1000000000000000.1",
            "12345678901234567",
            ".5",
            "5.",
            "1.2.3",
            " 1",
            "1,000",
            "1_000",
            "0x10",
        ] {
            assert!(
                matches!(parse_guess(raw), Err(AppError::UnprocessableEntity(_))),
                "{raw:?} should be rejected"
            );
        }
    }

    #[test]
    fn magnitude_hint_bands() {
        assert_eq!(
            magnitude_hint(0.3),
            Hint {
                low: 0.1,
                high: 1.0
            }
        );
        assert_eq!(
            magnitude_hint(1.0),
            Hint {
                low: 1.0,
                high: 10.0
            }
        );
        assert_eq!(
            magnitude_hint(999.0),
            Hint {
                low: 100.0,
                high: 1000.0
            }
        );
        assert_eq!(
            magnitude_hint(1000.0),
            Hint {
                low: 1000.0,
                high: 10000.0
            }
        );
        assert_eq!(
            magnitude_hint(0.001),
            Hint {
                low: 0.001,
                high: 0.01
            }
        );
        assert_eq!(
            magnitude_hint(1e15),
            Hint {
                low: 1e15,
                high: 1e16
            }
        );
    }
}

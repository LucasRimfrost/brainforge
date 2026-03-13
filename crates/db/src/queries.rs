use shared::error::{AppError, AppResult};
use sqlx::PgPool;
use uuid::Uuid;

use crate::models::{Challenge, ChallengeHistory, Difficulty, Submission, User};

pub async fn create_user(
    pool: &PgPool,
    username: &str,
    email: &str,
    password_hash: &str,
) -> AppResult<User> {
    sqlx::query_as!(
        User,
        r#"
        INSERT INTO users (username, email, password_hash)
        VALUES ($1, $2, $3)
        RETURNING id, username, email, password_hash, created_at
        "#,
        username,
        email,
        password_hash
    )
    .fetch_one(pool)
    .await
    .map_err(AppError::from)
}

pub async fn find_user_by_email(pool: &PgPool, email: &str) -> AppResult<Option<User>> {
    sqlx::query_as!(
        User,
        r#"
        SELECT id, username, email, password_hash, created_at
        FROM users
        WHERE email = $1
        "#,
        email
    )
    .fetch_optional(pool)
    .await
    .map_err(AppError::from)
}

pub async fn find_user_by_id(pool: &PgPool, id: Uuid) -> AppResult<Option<User>> {
    sqlx::query_as!(
        User,
        r#"
        SELECT id, username, email, password_hash, created_at
        FROM users
        WHERE id = $1
        "#,
        id
    )
    .fetch_optional(pool)
    .await
    .map_err(AppError::from)
}

pub async fn find_challenge_by_date(
    pool: &PgPool,
    scheduled_date: chrono::NaiveDate,
) -> AppResult<Option<Challenge>> {
    sqlx::query_as!(
        Challenge,
        r#"
        SELECT id, title, description,
               difficulty as "difficulty: Difficulty",
               expected_answer, hint, max_attempts,
               scheduled_date, created_at
        FROM challenges
        WHERE scheduled_date = $1
        "#,
        scheduled_date,
    )
    .fetch_optional(pool)
    .await
    .map_err(AppError::from)
}

pub async fn find_submissions_by_user_and_challenge(
    pool: &PgPool,
    user_id: Uuid,
    challenge_id: Uuid,
) -> AppResult<Vec<Submission>> {
    sqlx::query_as!(
        Submission,
        r#"
        SELECT id, user_id, challenge_id, answer,
               is_correct, attempt_number, submitted_at
        FROM submissions
        WHERE user_id = $1 AND challenge_id = $2
        "#,
        user_id,
        challenge_id
    )
    .fetch_all(pool)
    .await
    .map_err(AppError::from)
}

pub async fn create_submission(
    pool: &PgPool,
    user_id: Uuid,
    challenge_id: Uuid,
    answer: &str,
    is_correct: bool,
    attempt_number: i32,
) -> AppResult<Submission> {
    sqlx::query_as!(
        Submission,
        r#"
        INSERT INTO submissions (user_id, challenge_id, answer,
                                 is_correct, attempt_number)
        VALUES ($1, $2, $3, $4, $5)
        RETURNING id, user_id, challenge_id, answer, is_correct,
                  attempt_number, submitted_at
        "#,
        user_id,
        challenge_id,
        answer,
        is_correct,
        attempt_number,
    )
    .fetch_one(pool)
    .await
    .map_err(AppError::from)
}

pub async fn find_user_challenge_history(
    pool: &PgPool,
    user_id: Uuid,
    limit: i64,
) -> AppResult<Vec<ChallengeHistory>> {
    sqlx::query_as!(
        ChallengeHistory,
        r#"
        SELECT * FROM (
            SELECT DISTINCT ON (s.challenge_id)
                   c.id as challenge_id, c.title,
                   c.difficulty as "difficulty: Difficulty",
                   c.scheduled_date, s.is_correct,
                   s.attempt_number, s.submitted_at
            FROM submissions s
            JOIN challenges c ON c.id = s.challenge_id
            WHERE s.user_id = $1
            ORDER BY s.challenge_id, s.is_correct DESC, s.attempt_number DESC
        ) history
        ORDER BY scheduled_date DESC
        LIMIT $2
        "#,
        user_id,
        limit
    )
    .fetch_all(pool)
    .await
    .map_err(AppError::from)
}

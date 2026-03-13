use chrono::{DateTime, Utc};
use serde::{Deserialize, Serialize};
use sqlx::FromRow;
use uuid::Uuid;

#[derive(Debug, FromRow, Serialize)]
pub struct User {
    pub id: Uuid,
    pub username: String,
    pub email: String,
    pub password_hash: String,
    pub created_at: DateTime<Utc>,
}

#[derive(Debug, sqlx::Type, Serialize, Deserialize)]
#[sqlx(type_name = "text", rename_all = "lowercase")]
pub enum Difficulty {
    Easy,
    Medium,
    Hard,
}

#[derive(Debug, FromRow, Serialize)]
pub struct Challenge {
    pub id: Uuid,
    pub title: String,
    pub description: String,
    pub difficulty: Difficulty,
    pub expected_answer: String,
    pub hint: Option<String>,
    pub max_attempts: i32,
    pub scheduled_date: chrono::NaiveDate,
    pub created_at: chrono::DateTime<Utc>,
}

#[derive(Debug, FromRow, Serialize)]
pub struct ChallengeHistory {
    pub challenge_id: Uuid,
    pub title: String,
    pub difficulty: Difficulty,
    pub scheduled_date: chrono::NaiveDate,
    pub is_correct: bool,
    pub attempt_number: i32,
    pub submitted_at: DateTime<Utc>,
}

#[derive(Debug, FromRow, Serialize)]
pub struct Submission {
    pub id: Uuid,
    pub user_id: Uuid,
    pub challenge_id: Uuid,
    pub answer: String,
    pub is_correct: bool,
    pub attempt_number: i32,
    pub submitted_at: DateTime<Utc>,
}

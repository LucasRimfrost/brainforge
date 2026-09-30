//! Domain models mapped to database tables via [`sqlx::FromRow`].

use std::fmt;

use chrono::{DateTime, Utc};
use serde::{Deserialize, Serialize};
use sqlx::FromRow;
use uuid::Uuid;

/// A registered user account.
#[derive(FromRow, Serialize)]
pub struct User {
    pub id: Uuid,
    pub username: String,
    pub email: String,
    #[serde(skip_serializing)]
    pub password_hash: String,
    pub created_at: DateTime<Utc>,
}

impl fmt::Debug for User {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        f.debug_struct("User")
            .field("id", &self.id)
            .field("username", &self.username)
            .field("email", &self.email)
            .field("password_hash", &"[REDACTED]")
            .field("created_at", &self.created_at)
            .finish()
    }
}

/// A user's public profile fields (no password_hash).
#[derive(Debug, FromRow, Serialize)]
pub struct UserProfile {
    pub id: Uuid,
    pub username: String,
    pub email: String,
    pub created_at: DateTime<Utc>,
}

/// Challenge difficulty level, stored as lowercase text in PostgreSQL.
#[derive(Debug, sqlx::Type, Serialize, Deserialize)]
#[sqlx(type_name = "text", rename_all = "lowercase")]
#[serde(rename_all = "lowercase")]
pub enum Difficulty {
    Easy,
    Medium,
    Hard,
}

// ── Games registry ──────────────────────────────────────────────────────────

/// An entry in the games registry (e.g. "trivia", "code-output").
#[derive(Debug, FromRow, Serialize)]
pub struct Game {
    pub id: String,
    pub name: String,
    pub description: String,
    pub icon: Option<String>,
    pub is_active: bool,
    pub sort_order: i32,
    pub created_at: DateTime<Utc>,
}

// ── Trivia game ─────────────────────────────────────────────────────────────

/// A trivia question scheduled for a specific date.
#[derive(Debug, FromRow, Serialize)]
pub struct TriviaChallenge {
    pub id: Uuid,
    pub title: String,
    pub description: String,
    pub difficulty: Difficulty,
    pub expected_answer: String,
    pub hint: Option<String>,
    pub max_attempts: i32,
    pub scheduled_date: chrono::NaiveDate,
    pub created_at: DateTime<Utc>,
}

/// A single answer attempt by a user for a trivia challenge.
#[derive(Debug, FromRow, Serialize)]
pub struct TriviaSubmission {
    pub id: Uuid,
    pub user_id: Uuid,
    pub challenge_id: Uuid,
    pub answer: String,
    pub is_correct: bool,
    pub attempt_number: i32,
    pub submitted_at: DateTime<Utc>,
}

/// Aggregate trivia statistics for a user (streaks, totals).
#[derive(Debug, FromRow, Serialize)]
pub struct TriviaStats {
    pub user_id: Uuid,
    pub current_streak: i32,
    pub longest_streak: i32,
    pub total_solved: i32,
    pub total_attempts: i32,
    pub last_solved_date: Option<chrono::NaiveDate>,
}

/// Denormalized view of a user's best attempt per trivia challenge, used for history display.
#[derive(Debug, FromRow, Serialize)]
pub struct TriviaChallengeHistory {
    pub challenge_id: Uuid,
    pub title: String,
    pub difficulty: Difficulty,
    pub scheduled_date: chrono::NaiveDate,
    pub is_correct: bool,
    pub attempt_number: i32,
    pub submitted_at: DateTime<Utc>,
}

/// Row returned by the trivia archive query, combining challenge info with user progress.
#[derive(Debug, FromRow)]
pub struct TriviaArchiveRow {
    pub id: Uuid,
    pub title: String,
    pub difficulty: Difficulty,
    pub scheduled_date: chrono::NaiveDate,
    pub max_attempts: i32,
    pub is_solved: bool,
    pub attempts_used: i64,
}

/// A single row on the leaderboard, shared by both game types.
#[derive(Debug, FromRow, Serialize)]
pub struct LeaderboardRow {
    pub username: String,
    pub current_streak: i32,
    pub longest_streak: i32,
    pub total_solved: i32,
}

/// A hashed password-reset token with a one-hour TTL.
#[derive(Debug, FromRow)]
pub struct PasswordResetToken {
    pub id: Uuid,
    pub user_id: Uuid,
    pub token_hash: String,
    pub expires_at: DateTime<Utc>,
    pub created_at: DateTime<Utc>,
    pub used_at: Option<DateTime<Utc>>,
}

// ── Code Output game ────────────────────────────────────────────────────────

/// A "predict the output" challenge showing a code snippet in a given language.
#[derive(Debug, FromRow, Serialize)]
pub struct CodeOutputChallenge {
    pub id: Uuid,
    pub title: String,
    pub description: String,
    pub language: String,
    pub code_snippet: String,
    pub expected_output: String,
    pub difficulty: Difficulty,
    pub hint: Option<String>,
    pub max_attempts: i32,
    pub scheduled_date: chrono::NaiveDate,
    pub created_at: DateTime<Utc>,
}

/// A single answer attempt by a user for a code-output challenge.
#[derive(Debug, FromRow, Serialize)]
pub struct CodeOutputSubmission {
    pub id: Uuid,
    pub user_id: Uuid,
    pub challenge_id: Uuid,
    pub answer: String,
    pub is_correct: bool,
    pub attempt_number: i32,
    pub submitted_at: DateTime<Utc>,
}

/// Aggregate code-output statistics for a user (streaks, totals).
#[derive(Debug, FromRow, Serialize)]
pub struct CodeOutputStats {
    pub user_id: Uuid,
    pub current_streak: i32,
    pub longest_streak: i32,
    pub total_solved: i32,
    pub total_attempts: i32,
    pub last_solved_date: Option<chrono::NaiveDate>,
}

/// Denormalized view of a user's best attempt per code-output challenge, used for history display.
#[derive(Debug, FromRow, Serialize)]
pub struct CodeOutputChallengeHistory {
    pub challenge_id: Uuid,
    pub title: String,
    pub language: String,
    pub difficulty: Difficulty,
    pub scheduled_date: chrono::NaiveDate,
    pub is_correct: bool,
    pub attempt_number: i32,
    pub submitted_at: DateTime<Utc>,
}

/// Row returned by the code-output archive query, combining challenge info with user progress.
#[derive(Debug, FromRow)]
pub struct CodeOutputArchiveRow {
    pub id: Uuid,
    pub title: String,
    pub language: String,
    pub difficulty: Difficulty,
    pub scheduled_date: chrono::NaiveDate,
    pub max_attempts: i32,
    pub is_solved: bool,
    pub attempts_used: i64,
}

// ── Ballpark game ───────────────────────────────────────────────────────────

/// A daily estimation question with a numeric answer.
///
/// Holds the answer, so it is server-side only: it deliberately does not
/// implement `Serialize`, and its `Debug` output redacts the answer.
#[derive(FromRow)]
pub struct BallparkChallenge {
    pub id: Uuid,
    pub title: String,
    pub question: String,
    pub unit: String,
    pub answer: f64,
    pub decimals: i16,
    pub tolerance_pct: f64,
    pub difficulty: Difficulty,
    pub explanation: String,
    pub source_url: Option<String>,
    pub max_attempts: i32,
    pub scheduled_date: chrono::NaiveDate,
    pub created_at: DateTime<Utc>,
}

impl fmt::Debug for BallparkChallenge {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        f.debug_struct("BallparkChallenge")
            .field("id", &self.id)
            .field("title", &self.title)
            .field("answer", &"[REDACTED]")
            .field("decimals", &self.decimals)
            .field("tolerance_pct", &self.tolerance_pct)
            .field("max_attempts", &self.max_attempts)
            .field("scheduled_date", &self.scheduled_date)
            .finish_non_exhaustive()
    }
}

/// Higher/lower feedback for a ballpark guess, stored as snake_case text.
#[derive(Debug, Clone, Copy, PartialEq, Eq, sqlx::Type, Serialize, Deserialize)]
#[sqlx(type_name = "text", rename_all = "snake_case")]
#[serde(rename_all = "snake_case")]
pub enum Feedback {
    /// The answer is higher than the guess.
    TooLow,
    /// The answer is lower than the guess.
    TooHigh,
    /// The guess is within the challenge's tolerance.
    Within,
}

impl Feedback {
    /// The stored text form (matches the `feedback` CHECK constraint).
    pub fn as_str(self) -> &'static str {
        match self {
            Feedback::TooLow => "too_low",
            Feedback::TooHigh => "too_high",
            Feedback::Within => "within",
        }
    }
}

/// A single guess by a user for a ballpark challenge.
///
/// `error_pct` must not be sent to the client before the reveal.
#[derive(Debug, FromRow)]
pub struct BallparkSubmission {
    pub guess: f64,
    pub feedback: Feedback,
    pub error_pct: f64,
    pub attempt_number: i32,
}

/// The user's closest guess for a ballpark challenge.
#[derive(Debug, FromRow)]
pub struct BallparkBestGuess {
    pub guess: f64,
    pub error_pct: f64,
}

/// Result of an atomic ballpark submission.
#[derive(Debug)]
pub struct BallparkSubmitOutcome {
    pub attempt_number: i32,
    /// The closest guess so far; only set once the challenge is finished
    /// (solved or out of attempts).
    pub best: Option<BallparkBestGuess>,
}

/// Aggregate ballpark statistics for a user (streaks, totals).
#[derive(Debug, FromRow, Serialize)]
pub struct BallparkStats {
    pub user_id: Uuid,
    pub current_streak: i32,
    pub longest_streak: i32,
    pub total_solved: i32,
    pub total_attempts: i32,
    pub last_solved_date: Option<chrono::NaiveDate>,
}

/// A user's progress per ballpark challenge, used for history display.
///
/// `best_error_pct` is only set once the challenge is finished.
#[derive(Debug, FromRow, Serialize)]
pub struct BallparkChallengeHistory {
    pub challenge_id: Uuid,
    pub title: String,
    pub difficulty: Difficulty,
    pub scheduled_date: chrono::NaiveDate,
    pub is_correct: bool,
    pub attempt_number: i32,
    pub submitted_at: DateTime<Utc>,
    pub best_error_pct: Option<f64>,
}

/// Row returned by the ballpark archive query, combining challenge info with user progress.
#[derive(Debug, FromRow)]
pub struct BallparkArchiveRow {
    pub id: Uuid,
    pub title: String,
    pub difficulty: Difficulty,
    pub scheduled_date: chrono::NaiveDate,
    pub max_attempts: i32,
    pub is_solved: bool,
    pub attempts_used: i64,
}

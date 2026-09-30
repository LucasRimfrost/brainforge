use std::str::FromStr;

use axum::{
    Json, Router,
    extract::{Query, State},
    http::StatusCode,
    response::IntoResponse,
    routing::get,
};
use db::queries::{
    find_ballpark_leaderboard, find_code_output_leaderboard, find_trivia_leaderboard,
};
use serde::Deserialize;
use shared::error::{AppError, AppResult};

use crate::AppState;

/// A game that has a leaderboard, as named in the `?game=` query parameter.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum GameKind {
    Trivia,
    CodeOutput,
    Ballpark,
}

impl GameKind {
    /// The kebab-case name used in `?game=`.
    pub fn as_str(self) -> &'static str {
        match self {
            GameKind::Trivia => "trivia",
            GameKind::CodeOutput => "code-output",
            GameKind::Ballpark => "ballpark",
        }
    }
}

impl FromStr for GameKind {
    type Err = AppError;

    /// Parses the kebab-case game name; unknown names are a 422.
    fn from_str(s: &str) -> Result<Self, Self::Err> {
        match s {
            "trivia" => Ok(GameKind::Trivia),
            "code-output" => Ok(GameKind::CodeOutput),
            "ballpark" => Ok(GameKind::Ballpark),
            _ => Err(AppError::UnprocessableEntity(
                "Unknown game: expected one of trivia, code-output, ballpark".to_string(),
            )),
        }
    }
}

/// Query parameters for the leaderboard endpoint.
#[derive(Deserialize)]
pub struct LeaderboardParams {
    limit: Option<i64>,
    /// Game identifier: `"trivia"` (default), `"code-output"` or `"ballpark"`.
    game: Option<String>,
}

/// Mounts the leaderboard route at `/`.
pub fn router() -> Router<AppState> {
    Router::new().route("/", get(leaderboard))
}

/// GET /api/v1/leaderboard?game=trivia|code-output|ballpark
pub async fn leaderboard(
    State(state): State<AppState>,
    Query(params): Query<LeaderboardParams>,
) -> AppResult<impl IntoResponse> {
    let limit = params.limit.unwrap_or(30).clamp(1, 100);
    let game = params
        .game
        .as_deref()
        .map_or(Ok(GameKind::Trivia), GameKind::from_str)?;

    tracing::debug!(limit, game = game.as_str(), "fetching leaderboard");

    let leaderboard = match game {
        GameKind::Trivia => find_trivia_leaderboard(&state.pool, limit).await?,
        GameKind::CodeOutput => find_code_output_leaderboard(&state.pool, limit).await?,
        GameKind::Ballpark => find_ballpark_leaderboard(&state.pool, limit).await?,
    };

    Ok((StatusCode::OK, Json(leaderboard)))
}

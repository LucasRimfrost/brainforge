use axum::{
    Json, Router,
    extract::{Query, State},
    http::StatusCode,
    response::IntoResponse,
    routing::get,
};
use db::queries::{find_code_output_leaderboard, find_trivia_leaderboard};
use serde::Deserialize;
use shared::error::AppResult;

use crate::AppState;

#[derive(Deserialize)]
pub struct LeaderboardParams {
    limit: Option<i64>,
    game: Option<String>,
}

pub fn router() -> Router<AppState> {
    Router::new().route("/", get(leaderboard))
}

/// GET /api/v1/leaderboard?game=trivia|code-output
pub async fn leaderboard(
    State(state): State<AppState>,
    Query(params): Query<LeaderboardParams>,
) -> AppResult<impl IntoResponse> {
    let limit = params.limit.unwrap_or(30);
    let game = params.game.as_deref().unwrap_or("trivia");

    tracing::debug!(limit, game, "fetching leaderboard");

    let leaderboard = match game {
        "code-output" => find_code_output_leaderboard(&state.pool, limit).await?,
        _ => find_trivia_leaderboard(&state.pool, limit).await?,
    };

    Ok((StatusCode::OK, Json(leaderboard)))
}

use shared::error::{AppError, AppResult};
use sqlx::PgPool;

use crate::models::Game;

// ── Games registry ──────────────────────────────────────────────────────────────

/// Returns all games marked as active, ordered by `sort_order`.
#[tracing::instrument(skip(pool))]
pub async fn find_active_games(pool: &PgPool) -> AppResult<Vec<Game>> {
    let results = sqlx::query_as!(
        Game,
        r#"
        SELECT id, name, description, icon, is_active, sort_order, created_at
        FROM games
        WHERE is_active = true
        ORDER BY sort_order ASC
        "#,
    )
    .fetch_all(pool)
    .await
    .map_err(AppError::from)?;

    tracing::debug!(count = results.len(), "fetched active games");
    Ok(results)
}

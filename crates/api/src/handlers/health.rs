use axum::{Json, Router, extract::State, routing::get};
use serde::Serialize;
use shared::error::AppResult;

use crate::AppState;

/// Mounts the health-check route at `/health`.
pub fn router() -> Router<AppState> {
    Router::new().route("/health", get(health_check))
}

#[derive(Serialize)]
struct HealthResponse {
    status: &'static str,
    version: &'static str,
}

/// Pings the database and returns the service status and version.
async fn health_check(State(state): State<AppState>) -> AppResult<Json<HealthResponse>> {
    sqlx::query!("SELECT 1 as result")
        .fetch_one(&state.pool)
        .await
        .map_err(|e| {
            tracing::error!(error = %e, "health check database ping failed");
            shared::error::AppError::DatabaseError(e)
        })?;

    Ok(Json(HealthResponse {
        status: "healthy",
        version: env!("CARGO_PKG_VERSION"),
    }))
}

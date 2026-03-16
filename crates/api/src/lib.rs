//! HTTP API crate — handlers, middleware, and route definitions.

use shared::config::Config;
use sqlx::PgPool;

pub mod handlers;
pub mod middleware;
pub mod routes;

/// Shared application state passed to every handler via Axum's `State` extractor.
#[derive(Clone)]
pub struct AppState {
    pub pool: PgPool,
    pub config: Config,
}

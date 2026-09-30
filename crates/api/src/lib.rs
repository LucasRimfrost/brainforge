//! HTTP API crate — handlers, middleware, and route definitions.

use std::sync::Arc;

use auth::jwt::JwtKeys;
use shared::config::Config;
use sqlx::PgPool;

pub mod handlers;
pub mod middleware;
pub mod routes;

/// Shared application state passed to every handler via Axum's `State` extractor.
#[derive(Clone)]
pub struct AppState {
    pub pool: PgPool,
    pub config: Arc<Config>,
    pub jwt: Arc<JwtKeys>,
}

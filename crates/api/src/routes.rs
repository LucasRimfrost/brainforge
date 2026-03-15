use axum::{Router, extract::DefaultBodyLimit, http::header};
use tower_governor::GovernorLayer;
use tower_http::{set_header::SetResponseHeaderLayer, trace::TraceLayer};

use crate::{AppState, handlers, middleware::rate_limit::RateLimiters};

pub fn router(state: AppState) -> Router {
    let limiters = RateLimiters::new();
    limiters.spawn_cleanup();

    // Auth routes get stricter limiter applied
    let auth_routes = handlers::auth::router().layer(GovernorLayer::new(limiters.auth.clone()));

    let routes = Router::new()
        .merge(handlers::health::router())
        .nest("/auth", auth_routes)
        .nest("/challenge", handlers::challenge::router())
        .nest("/leaderboard", handlers::leaderboard::router());

    Router::new()
        .nest("/api/v1", Router::new().merge(routes))
        .layer(GovernorLayer::new(limiters.global.clone()))
        .layer(TraceLayer::new_for_http())
        .layer(DefaultBodyLimit::max(1024 * 1024))
        .layer(SetResponseHeaderLayer::overriding(
            header::X_CONTENT_TYPE_OPTIONS,
            header::HeaderValue::from_static("nosniff"),
        ))
        .layer(SetResponseHeaderLayer::overriding(
            header::X_FRAME_OPTIONS,
            header::HeaderValue::from_static("DENY"),
        ))
        .layer(SetResponseHeaderLayer::overriding(
            header::HeaderName::from_static("x-xss-protection"),
            header::HeaderValue::from_static("1; mode=block"),
        ))
        .layer(SetResponseHeaderLayer::overriding(
            header::HeaderName::from_static("strict-transport-security"),
            header::HeaderValue::from_static("max-age=31536000; includeSubDomains"),
        ))
        .layer(SetResponseHeaderLayer::overriding(
            header::HeaderName::from_static("referrer-policy"),
            header::HeaderValue::from_static("strict-origin-when-cross-origin"),
        ))
        .layer(SetResponseHeaderLayer::overriding(
            header::HeaderName::from_static("permissions-policy"),
            header::HeaderValue::from_static("camera=(), microphone=(), geolocation=()"),
        ))
        .with_state(state)
}

use axum::{
    Router,
    extract::DefaultBodyLimit,
    http::{StatusCode, header},
    middleware,
};
use std::time::Duration;
use tower_governor::GovernorLayer;
use tower_http::{
    cors::{AllowOrigin, CorsLayer},
    services::{ServeDir, ServeFile},
    set_header::SetResponseHeaderLayer,
    timeout::TimeoutLayer,
};

use axum::routing::{get, patch, post};

use crate::{
    AppState, handlers, middleware::csrf, middleware::logging, middleware::rate_limit::RateLimiters,
};

/// Builds the top-level Axum router with all API routes, middleware, CORS,
/// rate limiting, and security headers.
///
/// If `config.static_dir` is set, a fallback SPA file server is mounted.
pub fn router(state: AppState) -> Router {
    let limiters = RateLimiters::new(&state.config);
    limiters.spawn_cleanup();

    // Rate-limited auth routes: everything that checks or sets a password
    // (login, register, password reset, email/password change)
    let auth_strict = Router::new()
        .route("/register", post(handlers::auth::register))
        .route("/login", post(handlers::auth::login))
        .route("/forgot-password", post(handlers::auth::forgot_password))
        .route("/reset-password", post(handlers::auth::reset_password))
        .route("/email", patch(handlers::auth::update_email))
        .route("/password", patch(handlers::auth::update_password))
        .layer(DefaultBodyLimit::max(16 * 1024))
        .layer(GovernorLayer::new(limiters.auth.clone()));

    // Normal auth routes (me, logout, logout-all, profile) — only the global rate limiter applies
    let auth_normal = Router::new()
        .route("/me", get(handlers::auth::me))
        .route("/logout", post(handlers::auth::logout))
        .route("/logout-all", post(handlers::auth::logout_all))
        .route("/profile", patch(handlers::auth::update_profile))
        .layer(DefaultBodyLimit::max(16 * 1024));

    let auth_routes = Router::new().merge(auth_strict).merge(auth_normal);

    let trivia_routes = handlers::trivia::router().layer(DefaultBodyLimit::max(64 * 1024));

    let code_output_routes =
        handlers::code_output::router().layer(DefaultBodyLimit::max(64 * 1024));

    let routes = Router::new()
        .merge(handlers::health::router())
        .nest("/auth", auth_routes)
        .nest("/games", handlers::games::router())
        .nest("/trivia", trivia_routes)
        .nest("/code-output", code_output_routes)
        .nest("/leaderboard", handlers::leaderboard::router());

    let allowed_origin = state
        .config
        .cors_origin
        .as_deref()
        .unwrap_or("http://localhost:3000")
        .parse()
        .expect("Invalid CORS_ORIGIN");

    let cors = CorsLayer::new()
        .allow_origin(AllowOrigin::exact(allowed_origin))
        .allow_methods([
            axum::http::Method::GET,
            axum::http::Method::POST,
            axum::http::Method::PATCH,
        ])
        .allow_headers([
            header::CONTENT_TYPE,
            header::AUTHORIZATION,
            header::HeaderName::from_static("x-requested-with"),
        ])
        .allow_credentials(true);

    let api_routes = routes.layer(middleware::from_fn(csrf::require_csrf_header));

    let mut app = Router::new().nest("/api/v1", api_routes);

    // The SPA fallback must be mounted before the layers below, otherwise
    // they (including CSP and the other security headers) don't apply to it.
    if let Some(ref dir) = state.config.static_dir {
        app = app.fallback_service(
            ServeDir::new(dir).not_found_service(ServeFile::new(format!("{}/index.html", dir))),
        );
    }

    app
        // ── Request timeout (innermost, so the 503 is still logged) ─
        .layer(TimeoutLayer::with_status_code(
            StatusCode::SERVICE_UNAVAILABLE,
            Duration::from_secs(state.config.request_timeout_secs),
        ))
        // ── Observability (outermost → innermost) ───────────────────
        .layer(logging::sensitive_headers_layer())
        .layer(logging::trace_layer())
        .layer(middleware::from_fn(logging::request_id))
        .layer(middleware::from_fn(logging::logging))
        // ── Rate limiting ───────────────────────────────────────────
        .layer(GovernorLayer::new(limiters.global.clone()))
        .layer(cors)
        // ── Security / limits ───────────────────────────────────────
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
        .layer(SetResponseHeaderLayer::overriding(
            header::HeaderName::from_static("content-security-policy"),
            header::HeaderValue::from_static(
                "default-src 'self'; script-src 'self'; style-src 'self' 'unsafe-inline'; img-src 'self' data:; font-src 'self'; connect-src 'self'; frame-ancestors 'none'; base-uri 'self'; form-action 'self'"
            ),
        ))
        .with_state(state)
}

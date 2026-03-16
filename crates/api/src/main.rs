use std::net::SocketAddr;

use api::{AppState, routes};
use db::connection;
use shared::config::Config;
use tracing_subscriber::{EnvFilter, fmt, layer::SubscriberExt, util::SubscriberInitExt};

/// Entry point: loads config, connects to the database, and starts the HTTP server.
#[tokio::main]
async fn main() {
    dotenvy::dotenv().ok();
    init_tracing();

    let config = Config::from_env().expect("Failed to load configuration");

    let pool = connection::create_pool(&config.database_url)
        .await
        .expect("Failed to connect to database");

    let addr = format!("{}:{}", config.host, config.port);
    let state = AppState { pool, config };
    let router = routes::router(state);

    let listener = tokio::net::TcpListener::bind(&addr)
        .await
        .unwrap_or_else(|_| panic!("Failed to bind to address: {}", addr));

    tracing::info!("Listening on {addr}");

    axum::serve(
        listener,
        router.into_make_service_with_connect_info::<SocketAddr>(),
    )
    .with_graceful_shutdown(shutdown_signal())
    .await
    .expect("Server error");
}

/// Waits for `Ctrl+C` or `SIGTERM` and resolves, enabling graceful shutdown.
async fn shutdown_signal() {
    use tokio::signal;

    let ctrl_c = async {
        signal::ctrl_c()
            .await
            .expect("Failed to install Ctrl+C handler");
    };

    #[cfg(unix)]
    let terminate = async {
        signal::unix::signal(signal::unix::SignalKind::terminate())
            .expect("Failed to install SIGTERM handler")
            .recv()
            .await;
    };

    #[cfg(not(unix))]
    let terminate = std::future::pending::<()>();

    tokio::select! {
        _ = ctrl_c => tracing::info!("Ctrl+C received, shutting down"),
        _ = terminate => tracing::info!("SIGTERM received, shutting down"),
    }
}

/// Initialize the tracing subscriber with env-filter support.
///
/// Behaviour controlled by environment variables:
///
/// | Variable          | Effect                                              |
/// |-------------------|-----------------------------------------------------|
/// | `RUST_LOG`        | Filter directives (default below)                   |
/// | `RUST_LOG_FORMAT` | `json` → machine-readable, anything else → pretty   |
///
/// In **JSON mode** (production) every log line is a single JSON object —
/// ready for ingestion by Datadog, Loki, CloudWatch, etc.
///
/// In **pretty mode** (local dev) output is human-readable with colours,
/// span context, and thread names.
fn init_tracing() {
    let filter = EnvFilter::try_from_default_env()
        .unwrap_or_else(|_| EnvFilter::new("info,api=debug,tower_http=debug,tower_governor=info"));

    let is_json = std::env::var("RUST_LOG_FORMAT")
        .map(|v| v.eq_ignore_ascii_case("json"))
        .unwrap_or(false);

    let registry = tracing_subscriber::registry().with(filter);

    if is_json {
        // Production: structured JSON, one object per line.
        registry
            .with(
                fmt::layer()
                    .json()
                    .with_target(true)
                    .with_thread_names(true)
                    .with_span_list(true)
                    .with_current_span(true)
                    .flatten_event(true),
            )
            .init();
    } else {
        // Local dev: pretty, coloured, easy to scan.
        registry
            .with(
                fmt::layer()
                    .pretty()
                    .with_target(true)
                    .with_thread_names(true),
            )
            .init();
    }
}

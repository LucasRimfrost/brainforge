use std::str::FromStr;
use std::time::Duration;

use shared::config::Config;
use sqlx::PgPool;
use sqlx::postgres::{PgConnectOptions, PgPoolOptions};

/// Creates a PostgreSQL connection pool.
///
/// Pool size and the per-connection `statement_timeout` come from `config`
/// (`DB_MAX_CONNECTIONS`, `DB_MIN_CONNECTIONS`, `DB_STATEMENT_TIMEOUT_MS`);
/// the pool also uses a 5-second acquire timeout and a 10-minute idle timeout.
///
/// # Errors
///
/// Returns [`sqlx::Error`] if the URL is invalid or the database is unreachable.
pub async fn create_pool(config: &Config) -> Result<PgPool, sqlx::Error> {
    tracing::info!(
        max_connections = config.db_max_connections,
        min_connections = config.db_min_connections,
        statement_timeout_ms = config.db_statement_timeout_ms,
        acquire_timeout_secs = 5,
        idle_timeout_secs = 600,
        "connecting to database"
    );

    let connect_options = PgConnectOptions::from_str(&config.database_url)?
        .options([("statement_timeout", config.db_statement_timeout_ms)]);

    let pool = PgPoolOptions::new()
        .max_connections(config.db_max_connections)
        .min_connections(config.db_min_connections)
        .acquire_timeout(Duration::from_secs(5))
        .idle_timeout(Duration::from_secs(600))
        .connect_with(connect_options)
        .await?;

    tracing::info!("database connection pool established");
    Ok(pool)
}

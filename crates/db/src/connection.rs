use std::time::Duration;

use sqlx::PgPool;
use sqlx::postgres::PgPoolOptions;

pub async fn create_pool(database_url: &str) -> Result<PgPool, sqlx::Error> {
    tracing::info!(
        max_connections = 10,
        acquire_timeout_secs = 5,
        idle_timeout_secs = 600,
        "connecting to database"
    );

    let pool = PgPoolOptions::new()
        .max_connections(10)
        .acquire_timeout(Duration::from_secs(5))
        .idle_timeout(Duration::from_secs(600))
        .connect(database_url)
        .await?;

    tracing::info!("database connection pool established");
    Ok(pool)
}

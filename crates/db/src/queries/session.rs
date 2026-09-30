use shared::error::{AppError, AppResult};
use sqlx::PgPool;
use uuid::Uuid;

/// Stores a hashed session token with the given expiration.
#[tracing::instrument(skip(pool, token_hash))]
pub async fn create_session(
    pool: &PgPool,
    user_id: Uuid,
    token_hash: &str,
    expires_at: chrono::DateTime<chrono::Utc>,
) -> AppResult<()> {
    sqlx::query!(
        r#"
        INSERT INTO sessions (user_id, token_hash, expires_at)
        VALUES ($1, $2, $3)
        "#,
        user_id,
        token_hash,
        expires_at,
    )
    .execute(pool)
    .await
    .map_err(AppError::from)?;

    tracing::debug!(%user_id, "session created");
    Ok(())
}

/// Looks up an unexpired session by its SHA-256 token hash.
///
/// Returns `(session_id, user_id)`, or `None` if the session does not exist
/// or has expired.
#[tracing::instrument(skip(pool, token_hash))]
pub async fn find_active_session(
    pool: &PgPool,
    token_hash: &str,
) -> AppResult<Option<(Uuid, Uuid)>> {
    let result = sqlx::query!(
        r#"
        SELECT id, user_id
        FROM sessions
        WHERE token_hash = $1 AND expires_at > now()
        "#,
        token_hash,
    )
    .fetch_optional(pool)
    .await
    .map_err(AppError::from)?;

    tracing::debug!(found = result.is_some(), "session lookup");
    Ok(result.map(|row| (row.id, row.user_id)))
}

/// Deletes the session with the given token hash (logout). Does nothing if
/// no such session exists.
#[tracing::instrument(skip(pool, token_hash))]
pub async fn delete_session_by_hash(pool: &PgPool, token_hash: &str) -> AppResult<()> {
    let result = sqlx::query!(
        r#"
        DELETE FROM sessions
        WHERE token_hash = $1
        "#,
        token_hash,
    )
    .execute(pool)
    .await
    .map_err(AppError::from)?;

    tracing::debug!(deleted = result.rows_affected(), "session deleted");
    Ok(())
}

/// Deletes every session for a user (e.g. "log out of all devices").
#[tracing::instrument(skip(pool))]
pub async fn delete_all_user_sessions(pool: &PgPool, user_id: Uuid) -> AppResult<()> {
    let result = sqlx::query!(
        r#"
        DELETE FROM sessions
        WHERE user_id = $1
        "#,
        user_id,
    )
    .execute(pool)
    .await
    .map_err(AppError::from)?;

    tracing::info!(%user_id, deleted = result.rows_affected(), "all sessions deleted");
    Ok(())
}

/// Deletes every session for a user except `keep_session_id` (e.g. on
/// password change, so the current device stays logged in).
#[tracing::instrument(skip(pool))]
pub async fn delete_other_user_sessions(
    pool: &PgPool,
    user_id: Uuid,
    keep_session_id: Uuid,
) -> AppResult<()> {
    let result = sqlx::query!(
        r#"
        DELETE FROM sessions
        WHERE user_id = $1 AND id <> $2
        "#,
        user_id,
        keep_session_id,
    )
    .execute(pool)
    .await
    .map_err(AppError::from)?;

    tracing::info!(%user_id, deleted = result.rows_affected(), "other sessions deleted");
    Ok(())
}

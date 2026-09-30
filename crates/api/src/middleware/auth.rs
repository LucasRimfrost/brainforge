use axum::extract::FromRequestParts;
use axum_extra::extract::CookieJar;
use shared::error::AppError;
use uuid::Uuid;

use crate::AppState;

/// Name of the cookie carrying the opaque session token.
pub const SESSION_COOKIE: &str = "session";

/// Axum extractor that validates the `session` cookie against the `sessions`
/// table and provides the authenticated user's ID and session ID.
///
/// Add this to a handler's arguments to require authentication:
///
/// ```ignore
/// async fn protected(auth: AuthUser) { /* auth.id is a valid Uuid */ }
/// ```
pub struct AuthUser {
    pub id: Uuid,
    pub session_id: Uuid,
}

impl FromRequestParts<AppState> for AuthUser {
    type Rejection = AppError;

    async fn from_request_parts(
        parts: &mut axum::http::request::Parts,
        state: &AppState,
    ) -> Result<Self, Self::Rejection> {
        let jar = CookieJar::from_headers(&parts.headers);

        let cookie = jar.get(SESSION_COOKIE).ok_or_else(|| {
            tracing::debug!("auth rejected — no session cookie");
            AppError::Unauthorized
        })?;

        let token_hash = auth::token::hash_token(cookie.value());

        let (session_id, user_id) = db::queries::find_active_session(&state.pool, &token_hash)
            .await?
            .ok_or_else(|| {
                tracing::debug!("auth rejected — unknown or expired session");
                AppError::Unauthorized
            })?;

        tracing::debug!(user_id = %user_id, "user authenticated");
        Ok(AuthUser {
            id: user_id,
            session_id,
        })
    }
}

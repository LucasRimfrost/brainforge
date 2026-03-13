use axum::extract::FromRequestParts;
use axum_extra::extract::CookieJar;
use jsonwebtoken::{DecodingKey, Validation, decode};
use uuid::Uuid;

use crate::{AppState, auth::jwt::Claims, error::AppError};

pub struct AuthUser {
    pub id: Uuid,
}

impl FromRequestParts<AppState> for AuthUser {
    type Rejection = AppError;

    async fn from_request_parts(
        parts: &mut axum::http::request::Parts,
        state: &AppState,
    ) -> Result<Self, Self::Rejection> {
        let jar = CookieJar::from_headers(&parts.headers);

        let cookie = jar.get("access_token").ok_or(AppError::Unauthorized)?;

        let token = cookie.value();

        let token_data = decode::<Claims>(
            token,
            &DecodingKey::from_secret(state.config.jwt_secret.as_ref()),
            &Validation::default(),
        )
        .map_err(|e| {
            tracing::warn!("JWT validation failed: {}", e);
            AppError::Unauthorized
        })?;

        let user_id = Uuid::parse_str(&token_data.claims.sub).map_err(|_| {
            tracing::error!("Invalid UUID in JWT sub claim");
            AppError::Unauthorized
        })?;

        Ok(AuthUser { id: user_id })
    }
}

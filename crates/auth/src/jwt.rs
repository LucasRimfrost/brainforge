use chrono::Utc;
use jsonwebtoken::{DecodingKey, EncodingKey, Header, Validation, decode, encode};
use serde::{Deserialize, Serialize};
use shared::error::{AppError, AppResult};

const ISSUER: &str = "daily-challenge";

#[derive(Debug, Deserialize, Serialize)]
pub struct Claims {
    pub sub: String, // user id
    pub exp: usize,  // expiration
    pub iat: usize,  // issued at
    pub iss: String, // issuer (daily_challenge/domain)
}

pub fn create_access_token(user_id: &str, secret: &str, expiry_minutes: i64) -> AppResult<String> {
    let now = Utc::now();
    let exp = (now + chrono::Duration::minutes(expiry_minutes)).timestamp() as usize;

    let claims = Claims {
        sub: user_id.to_string(),
        exp,
        iat: now.timestamp() as usize,
        iss: ISSUER.to_string(),
    };

    encode(
        &Header::default(),
        &claims,
        &EncodingKey::from_secret(secret.as_bytes()),
    )
    .map_err(|e| {
        tracing::error!("Failed to encode JWT: {}", e);
        AppError::InternalError
    })
}

pub fn validate_token(token: &str, secret: &str) -> AppResult<Claims> {
    let mut validation = Validation::default();
    validation.set_issuer(&[ISSUER]);

    decode::<Claims>(
        token,
        &DecodingKey::from_secret(secret.as_bytes()),
        &validation,
    )
    .map(|data| data.claims)
    .map_err(|e| {
        tracing::warn!("JWT validation failed: {}", e);
        AppError::Unauthorized
    })
}

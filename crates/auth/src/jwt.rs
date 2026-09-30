use chrono::Utc;
use jsonwebtoken::{DecodingKey, EncodingKey, Header, Validation, decode, encode};
use serde::{Deserialize, Serialize};
use shared::error::{AppError, AppResult};

const ISSUER: &str = "brainforge";

/// JWT claims payload embedded in every access token.
#[derive(Debug, Deserialize, Serialize)]
pub struct Claims {
    /// Subject — the user's UUID.
    pub sub: String,
    /// Expiration time (UTC epoch seconds).
    pub exp: usize,
    /// Issued-at time (UTC epoch seconds).
    pub iat: usize,
    /// Issuer identifier (`"brainforge"`).
    pub iss: String,
}

/// Pre-built JWT signing/verification keys and validation rules.
///
/// Construct once at startup and share (e.g. via `Arc`) so keys are not
/// rebuilt on every request.
pub struct JwtKeys {
    encoding: EncodingKey,
    decoding: DecodingKey,
    validation: Validation,
    expiry_minutes: i64,
}

impl JwtKeys {
    /// Builds the encoding/decoding keys and issuer-checking validation once.
    pub fn new(secret: &[u8], expiry_minutes: i64) -> Self {
        let mut validation = Validation::default();
        validation.set_issuer(&[ISSUER]);

        Self {
            encoding: EncodingKey::from_secret(secret),
            decoding: DecodingKey::from_secret(secret),
            validation,
            expiry_minutes,
        }
    }

    /// Access token lifetime in minutes (also used for the cookie max-age).
    pub fn expiry_minutes(&self) -> i64 {
        self.expiry_minutes
    }

    /// Creates a signed JWT access token for the given user.
    ///
    /// # Errors
    ///
    /// Returns [`AppError::InternalError`] if JWT encoding fails.
    #[tracing::instrument(skip(self))]
    pub fn create_access_token(&self, user_id: &str) -> AppResult<String> {
        let now = Utc::now();
        let exp = (now + chrono::Duration::minutes(self.expiry_minutes)).timestamp() as usize;

        let claims = Claims {
            sub: user_id.to_string(),
            exp,
            iat: now.timestamp() as usize,
            iss: ISSUER.to_string(),
        };

        let token = encode(&Header::default(), &claims, &self.encoding).map_err(|e| {
            tracing::error!(error = %e, "JWT encoding failed");
            AppError::InternalError
        })?;

        tracing::debug!(
            user_id,
            expiry_minutes = self.expiry_minutes,
            "access token issued"
        );
        Ok(token)
    }

    /// Validates a JWT access token and returns its [`Claims`].
    ///
    /// Checks the signature, expiration, and issuer (`"brainforge"`).
    ///
    /// # Errors
    ///
    /// Returns [`AppError::Unauthorized`] if the token is invalid, expired, or
    /// signed with a different secret.
    #[tracing::instrument(skip(self, token), fields(token_len = token.len()))]
    pub fn validate_token(&self, token: &str) -> AppResult<Claims> {
        let claims = decode::<Claims>(token, &self.decoding, &self.validation)
            .map(|data| data.claims)
            .map_err(|e| {
                tracing::warn!(error = %e, "JWT validation failed");
                AppError::Unauthorized
            })?;

        tracing::debug!(user_id = %claims.sub, "token validated");
        Ok(claims)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    const SECRET: &str = "test-secret-key-for-unit-tests";
    const USER_ID: &str = "550e8400-e29b-41d4-a716-446655440000";

    fn keys() -> JwtKeys {
        JwtKeys::new(SECRET.as_bytes(), 60)
    }

    #[test]
    fn create_access_token_produces_valid_token() {
        let token = keys().create_access_token(USER_ID).unwrap();
        assert_eq!(token.split('.').count(), 3);
    }

    #[test]
    fn validate_token_accepts_valid_token() {
        let keys = keys();
        let token = keys.create_access_token(USER_ID).unwrap();
        let claims = keys.validate_token(&token).unwrap();
        assert_eq!(claims.sub, USER_ID);
        assert_eq!(claims.iss, "brainforge");
        assert!(claims.exp > claims.iat);
    }

    #[test]
    fn validate_token_rejects_expired_token() {
        let expired = JwtKeys::new(SECRET.as_bytes(), -5);
        let token = expired.create_access_token(USER_ID).unwrap();
        let result = expired.validate_token(&token);
        assert!(result.is_err());
    }

    #[test]
    fn validate_token_rejects_wrong_secret() {
        let token = keys().create_access_token(USER_ID).unwrap();
        let wrong = JwtKeys::new(b"wrong-secret", 60);
        let result = wrong.validate_token(&token);
        assert!(result.is_err());
    }

    #[test]
    fn validate_token_rejects_malformed_string() {
        let keys = keys();
        assert!(keys.validate_token("not.a.jwt").is_err());
        assert!(keys.validate_token("total-garbage").is_err());
    }
}

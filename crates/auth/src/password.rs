use argon2::{
    Argon2, PasswordHash, PasswordHasher, PasswordVerifier,
    password_hash::{SaltString, rand_core::OsRng},
};
use shared::error::AppError;
use std::time::Instant;

/// Hashes a plaintext password using Argon2id with a random salt.
///
/// This is a CPU-intensive operation and should be run on a blocking thread
/// (e.g. via [`tokio::task::spawn_blocking`]).
///
/// # Errors
///
/// Returns [`AppError::InternalError`] if hashing fails.
#[tracing::instrument(skip(password))]
pub fn hash_password(password: &str) -> Result<String, AppError> {
    let start = Instant::now();

    let salt = SaltString::generate(&mut OsRng);
    let hash = Argon2::default()
        .hash_password(password.as_bytes(), &salt)
        .map(|h| h.to_string())
        .map_err(|e| {
            tracing::error!(error = %e, "password hashing failed");
            AppError::InternalError
        })?;

    let elapsed_ms = start.elapsed().as_millis();
    tracing::debug!(elapsed_ms, "password hashed");
    Ok(hash)
}

/// Verifies a plaintext password against an Argon2 PHC hash string.
///
/// Returns `true` if the password matches, `false` otherwise.
///
/// This is a CPU-intensive operation and should be run on a blocking thread
/// (e.g. via [`tokio::task::spawn_blocking`]).
///
/// # Errors
///
/// Returns [`AppError::InternalError`] if the stored hash is malformed.
#[tracing::instrument(skip(password, hash))]
pub fn verify_password(password: &str, hash: &str) -> Result<bool, AppError> {
    let start = Instant::now();

    let parsed_hash = PasswordHash::new(hash).map_err(|e| {
        tracing::error!(error = %e, "password hash parsing failed");
        AppError::InternalError
    })?;

    let valid = Argon2::default()
        .verify_password(password.as_bytes(), &parsed_hash)
        .is_ok();

    let elapsed_ms = start.elapsed().as_millis();
    tracing::debug!(valid, elapsed_ms, "password verified");
    Ok(valid)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn hash_produces_valid_argon2_string() {
        let hash = hash_password("test-password-123").unwrap();
        assert!(hash.starts_with("$argon2"));
        PasswordHash::new(&hash).expect("hash should be a valid PHC string");
    }

    #[test]
    fn correct_password_verifies() {
        let hash = hash_password("correct-horse-battery").unwrap();
        assert!(verify_password("correct-horse-battery", &hash).unwrap());
    }

    #[test]
    fn wrong_password_fails_verification() {
        let hash = hash_password("correct-horse-battery").unwrap();
        assert!(!verify_password("wrong-password", &hash).unwrap());
    }
}

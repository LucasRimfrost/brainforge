//! Authentication and cryptographic utilities.
//!
//! - [`jwt`] — JWT access token creation and validation.
//! - [`password`] — Argon2 password hashing and verification.
//! - [`token`] — Opaque refresh / reset token generation, hashing, and verification.

pub mod jwt;
pub mod password;
pub mod token;

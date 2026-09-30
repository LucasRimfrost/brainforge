//! Authentication and cryptographic utilities.
//!
//! - [`password`] — Argon2 password hashing and verification.
//! - [`token`] — Opaque session / reset token generation, hashing, and verification.

pub mod password;
pub mod token;

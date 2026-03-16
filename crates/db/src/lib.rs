//! Database layer: connection pool, domain models, and query functions.
//!
//! All SQL is executed through compile-time checked [`sqlx`] macros.

pub mod connection;
pub mod models;
pub mod queries;

//! Shared types and utilities used across all crates in the workspace.
//!
//! This crate provides the application-wide error type ([`error::AppError`]),
//! a convenience result alias ([`error::AppResult`]), and environment-based
//! configuration ([`config::Config`]).

pub mod config;
pub mod error;

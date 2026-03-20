//! Database query functions using compile-time checked [`sqlx`] macros.
//!
//! Every public function in this module takes a [`PgPool`] reference and
//! returns an [`AppResult`]. Database errors are automatically converted
//! into [`AppError`] variants (with unique-violation mapped to
//! [`AppError::Conflict`]).

mod code_output;
mod games;
mod token;
mod trivia;
mod user;

pub use code_output::*;
pub use games::*;
pub use token::*;
pub use trivia::*;
pub use user::*;

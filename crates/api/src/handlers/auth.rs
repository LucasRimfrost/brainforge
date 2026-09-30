use axum::{
    Json,
    extract::State,
    http::{StatusCode, header},
    response::{AppendHeaders, IntoResponse},
};
use axum_extra::extract::CookieJar;
use db::queries::{
    create_session, delete_all_user_sessions, delete_other_user_sessions, delete_session_by_hash,
    find_code_output_stats, find_trivia_stats,
};
use serde::{Deserialize, Serialize};
use shared::error::{AppError, AppResult};
use validator::Validate;

use crate::{
    AppState,
    middleware::{AuthUser, auth::SESSION_COOKIE},
};

// ── Request types ───────────────────────────────────────────────────────────

/// Payload for `POST /auth/register`.
#[derive(Deserialize, Validate)]
pub struct RegisterRequest {
    #[validate(length(
        min = 3,
        max = 30,
        message = "Username must be between 3 and 30 characters"
    ))]
    pub username: String,

    #[validate(email(message = "Invalid email format"))]
    pub email: String,

    #[validate(length(min = 8, message = "Password must be at least 8 characters long"))]
    pub password: String,
}

/// Payload for `POST /auth/login`.
#[derive(Deserialize, Validate)]
pub struct LoginRequest {
    #[validate(email(message = "Invalid email format"))]
    pub email: String,
    #[validate(length(min = 1, message = "Password cannot be empty"))]
    pub password: String,
}

/// Payload for `POST /auth/forgot-password`.
#[derive(Deserialize, Validate)]
pub struct ForgotPasswordRequest {
    #[validate(email(message = "Invalid email format"))]
    pub email: String,
}

/// Payload for `POST /auth/reset-password`.
#[derive(Deserialize, Validate)]
pub struct ResetPasswordRequest {
    pub token: String,

    #[validate(length(min = 8, message = "Password must be at least 8 characters long"))]
    pub new_password: String,
}

/// Payload for `PATCH /auth/profile`.
#[derive(Deserialize, Validate)]
pub struct UpdateProfileRequest {
    #[validate(length(
        min = 3,
        max = 30,
        message = "Username must be between 3 and 30 characters"
    ))]
    pub username: String,
}

/// Payload for `PATCH /auth/email`. Requires re-authentication via `current_password`.
#[derive(Deserialize, Validate)]
pub struct UpdateEmailRequest {
    #[validate(email(message = "Invalid email format"))]
    pub new_email: String,
    #[validate(length(min = 1, message = "Password cannot be empty"))]
    pub current_password: String,
}

/// Payload for `PATCH /auth/password`. Requires re-authentication via `current_password`.
#[derive(Deserialize, Validate)]
pub struct UpdatePasswordRequest {
    #[validate(length(min = 1, message = "Current password cannot be empty"))]
    pub current_password: String,
    #[validate(length(min = 8, message = "New password must be at least 8 characters long"))]
    pub new_password: String,
}

// ── Response types ──────────────────────────────────────────────────────────

/// Returned after registration, login, and profile updates.
#[derive(Serialize)]
pub struct AuthResponse {
    pub id: String,
    pub username: String,
    pub email: String,
}

/// Returned by `GET /auth/me` — user profile combined with per-game stats.
#[derive(Serialize)]
pub struct MeResponse {
    pub id: String,
    pub username: String,
    pub email: String,
    pub trivia_stats: StatsResponse,
    pub code_output_stats: StatsResponse,
}

/// Aggregate game statistics for a single user and game type.
#[derive(Serialize, Default)]
pub struct StatsResponse {
    pub current_streak: i32,
    pub longest_streak: i32,
    pub total_solved: i32,
    pub total_attempts: i32,
}

// ── Handlers ────────────────────────────────────────────────────────────────

/// POST /api/v1/auth/register
pub async fn register(
    State(state): State<AppState>,
    Json(payload): Json<RegisterRequest>,
) -> AppResult<impl IntoResponse> {
    payload.validate()?;

    tracing::info!(email = %payload.email, username = %payload.username, "registration attempt");

    let password = payload.password.clone();
    let hashed = tokio::task::spawn_blocking(move || auth::password::hash_password(&password))
        .await
        .map_err(|e| {
            tracing::error!(error = %e, "password hashing task panicked");
            AppError::InternalError
        })??;

    let user =
        db::queries::create_user(&state.pool, &payload.username, &payload.email, &hashed).await?;

    tracing::info!(user_id = %user.id, email = %user.email, "user registered");

    let session_cookie = issue_session(&state, user.id).await?;

    Ok((
        StatusCode::CREATED,
        AppendHeaders([(header::SET_COOKIE, session_cookie.to_string())]),
        Json(AuthResponse {
            id: user.id.to_string(),
            username: user.username,
            email: user.email,
        }),
    ))
}

/// POST /api/v1/auth/login
pub async fn login(
    State(state): State<AppState>,
    Json(payload): Json<LoginRequest>,
) -> AppResult<impl IntoResponse> {
    payload.validate()?;

    tracing::info!(email = %payload.email, "login attempt");

    let user = db::queries::find_user_by_email(&state.pool, &payload.email)
        .await?
        .ok_or_else(|| {
            tracing::warn!(email = %payload.email, "login failed — unknown email");
            AppError::InvalidCredentials
        })?;

    let user_id = user.id;
    let password = payload.password.clone();
    let hash = user.password_hash.clone();
    let is_valid =
        tokio::task::spawn_blocking(move || auth::password::verify_password(&password, &hash))
            .await
            .map_err(|e| {
                tracing::error!(error = %e, "password verification task panicked");
                AppError::InternalError
            })??;

    if !is_valid {
        tracing::warn!(user_id = %user_id, "login failed — wrong password");
        return Err(AppError::InvalidCredentials);
    }

    let session_cookie = issue_session(&state, user.id).await?;

    tracing::info!(user_id = %user.id, "login successful");

    Ok((
        StatusCode::OK,
        AppendHeaders([(header::SET_COOKIE, session_cookie.to_string())]),
        Json(AuthResponse {
            id: user.id.to_string(),
            username: user.username,
            email: user.email,
        }),
    ))
}

/// POST /api/v1/auth/forgot-password
///
/// Always returns 200 regardless of whether the email exists.
/// This prevents email enumeration attacks.
pub async fn forgot_password(
    State(state): State<AppState>,
    Json(payload): Json<ForgotPasswordRequest>,
) -> AppResult<impl IntoResponse> {
    payload.validate()?;

    tracing::info!(email = %payload.email, "password reset requested");

    // Look up user — but don't reveal whether the email exists
    let user = db::queries::find_user_by_email(&state.pool, &payload.email).await?;

    if let Some(user) = user {
        // Generate reset token
        let raw_token = auth::token::generate_token();
        let token_hash = auth::token::hash_token(&raw_token);
        let expires_at = chrono::Utc::now() + chrono::Duration::minutes(30);

        db::queries::create_password_reset_token(&state.pool, user.id, &token_hash, expires_at)
            .await?;

        // TODO: The reset link must be sent by email instead. A logged token is a
        // working account-takeover link, so it is only logged in debug builds.
        // email::send_password_reset(&user.email, &reset_link).await?;
        if cfg!(debug_assertions) {
            let reset_link = format!("http://localhost:3000/reset-password?token={}", raw_token);

            tracing::info!(
                user_id = %user.id,
                "password reset link generated (dev only): {}",
                reset_link
            );
        }
    } else {
        tracing::debug!(email = %payload.email, "password reset for unknown email — ignoring silently");
    }

    // Always return success to prevent email enumeration
    Ok((
        StatusCode::OK,
        Json(serde_json::json!({
            "message": "If an account with that email exists, a password reset link has been sent."
        })),
    ))
}

/// POST /api/v1/auth/reset-password
pub async fn reset_password(
    State(state): State<AppState>,
    Json(payload): Json<ResetPasswordRequest>,
) -> AppResult<impl IntoResponse> {
    payload.validate()?;

    let token_hash = auth::token::hash_token(&payload.token);

    // Find the token
    let stored = db::queries::find_password_reset_token_by_hash(&state.pool, &token_hash)
        .await?
        .ok_or_else(|| {
            tracing::warn!("password reset failed — token not found");
            AppError::BadRequest("Invalid or expired reset token".to_string())
        })?;

    // Check if already used
    if stored.used_at.is_some() {
        tracing::warn!(token_id = %stored.id, "password reset failed — token already used");
        return Err(AppError::BadRequest(
            "This reset link has already been used".to_string(),
        ));
    }

    // Check if expired
    if stored.expires_at < chrono::Utc::now() {
        tracing::warn!(token_id = %stored.id, "password reset failed — token expired");
        db::queries::mark_password_reset_token_used(&state.pool, stored.id).await?;
        return Err(AppError::BadRequest(
            "This reset link has expired".to_string(),
        ));
    }

    // Hash the new password
    let new_password = payload.new_password.clone();
    let hashed = tokio::task::spawn_blocking(move || auth::password::hash_password(&new_password))
        .await
        .map_err(|e| {
            tracing::error!(error = %e, "password hashing task panicked");
            AppError::InternalError
        })??;

    // Atomically: update password + mark token used + delete all sessions.
    // Wrapped in a single transaction to prevent partial state on crash.
    db::queries::reset_password_atomic(&state.pool, stored.user_id, stored.id, &hashed).await?;

    tracing::info!(user_id = %stored.user_id, "password reset successful");

    Ok((
        StatusCode::OK,
        Json(serde_json::json!({
            "message": "Password has been reset. Please log in with your new password."
        })),
    ))
}

/// GET /api/v1/auth/me
pub async fn me(
    State(state): State<AppState>,
    auth_user: AuthUser,
) -> AppResult<impl IntoResponse> {
    let user_id = auth_user.id;

    let user = db::queries::find_user_profile_by_id(&state.pool, user_id)
        .await?
        .ok_or_else(|| {
            tracing::warn!(user_id = %user_id, "authenticated user not found in database");
            AppError::Unauthorized
        })?;

    let trivia_stats = match find_trivia_stats(&state.pool, user_id).await? {
        Some(s) => StatsResponse {
            current_streak: s.current_streak,
            longest_streak: s.longest_streak,
            total_solved: s.total_solved,
            total_attempts: s.total_attempts,
        },
        None => StatsResponse::default(),
    };

    let code_output_stats = match find_code_output_stats(&state.pool, user_id).await? {
        Some(s) => StatsResponse {
            current_streak: s.current_streak,
            longest_streak: s.longest_streak,
            total_solved: s.total_solved,
            total_attempts: s.total_attempts,
        },
        None => StatsResponse::default(),
    };

    tracing::debug!(user_id = %user_id, "profile fetched");

    Ok((
        StatusCode::OK,
        Json(MeResponse {
            id: user.id.to_string(),
            username: user.username,
            email: user.email,
            trivia_stats,
            code_output_stats,
        }),
    ))
}

/// POST /api/v1/auth/logout
///
/// Deletes the current session (if any) and clears the session cookie.
pub async fn logout(State(state): State<AppState>, jar: CookieJar) -> AppResult<impl IntoResponse> {
    if let Some(session_cookie) = jar.get(SESSION_COOKIE) {
        let token_hash = auth::token::hash_token(session_cookie.value());
        delete_session_by_hash(&state.pool, &token_hash).await?;
    }

    tracing::info!("user logged out");

    Ok((
        StatusCode::NO_CONTENT,
        AppendHeaders([(header::SET_COOKIE, build_logout_cookie().to_string())]),
    ))
}

/// POST /api/v1/auth/logout-all
///
/// Deletes every session belonging to the current user ("log out of all
/// devices") and clears the session cookie.
pub async fn logout_all(
    State(state): State<AppState>,
    auth_user: AuthUser,
) -> AppResult<impl IntoResponse> {
    delete_all_user_sessions(&state.pool, auth_user.id).await?;

    tracing::info!(user_id = %auth_user.id, "user logged out of all devices");

    Ok((
        StatusCode::NO_CONTENT,
        AppendHeaders([(header::SET_COOKIE, build_logout_cookie().to_string())]),
    ))
}

/// PATCH /api/v1/auth/profile
pub async fn update_profile(
    State(state): State<AppState>,
    auth_user: AuthUser,
    Json(payload): Json<UpdateProfileRequest>,
) -> AppResult<impl IntoResponse> {
    payload.validate()?;

    let user_id = auth_user.id;
    tracing::info!(%user_id, username = %payload.username, "profile update attempt");

    let user = db::queries::update_username(&state.pool, user_id, &payload.username).await?;

    tracing::info!(%user_id, "profile updated");

    Ok((
        StatusCode::OK,
        Json(AuthResponse {
            id: user.id.to_string(),
            username: user.username,
            email: user.email,
        }),
    ))
}

/// PATCH /api/v1/auth/email
pub async fn update_email(
    State(state): State<AppState>,
    auth_user: AuthUser,
    Json(payload): Json<UpdateEmailRequest>,
) -> AppResult<impl IntoResponse> {
    payload.validate()?;

    let user_id = auth_user.id;
    tracing::info!(%user_id, new_email = %payload.new_email, "email update attempt");

    let user = db::queries::find_user_by_id(&state.pool, user_id)
        .await?
        .ok_or(AppError::Unauthorized)?;

    let password = payload.current_password.clone();
    let hash = user.password_hash.clone();
    let is_valid =
        tokio::task::spawn_blocking(move || auth::password::verify_password(&password, &hash))
            .await
            .map_err(|e| {
                tracing::error!(error = %e, "password verification task panicked");
                AppError::InternalError
            })??;

    if !is_valid {
        tracing::warn!(%user_id, "email update failed — wrong password");
        return Err(AppError::InvalidCredentials);
    }

    let user = db::queries::update_email(&state.pool, user_id, &payload.new_email).await?;

    tracing::info!(%user_id, "email updated");

    Ok((
        StatusCode::OK,
        Json(AuthResponse {
            id: user.id.to_string(),
            username: user.username,
            email: user.email,
        }),
    ))
}

/// PATCH /api/v1/auth/password
pub async fn update_password(
    State(state): State<AppState>,
    auth_user: AuthUser,
    Json(payload): Json<UpdatePasswordRequest>,
) -> AppResult<impl IntoResponse> {
    payload.validate()?;

    let user_id = auth_user.id;
    tracing::info!(%user_id, "password change attempt");

    let user = db::queries::find_user_by_id(&state.pool, user_id)
        .await?
        .ok_or(AppError::Unauthorized)?;

    let current = payload.current_password.clone();
    let hash = user.password_hash.clone();
    let is_valid =
        tokio::task::spawn_blocking(move || auth::password::verify_password(&current, &hash))
            .await
            .map_err(|e| {
                tracing::error!(error = %e, "password verification task panicked");
                AppError::InternalError
            })??;

    if !is_valid {
        tracing::warn!(%user_id, "password change failed — wrong current password");
        return Err(AppError::InvalidCredentials);
    }

    let new_password = payload.new_password.clone();
    let hashed = tokio::task::spawn_blocking(move || auth::password::hash_password(&new_password))
        .await
        .map_err(|e| {
            tracing::error!(error = %e, "password hashing task panicked");
            AppError::InternalError
        })??;

    db::queries::update_user_password(&state.pool, user_id, &hashed).await?;

    // End all other sessions — force re-login on other devices, keep this one
    delete_other_user_sessions(&state.pool, user_id, auth_user.session_id).await?;

    tracing::info!(%user_id, "password changed");

    Ok((
        StatusCode::OK,
        Json(serde_json::json!({
            "message": "Password updated successfully"
        })),
    ))
}

// ── Private helpers ─────────────────────────────────────────────────────────

/// Create a new session for the user and return the cookie carrying its token.
///
/// Only the SHA-256 hash of the random token is stored in the database.
async fn issue_session(
    state: &AppState,
    user_id: uuid::Uuid,
) -> AppResult<axum_extra::extract::cookie::Cookie<'static>> {
    let raw_token = auth::token::generate_token();
    let token_hash = auth::token::hash_token(&raw_token);
    let expires_at = chrono::Utc::now() + chrono::Duration::days(state.config.session_expiry_days);

    create_session(&state.pool, user_id, &token_hash, expires_at).await?;

    Ok(build_session_cookie(
        raw_token,
        state.config.session_expiry_days,
    ))
}

fn build_session_cookie(
    token: String,
    expiry_days: i64,
) -> axum_extra::extract::cookie::Cookie<'static> {
    use axum_extra::extract::cookie::{Cookie, SameSite};

    Cookie::build((SESSION_COOKIE, token))
        .path("/")
        .http_only(true)
        .same_site(SameSite::Strict)
        .secure(!cfg!(debug_assertions))
        .max_age(time::Duration::days(expiry_days))
        .build()
}

fn build_logout_cookie() -> axum_extra::extract::cookie::Cookie<'static> {
    use axum_extra::extract::cookie::{Cookie, SameSite};

    Cookie::build((SESSION_COOKIE, String::new()))
        .path("/")
        .http_only(true)
        .same_site(SameSite::Strict)
        .secure(!cfg!(debug_assertions))
        .max_age(time::Duration::ZERO)
        .build()
}

mod common;

use serde_json::json;
use serial_test::serial;

// ── Registration ────────────────────────────────────────────────────────────

#[tokio::test]
#[serial]
async fn register_returns_201_and_user_data() {
    let app = common::TestApp::spawn().await;

    let resp = app
        .register("newuser", "new@example.com", "password123")
        .await;

    assert_eq!(resp.status(), 201);

    let body: serde_json::Value = resp.json().await.unwrap();
    assert_eq!(body["username"], "newuser");
    assert_eq!(body["email"], "new@example.com");
    assert!(body["id"].is_string());
}

#[tokio::test]
#[serial]
async fn register_sets_session_cookie() {
    let app = common::TestApp::spawn().await;

    let resp = app
        .register("cookieuser", "cookie@example.com", "password123")
        .await;

    let set_cookie = resp
        .headers()
        .get(reqwest::header::SET_COOKIE)
        .unwrap()
        .to_str()
        .unwrap();
    assert!(set_cookie.starts_with("session="));
    assert!(set_cookie.contains("HttpOnly"));
    assert!(set_cookie.contains("SameSite=Strict"));
    assert!(set_cookie.contains("Path=/"));

    // After register, /me should work (cookie was set and stored by the client)
    let resp = app
        .client
        .get(app.url("/api/v1/auth/me"))
        .send()
        .await
        .unwrap();
    assert_eq!(resp.status(), 200);
}

#[tokio::test]
#[serial]
async fn register_rejects_short_password() {
    let app = common::TestApp::spawn().await;

    let resp = app.register("user", "short@example.com", "short").await;
    assert_eq!(resp.status(), 422);
}

#[tokio::test]
#[serial]
async fn register_rejects_short_username() {
    let app = common::TestApp::spawn().await;

    let resp = app.register("ab", "short@example.com", "password123").await;
    assert_eq!(resp.status(), 422);
}

#[tokio::test]
#[serial]
async fn register_rejects_invalid_email() {
    let app = common::TestApp::spawn().await;

    let resp = app.register("user", "not-an-email", "password123").await;
    assert_eq!(resp.status(), 422);
}

#[tokio::test]
#[serial]
async fn register_rejects_duplicate_email() {
    let app = common::TestApp::spawn().await;

    app.register("first", "dupe@example.com", "password123")
        .await;

    let resp = app
        .register("second", "dupe@example.com", "password123")
        .await;
    assert_eq!(resp.status(), 409);
}

// ── Login ───────────────────────────────────────────────────────────────────

#[tokio::test]
#[serial]
async fn login_with_valid_credentials_returns_200() {
    let app = common::TestApp::spawn().await;

    app.register("loginuser", "login@example.com", "password123")
        .await;

    let resp = app.login("login@example.com", "password123").await;
    assert_eq!(resp.status(), 200);

    let body: serde_json::Value = resp.json().await.unwrap();
    assert_eq!(body["email"], "login@example.com");
    assert_eq!(body["username"], "loginuser");
}

#[tokio::test]
#[serial]
async fn login_with_wrong_password_returns_401() {
    let app = common::TestApp::spawn().await;

    app.register("wrongpw", "wrongpw@example.com", "password123")
        .await;

    let resp = app.login("wrongpw@example.com", "wrongpassword").await;
    assert_eq!(resp.status(), 401);
}

#[tokio::test]
#[serial]
async fn login_with_nonexistent_email_returns_401() {
    let app = common::TestApp::spawn().await;

    let resp = app.login("nobody@example.com", "password123").await;
    assert_eq!(resp.status(), 401);
}

#[tokio::test]
#[serial]
async fn login_rejects_invalid_email_format() {
    let app = common::TestApp::spawn().await;

    let resp = app.login("not-an-email", "password123").await;
    assert_eq!(resp.status(), 422);
}

#[tokio::test]
#[serial]
async fn login_rejects_empty_password() {
    let app = common::TestApp::spawn().await;

    let resp = app.login("test@example.com", "").await;
    assert_eq!(resp.status(), 422);
}

// ── Me ──────────────────────────────────────────────────────────────────────

#[tokio::test]
#[serial]
async fn me_without_cookie_returns_401() {
    let app = common::TestApp::spawn().await;

    // Fresh client — no cookie jar history
    let client = reqwest::Client::new();
    let resp = client.get(app.url("/api/v1/auth/me")).send().await.unwrap();
    assert_eq!(resp.status(), 401);
}

#[tokio::test]
#[serial]
async fn me_after_register_returns_profile_with_stats() {
    let app = common::TestApp::spawn().await;

    app.register_and_login().await;

    let resp = app
        .client
        .get(app.url("/api/v1/auth/me"))
        .send()
        .await
        .unwrap();
    assert_eq!(resp.status(), 200);

    let body: serde_json::Value = resp.json().await.unwrap();
    assert_eq!(body["username"], "testuser");
    assert_eq!(body["email"], "test@example.com");

    // Fresh user should have zeroed stats for both games
    let trivia = &body["trivia_stats"];
    assert_eq!(trivia["current_streak"], 0);
    assert_eq!(trivia["longest_streak"], 0);
    assert_eq!(trivia["total_solved"], 0);
    assert_eq!(trivia["total_attempts"], 0);

    let code_output = &body["code_output_stats"];
    assert_eq!(code_output["current_streak"], 0);
    assert_eq!(code_output["longest_streak"], 0);
    assert_eq!(code_output["total_solved"], 0);
    assert_eq!(code_output["total_attempts"], 0);
}

// ── Logout ──────────────────────────────────────────────────────────────────

#[tokio::test]
#[serial]
async fn logout_clears_session() {
    let app = common::TestApp::spawn().await;

    app.register_and_login().await;

    // Verify we're authenticated
    let resp = app
        .client
        .get(app.url("/api/v1/auth/me"))
        .send()
        .await
        .unwrap();
    assert_eq!(resp.status(), 200);

    // Logout
    let resp = app
        .client
        .post(app.url("/api/v1/auth/logout"))
        .send()
        .await
        .unwrap();
    assert_eq!(resp.status(), 204);

    // me should now fail
    let resp = app
        .client
        .get(app.url("/api/v1/auth/me"))
        .send()
        .await
        .unwrap();
    assert_eq!(resp.status(), 401);
}

#[tokio::test]
#[serial]
async fn login_after_logout_works() {
    let app = common::TestApp::spawn().await;

    app.register("relogin", "relogin@example.com", "password123")
        .await;

    // Logout
    app.client
        .post(app.url("/api/v1/auth/logout"))
        .send()
        .await
        .unwrap();

    // Login again
    let resp = app.login("relogin@example.com", "password123").await;
    assert_eq!(resp.status(), 200);

    // me should work again
    let resp = app
        .client
        .get(app.url("/api/v1/auth/me"))
        .send()
        .await
        .unwrap();
    assert_eq!(resp.status(), 200);
}

// ── Sessions ────────────────────────────────────────────────────────────────

#[tokio::test]
#[serial]
async fn session_cookie_is_rejected_after_logout() {
    let app = common::TestApp::spawn().await;

    let resp = app
        .register("replay", "replay@example.com", "password123")
        .await;
    let session = common::session_cookie(&resp);

    let resp = app
        .client
        .post(app.url("/api/v1/auth/logout"))
        .send()
        .await
        .unwrap();
    assert_eq!(resp.status(), 204);

    // Replay the old cookie from a client that never saw the logout response
    let resp = reqwest::Client::new()
        .get(app.url("/api/v1/auth/me"))
        .header("Cookie", session)
        .send()
        .await
        .unwrap();
    assert_eq!(resp.status(), 401);
}

#[tokio::test]
#[serial]
async fn logout_all_ends_every_session() {
    let app = common::TestApp::spawn().await;

    // Device A registers, device B logs in to the same account
    let resp = app
        .register("everywhere", "everywhere@example.com", "password123")
        .await;
    let session_a = common::session_cookie(&resp);

    let device_b = common::browser_client();
    let resp = device_b
        .post(app.url("/api/v1/auth/login"))
        .json(&json!({
            "email": "everywhere@example.com",
            "password": "password123",
        }))
        .send()
        .await
        .unwrap();
    assert_eq!(resp.status(), 200);
    let session_b = common::session_cookie(&resp);

    // Device B logs out everywhere
    let resp = device_b
        .post(app.url("/api/v1/auth/logout-all"))
        .send()
        .await
        .unwrap();
    assert_eq!(resp.status(), 204);

    // Neither session works any more, even when the cookie is replayed
    for session in [session_a, session_b] {
        let resp = reqwest::Client::new()
            .get(app.url("/api/v1/auth/me"))
            .header("Cookie", session)
            .send()
            .await
            .unwrap();
        assert_eq!(resp.status(), 401);
    }

    // Device A's own client is logged out too
    let resp = app
        .client
        .get(app.url("/api/v1/auth/me"))
        .send()
        .await
        .unwrap();
    assert_eq!(resp.status(), 401);
}

#[tokio::test]
#[serial]
async fn logout_all_requires_authentication() {
    let app = common::TestApp::spawn().await;

    let resp = app
        .client
        .post(app.url("/api/v1/auth/logout-all"))
        .send()
        .await
        .unwrap();
    assert_eq!(resp.status(), 401);
}

#[tokio::test]
#[serial]
async fn password_change_ends_other_sessions_but_keeps_current() {
    let app = common::TestApp::spawn().await;

    app.register("changer", "changer@example.com", "password123")
        .await;

    let other_device = common::browser_client();
    let resp = other_device
        .post(app.url("/api/v1/auth/login"))
        .json(&json!({
            "email": "changer@example.com",
            "password": "password123",
        }))
        .send()
        .await
        .unwrap();
    assert_eq!(resp.status(), 200);

    let resp = app
        .client
        .patch(app.url("/api/v1/auth/password"))
        .json(&json!({
            "current_password": "password123",
            "new_password": "newpassword456",
        }))
        .send()
        .await
        .unwrap();
    assert_eq!(resp.status(), 200);

    // The device that changed the password stays logged in
    let resp = app
        .client
        .get(app.url("/api/v1/auth/me"))
        .send()
        .await
        .unwrap();
    assert_eq!(resp.status(), 200);

    // The other device is logged out
    let resp = other_device
        .get(app.url("/api/v1/auth/me"))
        .send()
        .await
        .unwrap();
    assert_eq!(resp.status(), 401);
}

#[tokio::test]
#[serial]
async fn unknown_session_cookie_returns_401() {
    let app = common::TestApp::spawn().await;

    let resp = reqwest::Client::new()
        .get(app.url("/api/v1/auth/me"))
        .header("Cookie", "session=not-a-real-session-token")
        .send()
        .await
        .unwrap();
    assert_eq!(resp.status(), 401);
}

#[tokio::test]
#[serial]
async fn expired_session_cookie_returns_401() {
    let app = common::TestApp::spawn().await;

    let resp = app
        .register("expired", "expired@example.com", "password123")
        .await;
    let body: serde_json::Value = resp.json().await.unwrap();
    let user_id: uuid::Uuid = body["id"].as_str().unwrap().parse().unwrap();

    // Insert a session for this user that expired an hour ago
    let raw_token = auth::token::generate_token();
    sqlx::query(
        "INSERT INTO sessions (user_id, token_hash, expires_at)
         VALUES ($1, $2, now() - interval '1 hour')",
    )
    .bind(user_id)
    .bind(auth::token::hash_token(&raw_token))
    .execute(&app.pool)
    .await
    .expect("Failed to insert expired session");

    let resp = reqwest::Client::new()
        .get(app.url("/api/v1/auth/me"))
        .header("Cookie", format!("session={raw_token}"))
        .send()
        .await
        .unwrap();
    assert_eq!(resp.status(), 401);
}

// ── Edge cases ──────────────────────────────────────────────────────────────

#[tokio::test]
#[serial]
async fn register_with_missing_fields_returns_422() {
    let app = common::TestApp::spawn().await;

    // Missing password entirely
    let resp = app
        .client
        .post(app.url("/api/v1/auth/register"))
        .json(&json!({
            "username": "user",
            "email": "test@example.com"
        }))
        .send()
        .await
        .unwrap();

    assert_eq!(resp.status(), 422);
}

#[tokio::test]
#[serial]
async fn login_with_missing_fields_returns_422() {
    let app = common::TestApp::spawn().await;

    // Missing password
    let resp = app
        .client
        .post(app.url("/api/v1/auth/login"))
        .json(&json!({
            "email": "test@example.com"
        }))
        .send()
        .await
        .unwrap();

    assert_eq!(resp.status(), 422);
}

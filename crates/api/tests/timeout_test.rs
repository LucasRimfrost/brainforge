mod common;

use std::time::{Duration, Instant};

use serde_json::json;
use serial_test::serial;

/// Start a submit for the logged-in user while their row is locked by another
/// transaction, so the request stalls on the database. Returns the response
/// status and how long it took.
async fn stalled_submit(app: &common::TestApp) -> (u16, Duration) {
    let user = app.register_and_login().await;
    let user_id: uuid::Uuid = user["id"].as_str().unwrap().parse().unwrap();
    let challenge_id = app.seed_today_challenge().await;

    let mut blocker = app.pool.begin().await.unwrap();
    sqlx::query("SELECT id FROM users WHERE id = $1 FOR UPDATE")
        .bind(user_id)
        .execute(&mut *blocker)
        .await
        .unwrap();

    let start = Instant::now();
    let submit = app
        .client
        .post(app.url("/api/v1/trivia/submit"))
        .json(&json!({ "challenge_id": challenge_id, "answer": "4" }))
        .send();
    let resp = tokio::time::timeout(Duration::from_secs(8), submit)
        .await
        .expect("request was not cut off by any timeout")
        .unwrap();
    let elapsed = start.elapsed();

    blocker.rollback().await.unwrap();
    (resp.status().as_u16(), elapsed)
}

#[tokio::test]
#[serial]
async fn slow_request_is_cut_off_by_request_timeout() {
    let app = common::TestApp::spawn_with(|c| {
        c.request_timeout_secs = 1;
        c.db_statement_timeout_ms = 0;
    })
    .await;

    let (status, elapsed) = stalled_submit(&app).await;

    assert_eq!(status, 503);
    assert!(elapsed < Duration::from_secs(3), "took {elapsed:?}");
}

#[tokio::test]
#[serial]
async fn slow_query_is_cut_off_by_statement_timeout() {
    let app = common::TestApp::spawn_with(|c| {
        c.request_timeout_secs = 30;
        c.db_statement_timeout_ms = 500;
    })
    .await;

    let (status, elapsed) = stalled_submit(&app).await;

    assert_eq!(status, 500);
    assert!(elapsed < Duration::from_secs(3), "took {elapsed:?}");
}

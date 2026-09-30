mod common;

use std::collections::BTreeSet;

use chrono::{Duration, NaiveDate, Utc};
use serde_json::{Value, json};
use serial_test::serial;
use uuid::Uuid;

// The default seeded challenge: answer 4321.5 at 1 decimal, ±10%, 5 attempts.
// Its winning window is [3889.35, 4753.65] (±432.15), magnitude band 1000–10000.

/// Strings that must never appear in a response before the reveal: the
/// answer, the tolerance bounds (exact and rounded to 1 decimal), the
/// absolute tolerance, the explanation and the source.
const LEAK_STRINGS: &[&str] = &[
    "4321.5",
    "3889.35",
    "4753.65",
    "3889.4",
    "4753.6",
    "432.15",
    "widget science",
    "example.com/widgets",
];

/// JSON keys that must never appear anywhere before the reveal.
const FORBIDDEN_KEYS: &[&str] = &[
    "answer",
    "correct_answer",
    "best_guess",
    "best_error_pct",
    "error_pct",
    "explanation",
    "source_url",
    "tolerance",
    "lower_bound",
    "upper_bound",
    "distance",
];

const VIEW_KEYS: &[&str] = &[
    "id",
    "title",
    "question",
    "unit",
    "difficulty",
    "decimals",
    "tolerance_pct",
    "max_attempts",
    "scheduled_date",
    "attempts_used",
    "is_solved",
    "status",
    "guesses",
    "hint",
    "reveal",
];

const SUBMIT_KEYS: &[&str] = &[
    "feedback",
    "is_correct",
    "attempt_number",
    "attempts_remaining",
    "hint",
    "reveal",
];

const REVEAL_KEYS: &[&str] = &[
    "answer",
    "best_guess",
    "best_error_pct",
    "explanation",
    "source_url",
];

// ── Helpers ─────────────────────────────────────────────────────────────────

fn today() -> NaiveDate {
    Utc::now().date_naive()
}

fn key_set(v: &Value) -> BTreeSet<String> {
    v.as_object()
        .expect("expected a JSON object")
        .keys()
        .cloned()
        .collect()
}

fn expected_keys(keys: &[&str]) -> BTreeSet<String> {
    keys.iter().map(|k| k.to_string()).collect()
}

/// Collects every key that carries a non-null value (a `null` placeholder,
/// like history's unfinished `best_error_pct`, reveals nothing).
fn collect_keys(v: &Value, out: &mut Vec<String>) {
    match v {
        Value::Object(map) => {
            for (k, child) in map {
                if !child.is_null() {
                    out.push(k.clone());
                }
                collect_keys(child, out);
            }
        }
        Value::Array(items) => items.iter().for_each(|i| collect_keys(i, out)),
        _ => {}
    }
}

/// Asserts that a pre-reveal response body leaks nothing about the answer:
/// neither in its raw text nor via any non-null JSON key.
fn assert_no_leak(label: &str, raw: &str) {
    for needle in LEAK_STRINGS {
        assert!(
            !raw.contains(needle),
            "{label}: body leaks {needle:?}: {raw}"
        );
    }
    let v: Value = serde_json::from_str(raw).unwrap();
    let mut keys = Vec::new();
    collect_keys(&v, &mut keys);
    for key in &keys {
        assert!(
            !FORBIDDEN_KEYS.contains(&key.as_str()),
            "{label}: body has forbidden key {key:?}: {raw}"
        );
    }
}

/// Asserts a challenge view's exact key set, including each guess's keys.
fn assert_view_shape(label: &str, v: &Value) {
    assert_eq!(key_set(v), expected_keys(VIEW_KEYS), "{label}");
    for g in v["guesses"].as_array().unwrap() {
        assert_eq!(key_set(g), expected_keys(&["value", "feedback"]), "{label}");
    }
}

async fn submit_with(
    client: &reqwest::Client,
    app: &common::TestApp,
    challenge_id: Uuid,
    guess: &str,
) -> reqwest::Response {
    client
        .post(app.url("/api/v1/ballpark/submit"))
        .json(&json!({ "challenge_id": challenge_id, "guess": guess }))
        .send()
        .await
        .unwrap()
}

async fn submit(app: &common::TestApp, challenge_id: Uuid, guess: &str) -> reqwest::Response {
    submit_with(&app.client, app, challenge_id, guess).await
}

/// Submits a guess that must be accepted; returns the parsed body.
async fn submit_ok(app: &common::TestApp, challenge_id: Uuid, guess: &str) -> Value {
    let resp = submit(app, challenge_id, guess).await;
    assert_eq!(resp.status(), 200, "guess {guess:?}");
    resp.json().await.unwrap()
}

/// GETs a path and returns (status, raw body).
async fn get_raw_with(
    client: &reqwest::Client,
    app: &common::TestApp,
    path: &str,
) -> (u16, String) {
    let resp = client.get(app.url(path)).send().await.unwrap();
    let status = resp.status().as_u16();
    (status, resp.text().await.unwrap())
}

async fn get_json(app: &common::TestApp, path: &str) -> Value {
    let (status, raw) = get_raw_with(&app.client, app, path).await;
    assert_eq!(status, 200, "GET {path}: {raw}");
    serde_json::from_str(&raw).unwrap()
}

async fn me(app: &common::TestApp) -> Value {
    get_json(app, "/api/v1/auth/me").await
}

async fn count_submissions(app: &common::TestApp, challenge_id: Uuid) -> i64 {
    let (rows,): (i64,) =
        sqlx::query_as("SELECT count(*) FROM ballpark_submissions WHERE challenge_id = $1")
            .bind(challenge_id)
            .fetch_one(&app.pool)
            .await
            .unwrap();
    rows
}

async fn register_second_user(app: &common::TestApp, username: &str) -> (reqwest::Client, Value) {
    let client = common::browser_client();
    let resp = client
        .post(app.url("/api/v1/auth/register"))
        .json(&json!({
            "username": username,
            "email": format!("{username}@example.com"),
            "password": "password123",
        }))
        .send()
        .await
        .unwrap();
    assert_eq!(resp.status(), 201);
    let body = resp.json().await.unwrap();
    (client, body)
}

async fn seed_stats(
    app: &common::TestApp,
    user_id: &str,
    current: i32,
    longest: i32,
    solved: i32,
    last: NaiveDate,
) {
    let user_id: Uuid = user_id.parse().unwrap();
    sqlx::query(
        "INSERT INTO ballpark_stats (user_id, current_streak, longest_streak, total_solved, total_attempts, last_solved_date)
         VALUES ($1, $2, $3, $4, $4, $5)",
    )
    .bind(user_id)
    .bind(current)
    .bind(longest)
    .bind(solved)
    .bind(last)
    .execute(&app.pool)
    .await
    .unwrap();
}

// ── Rules: view ─────────────────────────────────────────────────────────────

#[tokio::test]
#[serial]
async fn today_returns_view_without_hint_or_reveal() {
    let app = common::TestApp::spawn().await;
    app.register_and_login().await;
    let challenge_id = app.seed_today_ballpark_challenge().await;

    let (status, raw) = get_raw_with(&app.client, &app, "/api/v1/ballpark/today").await;
    assert_eq!(status, 200);
    assert_no_leak("today", &raw);

    let body: Value = serde_json::from_str(&raw).unwrap();
    assert_view_shape("today", &body);
    assert_eq!(body["id"], challenge_id.to_string());
    assert_eq!(body["title"], "Ballpark Test");
    assert_eq!(body["question"], "How many widgets are there?");
    assert_eq!(body["unit"], "widgets");
    assert_eq!(body["difficulty"], "medium");
    assert_eq!(body["decimals"], 1);
    assert_eq!(body["tolerance_pct"], 10.0);
    assert_eq!(body["max_attempts"], 5);
    assert_eq!(body["scheduled_date"], today().to_string());
    assert_eq!(body["attempts_used"], 0);
    assert_eq!(body["is_solved"], false);
    assert_eq!(body["status"], "in_progress");
    assert_eq!(body["guesses"], json!([]));
    assert!(body["hint"].is_null());
    assert!(body["reveal"].is_null());
}

#[tokio::test]
#[serial]
async fn today_returns_404_when_no_challenge_scheduled() {
    let app = common::TestApp::spawn().await;
    app.register_and_login().await;

    let (status, _) = get_raw_with(&app.client, &app, "/api/v1/ballpark/today").await;
    assert_eq!(status, 404);
}

#[tokio::test]
#[serial]
async fn by_date_returns_past_challenge_and_400_for_bad_date() {
    let app = common::TestApp::spawn().await;
    app.register_and_login().await;
    let date = NaiveDate::from_ymd_opt(2025, 1, 15).unwrap();
    app.seed_ballpark_challenge_for_date(date).await;

    let body = get_json(&app, "/api/v1/ballpark/2025-01-15").await;
    assert_eq!(body["scheduled_date"], "2025-01-15");
    assert_eq!(body["status"], "in_progress");

    let (status, _) = get_raw_with(&app.client, &app, "/api/v1/ballpark/2025-02-30").await;
    assert_eq!(status, 400);
    let (status, _) = get_raw_with(&app.client, &app, "/api/v1/ballpark/2020-01-01").await;
    assert_eq!(status, 404);
}

// ── Rules: feedback and tolerance ───────────────────────────────────────────

#[tokio::test]
#[serial]
async fn submit_reports_too_low_too_high_and_within() {
    let app = common::TestApp::spawn().await;
    app.register_and_login().await;
    let challenge_id = app.seed_today_ballpark_challenge().await;

    let body = submit_ok(&app, challenge_id, "1000").await;
    assert_eq!(key_set(&body), expected_keys(SUBMIT_KEYS));
    assert_eq!(body["feedback"], "too_low");
    assert_eq!(body["is_correct"], false);
    assert_eq!(body["attempt_number"], 1);
    assert_eq!(body["attempts_remaining"], 4);

    let body = submit_ok(&app, challenge_id, "9000").await;
    assert_eq!(body["feedback"], "too_high");
    assert_eq!(body["attempt_number"], 2);

    let body = submit_ok(&app, challenge_id, "4500").await;
    assert_eq!(body["feedback"], "within");
    assert_eq!(body["is_correct"], true);
    assert_eq!(body["attempt_number"], 3);
    assert_eq!(body["attempts_remaining"], 2);

    let view = get_json(&app, "/api/v1/ballpark/today").await;
    assert_eq!(
        view["guesses"],
        json!([
            { "value": 1000.0, "feedback": "too_low" },
            { "value": 9000.0, "feedback": "too_high" },
            { "value": 4500.0, "feedback": "within" },
        ])
    );
}

#[tokio::test]
#[serial]
async fn submit_tolerance_edges_are_inclusive() {
    let app = common::TestApp::spawn().await;
    app.register_and_login().await;
    // answer 100, 3 decimals, ±10% → [90, 110]
    let upper = app
        .seed_ballpark_challenge("Upper", 100.0, 3, 10.0, 5, today())
        .await;
    let lower = app
        .seed_ballpark_challenge("Lower", 100.0, 3, 10.0, 5, today() - Duration::days(1))
        .await;

    assert_eq!(
        submit_ok(&app, upper, "110.001").await["feedback"],
        "too_high"
    );
    assert_eq!(submit_ok(&app, upper, "110").await["feedback"], "within");

    assert_eq!(
        submit_ok(&app, lower, "89.999").await["feedback"],
        "too_low"
    );
    assert_eq!(submit_ok(&app, lower, "90").await["feedback"], "within");
}

#[tokio::test]
#[serial]
async fn submit_half_unit_floor_lets_exact_small_answers_win() {
    let app = common::TestApp::spawn().await;
    app.register_and_login().await;
    // answer 8, integer: 10% is 0.8, so 7 and 9 miss and only 8 wins
    let legs = app
        .seed_ballpark_challenge("Legs", 8.0, 0, 10.0, 5, today())
        .await;
    // answer 3, integer: 10% is 0.3 < half a unit, so the floor (0.5) applies
    let small = app
        .seed_ballpark_challenge("Small", 3.0, 0, 10.0, 5, today() - Duration::days(1))
        .await;

    assert_eq!(submit_ok(&app, legs, "9").await["feedback"], "too_high");
    assert_eq!(submit_ok(&app, legs, "7").await["feedback"], "too_low");
    assert_eq!(submit_ok(&app, legs, "8").await["feedback"], "within");

    assert_eq!(submit_ok(&app, small, "4").await["feedback"], "too_high");
    assert_eq!(submit_ok(&app, small, "2").await["feedback"], "too_low");
    let body = submit_ok(&app, small, "3").await;
    assert_eq!(body["feedback"], "within");
    assert_eq!(body["reveal"]["best_error_pct"], 0.0);
}

#[tokio::test]
#[serial]
async fn submit_rounds_guess_to_challenge_decimals() {
    let app = common::TestApp::spawn().await;
    app.register_and_login().await;
    // 1 decimal
    let challenge_id = app.seed_today_ballpark_challenge().await;

    // 312.45 rounds half away from zero to 312.5
    assert_eq!(
        submit_ok(&app, challenge_id, "312.45").await["feedback"],
        "too_low"
    );
    // 2000.04 rounds to 2000.0
    assert_eq!(
        submit_ok(&app, challenge_id, "2000.04").await["feedback"],
        "too_low"
    );

    let view = get_json(&app, "/api/v1/ballpark/today").await;
    assert_eq!(view["guesses"][0]["value"], 312.5);
    assert_eq!(view["guesses"][1]["value"], 2000.0);

    // "2000" is the same value after rounding → duplicate
    assert_eq!(submit(&app, challenge_id, "2000").await.status(), 400);

    // Integer challenge: 2.6 rounds to 3 and wins
    let integer = app
        .seed_ballpark_challenge("Integer", 3.0, 0, 10.0, 5, today() - Duration::days(1))
        .await;
    let body = submit_ok(&app, integer, "2.6").await;
    assert_eq!(body["feedback"], "within");
    assert_eq!(body["reveal"]["best_guess"], 3.0);
}

// ── Rules: attempts, duplicates, hint and reveal ────────────────────────────

#[tokio::test]
#[serial]
async fn duplicate_guess_is_rejected_without_using_an_attempt() {
    let app = common::TestApp::spawn().await;
    app.register_and_login().await;
    let challenge_id = app.seed_today_ballpark_challenge().await;

    submit_ok(&app, challenge_id, "1000").await;

    for dup in ["1000", "1000.0", "0001000", "1000.04"] {
        let resp = submit(&app, challenge_id, dup).await;
        assert_eq!(resp.status(), 400, "{dup}");
        let body: Value = resp.json().await.unwrap();
        assert_eq!(body["error"], "You already guessed that");
    }

    let view = get_json(&app, "/api/v1/ballpark/today").await;
    assert_eq!(view["attempts_used"], 1);
    assert_eq!(count_submissions(&app, challenge_id).await, 1);
    assert_eq!(me(&app).await["ballpark_stats"]["total_attempts"], 1);

    // The next distinct guess is attempt 2.
    assert_eq!(
        submit_ok(&app, challenge_id, "1001").await["attempt_number"],
        2
    );
}

#[tokio::test]
#[serial]
async fn submit_rejects_after_max_attempts() {
    let app = common::TestApp::spawn().await;
    app.register_and_login().await;
    let challenge_id = app.seed_today_ballpark_challenge().await;

    for (i, guess) in ["1", "2", "3", "4", "5"].iter().enumerate() {
        let body = submit_ok(&app, challenge_id, guess).await;
        assert_eq!(body["attempt_number"], i as i64 + 1);
        assert_eq!(body["attempts_remaining"], 4 - i as i64);
    }

    let resp = submit(&app, challenge_id, "4321.5").await;
    assert_eq!(resp.status(), 400);
    let body: Value = resp.json().await.unwrap();
    assert_eq!(body["error"], "No attempts remaining");
    assert_eq!(count_submissions(&app, challenge_id).await, 5);
}

#[tokio::test]
#[serial]
async fn submit_rejects_after_solved() {
    let app = common::TestApp::spawn().await;
    app.register_and_login().await;
    let challenge_id = app.seed_today_ballpark_challenge().await;

    submit_ok(&app, challenge_id, "4321.5").await;

    let resp = submit(&app, challenge_id, "4000").await;
    assert_eq!(resp.status(), 400);
    let body: Value = resp.json().await.unwrap();
    assert_eq!(body["error"], "Challenge already solved");
    assert_eq!(count_submissions(&app, challenge_id).await, 1);
}

#[tokio::test]
#[serial]
async fn hint_unlocks_after_two_attempts_in_submit_and_get() {
    let app = common::TestApp::spawn().await;
    app.register_and_login().await;
    let challenge_id = app.seed_today_ballpark_challenge().await;
    let band = json!({ "low": 1000.0, "high": 10000.0 });
    let paths = [
        "/api/v1/ballpark/today".to_string(),
        format!("/api/v1/ballpark/{}", today()),
    ];

    for path in &paths {
        assert!(get_json(&app, path).await["hint"].is_null(), "{path}");
    }

    for (i, guess) in ["1", "2", "3", "4", "5"].iter().enumerate() {
        let attempt = i + 1;
        let body = submit_ok(&app, challenge_id, guess).await;

        // Submit: hint from attempt 2, but not once attempts are exhausted.
        if (2..5).contains(&attempt) {
            assert_eq!(body["hint"], band, "submit attempt {attempt}");
        } else {
            assert!(body["hint"].is_null(), "submit attempt {attempt}");
        }

        for path in &paths {
            let view = get_json(&app, path).await;
            if (2..5).contains(&attempt) {
                assert_eq!(view["hint"], band, "{path} after {attempt}");
            } else {
                assert!(view["hint"].is_null(), "{path} after {attempt}");
            }
        }
    }
}

#[tokio::test]
#[serial]
async fn hint_is_null_when_solved() {
    let app = common::TestApp::spawn().await;
    app.register_and_login().await;
    let challenge_id = app.seed_today_ballpark_challenge().await;

    submit_ok(&app, challenge_id, "1").await;
    submit_ok(&app, challenge_id, "2").await;
    let body = submit_ok(&app, challenge_id, "4321").await;
    assert_eq!(body["is_correct"], true);
    assert!(body["hint"].is_null());

    let view = get_json(&app, "/api/v1/ballpark/today").await;
    assert_eq!(view["status"], "solved");
    assert!(view["hint"].is_null());
}

#[tokio::test]
#[serial]
async fn reveal_on_solve() {
    let app = common::TestApp::spawn().await;
    app.register_and_login().await;
    let challenge_id = app.seed_today_ballpark_challenge().await;

    let body = submit_ok(&app, challenge_id, "3000").await;
    assert!(body["reveal"].is_null());

    let body = submit_ok(&app, challenge_id, "4000").await;
    assert_eq!(body["feedback"], "within");
    let reveal = &body["reveal"];
    assert_eq!(key_set(reveal), expected_keys(REVEAL_KEYS));
    assert_eq!(reveal["answer"], 4321.5);
    assert_eq!(reveal["best_guess"], 4000.0);
    let err = reveal["best_error_pct"].as_f64().unwrap();
    assert!((err - 321.5 / 4321.5 * 100.0).abs() < 1e-9, "{err}");
    assert_eq!(reveal["explanation"], "Because of widget science.");
    assert_eq!(reveal["source_url"], "https://example.com/widgets");

    for path in [
        "/api/v1/ballpark/today".to_string(),
        format!("/api/v1/ballpark/{}", today()),
    ] {
        let view = get_json(&app, &path).await;
        assert_view_shape(&path, &view);
        assert_eq!(view["status"], "solved");
        assert_eq!(view["is_solved"], true);
        assert_eq!(view["attempts_used"], 2);
        assert_eq!(view["reveal"], *reveal, "{path}");
    }
}

#[tokio::test]
#[serial]
async fn reveal_on_failure_shows_closest_guess() {
    let app = common::TestApp::spawn().await;
    app.register_and_login().await;
    let challenge_id = app.seed_today_ballpark_challenge().await;

    for guess in ["100", "9000", "3000", "6000"] {
        assert!(submit_ok(&app, challenge_id, guess).await["reveal"].is_null());
    }
    let body = submit_ok(&app, challenge_id, "10").await;
    assert_eq!(body["attempts_remaining"], 0);
    let reveal = &body["reveal"];
    assert_eq!(reveal["answer"], 4321.5);
    // 3000 is 30.6% off, 6000 is 38.8% off
    assert_eq!(reveal["best_guess"], 3000.0);
    let err = reveal["best_error_pct"].as_f64().unwrap();
    assert!((err - 1321.5 / 4321.5 * 100.0).abs() < 1e-9, "{err}");

    let view = get_json(&app, "/api/v1/ballpark/today").await;
    assert_eq!(view["status"], "failed");
    assert_eq!(view["is_solved"], false);
    assert_eq!(view["attempts_used"], 5);
    assert_eq!(view["reveal"], *reveal);
}

// ── Validation ──────────────────────────────────────────────────────────────

#[tokio::test]
#[serial]
async fn submit_rejects_invalid_guesses_with_422() {
    let app = common::TestApp::spawn().await;
    app.register_and_login().await;
    let challenge_id = app.seed_today_ballpark_challenge().await;

    let too_long = "1".repeat(33);
    for guess in [
        "abc",
        "NaN",
        "nan",
        "Infinity",
        "inf",
        "-inf",
        "-5",
        "1e5",
        "1000000000000001",
        "10000000000000001",
        "",
        "1.1234567",
        "1,000",
        " 42",
        too_long.as_str(),
    ] {
        let resp = submit(&app, challenge_id, guess).await;
        assert_eq!(resp.status(), 422, "guess {guess:?}");
    }

    // A JSON number instead of a string is a type error.
    let resp = app
        .client
        .post(app.url("/api/v1/ballpark/submit"))
        .json(&json!({ "challenge_id": challenge_id, "guess": 4321.5 }))
        .send()
        .await
        .unwrap();
    assert_eq!(resp.status(), 422);

    // Missing challenge_id.
    let resp = app
        .client
        .post(app.url("/api/v1/ballpark/submit"))
        .json(&json!({ "guess": "100" }))
        .send()
        .await
        .unwrap();
    assert_eq!(resp.status(), 422);

    // The upper bound itself is accepted.
    assert_eq!(
        submit(&app, challenge_id, "1000000000000000")
            .await
            .status(),
        200
    );

    // Only the valid guess was recorded.
    assert_eq!(count_submissions(&app, challenge_id).await, 1);
}

#[tokio::test]
#[serial]
async fn submit_validates_guess_before_challenge_lookup() {
    let app = common::TestApp::spawn().await;
    app.register_and_login().await;

    // Unknown challenge, but the guess is invalid: 422, not 404.
    let resp = submit(&app, Uuid::new_v4(), "NaN").await;
    assert_eq!(resp.status(), 422);

    let resp = submit(&app, Uuid::new_v4(), "100").await;
    assert_eq!(resp.status(), 404);
}

#[tokio::test]
#[serial]
async fn submit_body_over_4kib_returns_413() {
    let app = common::TestApp::spawn().await;
    app.register_and_login().await;
    let challenge_id = app.seed_today_ballpark_challenge().await;

    let resp = submit(&app, challenge_id, &"1".repeat(5000)).await;
    assert_eq!(resp.status(), 413);
}

// ── Scoring and stats ───────────────────────────────────────────────────────

#[tokio::test]
#[serial]
async fn solving_today_updates_streak_and_total() {
    let app = common::TestApp::spawn().await;
    app.register_and_login().await;
    let challenge_id = app.seed_today_ballpark_challenge().await;

    submit_ok(&app, challenge_id, "1000").await;
    submit_ok(&app, challenge_id, "4321.5").await;

    let body = me(&app).await;
    let stats = &body["ballpark_stats"];
    assert_eq!(stats["current_streak"], 1);
    assert_eq!(stats["longest_streak"], 1);
    assert_eq!(stats["total_solved"], 1);
    assert_eq!(stats["total_attempts"], 2);

    // Other games' stats are untouched.
    assert_eq!(body["trivia_stats"]["total_attempts"], 0);
    assert_eq!(body["code_output_stats"]["total_attempts"], 0);
}

#[tokio::test]
#[serial]
async fn solving_today_extends_or_resets_streak() {
    let app = common::TestApp::spawn().await;
    let user = app.register_and_login().await;
    let user_id = user["id"].as_str().unwrap();
    let challenge_id = app.seed_today_ballpark_challenge().await;

    // Solved yesterday with a streak of 3 → 4.
    seed_stats(&app, user_id, 3, 3, 3, today() - Duration::days(1)).await;
    submit_ok(&app, challenge_id, "4321.5").await;
    let stats = me(&app).await["ballpark_stats"].clone();
    assert_eq!(stats["current_streak"], 4);
    assert_eq!(stats["longest_streak"], 4);
    assert_eq!(stats["total_solved"], 4);

    // Last solved two days ago with a streak of 5 → reset to 1, longest kept.
    let (client_b, user_b) = register_second_user(&app, "streaker").await;
    seed_stats(
        &app,
        user_b["id"].as_str().unwrap(),
        5,
        7,
        9,
        today() - Duration::days(2),
    )
    .await;
    assert_eq!(
        submit_with(&client_b, &app, challenge_id, "4321.5")
            .await
            .status(),
        200
    );
    let (_, raw) = get_raw_with(&client_b, &app, "/api/v1/auth/me").await;
    let stats = serde_json::from_str::<Value>(&raw).unwrap()["ballpark_stats"].clone();
    assert_eq!(stats["current_streak"], 1);
    assert_eq!(stats["longest_streak"], 7);
    assert_eq!(stats["total_solved"], 10);
}

#[tokio::test]
#[serial]
async fn archive_solve_does_not_count_toward_streak_or_total() {
    let app = common::TestApp::spawn().await;
    app.register_and_login().await;
    let yesterday = today() - Duration::days(1);
    let challenge_id = app.seed_ballpark_challenge_for_date(yesterday).await;

    submit_ok(&app, challenge_id, "1000").await;
    let body = submit_ok(&app, challenge_id, "4321.5").await;
    assert_eq!(body["is_correct"], true);
    assert!(body["reveal"].is_object());

    let stats = me(&app).await["ballpark_stats"].clone();
    assert_eq!(stats["current_streak"], 0);
    assert_eq!(stats["longest_streak"], 0);
    assert_eq!(stats["total_solved"], 0);
    // Accepted guesses still count as attempts, archive plays included.
    assert_eq!(stats["total_attempts"], 2);

    // The archive shows it as solved.
    let archive = get_json(&app, "/api/v1/ballpark/archive").await;
    assert_eq!(archive[0]["is_solved"], true);
    assert_eq!(archive[0]["attempts_used"], 2);
}

#[tokio::test]
#[serial]
async fn wrong_attempts_increment_total_attempts() {
    let app = common::TestApp::spawn().await;
    app.register_and_login().await;
    let challenge_id = app.seed_today_ballpark_challenge().await;

    submit_ok(&app, challenge_id, "1").await;
    submit_ok(&app, challenge_id, "2").await;
    submit_ok(&app, challenge_id, "3").await;

    let stats = me(&app).await["ballpark_stats"].clone();
    assert_eq!(stats["total_attempts"], 3);
    assert_eq!(stats["total_solved"], 0);
    assert_eq!(stats["current_streak"], 0);
}

#[tokio::test]
#[serial]
async fn me_includes_zeroed_ballpark_stats_for_new_user() {
    let app = common::TestApp::spawn().await;
    app.register_and_login().await;

    let body = me(&app).await;
    assert_eq!(
        body["ballpark_stats"],
        json!({ "current_streak": 0, "longest_streak": 0, "total_solved": 0, "total_attempts": 0 })
    );
}

#[tokio::test]
#[serial]
async fn leaderboard_ballpark_orders_by_streak_then_solved() {
    let app = common::TestApp::spawn().await;
    let challenge_id = app.seed_today_ballpark_challenge().await;

    // User A: registered first, solves today with no prior streak → 1.
    app.register("user_a", "a@example.com", "password123").await;
    submit_ok(&app, challenge_id, "4321.5").await;

    // User B: solved yesterday (streak 2), solves today → 3.
    let (client_b, user_b) = register_second_user(&app, "user_b").await;
    seed_stats(
        &app,
        user_b["id"].as_str().unwrap(),
        2,
        2,
        2,
        today() - Duration::days(1),
    )
    .await;
    assert_eq!(
        submit_with(&client_b, &app, challenge_id, "4000")
            .await
            .status(),
        200
    );

    // User C: only a wrong guess → 0 streak, 0 solved.
    let (client_c, _) = register_second_user(&app, "user_c").await;
    assert_eq!(
        submit_with(&client_c, &app, challenge_id, "1")
            .await
            .status(),
        200
    );

    let board = get_json(&app, "/api/v1/leaderboard?game=ballpark").await;
    let rows = board.as_array().unwrap();
    let names: Vec<&str> = rows
        .iter()
        .map(|r| r["username"].as_str().unwrap())
        .collect();
    assert_eq!(names, ["user_b", "user_a", "user_c"]);
    assert_eq!(rows[0]["current_streak"], 3);
    assert_eq!(rows[0]["total_solved"], 3);
    assert_eq!(rows[1]["current_streak"], 1);
    assert_eq!(rows[1]["total_solved"], 1);
    assert_eq!(rows[2]["current_streak"], 0);

    // The trivia board is unaffected by ballpark solves.
    let trivia = get_json(&app, "/api/v1/leaderboard?game=trivia").await;
    assert!(trivia.as_array().unwrap().is_empty());
}

#[tokio::test]
#[serial]
async fn leaderboard_unknown_game_returns_422() {
    let app = common::TestApp::spawn().await;

    for game in ["chess", "code_output", "Ballpark", ""] {
        let resp = app
            .client
            .get(app.url(&format!("/api/v1/leaderboard?game={game}")))
            .send()
            .await
            .unwrap();
        assert_eq!(resp.status(), 422, "game={game:?}");
    }

    for path in [
        "/api/v1/leaderboard",
        "/api/v1/leaderboard?game=trivia",
        "/api/v1/leaderboard?game=code-output",
        "/api/v1/leaderboard?game=ballpark",
    ] {
        let resp = app.client.get(app.url(path)).send().await.unwrap();
        assert_eq!(resp.status(), 200, "{path}");
    }
}

#[tokio::test]
#[serial]
async fn games_list_includes_ballpark() {
    let app = common::TestApp::spawn().await;

    let games = get_json(&app, "/api/v1/games").await;
    let ids: Vec<&str> = games
        .as_array()
        .unwrap()
        .iter()
        .map(|g| g["id"].as_str().unwrap())
        .collect();
    assert_eq!(ids, ["trivia", "code_output", "ballpark"]);
    assert_eq!(games[2]["name"], "Ballpark");
}

// ── History and archive ─────────────────────────────────────────────────────

#[tokio::test]
#[serial]
async fn history_shows_best_error_pct_only_when_finished() {
    let app = common::TestApp::spawn().await;
    app.register_and_login().await;
    let challenge_id = app.seed_today_ballpark_challenge().await;

    let (status, raw) = get_raw_with(&app.client, &app, "/api/v1/ballpark/history").await;
    assert_eq!(status, 200);
    assert_eq!(raw, "[]");

    submit_ok(&app, challenge_id, "3000").await;

    let (_, raw) = get_raw_with(&app.client, &app, "/api/v1/ballpark/history").await;
    for needle in LEAK_STRINGS {
        assert!(!raw.contains(needle), "history leaks {needle}: {raw}");
    }
    let history: Value = serde_json::from_str(&raw).unwrap();
    assert_eq!(history.as_array().unwrap().len(), 1);
    assert_eq!(history[0]["challenge_id"], challenge_id.to_string());
    assert_eq!(history[0]["is_correct"], false);
    assert_eq!(history[0]["attempt_number"], 1);
    assert!(history[0]["best_error_pct"].is_null());

    submit_ok(&app, challenge_id, "4000").await;

    let history = get_json(&app, "/api/v1/ballpark/history?limit=5").await;
    assert_eq!(history[0]["is_correct"], true);
    assert_eq!(history[0]["attempt_number"], 2);
    let err = history[0]["best_error_pct"].as_f64().unwrap();
    assert!((err - 321.5 / 4321.5 * 100.0).abs() < 1e-9, "{err}");
}

#[tokio::test]
#[serial]
async fn archive_returns_past_challenges_only() {
    let app = common::TestApp::spawn().await;
    app.register_and_login().await;
    let yesterday = today() - Duration::days(1);
    let past = app.seed_ballpark_challenge_for_date(yesterday).await;
    app.seed_today_ballpark_challenge().await;
    app.seed_ballpark_challenge_for_date(today() + Duration::days(1))
        .await;

    let (status, raw) = get_raw_with(&app.client, &app, "/api/v1/ballpark/archive").await;
    assert_eq!(status, 200);
    assert_no_leak("archive", &raw);
    let archive: Value = serde_json::from_str(&raw).unwrap();
    let entries = archive.as_array().unwrap();
    assert_eq!(entries.len(), 1);
    assert_eq!(entries[0]["id"], past.to_string());
    assert_eq!(entries[0]["scheduled_date"], yesterday.to_string());
    assert_eq!(entries[0]["is_solved"], false);
    assert_eq!(entries[0]["attempts_used"], 0);
    assert_eq!(entries[0]["max_attempts"], 5);
}

// ── Authorization ───────────────────────────────────────────────────────────

#[tokio::test]
#[serial]
async fn every_endpoint_requires_auth() {
    let app = common::TestApp::spawn().await;
    let challenge_id = app.seed_today_ballpark_challenge().await;
    let client = reqwest::Client::new();

    for path in [
        "/api/v1/ballpark/today".to_string(),
        format!("/api/v1/ballpark/{}", today()),
        "/api/v1/ballpark/archive".to_string(),
        "/api/v1/ballpark/history".to_string(),
    ] {
        let resp = client.get(app.url(&path)).send().await.unwrap();
        assert_eq!(resp.status(), 401, "{path}");
    }

    let resp = client
        .post(app.url("/api/v1/ballpark/submit"))
        .header("x-requested-with", "XMLHttpRequest")
        .json(&json!({ "challenge_id": challenge_id, "guess": "100" }))
        .send()
        .await
        .unwrap();
    assert_eq!(resp.status(), 401);
    assert_eq!(count_submissions(&app, challenge_id).await, 0);
}

#[tokio::test]
#[serial]
async fn submit_without_x_requested_with_returns_403() {
    let app = common::TestApp::spawn().await;
    let challenge_id = app.seed_today_ballpark_challenge().await;

    // A logged-in client that does not send the CSRF header by default.
    let client = reqwest::Client::builder()
        .cookie_store(true)
        .build()
        .unwrap();
    let resp = client
        .post(app.url("/api/v1/auth/register"))
        .header("x-requested-with", "XMLHttpRequest")
        .json(&json!({ "username": "nocsrf", "email": "nocsrf@example.com", "password": "password123" }))
        .send()
        .await
        .unwrap();
    assert_eq!(resp.status(), 201);

    let resp = client
        .post(app.url("/api/v1/ballpark/submit"))
        .json(&json!({ "challenge_id": challenge_id, "guess": "100" }))
        .send()
        .await
        .unwrap();
    assert_eq!(resp.status(), 403);
    assert_eq!(count_submissions(&app, challenge_id).await, 0);
}

#[tokio::test]
#[serial]
async fn users_never_see_each_others_guesses_or_reveal() {
    let app = common::TestApp::spawn().await;
    app.register_and_login().await;
    let challenge_id = app.seed_today_ballpark_challenge().await;

    // User A exhausts all attempts and gets the reveal.
    for guess in ["1", "2", "3", "4", "5"] {
        submit_ok(&app, challenge_id, guess).await;
    }
    assert_eq!(
        get_json(&app, "/api/v1/ballpark/today").await["status"],
        "failed"
    );

    // User B sees a fresh, unrevealed challenge.
    let (client_b, _) = register_second_user(&app, "user_b").await;
    for path in [
        "/api/v1/ballpark/today".to_string(),
        format!("/api/v1/ballpark/{}", today()),
    ] {
        let (status, raw) = get_raw_with(&client_b, &app, &path).await;
        assert_eq!(status, 200);
        assert_no_leak(&path, &raw);
        let view: Value = serde_json::from_str(&raw).unwrap();
        assert_eq!(view["attempts_used"], 0, "{path}");
        assert_eq!(view["guesses"], json!([]), "{path}");
        assert_eq!(view["status"], "in_progress", "{path}");
        assert!(view["hint"].is_null(), "{path}");
        assert!(view["reveal"].is_null(), "{path}");
    }

    let (_, raw) = get_raw_with(&client_b, &app, "/api/v1/ballpark/history").await;
    assert_eq!(raw, "[]");

    // B's own guesses start at attempt 1 and A's guesses aren't duplicates.
    let resp = submit_with(&client_b, &app, challenge_id, "1").await;
    assert_eq!(resp.status(), 200);
    let raw = resp.text().await.unwrap();
    assert_no_leak("user B submit", &raw);
    let body: Value = serde_json::from_str(&raw).unwrap();
    assert_eq!(body["attempt_number"], 1);
    assert_eq!(body["attempts_remaining"], 4);

    // A's stats are A's alone.
    let (_, raw) = get_raw_with(&client_b, &app, "/api/v1/auth/me").await;
    let me_b: Value = serde_json::from_str(&raw).unwrap();
    assert_eq!(me_b["ballpark_stats"]["total_attempts"], 1);
    assert_eq!(me(&app).await["ballpark_stats"]["total_attempts"], 5);
}

// ── No early content, no leaked answers ─────────────────────────────────────

#[tokio::test]
#[serial]
async fn future_challenge_by_date_returns_404() {
    let app = common::TestApp::spawn().await;
    app.register_and_login().await;
    let tomorrow = today() + Duration::days(1);
    app.seed_ballpark_challenge_for_date(tomorrow).await;

    let (status, raw) =
        get_raw_with(&app.client, &app, &format!("/api/v1/ballpark/{tomorrow}")).await;
    assert_eq!(status, 404);
    assert_no_leak("future by date", &raw);

    // And `today` doesn't fall through to it.
    let (status, _) = get_raw_with(&app.client, &app, "/api/v1/ballpark/today").await;
    assert_eq!(status, 404);
}

#[tokio::test]
#[serial]
async fn submit_for_future_challenge_returns_404_and_inserts_nothing() {
    let app = common::TestApp::spawn().await;
    app.register_and_login().await;
    let tomorrow = today() + Duration::days(1);
    let challenge_id = app.seed_ballpark_challenge_for_date(tomorrow).await;

    for guess in ["1000", "4321.5"] {
        let resp = submit(&app, challenge_id, guess).await;
        assert_eq!(resp.status(), 404);
        assert_no_leak("future submit", &resp.text().await.unwrap());
    }

    assert_eq!(count_submissions(&app, challenge_id).await, 0);
    assert_eq!(me(&app).await["ballpark_stats"]["total_attempts"], 0);
}

#[tokio::test]
#[serial]
async fn future_challenge_never_appears_in_archive_history_or_leaderboard() {
    let app = common::TestApp::spawn().await;
    let user = app.register_and_login().await;
    let user_id: Uuid = user["id"].as_str().unwrap().parse().unwrap();
    let tomorrow = today() + Duration::days(1);
    let future = app.seed_ballpark_challenge_for_date(tomorrow).await;

    // A (manually inserted) submission on the future challenge.
    sqlx::query(
        "INSERT INTO ballpark_submissions (user_id, challenge_id, guess, feedback, error_pct, attempt_number)
         VALUES ($1, $2, 4321.5, 'within', 0, 1)",
    )
    .bind(user_id)
    .bind(future)
    .execute(&app.pool)
    .await
    .unwrap();

    let (_, raw) = get_raw_with(&app.client, &app, "/api/v1/ballpark/archive").await;
    assert_eq!(raw, "[]");

    let (_, raw) = get_raw_with(&app.client, &app, "/api/v1/ballpark/history").await;
    assert_eq!(raw, "[]");

    let (_, raw) = get_raw_with(&app.client, &app, "/api/v1/leaderboard?game=ballpark").await;
    assert_eq!(raw, "[]");
}

#[tokio::test]
#[serial]
async fn no_answer_leak_in_any_state_before_reveal() {
    let app = common::TestApp::spawn().await;
    app.register_and_login().await;
    let challenge_id = app.seed_today_ballpark_challenge().await;
    let paths = [
        "/api/v1/ballpark/today".to_string(),
        format!("/api/v1/ballpark/{}", today()),
        "/api/v1/ballpark/history".to_string(),
        "/api/v1/ballpark/archive".to_string(),
        "/api/v1/leaderboard?game=ballpark".to_string(),
        "/api/v1/games".to_string(),
        "/api/v1/auth/me".to_string(),
    ];

    // Wrong guesses on both sides of the answer, but outside the window.
    let guesses = ["1000", "9000", "3000", "6000", "3889.3"];

    for attempts in 0..=guesses.len() {
        if attempts > 0 {
            let resp = submit(&app, challenge_id, guesses[attempts - 1]).await;
            assert_eq!(resp.status(), 200);
            let raw = resp.text().await.unwrap();
            let body: Value = serde_json::from_str(&raw).unwrap();
            assert_eq!(key_set(&body), expected_keys(SUBMIT_KEYS));
            assert_ne!(body["feedback"], "within");
            if attempts < guesses.len() {
                assert_no_leak(&format!("submit {attempts}"), &raw);
                assert!(body["reveal"].is_null());
            } else {
                // The final attempt reveals.
                assert_eq!(body["reveal"]["answer"], 4321.5);
            }
        }

        if attempts == guesses.len() {
            break;
        }

        for path in &paths {
            let (status, raw) = get_raw_with(&app.client, &app, path).await;
            assert_eq!(status, 200, "{path}");
            let label = format!("{path} after {attempts} guesses");
            assert_no_leak(&label, &raw);

            if path.contains("/ballpark/")
                && !path.ends_with("history")
                && !path.ends_with("archive")
            {
                let view: Value = serde_json::from_str(&raw).unwrap();
                assert_view_shape(&label, &view);
                assert_eq!(view["status"], "in_progress", "{label}");
                assert_eq!(view["attempts_used"], attempts, "{label}");
                assert!(view["reveal"].is_null(), "{label}");
                if attempts < 2 {
                    assert!(view["hint"].is_null(), "{label}: hint before unlock");
                } else {
                    assert_eq!(
                        key_set(&view["hint"]),
                        expected_keys(&["low", "high"]),
                        "{label}"
                    );
                }
            }
        }
    }

    // After the reveal the answer is visible in the view.
    let view = get_json(&app, "/api/v1/ballpark/today").await;
    assert_eq!(view["status"], "failed");
    assert_eq!(view["reveal"]["answer"], 4321.5);
    assert_eq!(view["reveal"]["best_guess"], 3889.3);
}

// ── Concurrency ─────────────────────────────────────────────────────────────

/// Concurrent submissions from one user must still respect `max_attempts`.
#[tokio::test]
#[serial]
async fn concurrent_submits_do_not_exceed_max_attempts() {
    let app = common::TestApp::spawn().await;
    app.register_and_login().await;
    let challenge_id = app.seed_today_ballpark_challenge().await; // max_attempts = 5

    let mut set = tokio::task::JoinSet::new();
    for i in 1..=10 {
        // Distinct wrong guesses, so none is rejected as a duplicate.
        let req = app
            .client
            .post(app.url("/api/v1/ballpark/submit"))
            .json(&json!({ "challenge_id": challenge_id, "guess": i.to_string() }));
        set.spawn(async move { req.send().await.unwrap().status().as_u16() });
    }
    let statuses: Vec<u16> = set.join_all().await;

    assert_eq!(
        statuses.iter().filter(|&&s| s == 200).count(),
        5,
        "{statuses:?}"
    );
    assert!(
        statuses.iter().all(|&s| s == 200 || s == 400),
        "{statuses:?}"
    );
    assert_eq!(count_submissions(&app, challenge_id).await, 5);
    assert_eq!(me(&app).await["ballpark_stats"]["total_attempts"], 5);
}

/// A submission in flight for one user must not block other users' submissions
/// to the same (shared, daily) challenge.
#[tokio::test]
#[serial]
async fn submit_is_not_blocked_by_other_users_in_flight_submission() {
    let app = common::TestApp::spawn().await;
    let user_a = app.register_and_login().await;
    let user_a_id: Uuid = user_a["id"].as_str().unwrap().parse().unwrap();
    let challenge_id = app.seed_today_ballpark_challenge().await;
    let submit_url = app.url("/api/v1/ballpark/submit");

    // User A's first attempt creates their stats row.
    let resp = app
        .client
        .post(&submit_url)
        .json(&json!({ "challenge_id": challenge_id, "guess": "1" }))
        .send()
        .await
        .unwrap();
    assert_eq!(resp.status(), 200);

    // Stall user A's next submission mid-transaction by locking their stats row.
    let mut stall = app.pool.begin().await.unwrap();
    sqlx::query("SELECT 1 FROM ballpark_stats WHERE user_id = $1 FOR UPDATE")
        .bind(user_a_id)
        .execute(&mut *stall)
        .await
        .unwrap();
    let a_submit = app
        .client
        .post(&submit_url)
        .json(&json!({ "challenge_id": challenge_id, "guess": "2" }))
        .send();
    let a_task = tokio::spawn(a_submit);
    tokio::time::sleep(std::time::Duration::from_millis(300)).await;

    // User B submits to the same challenge while A's transaction is open.
    let (client_b, _) = register_second_user(&app, "userb").await;
    let b_submit = client_b
        .post(&submit_url)
        .json(&json!({ "challenge_id": challenge_id, "guess": "4321.5" }))
        .send();
    let resp = tokio::time::timeout(std::time::Duration::from_secs(3), b_submit)
        .await
        .expect("user B's submit was blocked by user A's in-flight submission")
        .unwrap();
    assert_eq!(resp.status(), 200);

    stall.rollback().await.unwrap();
    assert_eq!(a_task.await.unwrap().unwrap().status(), 200);
}

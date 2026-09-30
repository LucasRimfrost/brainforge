#![allow(dead_code)]

use api::{AppState, routes};
use db::connection::create_pool;
use shared::config::Config;
use sqlx::PgPool;
use std::net::SocketAddr;
use std::sync::Arc;
use tokio::net::TcpListener;

pub struct TestApp {
    pub addr: SocketAddr,
    pub pool: PgPool,
    pub client: reqwest::Client,
    config: Arc<Config>,
}

impl TestApp {
    /// Spawn a fully wired test server on a random port.
    ///
    /// - Loads config from `.env.test`
    /// - Cleans all tables so each test starts fresh
    /// - Launches the real router (handlers, middleware, rate limiting, etc.)
    /// - Returns a `reqwest::Client` with a cookie jar (behaves like a browser)
    pub async fn spawn() -> Self {
        Self::spawn_with(|_| {}).await
    }

    /// Like [`TestApp::spawn`], but lets the test adjust the loaded config
    /// (e.g. set `static_dir`) before the router is built.
    pub async fn spawn_with(configure: impl FnOnce(&mut Config)) -> Self {
        // Load .env.test from the workspace root
        dotenvy::from_filename(".env.test").ok();

        let mut config = Config::from_env().expect("Failed to load test config");
        configure(&mut config);
        let config = Arc::new(config);

        let pool = create_pool(&config)
            .await
            .expect("Failed to connect to test database");

        cleanup_db(&pool).await;

        let state = AppState {
            pool: pool.clone(),
            config: Arc::clone(&config),
        };

        let router = routes::router(state);

        let listener = TcpListener::bind("127.0.0.1:0")
            .await
            .expect("Failed to bind test server");
        let addr = listener.local_addr().unwrap();

        tokio::spawn(async move {
            axum::serve(
                listener,
                router.into_make_service_with_connect_info::<SocketAddr>(),
            )
            .await
            .unwrap();
        });

        let client = browser_client();

        Self {
            addr,
            pool,
            client,
            config,
        }
    }

    /// Build a full URL from a path, e.g. `/api/v1/auth/login`
    pub fn url(&self, path: &str) -> String {
        format!("http://{}{}", self.addr, path)
    }

    /// Access the test server's configuration (e.g. for crafting JWTs in tests).
    pub fn config(&self) -> &Config {
        &self.config
    }

    // ── Auth helpers ────────────────────────────────────────────────

    /// Register a user and return the response body as JSON.
    /// The client's cookie jar will hold the access_token after this.
    pub async fn register(&self, username: &str, email: &str, password: &str) -> reqwest::Response {
        self.client
            .post(self.url("/api/v1/auth/register"))
            .json(&serde_json::json!({
                "username": username,
                "email": email,
                "password": password,
            }))
            .send()
            .await
            .expect("Failed to send register request")
    }

    /// Login and return the response. Cookie jar is updated automatically.
    pub async fn login(&self, email: &str, password: &str) -> reqwest::Response {
        self.client
            .post(self.url("/api/v1/auth/login"))
            .json(&serde_json::json!({
                "email": email,
                "password": password,
            }))
            .send()
            .await
            .expect("Failed to send login request")
    }

    /// Register a default test user and leave the client authenticated.
    pub async fn register_and_login(&self) -> serde_json::Value {
        let resp = self
            .register("testuser", "test@example.com", "password123")
            .await;
        assert_eq!(resp.status(), 201);
        resp.json().await.unwrap()
    }

    // ── Seed helpers (for data that has no creation API) ────────────

    /// Insert a challenge for a given date directly into the database.
    /// Returns the challenge UUID.
    pub async fn seed_challenge(
        &self,
        title: &str,
        description: &str,
        difficulty: &str,
        expected_answer: &str,
        max_attempts: i32,
        scheduled_date: chrono::NaiveDate,
    ) -> uuid::Uuid {
        let rec: (uuid::Uuid,) = sqlx::query_as(
            "INSERT INTO trivia_challenges (title, description, difficulty, expected_answer, max_attempts, scheduled_date)
             VALUES ($1, $2, $3, $4, $5, $6)
             RETURNING id"
        )
        .bind(title)
        .bind(description)
        .bind(difficulty)
        .bind(expected_answer)
        .bind(max_attempts)
        .bind(scheduled_date)
        .fetch_one(&self.pool)
        .await
        .expect("Failed to seed challenge");

        rec.0
    }

    /// Seed a challenge for today with reasonable defaults.
    pub async fn seed_today_challenge(&self) -> uuid::Uuid {
        let today = chrono::Utc::now().date_naive();
        self.seed_challenge("Test Challenge", "What is 2 + 2?", "easy", "4", 3, today)
            .await
    }

    /// Seed a challenge for a specific date with reasonable defaults.
    pub async fn seed_challenge_for_date(&self, date: chrono::NaiveDate) -> uuid::Uuid {
        self.seed_challenge(
            "Past Challenge",
            "What color is the sky?",
            "easy",
            "blue",
            3,
            date,
        )
        .await
    }

    #[allow(clippy::too_many_arguments)]
    pub async fn seed_code_output_challenge(
        &self,
        title: &str,
        description: &str,
        language: &str,
        code_snippet: &str,
        expected_output: &str,
        max_attempts: i32,
        scheduled_date: chrono::NaiveDate,
    ) -> uuid::Uuid {
        let rec: (uuid::Uuid,) = sqlx::query_as(
            "INSERT INTO code_output_challenges (title, description, language, code_snippet, expected_output, difficulty, max_attempts, scheduled_date)
             VALUES ($1, $2, $3, $4, $5, 'easy', $6, $7)
             RETURNING id"
        )
        .bind(title)
        .bind(description)
        .bind(language)
        .bind(code_snippet)
        .bind(expected_output)
        .bind(max_attempts)
        .bind(scheduled_date)
        .fetch_one(&self.pool)
        .await
        .expect("Failed to seed code output challenge");

        rec.0
    }

    pub async fn seed_today_code_output_challenge(&self) -> uuid::Uuid {
        let today = chrono::Utc::now().date_naive();
        self.seed_code_output_challenge(
            "Print Test",
            "What does this code print?",
            "python",
            "x = [1, 2, 3]\nprint(x[1:])",
            "[2, 3]",
            3,
            today,
        )
        .await
    }

    /// Insert a ballpark challenge directly into the database.
    /// Returns the challenge UUID.
    pub async fn seed_ballpark_challenge(
        &self,
        title: &str,
        answer: f64,
        decimals: i16,
        tolerance_pct: f64,
        max_attempts: i32,
        scheduled_date: chrono::NaiveDate,
    ) -> uuid::Uuid {
        let rec: (uuid::Uuid,) = sqlx::query_as(
            "INSERT INTO ballpark_challenges (title, question, unit, answer, decimals, tolerance_pct,
                                              difficulty, explanation, source_url, max_attempts, scheduled_date)
             VALUES ($1, 'How many widgets are there?', 'widgets', $2, $3, $4,
                     'medium', 'Because of widget science.', 'https://example.com/widgets', $5, $6)
             RETURNING id",
        )
        .bind(title)
        .bind(answer)
        .bind(decimals)
        .bind(tolerance_pct)
        .bind(max_attempts)
        .bind(scheduled_date)
        .fetch_one(&self.pool)
        .await
        .expect("Failed to seed ballpark challenge");

        rec.0
    }

    /// Seed a ballpark challenge for a specific date with the default rules
    /// (5 attempts, ±10%) and a distinctive answer of `4321.5` at 1 decimal.
    pub async fn seed_ballpark_challenge_for_date(&self, date: chrono::NaiveDate) -> uuid::Uuid {
        self.seed_ballpark_challenge("Ballpark Test", 4321.5, 1, 10.0, 5, date)
            .await
    }

    /// Seed today's ballpark challenge with the defaults of
    /// [`TestApp::seed_ballpark_challenge_for_date`].
    pub async fn seed_today_ballpark_challenge(&self) -> uuid::Uuid {
        let today = chrono::Utc::now().date_naive();
        self.seed_ballpark_challenge_for_date(today).await
    }
}

/// Build a `reqwest::Client` that behaves like the frontend in a browser: it
/// keeps a cookie jar and sends the `X-Requested-With` CSRF header.
///
/// Use this to simulate a second device logged in to the same account.
pub fn browser_client() -> reqwest::Client {
    let mut default_headers = reqwest::header::HeaderMap::new();
    default_headers.insert(
        "x-requested-with",
        reqwest::header::HeaderValue::from_static("XMLHttpRequest"),
    );

    reqwest::Client::builder()
        .cookie_store(true)
        .default_headers(default_headers)
        .build()
        .unwrap()
}

/// Extract the `session=<token>` pair from a response's `Set-Cookie` header,
/// ready to be replayed in a `Cookie` header.
pub fn session_cookie(resp: &reqwest::Response) -> String {
    resp.headers()
        .get_all(reqwest::header::SET_COOKIE)
        .iter()
        .filter_map(|v| v.to_str().ok())
        .find(|v| v.starts_with("session="))
        .and_then(|v| v.split(';').next())
        .expect("response did not set a session cookie")
        .to_string()
}

/// Delete all data from every table, respecting foreign key order.
/// Runs before each test so every test starts with a clean slate.
async fn cleanup_db(pool: &PgPool) {
    sqlx::query("DELETE FROM ballpark_submissions")
        .execute(pool)
        .await
        .expect("Failed to clean ballpark_submissions");
    sqlx::query("DELETE FROM ballpark_stats")
        .execute(pool)
        .await
        .expect("Failed to clean ballpark_stats");
    sqlx::query("DELETE FROM ballpark_challenges")
        .execute(pool)
        .await
        .expect("Failed to clean ballpark_challenges");
    sqlx::query("DELETE FROM code_output_submissions")
        .execute(pool)
        .await
        .expect("Failed to clean code_output_submissions");
    sqlx::query("DELETE FROM code_output_stats")
        .execute(pool)
        .await
        .expect("Failed to clean code_output_stats");
    sqlx::query("DELETE FROM trivia_submissions")
        .execute(pool)
        .await
        .expect("Failed to clean trivia_submissions");
    sqlx::query("DELETE FROM trivia_stats")
        .execute(pool)
        .await
        .expect("Failed to clean trivia_stats");
    sqlx::query("DELETE FROM sessions")
        .execute(pool)
        .await
        .expect("Failed to clean sessions");
    sqlx::query("DELETE FROM password_reset_tokens")
        .execute(pool)
        .await
        .expect("Failed to clean password_reset_tokens");
    sqlx::query("DELETE FROM code_output_challenges")
        .execute(pool)
        .await
        .expect("Failed to clean code_output_challenges");
    sqlx::query("DELETE FROM trivia_challenges")
        .execute(pool)
        .await
        .expect("Failed to clean trivia_challenges");
    sqlx::query("DELETE FROM users")
        .execute(pool)
        .await
        .expect("Failed to clean users");
}

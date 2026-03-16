use std::sync::Arc;
use std::time::Duration;

use governor::middleware::StateInformationMiddleware;
use tower_governor::governor::{GovernorConfig, GovernorConfigBuilder};
use tower_governor::key_extractor::SmartIpKeyExtractor;

/// Shared, arc-wrapped governor configuration keyed by client IP.
pub type RateLimitConfig = Arc<GovernorConfig<SmartIpKeyExtractor, StateInformationMiddleware>>;

/// Holds the two rate-limiter configurations used by the application.
///
/// - `global` — applies to every request (5 req/s, burst of 50).
/// - `auth` — stricter limiter for authentication endpoints (1 req/10s, burst of 5).
pub struct RateLimiters {
    pub global: RateLimitConfig,
    pub auth: RateLimitConfig,
}

impl Default for RateLimiters {
    fn default() -> Self {
        Self::new()
    }
}

impl RateLimiters {
    /// Creates the global and auth rate limiters with default parameters.
    pub fn new() -> Self {
        let global = Arc::new(
            GovernorConfigBuilder::default()
                .per_millisecond(200)
                .burst_size(50)
                .key_extractor(SmartIpKeyExtractor)
                .use_headers()
                .finish()
                .expect("invalid global rate-limiter config"),
        );

        let auth = Arc::new(
            GovernorConfigBuilder::default()
                .per_second(10)
                .burst_size(5)
                .key_extractor(SmartIpKeyExtractor)
                .use_headers()
                .finish()
                .expect("invalid auth rate-limiter config"),
        );

        Self { global, auth }
    }

    /// Spawns a background task that evicts stale rate-limiter entries every 60 seconds.
    pub fn spawn_cleanup(&self) {
        let global_limiter = self.global.limiter().clone();
        let auth_limiter = self.auth.limiter().clone();

        tokio::spawn(async move {
            let mut interval = tokio::time::interval(Duration::from_secs(60));
            loop {
                interval.tick().await;
                tracing::debug!(
                    "rate-limiter cleanup — global keys: {}, auth keys: {}",
                    global_limiter.len(),
                    auth_limiter.len(),
                );
                global_limiter.retain_recent();
                auth_limiter.retain_recent();
            }
        });
    }
}

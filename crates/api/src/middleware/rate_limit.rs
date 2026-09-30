use std::net::IpAddr;
use std::sync::Arc;
use std::time::Duration;

use axum::http::Request;
use governor::middleware::StateInformationMiddleware;
use tower_governor::GovernorError;
use tower_governor::governor::{GovernorConfig, GovernorConfigBuilder};
use tower_governor::key_extractor::{KeyExtractor, PeerIpKeyExtractor, SmartIpKeyExtractor};

/// Shared, arc-wrapped governor configuration keyed by client IP.
pub type RateLimitConfig = Arc<GovernorConfig<ClientIpKeyExtractor, StateInformationMiddleware>>;

/// Determines the client IP used as the rate-limit key.
///
/// Chosen at startup from `TRUST_PROXY_HEADERS`:
///
/// - `Peer` (default) — the real socket address. Clients cannot influence it.
/// - `Smart` — `X-Forwarded-For` / `X-Real-IP` / `Forwarded`, falling back to
///   the socket address. Only safe behind a reverse proxy that overwrites
///   those headers; otherwise any client can fake a new IP per request and
///   bypass the limits.
#[derive(Debug, Clone, Copy)]
pub enum ClientIpKeyExtractor {
    Peer(PeerIpKeyExtractor),
    Smart(SmartIpKeyExtractor),
}

impl ClientIpKeyExtractor {
    /// Returns the proxy-header extractor if `trust_proxy_headers` is set,
    /// otherwise the socket-address extractor.
    pub fn new(trust_proxy_headers: bool) -> Self {
        if trust_proxy_headers {
            Self::Smart(SmartIpKeyExtractor)
        } else {
            Self::Peer(PeerIpKeyExtractor)
        }
    }
}

impl KeyExtractor for ClientIpKeyExtractor {
    type Key = IpAddr;

    fn name(&self) -> &'static str {
        match self {
            Self::Peer(k) => k.name(),
            Self::Smart(k) => k.name(),
        }
    }

    fn extract<T>(&self, req: &Request<T>) -> Result<Self::Key, GovernorError> {
        match self {
            Self::Peer(k) => k.extract(req),
            Self::Smart(k) => k.extract(req),
        }
    }

    fn key_name(&self, key: &Self::Key) -> Option<String> {
        Some(key.to_string())
    }
}

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
        Self::new(false)
    }
}

impl RateLimiters {
    /// Creates the global and auth rate limiters with default parameters.
    ///
    /// `trust_proxy_headers` selects the client-IP source; see
    /// [`ClientIpKeyExtractor`].
    pub fn new(trust_proxy_headers: bool) -> Self {
        let key_extractor = ClientIpKeyExtractor::new(trust_proxy_headers);
        tracing::info!(
            key_extractor = key_extractor.name(),
            "rate limiter client IP source"
        );

        let global = Arc::new(
            GovernorConfigBuilder::default()
                .per_millisecond(200)
                .burst_size(50)
                .key_extractor(key_extractor)
                .use_headers()
                .finish()
                .expect("invalid global rate-limiter config"),
        );

        let auth = Arc::new(
            GovernorConfigBuilder::default()
                .per_second(10)
                .burst_size(5)
                .key_extractor(key_extractor)
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

#[cfg(test)]
mod tests {
    use super::*;
    use axum::extract::ConnectInfo;
    use std::net::SocketAddr;

    const PEER: [u8; 4] = [127, 0, 0, 1];
    const FORGED: [u8; 4] = [203, 0, 113, 7];

    fn request_with_forwarded_for() -> Request<()> {
        let mut req = Request::builder()
            .header("x-forwarded-for", "203.0.113.7")
            .body(())
            .unwrap();
        req.extensions_mut()
            .insert(ConnectInfo(SocketAddr::from((PEER, 4000))));
        req
    }

    #[test]
    fn peer_extractor_ignores_forwarded_headers() {
        let key = ClientIpKeyExtractor::new(false)
            .extract(&request_with_forwarded_for())
            .unwrap();
        assert_eq!(key, IpAddr::from(PEER));
    }

    #[test]
    fn smart_extractor_uses_forwarded_headers() {
        let key = ClientIpKeyExtractor::new(true)
            .extract(&request_with_forwarded_for())
            .unwrap();
        assert_eq!(key, IpAddr::from(FORGED));
    }
}

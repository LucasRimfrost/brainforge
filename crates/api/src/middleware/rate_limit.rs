use std::net::IpAddr;
use std::sync::Arc;
use std::time::Duration;

use axum::http::{HeaderMap, Request};
use governor::middleware::StateInformationMiddleware;
use ipnet::IpNet;
use shared::config::Config;
use tower_governor::GovernorError;
use tower_governor::governor::{GovernorConfig, GovernorConfigBuilder};
use tower_governor::key_extractor::{KeyExtractor, PeerIpKeyExtractor};

/// Shared, arc-wrapped governor configuration keyed by client IP.
pub type RateLimitConfig = Arc<GovernorConfig<ClientIpKeyExtractor, StateInformationMiddleware>>;

/// Determines the client IP used as the rate-limit key.
///
/// Chosen at startup from `TRUST_PROXY_HEADERS`:
///
/// - `Peer` (default) — the real socket address. Clients cannot influence it.
/// - `Proxy` — taken from proxy headers; see [`ProxyIpKeyExtractor`]. Only
///   safe behind a reverse proxy; otherwise any client can fake a new IP per
///   request and bypass the limits.
#[derive(Debug, Clone)]
pub enum ClientIpKeyExtractor {
    Peer(PeerIpKeyExtractor),
    Proxy(ProxyIpKeyExtractor),
}

impl ClientIpKeyExtractor {
    /// Returns the proxy-header extractor if `trust_proxy_headers` is set,
    /// otherwise the socket-address extractor. `hops` and `trusted_proxies`
    /// only apply to the proxy-header extractor.
    pub fn new(trust_proxy_headers: bool, hops: usize, trusted_proxies: Vec<IpNet>) -> Self {
        if trust_proxy_headers {
            Self::Proxy(ProxyIpKeyExtractor {
                hops: hops.max(1),
                trusted_proxies: trusted_proxies.into(),
            })
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
            Self::Proxy(_) => "proxy X-Forwarded-For (rightmost minus trusted hops)",
        }
    }

    fn extract<T>(&self, req: &Request<T>) -> Result<Self::Key, GovernorError> {
        match self {
            Self::Peer(k) => k.extract(req),
            Self::Proxy(k) => Ok(k.client_ip(PeerIpKeyExtractor.extract(req)?, req.headers())),
        }
    }

    fn key_name(&self, key: &Self::Key) -> Option<String> {
        Some(key.to_string())
    }
}

/// Client IP from proxy headers, for use behind trusted reverse proxies.
///
/// Proxies such as nginx (`$proxy_add_x_forwarded_for`) and AWS ALB *append*
/// the address they saw to `X-Forwarded-For`, so everything left of the
/// entries added by our own proxies is client-supplied and can be forged. The
/// client IP is therefore the entry `hops` places from the right. Without
/// `X-Forwarded-For` it falls back to `X-Real-IP`, then the socket address.
///
/// If `trusted_proxies` is non-empty, headers are only read when the socket
/// address is in one of those networks; other connections use the socket
/// address.
#[derive(Debug, Clone)]
pub struct ProxyIpKeyExtractor {
    hops: usize,
    trusted_proxies: Arc<[IpNet]>,
}

impl ProxyIpKeyExtractor {
    fn client_ip(&self, peer: IpAddr, headers: &HeaderMap) -> IpAddr {
        if !self.trusted_proxies.is_empty()
            && !self.trusted_proxies.iter().any(|net| net.contains(&peer))
        {
            return peer;
        }

        let forwarded: Vec<&str> = headers
            .get_all("x-forwarded-for")
            .iter()
            .filter_map(|v| v.to_str().ok())
            .flat_map(|v| v.split(','))
            .map(str::trim)
            .collect();

        if !forwarded.is_empty() {
            let entry = forwarded[forwarded.len().saturating_sub(self.hops)];
            return entry.parse().unwrap_or(peer);
        }

        headers
            .get("x-real-ip")
            .and_then(|v| v.to_str().ok())
            .and_then(|v| v.trim().parse().ok())
            .unwrap_or(peer)
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

impl RateLimiters {
    /// Creates the global and auth rate limiters with default parameters.
    ///
    /// The client-IP source comes from `TRUST_PROXY_HEADERS`,
    /// `TRUSTED_PROXY_HOPS` and `TRUSTED_PROXY_CIDRS`; see
    /// [`ClientIpKeyExtractor`].
    pub fn new(config: &Config) -> Self {
        let key_extractor = ClientIpKeyExtractor::new(
            config.trust_proxy_headers,
            config.trusted_proxy_hops,
            config.trusted_proxy_cidrs.clone(),
        );
        tracing::info!(
            key_extractor = key_extractor.name(),
            "rate limiter client IP source"
        );

        let global = Arc::new(
            GovernorConfigBuilder::default()
                .per_millisecond(200)
                .burst_size(50)
                .key_extractor(key_extractor.clone())
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
    const CLIENT: [u8; 4] = [198, 51, 100, 20];

    fn request(headers: &[(&str, &str)]) -> Request<()> {
        let mut builder = Request::builder();
        for (name, value) in headers {
            builder = builder.header(*name, *value);
        }
        let mut req = builder.body(()).unwrap();
        req.extensions_mut()
            .insert(ConnectInfo(SocketAddr::from((PEER, 4000))));
        req
    }

    fn proxy(hops: usize, trusted: &[&str]) -> ClientIpKeyExtractor {
        let nets = trusted.iter().map(|n| n.parse().unwrap()).collect();
        ClientIpKeyExtractor::new(true, hops, nets)
    }

    #[test]
    fn peer_extractor_ignores_forwarded_headers() {
        let key = ClientIpKeyExtractor::new(false, 1, Vec::new())
            .extract(&request(&[("x-forwarded-for", "203.0.113.7")]))
            .unwrap();
        assert_eq!(key, IpAddr::from(PEER));
    }

    #[test]
    fn proxy_extractor_uses_forwarded_headers() {
        let key = proxy(1, &[])
            .extract(&request(&[("x-forwarded-for", "203.0.113.7")]))
            .unwrap();
        assert_eq!(key, IpAddr::from(FORGED));
    }

    #[test]
    fn proxy_extractor_ignores_forged_leftmost_entries() {
        let key = proxy(1, &[])
            .extract(&request(&[(
                "x-forwarded-for",
                "203.0.113.7, 198.51.100.20",
            )]))
            .unwrap();
        assert_eq!(key, IpAddr::from(CLIENT));
    }

    #[test]
    fn proxy_extractor_skips_trusted_hops() {
        let key = proxy(2, &[])
            .extract(&request(&[(
                "x-forwarded-for",
                "203.0.113.7, 198.51.100.20, 10.0.0.2",
            )]))
            .unwrap();
        assert_eq!(key, IpAddr::from(CLIENT));
    }

    #[test]
    fn proxy_extractor_reads_all_forwarded_for_headers() {
        let key = proxy(1, &[])
            .extract(&request(&[
                ("x-forwarded-for", "203.0.113.7"),
                ("x-forwarded-for", "198.51.100.20"),
            ]))
            .unwrap();
        assert_eq!(key, IpAddr::from(CLIENT));
    }

    #[test]
    fn proxy_extractor_falls_back_to_real_ip_then_peer() {
        let key = proxy(1, &[])
            .extract(&request(&[("x-real-ip", "198.51.100.20")]))
            .unwrap();
        assert_eq!(key, IpAddr::from(CLIENT));

        let key = proxy(1, &[]).extract(&request(&[])).unwrap();
        assert_eq!(key, IpAddr::from(PEER));
    }

    #[test]
    fn proxy_extractor_uses_peer_for_unparsable_entry() {
        let key = proxy(1, &[])
            .extract(&request(&[("x-forwarded-for", "203.0.113.7, garbage")]))
            .unwrap();
        assert_eq!(key, IpAddr::from(PEER));
    }

    #[test]
    fn proxy_extractor_ignores_headers_from_untrusted_peer() {
        let req = request(&[("x-forwarded-for", "198.51.100.20")]);

        let key = proxy(1, &["10.0.0.0/8"]).extract(&req).unwrap();
        assert_eq!(key, IpAddr::from(PEER));

        let key = proxy(1, &["127.0.0.0/8"]).extract(&req).unwrap();
        assert_eq!(key, IpAddr::from(CLIENT));
    }
}

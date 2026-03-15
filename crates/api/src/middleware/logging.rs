use axum::{extract::Request, http::HeaderValue, middleware::Next, response::Response};
use std::time::Instant;
use tower_http::{
    classify::{ServerErrorsAsFailures, SharedClassifier},
    sensitive_headers::SetSensitiveRequestHeadersLayer,
    trace::{MakeSpan, OnRequest, OnResponse, TraceLayer},
};

// ── Request ID middleware ────────────────────────────────────────────────────

pub async fn request_id(mut req: Request, next: Next) -> Response {
    let id = req
        .headers()
        .get("x-request-id")
        .and_then(|v| v.to_str().ok())
        .map(String::from)
        .unwrap_or_else(|| uuid::Uuid::new_v4().to_string());

    tracing::Span::current().record("request_id", id.as_str());
    req.extensions_mut().insert(RequestId(id.clone()));

    let mut response = next.run(req).await;

    if let Ok(val) = HeaderValue::from_str(&id) {
        response.headers_mut().insert("x-request-id", val);
    }

    response
}

#[derive(Clone, Debug)]
pub struct RequestId(pub String);

// ── Request / response logging middleware ─────────────────────────────────────

pub async fn logging(req: Request, next: Next) -> Response {
    let method = req.method().clone();
    let uri = req.uri().clone();
    let version = req.version();

    let start = Instant::now();
    let response = next.run(req).await;
    let latency_ms = start.elapsed().as_secs_f64() * 1000.0;

    let status = response.status().as_u16();
    let body_size = response
        .headers()
        .get(axum::http::header::CONTENT_LENGTH)
        .and_then(|v| v.to_str().ok())
        .unwrap_or("-");

    match status {
        s if s >= 500 => {
            tracing::error!(
                %method,
                path = %uri,
                ?version,
                status,
                latency_ms = format!("{latency_ms:.2}"),
                body_size,
                "request failed"
            );
        }
        s if s >= 400 => {
            tracing::warn!(
                %method,
                path = %uri,
                status,
                latency_ms = format!("{latency_ms:.2}"),
                body_size,
                "client error"
            );
        }
        _ => {
            tracing::info!(
                %method,
                path = %uri,
                status,
                latency_ms = format!("{latency_ms:.2}"),
                body_size,
                "request completed"
            );
        }
    }

    response
}

// ── Trace span ───────────────────────────────────────────────────────────────

#[derive(Clone)]
pub struct AppMakeSpan;

impl<B> MakeSpan<B> for AppMakeSpan {
    fn make_span(&mut self, request: &axum::http::Request<B>) -> tracing::Span {
        tracing::info_span!(
            "http_request",
            method = %request.method(),
            uri = %request.uri(),
            request_id = tracing::field::Empty,
        )
    }
}

#[derive(Clone)]
pub struct DisabledOnRequest;

impl<B> OnRequest<B> for DisabledOnRequest {
    fn on_request(&mut self, _: &axum::http::Request<B>, _: &tracing::Span) {}
}

#[derive(Clone)]
pub struct DisabledOnResponse;

impl<B> OnResponse<B> for DisabledOnResponse {
    fn on_response(self, _: &axum::http::Response<B>, _: std::time::Duration, _: &tracing::Span) {}
}

pub fn trace_layer() -> TraceLayer<
    SharedClassifier<ServerErrorsAsFailures>,
    AppMakeSpan,
    DisabledOnRequest,
    DisabledOnResponse,
> {
    TraceLayer::new_for_http()
        .make_span_with(AppMakeSpan)
        .on_request(DisabledOnRequest)
        .on_response(DisabledOnResponse)
}

// ── Sensitive header redaction ───────────────────────────────────────────────

pub fn sensitive_headers_layer() -> SetSensitiveRequestHeadersLayer {
    use axum::http::header;
    let headers: std::sync::Arc<[_]> =
        vec![header::AUTHORIZATION, header::COOKIE, header::SET_COOKIE].into();
    SetSensitiveRequestHeadersLayer::from_shared(headers)
}

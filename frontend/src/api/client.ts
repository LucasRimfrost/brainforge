import type { ApiError } from "./types";

export class ApiRequestError extends Error {
  status: number;
  body: ApiError;

  constructor(status: number, body: ApiError) {
    super(body.error);
    this.name = "ApiRequestError";
    this.status = status;
    this.body = body;
  }
}

// Paths that should never trigger a token refresh (avoids infinite loops)
const AUTH_PATHS = ["/api/v1/auth/login", "/api/v1/auth/refresh"];

// Shared state for deduplicating concurrent refresh attempts
let refreshInFlight: Promise<boolean> | null = null;

async function attemptRefresh(): Promise<boolean> {
  try {
    const res = await fetch("/api/v1/auth/refresh", {
      method: "POST",
      credentials: "include",
    });
    return res.ok;
  } catch {
    return false;
  }
}

function doRefresh(): Promise<boolean> {
  if (!refreshInFlight) {
    refreshInFlight = attemptRefresh().finally(() => {
      refreshInFlight = null;
    });
  }
  return refreshInFlight;
}

async function rawFetch(path: string, options: RequestInit): Promise<Response> {
  return fetch(path, {
    ...options,
    credentials: "include",
    headers: {
      "Content-Type": "application/json",
      ...options.headers,
    },
  });
}

export async function api<T>(
  path: string,
  options: RequestInit = {},
): Promise<T> {
  let res = await rawFetch(path, options);

  // On 401, try refreshing the access token — unless the request itself is an auth endpoint
  if (res.status === 401 && !AUTH_PATHS.some((p) => path.startsWith(p))) {
    const refreshed = await doRefresh();
    if (refreshed) {
      res = await rawFetch(path, options);
    } else {
      window.location.href = "/login";
      // Throw so callers don't continue processing
      throw new ApiRequestError(401, { error: "Session expired" });
    }
  }

  if (!res.ok) {
    const body: ApiError = await res.json().catch(() => ({
      error: res.statusText,
    }));
    throw new ApiRequestError(res.status, body);
  }

  if (res.status === 204) return undefined as T;

  return res.json() as Promise<T>;
}

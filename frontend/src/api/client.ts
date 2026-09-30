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

async function rawFetch(path: string, options: RequestInit): Promise<Response> {
  // eslint-disable-next-line no-restricted-globals
  return fetch(path, {
    ...options,
    credentials: "include",
    headers: {
      "Content-Type": "application/json",
      "X-Requested-With": "XMLHttpRequest",
      ...options.headers,
    },
  });
}

export async function api<T>(
  path: string,
  options: RequestInit = {},
): Promise<T> {
  const res = await rawFetch(path, options);

  // Sessions are server-side, so there is nothing to refresh: a 401 is final
  // and the caller decides what to do (e.g. useAuth treats it as logged out).
  if (!res.ok) {
    const body: ApiError = await res.json().catch(() => ({
      error: res.statusText,
    }));
    throw new ApiRequestError(res.status, body);
  }

  if (res.status === 204) return undefined as T;

  return res.json() as Promise<T>;
}

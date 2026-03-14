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

export async function api<T>(
  path: string,
  options: RequestInit = {},
): Promise<T> {
  const res = await fetch(path, {
    ...options,
    credentials: "include",
    headers: {
      "Content-Type": "application/json",
      ...options.headers,
    },
  });

  if (!res.ok) {
    const body: ApiError = await res.json().catch(() => ({
      error: res.statusText,
    }));
    throw new ApiRequestError(res.status, body);
  }

  if (res.status === 204) return undefined as T;

  return res.json() as Promise<T>;
}

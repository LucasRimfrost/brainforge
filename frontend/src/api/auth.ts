import { api } from "./client";
import type {
  LoginRequest,
  RegisterRequest,
  User,
  UserWithStats,
} from "./types";

const BASE = "/api/v1/auth";

export function register(data: RegisterRequest): Promise<User> {
  return api<User>(`${BASE}/register`, {
    method: "POST",
    body: JSON.stringify(data),
  });
}

export function login(data: LoginRequest): Promise<User> {
  return api<User>(`${BASE}/login`, {
    method: "POST",
    body: JSON.stringify(data),
  });
}

export function logout(): Promise<void> {
  return api<void>(`${BASE}/logout`, { method: "POST" });
}

export function refresh(): Promise<void> {
  return api<void>(`${BASE}/refresh`, { method: "POST" });
}

export function getMe(): Promise<UserWithStats> {
  return api<UserWithStats>(`${BASE}/me`);
}

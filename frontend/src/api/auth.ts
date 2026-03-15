import { api } from "./client";
import type {
  ForgotPasswordRequest,
  LoginRequest,
  MessageResponse,
  RegisterRequest,
  ResetPasswordRequest,
  UpdateEmailRequest,
  UpdatePasswordRequest,
  UpdateProfileRequest,
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

export function forgotPassword(data: ForgotPasswordRequest): Promise<MessageResponse> {
  return api<MessageResponse>(`${BASE}/forgot-password`, {
    method: "POST",
    body: JSON.stringify(data),
  });
}

export function resetPassword(data: ResetPasswordRequest): Promise<MessageResponse> {
  return api<MessageResponse>(`${BASE}/reset-password`, {
    method: "POST",
    body: JSON.stringify(data),
  });
}

export function updateProfile(data: UpdateProfileRequest): Promise<User> {
  return api<User>(`${BASE}/profile`, {
    method: "PATCH",
    body: JSON.stringify(data),
  });
}

export function updateEmail(data: UpdateEmailRequest): Promise<User> {
  return api<User>(`${BASE}/email`, {
    method: "PATCH",
    body: JSON.stringify(data),
  });
}

export function updatePassword(data: UpdatePasswordRequest): Promise<MessageResponse> {
  return api<MessageResponse>(`${BASE}/password`, {
    method: "PATCH",
    body: JSON.stringify(data),
  });
}

export function getMe(): Promise<UserWithStats> {
  return api<UserWithStats>(`${BASE}/me`);
}

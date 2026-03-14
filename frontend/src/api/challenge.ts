import { api } from "./client";
import type {
  Challenge,
  HistoryEntry,
  SubmitRequest,
  SubmitResponse,
} from "./types";

const BASE = "/api/v1/challenge";

export function getToday(): Promise<Challenge> {
  return api<Challenge>(`${BASE}/today`);
}

export function submitAnswer(data: SubmitRequest): Promise<SubmitResponse> {
  return api<SubmitResponse>(`${BASE}/submit`, {
    method: "POST",
    body: JSON.stringify(data),
  });
}

export function getHistory(limit = 30): Promise<HistoryEntry[]> {
  return api<HistoryEntry[]>(`${BASE}/history?limit=${limit}`);
}

import { api } from "./client";
import type { LeaderboardEntry } from "./types";

export function getLeaderboard(limit = 30): Promise<LeaderboardEntry[]> {
  return api<LeaderboardEntry[]>(`/api/v1/leaderboard?limit=${limit}`);
}

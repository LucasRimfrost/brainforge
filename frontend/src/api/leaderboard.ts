import { api } from "./client";
import type { LeaderboardEntry } from "./types";

export function getLeaderboard(game: "trivia" | "code-output" = "trivia", limit = 30): Promise<LeaderboardEntry[]> {
  return api<LeaderboardEntry[]>(`/api/v1/leaderboard?game=${game}&limit=${limit}`);
}

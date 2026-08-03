// Pure high-score ranking over the shared game_scores table (game-routes.ts).
// Ordering rule: higher score first; ties go to the EARLIER submission — the
// first player to reach a score owns that rank until someone beats it.

export const TOP_N = 5;

export type ScoreRow = { id: string; score: number; createdAt: Date };

export function orderScores<T extends ScoreRow>(rows: T[]): T[] {
  return [...rows].sort(
    (a, b) => b.score - a.score || a.createdAt.getTime() - b.createdAt.getTime(),
  );
}

export function topScores<T extends ScoreRow>(rows: T[]): T[] {
  return orderScores(rows).slice(0, TOP_N);
}

// 1-based rank of an entry in the full ordered list; -1 if the id isn't there.
export function rankOf(rows: ScoreRow[], id: string): number {
  const idx = orderScores(rows).findIndex((r) => r.id === id);
  return idx === -1 ? -1 : idx + 1;
}

import { Hono } from "hono";
import { and, eq, isNull, or, sql } from "drizzle-orm";
import { db } from "./db/client";
import { cards, decks, reviewState, reviews, verbReviewState, verbReviews, verbs } from "./db/schema";
import { DAY_TZ } from "./srs/day";
import { summarizeProgress } from "./srs/tiers";
import { buildHeatmap, computeStreaks, localDateString, sumLastWeek } from "./srs/stats";
import { requireAuth, type AppEnv } from "./auth";
import type { StatsResponse } from "../shared/types";

export const statsRoutes = new Hono<AppEnv>();
statsRoutes.use("*", requireAuth);

const HEATMAP_WEEKS = 6;

// Per-day count of cards done (graded first-of-day reviews) for one user, bucketed
// by local calendar day in DAY_TZ. Returns [{ day: "YYYY-MM-DD", n }]. Small: at
// most one row per active day. `column`/`table` are trusted (this module's own).
function dailyCounts(table: typeof reviews | typeof verbReviews, userId: string) {
  return db.execute<{ day: string; n: number }>(sql`
    select to_char((${table.reviewedAt} at time zone ${DAY_TZ})::date, 'YYYY-MM-DD') as day,
           count(*)::int as n
    from ${table}
    where ${table.userId} = ${userId} and ${table.graded} = true
    group by day
  `);
}

// All motivation stats, derived ad-hoc — nothing is stored. Everything here is a
// simple per-user read: two day-bucketed count queries + two stability scans.
statsRoutes.get("/stats", async (c) => {
  const userId = c.get("user").id;
  const today = localDateString(new Date(), DAY_TZ);

  const [wordDays, verbDays] = await Promise.all([
    dailyCounts(reviews, userId),
    dailyCounts(verbReviews, userId),
  ]);

  // Merge words + verbs into one activity count per day.
  const counts = new Map<string, number>();
  for (const r of [...wordDays.rows, ...verbDays.rows]) {
    counts.set(r.day, (counts.get(r.day) ?? 0) + r.n);
  }

  const active = new Set(counts.keys());
  const { current, longest } = computeStreaks(active, today);

  // Mastery bar: the whole library (words + verbs), same tiers as the home cards.
  const [wordStates, verbStates] = await Promise.all([
    db
      .select({ stability: reviewState.stability, stateId: reviewState.id })
      .from(cards)
      .innerJoin(decks, eq(decks.id, cards.deckId))
      .leftJoin(
        reviewState,
        and(eq(reviewState.cardId, cards.id), eq(reviewState.userId, userId)),
      )
      .where(or(eq(decks.ownerId, userId), isNull(decks.ownerId))),
    db
      .select({ stability: verbReviewState.stability, stateId: verbReviewState.id })
      .from(verbs)
      .leftJoin(
        verbReviewState,
        and(eq(verbReviewState.verbId, verbs.id), eq(verbReviewState.userId, userId)),
      ),
  ]);
  const stabilities = [...wordStates, ...verbStates].map((r) =>
    r.stateId === null ? null : r.stability,
  );

  const body: StatsResponse = {
    heatmap: buildHeatmap(counts, today, HEATMAP_WEEKS),
    weeks: HEATMAP_WEEKS,
    currentStreak: current,
    longestStreak: longest,
    practicedLastWeek: sumLastWeek(counts, today),
    mastery: summarizeProgress(stabilities, 0),
  };
  return c.json(body);
});

// Writes to daily_progress: the point-in-time record of a "perfect day" (all words
// done + all verbs done + a Freund chat). Each upsert is idempotent on (user, day)
// and only ever raises a flag/counter — a day never un-completes. `day` is the local
// calendar date in DAY_TZ, matching the heatmap buckets. See STREAK.md.

import { and, eq, sql } from "drizzle-orm";
import { db } from "./client";
import { dailyProgress } from "./schema";
import { DAY_TZ } from "../srs/day";
import { localDateString } from "../srs/stats";

/** The local calendar date key ("YYYY-MM-DD") for `now`, matching the heatmap. */
export function dayKey(now: Date): string {
  return localDateString(now, DAY_TZ);
}

/** Mark today's words finished. Called from /session/today when the day is complete. */
export function markWordsDone(userId: string, now: Date) {
  return db
    .insert(dailyProgress)
    .values({ userId, day: dayKey(now), wordsDone: true })
    .onConflictDoUpdate({
      target: [dailyProgress.userId, dailyProgress.day],
      set: { wordsDone: true },
    });
}

/** Mark today's verbs finished. Called from /verbs/session/today when complete. */
export function markVerbsDone(userId: string, now: Date) {
  return db
    .insert(dailyProgress)
    .values({ userId, day: dayKey(now), verbsDone: true })
    .onConflictDoUpdate({
      target: [dailyProgress.userId, dailyProgress.day],
      set: { verbsDone: true },
    });
}

/** How many Freund messages the user has sent today (0 → the nudge should fire). */
export async function freundCountToday(userId: string, now: Date): Promise<number> {
  const [row] = await db
    .select({ n: dailyProgress.freundCount })
    .from(dailyProgress)
    .where(and(eq(dailyProgress.userId, userId), eq(dailyProgress.day, dayKey(now))));
  return row?.n ?? 0;
}

/** Count one Freund message for today. Called from /freund/message per user turn. */
export function bumpFreund(userId: string, now: Date) {
  return db
    .insert(dailyProgress)
    .values({ userId, day: dayKey(now), freundCount: 1 })
    .onConflictDoUpdate({
      target: [dailyProgress.userId, dailyProgress.day],
      set: { freundCount: sql`${dailyProgress.freundCount} + 1` },
    });
}

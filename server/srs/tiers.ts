// Mastery tiers, derived from FSRS `stability` (days until recall would fall to
// ~90%). Pure functions — see PLAN.md §5a. No I/O; the route supplies the data.

import type { MasteryTier, ProgressResponse } from "../../shared/types";

// Tier thresholds in days of stability.
export const FAMILIAR_MIN_DAYS = 7;
export const MASTERED_MIN_DAYS = 21;

/**
 * Tier for a card. `stability === null` means the card has no review state yet
 * (never studied) → "new". A studied card always has stability > 0, so the
 * null check — not a stability===0 check — is what separates new from learning.
 */
export function tierFor(stability: number | null): MasteryTier {
  if (stability === null) return "new";
  if (stability >= MASTERED_MIN_DAYS) return "mastered";
  if (stability >= FAMILIAR_MIN_DAYS) return "familiar";
  return "learning";
}

/**
 * Roll a user's whole library into tier counts + the headline Mastered number.
 * `stabilities` has one entry per card: a number if it has review state, or
 * `null` if it doesn't (new). `reviewsToday` is supplied by the route.
 */
export function summarizeProgress(
  stabilities: (number | null)[],
  reviewsToday: number,
): ProgressResponse {
  const tiers: Record<MasteryTier, number> = {
    new: 0,
    learning: 0,
    familiar: 0,
    mastered: 0,
  };
  for (const s of stabilities) tiers[tierFor(s)]++;
  return {
    tiers,
    mastered: tiers.mastered,
    total: stabilities.length,
    reviewsToday,
  };
}

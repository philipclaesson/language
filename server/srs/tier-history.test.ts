import { test } from "node:test";
import assert from "node:assert/strict";
import { tierHistory, type ReplayReview } from "./tier-history.ts";

const TODAY = "2026-08-17";

// A graded pass at local noon on the given YYYY-MM-DD (Berlin is UTC+1/+2, so 12:00Z
// lands on the same calendar day either season).
function pass(date: string): ReplayReview {
  return { rating: 3, reviewedAt: new Date(`${date}T12:00:00Z`) };
}
function fail(date: string): ReplayReview {
  return { rating: 1, reviewedAt: new Date(`${date}T12:00:00Z`) };
}

test("empty library → all-zero points, oldest first, ending today", () => {
  const h = tierHistory([], TODAY, 30);
  assert.equal(h.length, 30);
  assert.equal(h[0].date, "2026-07-19");
  assert.equal(h[29].date, TODAY);
  assert.ok(h.every((p) => p.learning === 0 && p.familiar === 0 && p.mastered === 0));
});

test("a card counts only from the day it was first reviewed", () => {
  const h = tierHistory([[pass("2026-08-15")]], TODAY, 30);
  const before = h.find((p) => p.date === "2026-08-14")!;
  const on = h.find((p) => p.date === "2026-08-15")!;
  const after = h.find((p) => p.date === "2026-08-16")!;
  assert.equal(before.learning + before.familiar + before.mastered, 0);
  // One graded pass gives low stability → "learning".
  assert.equal(on.learning, 1);
  assert.equal(on.familiar + on.mastered, 0);
  // Tier is flat between reviews: still learning the next day, no re-review needed.
  assert.equal(after.learning, 1);
});

test("a review before the window carries in on every visible day", () => {
  // Reviewed 40 days ago, never since → still standing (as "learning") across the
  // whole 30-day window; the log read isn't bounded by the window.
  const h = tierHistory([[pass(addDaysStr(TODAY, -40))]], TODAY, 30);
  assert.ok(h.every((p) => p.learning === 1));
});

test("cards with no reviews contribute nothing (the 'new' tier is dropped)", () => {
  const h = tierHistory([[], [pass("2026-08-16")]], TODAY, 30);
  const today = h[h.length - 1];
  assert.equal(today.learning, 1); // only the reviewed card, not the empty one
});

test("spaced passes climb into mastered and stay there", () => {
  // Ten passes spaced ~30 days apart push stability well past the 21-day mastered
  // threshold; the final day should show the card mastered, not learning/familiar.
  const reviews: ReplayReview[] = [];
  for (let i = 12; i >= 0; i--) reviews.push(pass(addDaysStr(TODAY, -i * 30)));
  const h = tierHistory([reviews], TODAY, 30);
  const today = h[h.length - 1];
  assert.equal(today.mastered, 1);
  assert.equal(today.learning + today.familiar, 0);
});

test("a fail resets a mastered card back down to learning", () => {
  const reviews: ReplayReview[] = [];
  for (let i = 12; i >= 1; i--) reviews.push(pass(addDaysStr(TODAY, -i * 30)));
  reviews.push(fail(TODAY)); // lapse today
  const h = tierHistory([reviews], TODAY, 30);
  const today = h[h.length - 1];
  assert.equal(today.learning, 1);
  assert.equal(today.mastered + today.familiar, 0);
});

// Local date-string arithmetic mirror of srs/stats.addDays, for building test dates.
function addDaysStr(date: string, n: number): string {
  const [y, m, d] = date.split("-").map(Number);
  return new Date(Date.UTC(y, m - 1, d + n)).toISOString().slice(0, 10);
}

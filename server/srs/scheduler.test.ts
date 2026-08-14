import { test } from "node:test";
import assert from "node:assert/strict";
import { ratingFor, scheduleNext, type StoredSrs } from "./scheduler.ts";

// Simulate the production path: each review reloads StoredSrs from the DB, so
// only the persisted fields survive between reviews. This is the round-trip that
// the `learning_steps`-not-persisted bug hid in — a card stuck in `learning`
// never graduated and its due never moved past minutes.

const DAY_MS = 86_400_000;

test("a brand-new card answered correctly graduates to review and is scheduled days out", () => {
  const now = new Date("2026-06-21T10:00:00Z");
  const next = scheduleNext(null, "pass", now);

  assert.equal(next.state, "review", "should leave `new`/`learning` on first pass");
  assert.ok(
    next.due.getTime() - now.getTime() >= DAY_MS,
    `due should be at least a day out, got ${next.due.toISOString()}`,
  );
});

test("repeated correct answers across DB reloads keep growing the interval", () => {
  // This is the regression test: with the bug, every reload reset the card to
  // learning-step 0, so it never graduated, stability stayed flat (~2.3), and
  // due was always ~minutes out. Here we assert the opposite.
  let stored: StoredSrs | null = null;
  let now = new Date("2026-06-21T10:00:00Z");
  let prevInterval = 0;

  for (let i = 0; i < 4; i++) {
    const next: StoredSrs = scheduleNext(stored, "pass", now);
    const interval = next.due.getTime() - now.getTime();

    assert.equal(next.state, "review", `review #${i + 1} should be in review state`);
    assert.ok(
      interval > prevInterval,
      `interval should grow each review; #${i + 1} was ${interval}ms, prev ${prevInterval}ms`,
    );
    assert.ok(next.stability > 0, "stability should be positive");

    prevInterval = interval;
    stored = next; // persist + reload (only StoredSrs fields survive)
    now = new Date(next.due); // review again exactly when due
  }
});

test("a near miss lands between a pass and a fail, and never lapses the card", () => {
  // The point of the whole three-grade change: getting the article wrong on a word
  // you know should cost you *some* interval, not the card's entire history.
  const now = new Date("2026-06-21T10:00:00Z");
  let card = scheduleNext(null, "pass", now);
  for (let i = 0; i < 3; i++) card = scheduleNext(card, "pass", new Date(card.due));

  const at = new Date(card.due);
  const passed = scheduleNext(card, "pass", at);
  const near = scheduleNext(card, "near", at);
  const failed = scheduleNext(card, "fail", at);

  assert.ok(
    near.due.getTime() < passed.due.getTime() && near.due.getTime() > failed.due.getTime(),
    `near should sit between pass and fail; got near ${near.due.toISOString()}, ` +
      `pass ${passed.due.toISOString()}, fail ${failed.due.toISOString()}`,
  );
  assert.equal(near.lapses, card.lapses, "a near miss must not count as a lapse");
  assert.ok(
    near.stability > card.stability,
    "a near miss is still a successful recall — stability should grow, not reset",
  );
  assert.ok(failed.stability < card.stability, "a fail resets stability");
  assert.ok(near.difficulty > passed.difficulty, "a near miss should make the card harder");
});

test("ratings map to FSRS's own scale, and only a pass clears the day", () => {
  // The daily loop reads `reviews.rating >= 3` as "satisfied today" — a near miss
  // must stay below that line or it would silently complete the card.
  assert.equal(ratingFor("pass"), 3);
  assert.equal(ratingFor("near"), 2);
  assert.equal(ratingFor("fail"), 1);
});

test("failing a card lapses it (more lapses, sooner due than a pass)", () => {
  const now = new Date("2026-06-21T10:00:00Z");
  // Get a mature-ish card first via a couple of passes.
  let card = scheduleNext(null, "pass", now);
  card = scheduleNext(card, "pass", new Date(card.due));

  const reviewAt = new Date(card.due);
  const failed = scheduleNext(card, "fail", reviewAt);
  const passed = scheduleNext(card, "pass", reviewAt);

  assert.equal(failed.lapses, card.lapses + 1, "a fail should increment lapses");
  assert.ok(
    failed.due.getTime() < passed.due.getTime(),
    "a failed card should come due sooner than if it had passed",
  );
});

import { test } from "node:test";
import assert from "node:assert/strict";
import { scheduleNext, type StoredSrs } from "./scheduler.ts";

// Simulate the production path: each review reloads StoredSrs from the DB, so
// only the persisted fields survive between reviews. This is the round-trip that
// the `learning_steps`-not-persisted bug hid in — a card stuck in `learning`
// never graduated and its due never moved past minutes.

const DAY_MS = 86_400_000;

test("a brand-new card answered correctly graduates to review and is scheduled days out", () => {
  const now = new Date("2026-06-21T10:00:00Z");
  const next = scheduleNext(null, true, now);

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
    const next: StoredSrs = scheduleNext(stored, true, now);
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

test("failing a card lapses it (more lapses, sooner due than a pass)", () => {
  const now = new Date("2026-06-21T10:00:00Z");
  // Get a mature-ish card first via a couple of passes.
  let card = scheduleNext(null, true, now);
  card = scheduleNext(card, true, new Date(card.due));

  const reviewAt = new Date(card.due);
  const failed = scheduleNext(card, false, reviewAt);
  const passed = scheduleNext(card, true, reviewAt);

  assert.equal(failed.lapses, card.lapses + 1, "a fail should increment lapses");
  assert.ok(
    failed.due.getTime() < passed.due.getTime(),
    "a failed card should come due sooner than if it had passed",
  );
});

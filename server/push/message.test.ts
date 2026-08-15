import { test } from "node:test";
import assert from "node:assert/strict";
import { freundNudge, reminderMessage } from "./message";

test("no reminder when nothing is due", () => {
  assert.equal(reminderMessage({ words: 0, verbs: 0, total: 0 }), null);
});

test("words only", () => {
  const msg = reminderMessage({ words: 7, verbs: 0, total: 7 });
  assert.ok(msg);
  assert.equal(msg.body, "7 words to review today.");
  assert.equal(msg.url, "/review");
});

test("verbs only routes to the verb loop", () => {
  const msg = reminderMessage({ words: 0, verbs: 3, total: 3 });
  assert.ok(msg);
  assert.equal(msg.body, "3 verbs to review today.");
  assert.equal(msg.url, "/verbs/review");
});

test("words and verbs combine", () => {
  const msg = reminderMessage({ words: 5, verbs: 2, total: 7 });
  assert.ok(msg);
  assert.equal(msg.body, "5 words and 2 verbs to review today.");
  assert.equal(msg.url, "/review");
});

test("singular has no trailing s", () => {
  const msg = reminderMessage({ words: 1, verbs: 1, total: 2 });
  assert.ok(msg);
  assert.equal(msg.body, "1 word and 1 verb to review today.");
});

test("review reminder carries its own tag", () => {
  const msg = reminderMessage({ words: 3, verbs: 0, total: 3 });
  assert.ok(msg);
  assert.equal(msg.tag, "daily-reminder");
});

test("freundNudge deep-links into the given scenario, distinct tag", () => {
  const scenario = "At the bakery — Freund is the baker.";
  const msg = freundNudge(scenario);
  assert.equal(msg.url, `/freund?scenario=${encodeURIComponent(scenario)}`);
  assert.ok(msg.body.includes(scenario));
  assert.equal(msg.tag, "freund-nudge");
  assert.notEqual(msg.tag, "daily-reminder", "must not collapse with the review reminder");
});

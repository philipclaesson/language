import { test } from "node:test";
import assert from "node:assert/strict";
import { normalizeSense, senseTokens, findClusters } from "./gloss-clusters.ts";
import type { ParsedWord } from "./words-parse.ts";

// Minimal corpus row; only the fields findClusters reads matter.
function w(p: Partial<ParsedWord>): ParsedWord {
  return {
    prompt: "",
    answer: "",
    answerAlts: [],
    article: null,
    partOfSpeech: "verb",
    notes: null,
    exampleEn: null,
    exampleDe: null,
    frequencyRank: null,
    ...p,
  };
}

test("normalizeSense strips the infinitive marker, case, punctuation", () => {
  assert.equal(normalizeSense("to occur"), "occur");
  assert.equal(normalizeSense("  To Take Place. "), "take place");
  assert.equal(normalizeSense("occur"), "occur");
});

test("senseTokens splits on comma/slash/semicolon and dedupes", () => {
  assert.deepEqual(senseTokens("to take place, occur"), ["take place", "occur"]);
  assert.deepEqual(senseTokens("to do, make"), ["do", "make"]);
  assert.deepEqual(senseTokens("big, large / great"), ["big", "large", "great"]);
});

test("clusters group distinct German words sharing an English sense", () => {
  const words = [
    w({ answer: "geschehen", prompt: "to happen, occur", frequencyRank: 623 }),
    w({ answer: "erfolgen", prompt: "to take place, occur", frequencyRank: 648 }),
    w({ answer: "stattfinden", prompt: "to take place, occur", frequencyRank: 652 }),
    w({ answer: "gehen", prompt: "to go", frequencyRank: 30 }), // unrelated singleton
  ];
  const clusters = findClusters(words);
  const occur = clusters.find((c) => c.sense === "occur");
  assert.ok(occur, "expected an 'occur' cluster");
  assert.deepEqual(occur.cards.map((c) => c.answer), ["geschehen", "erfolgen", "stattfinden"]);
  assert.equal(occur.medianRank, 648);
  // "take place" is shared by two of them → its own cluster; "go" is a singleton → none.
  assert.ok(clusters.some((c) => c.sense === "take place" && c.size === 2));
  assert.ok(!clusters.some((c) => c.sense === "go"));
});

test("a two-sense word joins both of its clusters", () => {
  const words = [
    w({ answer: "auftreten", prompt: "to appear, occur", frequencyRank: 654 }),
    w({ answer: "geschehen", prompt: "to happen, occur", frequencyRank: 623 }),
    w({ answer: "erscheinen", prompt: "to appear", frequencyRank: 408 }),
  ];
  const clusters = findClusters(words);
  assert.deepEqual(
    clusters.find((c) => c.sense === "occur")?.cards.map((c) => c.answer).sort(),
    ["auftreten", "geschehen"],
  );
  assert.deepEqual(
    clusters.find((c) => c.sense === "appear")?.cards.map((c) => c.answer).sort(),
    ["auftreten", "erscheinen"],
  );
});

test("fully-glossed clusters are hidden unless asked for; partial ones stay", () => {
  const words = [
    w({ answer: "a", prompt: "x, done", frequencyRank: 1, swedish: "aa" }),
    w({ answer: "b", prompt: "y, done", frequencyRank: 2, swedish: "bb" }),
    w({ answer: "c", prompt: "z, half", frequencyRank: 3, swedish: "cc" }),
    w({ answer: "d", prompt: "w, half", frequencyRank: 4 }), // not glossed
  ];
  const clusters = findClusters(words);
  assert.ok(!clusters.some((c) => c.sense === "done"), "fully glossed → hidden");
  const half = clusters.find((c) => c.sense === "half");
  assert.ok(half && half.glossedCount === 1, "partially glossed → shown");
  assert.ok(findClusters(words, { includeGlossed: true }).some((c) => c.sense === "done"));
});

test("maxRank and pos filters restrict which cards count", () => {
  const words = [
    w({ answer: "nah", prompt: "near", frequencyRank: 100, partOfSpeech: "adjective" }),
    w({ answer: "dicht", prompt: "near", frequencyRank: 200, partOfSpeech: "adjective" }),
    w({ answer: "beinahe", prompt: "near", frequencyRank: 9000, partOfSpeech: "adverb" }),
  ];
  // With a rank cap the far card drops out — leaving only two, still a cluster.
  const capped = findClusters(words, { maxRank: 1000 });
  assert.deepEqual(capped.find((c) => c.sense === "near")?.cards.map((c) => c.answer), [
    "nah",
    "dicht",
  ]);
  // Restrict to adverbs → only one card shares "near" → no cluster.
  assert.ok(!findClusters(words, { pos: new Set(["adverb"]) }).some((c) => c.sense === "near"));
});

import { test } from "node:test";
import assert from "node:assert/strict";
import type { ParsedWord } from "./words-parse.ts";
import {
  WORD_OVERRIDES,
  applyOverrides,
  overrideUpdateSql,
  type WordOverride,
} from "./words-overrides.ts";
import wordsData from "./words.data.json" with { type: "json" };

function word(rank: number, extra: Partial<ParsedWord> = {}): ParsedWord {
  return {
    prompt: `prompt ${rank}`,
    answer: `answer${rank}`,
    answerAlts: [],
    article: null,
    partOfSpeech: "verb",
    notes: null,
    exampleEn: `en ${rank}`,
    exampleDe: `de ${rank}`,
    frequencyRank: rank,
    ...extra,
  };
}

test("applyOverrides patches only the targeted rank, without mutating input", () => {
  const words = [word(1), word(2), word(3)];
  const out = applyOverrides(words, [
    { rank: 2, reason: "test", set: { prompt: "fixed", exampleEn: "fixed en" } },
  ]);
  assert.equal(out[1].prompt, "fixed");
  assert.equal(out[1].exampleEn, "fixed en");
  assert.equal(out[1].answer, "answer2"); // untouched fields kept
  assert.deepEqual(out[0], word(1)); // other words untouched
  assert.deepEqual(out[2], word(3));
  assert.equal(words[1].prompt, "prompt 2"); // input not mutated
});

test("applyOverrides throws when an override matches no word", () => {
  assert.throws(
    () => applyOverrides([word(1)], [{ rank: 99, reason: "test", set: { prompt: "x" } }]),
    /rank 99 matched no word/,
  );
});

test("applyOverrides throws on duplicate ranks in the table", () => {
  const dup: WordOverride[] = [
    { rank: 1, reason: "a", set: { prompt: "x" } },
    { rank: 1, reason: "b", set: { answer: "y" } },
  ];
  assert.throws(() => applyOverrides([word(1)], dup), /duplicate override for rank 1/);
});

test("overrideUpdateSql emits one in-place UPDATE keyed on (deck_id, frequency_rank)", () => {
  const sql = overrideUpdateSql({
    rank: 42,
    reason: "why",
    set: { prompt: "it's a prompt", answerAlts: ["ä", "b"], article: null },
  });
  assert.match(sql, /^-- rank 42: why\n/);
  assert.match(sql, /"prompt" = 'it''s a prompt'/); // quotes escaped
  assert.match(sql, /"answer_alts" = ARRAY\['ä', 'b'\]::text\[\]/); // camelCase → column
  assert.match(sql, /"article" = NULL/);
  assert.match(
    sql,
    /WHERE "deck_id" = 'b7c8e3a0-6d4f-4e2a-9c1b-000000005000'::uuid AND "frequency_rank" = 42;\n$/,
  );
});

test("overrideUpdateSql maps the swedish field to its column", () => {
  const sql = overrideUpdateSql({ rank: 463, reason: "sv", set: { swedish: "trots det" } });
  assert.match(sql, /"swedish" = 'trots det'/);
});

test("overrideUpdateSql rejects an override that sets nothing", () => {
  assert.throws(() => overrideUpdateSql({ rank: 1, reason: "x", set: {} }), /sets no fields/);
});

// The drift guard: the committed corpus must already reflect every override. If this
// fails, an override was added (or words.data.json was hand-edited) without running
// `npx tsx scripts/apply-overrides.ts` — run it and commit the result.
test("words.data.json already reflects every override (else run scripts/apply-overrides.ts)", () => {
  const words = wordsData as ParsedWord[];
  assert.ok(WORD_OVERRIDES.length > 0);
  assert.deepEqual(applyOverrides(words), words);
});

import { test } from "node:test";
import assert from "node:assert/strict";
import {
  KASUS_BANK,
  KASUS_ROUND_SIZE,
  kasusRound,
  solveSentence,
  type Kasus,
} from "./kasus-game";

// Structural guards over the hand-authored bank. Gender/meaning can't be
// machine-checked here, but the article↔case agreement below catches the most
// likely authoring slips (a dativ item filled with "den", etc.).

// Singular definite articles that can express each case.
const ALLOWED: Record<Kasus, string[]> = {
  nominativ: ["der", "die", "das"],
  akkusativ: ["den", "die", "das"],
  dativ: ["dem", "der"],
};

test("every item has exactly one blank", () => {
  for (const item of KASUS_BANK) {
    assert.equal(
      item.sentence.split("___").length,
      2,
      `${item.id}: expected exactly one ___`,
    );
  }
});

test("ids are unique", () => {
  const ids = KASUS_BANK.map((i) => i.id);
  assert.equal(new Set(ids).size, ids.length);
});

test("article agrees with the claimed case", () => {
  for (const item of KASUS_BANK) {
    assert.ok(
      ALLOWED[item.kasus].includes(item.article),
      `${item.id}: "${item.article}" can't express ${item.kasus}`,
    );
  }
});

test("every item carries a teaching rule", () => {
  for (const item of KASUS_BANK) {
    assert.ok(item.rule.length > 0, `${item.id}: empty rule`);
  }
});

test("bank is big enough for a full round with variety to spare", () => {
  assert.ok(KASUS_BANK.length >= KASUS_ROUND_SIZE * 3);
});

test("solveSentence fills the blank", () => {
  const item = KASUS_BANK.find((i) => i.id === "mit-bus")!;
  assert.equal(solveSentence(item), "Ich fahre mit dem Bus in die Stadt.");
});

test("solveSentence capitalizes a sentence-initial article", () => {
  const item = KASUS_BANK.find((i) => i.id === "subjekt-hund")!;
  assert.equal(solveSentence(item), "Der Hund schläft im Garten.");
});

test("kasusRound samples the requested size without duplicates", () => {
  const round = kasusRound();
  assert.equal(round.length, KASUS_ROUND_SIZE);
  assert.equal(new Set(round.map((i) => i.id)).size, round.length);
});

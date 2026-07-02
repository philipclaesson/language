// One-off, re-runnable generator for the frequency word corpus.
//
// Reads the Anki deck "5000 German words sorted by frequency" and writes two
// committed artifacts:
//   - server/db/words.data.json  — the cleaned corpus (used by db:seed:words)
//   - drizzle/0005_seed_words.sql — the data migration that loads it into prod
//
// The messy per-note cleaning rules live in server/db/words-parse.ts (tested).
// This script is just I/O: unpack, read SQLite, parse, sort, emit.
//
// Usage (node:sqlite is behind a flag on Node 22.11):
//   NODE_OPTIONS=--experimental-sqlite npx tsx scripts/gen-words.ts [path-to.apkg]
//
// Default input: ~/Downloads/5000_German_words_sorted_by_frequency.apkg

import { DatabaseSync } from "node:sqlite";
import { execFileSync } from "node:child_process";
import { existsSync, mkdtempSync, readFileSync, writeFileSync } from "node:fs";
import { tmpdir, homedir } from "node:os";
import { join } from "node:path";
import { parseNote, type ParsedWord, type RawNote } from "../server/db/words-parse.ts";

// The global corpus deck's fixed id — shared by words.ts and the migration so
// both the seed script and the migration target the same row.
export const WORD_DECK_ID = "b7c8e3a0-6d4f-4e2a-9c1b-000000005000";
const DECK_NAME = "German — Frequency 5000";
const DECK_DESC = "The ~3,700 most frequent German words, ordered by frequency.";

// Anki note field order for this deck's note model (from col.models[…].flds).
const FIELDS = [
  "german", // GermanEntry
  "germanSentence", // GermanSampleSentence
  "rank", // Rank
  "english", // EnglishMeaning
  "notThisWord", // NotThisWord
  "englishSentence", // RoughEnglishSentence
] as const;

function collectionPath(input: string): string {
  if (input.endsWith(".anki2")) return input;
  // It's an .apkg (zip) — unpack collection.anki2 to a temp dir.
  const dir = mkdtempSync(join(tmpdir(), "apkg-"));
  execFileSync("unzip", ["-o", "-d", dir, input, "collection.anki2"]);
  return join(dir, "collection.anki2");
}

function sqlStr(s: string): string {
  return `'${s.replace(/'/g, "''")}'`;
}
function sqlNullable(s: string | null): string {
  return s === null ? "NULL" : sqlStr(s);
}
function sqlArray(items: string[]): string {
  return items.length === 0
    ? "ARRAY[]::text[]"
    : `ARRAY[${items.map(sqlStr).join(", ")}]::text[]`;
}

const input =
  process.argv[2] ??
  join(homedir(), "Downloads", "5000_German_words_sorted_by_frequency.apkg");
if (!existsSync(input)) {
  console.error(`Input not found: ${input}`);
  process.exit(1);
}

const db = new DatabaseSync(collectionPath(input), { readOnly: true });
const rows = db.prepare("SELECT flds FROM notes").all() as { flds: string }[];
db.close();

const words: ParsedWord[] = [];
for (const { flds } of rows) {
  const parts = flds.split("\x1f");
  const raw = Object.fromEntries(FIELDS.map((f, i) => [f, parts[i] ?? ""])) as RawNote;
  const w = parseNote(raw);
  if (!w.prompt || !w.answer) continue; // skip anything that cleaned to nothing
  words.push(w);
}

// Frequency order (nulls last), stable — this is the new-card introduction order.
words.sort((a, b) => (a.frequencyRank ?? Infinity) - (b.frequencyRank ?? Infinity));

const nouns = words.filter((w) => w.partOfSpeech === "noun").length;
const gendered = words.filter((w) => w.article).length;

// --- words.data.json ---
const jsonPath = join(import.meta.dirname, "..", "server", "db", "words.data.json");
writeFileSync(jsonPath, JSON.stringify(words, null, 0) + "\n");

// --- 0005_seed_words.sql ---
const header = `-- Seed the global frequency word corpus. Generated from an Anki deck by
-- scripts/gen-words.ts; the cleaning rules live in server/db/words-parse.ts.
-- Creates ONE ownerless (global) deck + ${words.length} cards. The deck's null
-- owner_id makes it read-only to users and hidden from the tutor, while the
-- widened review queries surface its cards in every user's daily loop, ordered
-- by frequency_rank. Applied to dev via db:migrate and to prod by the CI migrate
-- job on push to main. Idempotent on the deck (guarded); migration tracking
-- keeps the cards from being inserted twice.

INSERT INTO "decks" ("id", "owner_id", "name", "source", "description")
SELECT '${WORD_DECK_ID}'::uuid, NULL, ${sqlStr(DECK_NAME)}, 'seed', ${sqlStr(DECK_DESC)}
WHERE NOT EXISTS (SELECT 1 FROM "decks" WHERE "id" = '${WORD_DECK_ID}'::uuid);
`;

const valueRows = words.map((w) => {
  const cols = [
    `'${WORD_DECK_ID}'`,
    sqlStr(w.prompt),
    sqlStr(w.answer),
    sqlArray(w.answerAlts),
    sqlNullable(w.partOfSpeech),
    sqlNullable(w.article),
    sqlNullable(w.notes),
    w.frequencyRank === null ? "NULL" : String(w.frequencyRank),
    "'seed'",
  ];
  return `  (${cols.join(", ")})`;
});

// Plain multi-row INSERT (as in 0003_seed_verbs.sql): each literal is coerced to
// its target column type — notably the unknown deck_id literal → uuid, which an
// INSERT ... SELECT would not do. Runs once (migration-tracked); the guarded deck
// insert above keeps a hand re-run from duplicating the deck.
const insert = `
INSERT INTO "cards" ("deck_id", "prompt", "answer", "answer_alts", "part_of_speech", "article", "notes", "frequency_rank", "source") VALUES
${valueRows.join(",\n")};
`;

const sqlPath = join(import.meta.dirname, "..", "drizzle", "0005_seed_words.sql");
writeFileSync(sqlPath, header + insert);

console.log(
  `Wrote ${words.length} words (${nouns} nouns, ${gendered} gender-tested).\n` +
    `  → ${jsonPath}\n  → ${sqlPath}`,
);

// One-off, re-runnable generator for the frequency word corpus.
//
// Reads the Anki deck "5000 German words sorted by frequency" and regenerates the
// committed corpus:
//   - server/db/words.data.json  — the cleaned corpus (used by db:seed:words)
//
// NOTE: drizzle/0005_seed_words.sql is FROZEN — it's already applied to prod, and it
// predates the example_en/example_de columns (so it must not reference them). This
// script therefore no longer emits it; the sample sentences reach existing/new
// environments via the ALTER + backfill migrations (see drizzle/0007+). Re-run this
// only to refresh words.data.json for local `db:seed:words`.
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
import { existsSync, mkdtempSync, writeFileSync } from "node:fs";
import { tmpdir, homedir } from "node:os";
import { join } from "node:path";
import { parseNote, type ParsedWord, type RawNote } from "../server/db/words-parse.ts";

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

console.log(
  `Wrote ${words.length} words (${nouns} nouns, ${gendered} gender-tested).\n` +
    `  → ${jsonPath}`,
);

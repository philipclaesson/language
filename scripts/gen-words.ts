// One-off, re-runnable generator for the frequency word corpus.
//
// Reads the Anki deck "English-Deutsch (Sorted by Frequency)" (~5,000 notes) and
// regenerates two committed artifacts:
//   - server/db/words.data.json        — the cleaned corpus (used by db:seed:words)
//   - drizzle/0009_replace_words.sql    — the data migration that REPLACES the prod
//                                         corpus (wipes the old deck's cards, loads
//                                         these into the same global deck row)
//
// History: the corpus was first seeded from a lower-quality deck (0005, frozen) with
// its sentences split out by 0008. This deck has far better example sentences, so we
// swap it in via 0009 rather than editing the frozen migrations. 0009 deletes the old
// corpus cards (cascading their review_state/reviews — that progress is intentionally
// discarded) and reloads the same global deck. Re-running this script overwrites both
// artifacts; bump the migration number below if you regenerate after 0009 is applied.
//
// The per-note cleaning rules live in server/db/words-parse.ts (tested). This script
// is just I/O: unpack, decompress, read SQLite, parse, sort, emit.
//
// Usage (node:sqlite is behind a flag on Node 22.11; zstd binary must be on PATH):
//   NODE_OPTIONS=--experimental-sqlite npx tsx scripts/gen-words.ts [path-to.apkg]

import { DatabaseSync } from "node:sqlite";
import { execFileSync } from "node:child_process";
import { existsSync, mkdtempSync, writeFileSync } from "node:fs";
import { tmpdir, homedir } from "node:os";
import { join } from "node:path";
import { parseNote, type ParsedWord, type RawNote } from "../server/db/words-parse.ts";

// The global corpus deck's fixed id — shared with server/db/words.ts and the seed
// migrations so the seed script and every migration target the same deck row.
const WORD_DECK_ID = "b7c8e3a0-6d4f-4e2a-9c1b-000000005000";
const DECK_NAME = "German — Frequency 5000";
const DECK_DESC =
  "The ~5,000 most frequent German words, ordered by frequency, each with an example sentence.";
const MIGRATION = "0009_replace_words"; // target migration filename (see header note)

// Note field order for the "English-Deutsch" model. The model has three senses plus
// IPA/frequency; we keep sense 1 (primary meaning) — see words-parse.ts.
const FIELDS = [
  "rank", // 0  Rank (1-based frequency order)
  "word", // 1  Word (German headword)
  "_ipa", // 2  IPA (ignored)
  "pos1", // 3  Part-of-Speech 1 (article for nouns)
  "def1", // 4  Definition 1 (English, the prompt)
  "de1", // 5  German 1 (example sentence)
  "en1", // 6  English 1 (translation)
  // 7-15: senses 2/3 + Frequency — ignored.
] as const;

// Unpack the .apkg (a zip) and return a path to a readable SQLite collection. Newer
// Anki exports store the real data in a zstd-compressed `collection.anki21b`; older
// ones use a plain `collection.anki2`.
function collectionPath(input: string): string {
  if (input.endsWith(".anki2")) return input;
  const dir = mkdtempSync(join(tmpdir(), "apkg-"));
  execFileSync("unzip", ["-o", "-d", dir, input]);
  const zstd = join(dir, "collection.anki21b");
  if (existsSync(zstd)) {
    const out = join(dir, "collection.decompressed.anki2");
    execFileSync("zstd", ["-d", "-f", "-o", out, zstd]);
    return out;
  }
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
  join(homedir(), "Downloads", "English-Deutsch (Sorted by Frequency)-20260704133724.apkg");
if (!existsSync(input)) {
  console.error(`Input not found: ${input}`);
  process.exit(1);
}

const db = new DatabaseSync(collectionPath(input), { readOnly: true });
// Restrict to the vocabulary note type (the export bundles a few unused default
// note types with no notes; be explicit rather than trusting "all notes"). Filter
// the name in JS — the `notetypes.name` column uses a custom `unicase` collation
// that node:sqlite can't resolve, so a `WHERE name = …` comparison would error.
const notetypes = db.prepare("SELECT id, name FROM notetypes").all() as {
  id: number;
  name: string;
}[];
const model = notetypes.find((t) => t.name === "English-Deutsch");
if (!model) {
  console.error("Could not find the 'English-Deutsch' note type in the deck.");
  process.exit(1);
}
const rows = db
  .prepare("SELECT flds FROM notes WHERE mid = ?")
  .all(model.id) as { flds: string }[];
db.close();

const words: ParsedWord[] = [];
for (const { flds } of rows) {
  const parts = flds.split("\x1f");
  const raw = Object.fromEntries(FIELDS.map((f, i) => [f, parts[i] ?? ""])) as unknown as RawNote;
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

// --- 000N_replace_words.sql ---
const header = `-- Replace the global frequency word corpus with a higher-quality deck. Generated
-- from an Anki deck by scripts/gen-words.ts; cleaning rules in server/db/words-parse.ts.
-- The original corpus (seeded by the frozen 0005, sentences split by 0008) had weak
-- example sentences. This swaps in ~${words.length} words with natural sentences, reusing the
-- SAME global deck row (id below). It DELETES the old corpus cards first, cascading
-- their review_state/reviews — progress on the old corpus is intentionally discarded.
-- Applied to dev via db:migrate and to prod by the CI migrate job on push to main.

-- Ensure the global deck row exists (a fresh DB may not have run 0005), then refresh it.
INSERT INTO "decks" ("id", "owner_id", "name", "source", "description")
SELECT '${WORD_DECK_ID}'::uuid, NULL, ${sqlStr(DECK_NAME)}, 'seed', ${sqlStr(DECK_DESC)}
WHERE NOT EXISTS (SELECT 1 FROM "decks" WHERE "id" = '${WORD_DECK_ID}'::uuid);
UPDATE "decks" SET "name" = ${sqlStr(DECK_NAME)}, "description" = ${sqlStr(DECK_DESC)}
WHERE "id" = '${WORD_DECK_ID}'::uuid;

-- Drop the old corpus cards (cascades review_state + reviews via ON DELETE CASCADE).
DELETE FROM "cards" WHERE "deck_id" = '${WORD_DECK_ID}'::uuid;
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
    sqlNullable(w.exampleEn),
    sqlNullable(w.exampleDe),
    w.frequencyRank === null ? "NULL" : String(w.frequencyRank),
    "'seed'",
  ];
  return `  (${cols.join(", ")})`;
});

// Plain multi-row INSERT (as in 0003_seed_verbs.sql): each literal is coerced to its
// target column type — notably the unknown deck_id literal → uuid.
const insert = `
INSERT INTO "cards" ("deck_id", "prompt", "answer", "answer_alts", "part_of_speech", "article", "notes", "example_en", "example_de", "frequency_rank", "source") VALUES
${valueRows.join(",\n")};
`;

const sqlPath = join(import.meta.dirname, "..", "drizzle", `${MIGRATION}.sql`);
writeFileSync(sqlPath, header + insert);

console.log(
  `Wrote ${words.length} words (${nouns} nouns, ${gendered} gender-tested).\n` +
    `  → ${jsonPath}\n  → ${sqlPath}`,
);

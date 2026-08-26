// Hand-fixes ("overrides") for the frequency word corpus, applied on top of the
// Anki source. Some cards need edits the source deck doesn't have — a duplicate
// prompt disambiguated, an example sentence that doesn't demonstrate its word.
// Editing words.data.json directly would be lost on the next regeneration, so the
// fixes live HERE, keyed by frequency_rank (the corpus's stable card key, also how
// the backfill migrations address cards in prod), and are applied by both scripts:
//   - scripts/apply-overrides.ts — the day-to-day tool: patches the committed
//     words.data.json in place (no .apkg needed) and emits the next backfill
//     migration for the ranks that changed, preserving review progress;
//   - scripts/gen-words.ts — the full regen from the source .apkg applies the
//     table last, so regenerating never loses a fix.
//
// Workflow for a new fix:
//   1. add an entry to WORD_OVERRIDES below (one entry per rank; amend to stack fixes)
//   2. npx tsx scripts/apply-overrides.ts --name=<short_snake_case_name>
//   3. review the generated drizzle/00NN_<name>.sql, `npm run check`, commit all of it
// The test in words-overrides.test.ts fails if this table and words.data.json
// drift — i.e. if step 2 was skipped.
//
// History: 0011 fixed parser-mangled answers (a words-parse.ts fix — regen-safe, so
// not repeated here); 0012 (weiter) and 0014 (befinden) were the first content
// overrides, hand-written before this table existed. They're seeded below so a
// regeneration keeps them; their migrations already ran, so they emit no new SQL.

import type { ParsedWord } from "./words-parse";

// Fixed id of the global corpus deck. MUST match server/db/words.ts,
// scripts/gen-words.ts, and the deck row in drizzle/0005_seed_words.sql.
export const WORD_DECK_ID = "b7c8e3a0-6d4f-4e2a-9c1b-000000005000";

// The card fields an override may change. frequencyRank is the KEY (it is how the
// card is found, in data.json and in prod alike), so it can never be overridden.
export type OverrideFields = Partial<Omit<ParsedWord, "frequencyRank">>;

export type WordOverride = {
  rank: number; // frequency_rank of the card to fix
  reason: string; // one line on why — copied into the generated migration
  set: OverrideFields;
};

export const WORD_OVERRIDES: WordOverride[] = [
  {
    rank: 221,
    reason:
      'the "weiter" example used "weitere" (the rank-182 card), never the word itself — replaced with a sentence in the adverbial "onwards" sense (first shipped as 0012)',
    set: {
      exampleEn: "We’re tired, but we walk a little further.",
      exampleDe: "Wir sind müde, aber wir gehen noch ein bisschen weiter.",
    },
  },
  {
    rank: 464,
    reason:
      'prompt "to be" was an exact duplicate of the rank-4 card "sein"; "sich befinden" means to be located/situated, and the gloss now says "is located" to match (first shipped as 0014)',
    set: {
      prompt: "to be located, to be situated",
      exampleEn: "The restaurant is located near the railway station.",
    },
  },
  {
    rank: 287,
    reason: 'Swedish "erhålla" is a near-perfect cognate of erhalten (to receive)',
    set: { swedish: "erhålla" },
  },
  {
    rank: 463,
    reason: 'Swedish "trots det" maps trotzdem (nevertheless) far better than English',
    set: { swedish: "trots det" },
  },
  { rank: 75, reason: 'Swedish cognate for uns (us)', set: { swedish: "oss" } },
  { rank: 495, reason: 'Swedish cognate for euch (you pl.)', set: { swedish: "er" } },
  { rank: 340, reason: 'Swedish cognate for tatsächlich (actual)', set: { swedish: "faktisk" } },
  { rank: 321, reason: 'Swedish cognate for steigen (to climb/rise)', set: { swedish: "stiga" } },
  { rank: 302, reason: 'Swedish cognate for deutlich (clear)', set: { swedish: "tydlig" } },
  { rank: 299, reason: 'Swedish cognate for handeln (to act/trade)', set: { swedish: "handla" } },
  { rank: 297, reason: 'Swedish cognate for die Zahl (number)', set: { swedish: "tal" } },
  { rank: 280, reason: 'Swedish cognate for bestimmt (certain/definite)', set: { swedish: "bestämd" } },
  { rank: 279, reason: 'Swedish for überhaupt (at all)', set: { swedish: "över huvud taget" } },
  { rank: 523, reason: 'Swedish cognate for annehmen (to assume/accept)', set: { swedish: "anta" } },
  { rank: 569, reason: 'Swedish cognate for der Begriff (concept/term)', set: { swedish: "begrepp" } },
  { rank: 568, reason: 'Swedish cognate for aktuell (current)', set: { swedish: "aktuell" } },
  { rank: 419, reason: 'Swedish cognate for bestimmen (to decide/determine)', set: { swedish: "bestämma" } },
  {
    rank: 216,
    reason: 'Swedish "känna någon" pins kennen to knowing a person (vs. wissen)',
    set: { swedish: "känna någon" },
  },
  { rank: 189, reason: 'Swedish cognate for wirklich (real/actual)', set: { swedish: "verklig" } },
  { rank: 560, reason: 'Swedish "bo" maps wohnen (to live/reside) better than English "to live"', set: { swedish: "bo" } },
  { rank: 566, reason: 'Swedish cognate for merken (to notice)', set: { swedish: "märka" } },

  // Swedish glosses to disambiguate five near-synonymous "to happen / occur / take
  // place" verbs clustered around rank 620–654, all glossed near-identically in English.
  { rank: 623, reason: 'Swedish cognate "ske" pins geschehen (to happen/occur)', set: { swedish: "ske" } },
  { rank: 628, reason: 'Swedish cognate "förekomma" pins vorkommen (to occur/be present)', set: { swedish: "förekomma" } },
  { rank: 648, reason: 'Swedish "genomföras" pins erfolgen (to take place/be carried out); the cognate "följa" drifted to mean "follow"', set: { swedish: "genomföras" } },
  { rank: 652, reason: 'Swedish idiom "äga rum" pins stattfinden (to take place); "ta plats" is a false friend (= take up space)', set: { swedish: "äga rum" } },
  { rank: 654, reason: 'Swedish cognate "uppträda" pins auftreten (to appear/occur/perform)', set: { swedish: "uppträda" } },

  // Swedish glosses to disambiguate three "different" words all glossed the same in English.
  { rank: 254, reason: 'Swedish "olika" pins verschieden (various/different)', set: { swedish: "olika" } },
  { rank: 303, reason: 'Swedish "annorlunda" pins anders (differently); the cognate "annars" is a false friend (= otherwise/else)', set: { swedish: "annorlunda" } },
  { rank: 345, reason: 'Swedish "skilda" pins unterschiedlich (differing/distinct), mirroring Unterschied→skillnad', set: { swedish: "skilda" } },

  // Swedish glosses splitting the two "doctor" words: title vs. profession.
  { rank: 240, reason: 'Swedish cognate "doktor" pins Doktor (title/degree)', set: { swedish: "doktor" } },
  { rank: 622, reason: 'Swedish "läkare" pins Arzt (physician/profession), vs. Doktor the title', set: { swedish: "läkare" } },

  // Swedish glosses splitting three "increase" verbs (steigen already covered above,
  // rank 321 → stiga): höja (transitive, raise) vs. tilltaga (intransitive, grow).
  { rank: 617, reason: 'Swedish cognate "höja" pins erhöhen (to raise, transitive)', set: { swedish: "höja" } },
  { rank: 650, reason: 'Swedish "tilltaga" pins zunehmen (to increase/grow, intransitive) — a morpheme-for-morpheme cognate (zu-nehmen = till-taga)', set: { swedish: "tilltaga" } },

  // Plural-only nouns (plurale tantum) the source deck left article-less. With a
  // null article checkAnswer treats the card as a non-noun, so the *correct*
  // "die Leute" graded as a plain fail; "die" restores normal noun grading.
  // Deliberately NOT extended to the nominalized adjectives (Beamte, Deutsche,
  // Vorsitzende, …), whose article follows the referent's gender.
  { rank: 224, reason: 'plurale tantum: die Leute (article-less in the source deck)', set: { article: "die" } },
  { rank: 404, reason: 'plurale tantum: die Eltern (article-less in the source deck)', set: { article: "die" } },
  { rank: 564, reason: 'plurale tantum: die Kosten (article-less in the source deck)', set: { article: "die" } },
  { rank: 574, reason: 'plural of das Datum, used as plurale tantum: die Daten', set: { article: "die" } },
  { rank: 951, reason: 'plural of das Medium, used as plurale tantum: die Medien', set: { article: "die" } },
  { rank: 2853, reason: 'plurale tantum: die Schulden (article-less in the source deck)', set: { article: "die" } },
  { rank: 3448, reason: 'plurale tantum: die Ferien (article-less in the source deck)', set: { article: "die" } },
  { rank: 3929, reason: 'plural noun: die Geschwister (article-less in the source deck)', set: { article: "die" } },
  { rank: 4068, reason: 'plural noun: die Taliban (article-less in the source deck)', set: { article: "die" } },
  { rank: 4099, reason: 'plural-only proper noun: die Alpen (article-less in the source deck)', set: { article: "die" } },

  // Ordinary singular nouns the source deck also left article-less — same grading
  // bug as the plurals above, but each takes its own gender.
  { rank: 198, reason: 'der Teil (part of a whole) — article missing in the source deck', set: { article: "der" } },
  { rank: 1117, reason: 'der Grad (degree) — article missing in the source deck', set: { article: "der" } },
  { rank: 2172, reason: 'die E-Mail — article missing in the source deck', set: { article: "die" } },
  { rank: 4516, reason: 'der Laptop — article missing in the source deck', set: { article: "der" } },
];

/**
 * Apply the override table to a parsed corpus. Returns a new array (input rows are
 * never mutated; overridden rows are replaced). Throws on a duplicate rank in the
 * table or on an override whose rank matches no word — both mean the table is
 * stale (e.g. the source deck changed underneath it) and must fail loudly rather
 * than silently skip a fix.
 */
export function applyOverrides(
  words: ParsedWord[],
  overrides: WordOverride[] = WORD_OVERRIDES,
): ParsedWord[] {
  const byRank = new Map<number, WordOverride>();
  for (const o of overrides) {
    if (byRank.has(o.rank)) throw new Error(`duplicate override for rank ${o.rank}`);
    byRank.set(o.rank, o);
  }
  const applied = new Set<number>();
  const out = words.map((w) => {
    const o = w.frequencyRank === null ? undefined : byRank.get(w.frequencyRank);
    if (!o) return w;
    applied.add(o.rank);
    const patch = Object.fromEntries(
      Object.entries(o.set).filter(([, v]) => v !== undefined),
    );
    return { ...w, ...patch };
  });
  for (const o of overrides) {
    if (!applied.has(o.rank)) throw new Error(`override for rank ${o.rank} matched no word`);
  }
  return out;
}

// --- SQL literals + backfill emission -----------------------------------------
// Pure string builders shared by scripts/gen-words.ts (the full corpus INSERT) and
// scripts/apply-overrides.ts (the per-fix backfill UPDATEs). They live here, not in
// the scripts, so the rules are unit-tested.

export function sqlStr(s: string): string {
  return `'${s.replace(/'/g, "''")}'`;
}
export function sqlNullable(s: string | null): string {
  return s === null ? "NULL" : sqlStr(s);
}
export function sqlArray(items: string[]): string {
  return items.length === 0
    ? "ARRAY[]::text[]"
    : `ARRAY[${items.map(sqlStr).join(", ")}]::text[]`;
}

// cards column for each overridable field.
const FIELD_COLUMNS: Record<keyof OverrideFields, string> = {
  prompt: "prompt",
  answer: "answer",
  answerAlts: "answer_alts",
  article: "article",
  partOfSpeech: "part_of_speech",
  notes: "notes",
  swedish: "swedish",
  exampleEn: "example_en",
  exampleDe: "example_de",
};

function sqlValue(v: string | string[] | null): string {
  if (v === null) return "NULL";
  if (Array.isArray(v)) return sqlArray(v);
  return sqlStr(v);
}

/**
 * One idempotent, progress-preserving UPDATE for an override: sets only the fields
 * the override sets, keyed on (deck_id, frequency_rank) — same shape as the
 * hand-written backfills 0011/0012/0014.
 */
export function overrideUpdateSql(o: WordOverride): string {
  const entries = (Object.entries(o.set) as [keyof OverrideFields, string | string[] | null][])
    .filter(([, v]) => v !== undefined);
  if (entries.length === 0) throw new Error(`override for rank ${o.rank} sets no fields`);
  const sets = entries.map(([field, v]) => `"${FIELD_COLUMNS[field]}" = ${sqlValue(v)}`);
  return (
    `-- rank ${o.rank}: ${o.reason}\n` +
    `UPDATE "cards" SET ${sets.join(", ")}\n` +
    `WHERE "deck_id" = '${WORD_DECK_ID}'::uuid AND "frequency_rank" = ${o.rank};\n`
  );
}

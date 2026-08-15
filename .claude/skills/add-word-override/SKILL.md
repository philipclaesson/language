---
name: add-word-override
description: Add or amend a hand-fix ("override") for a card in the global frequency word corpus — fix a wrong/duplicate English prompt, a bad example sentence, a wrong answer/article, etc. Use when the user reports a bad frequency-deck card (often with a screenshot) and wants it corrected. Drives the whole flow: locate the card, edit the override table, generate the backfill migration, verify, and commit.
---

# Add a word-corpus override

Fixes one card in the global frequency word corpus **durably** — survives a full
regen from the Anki `.apkg`, preserves everyone's review progress, and reaches prod
via a normal migration. Never hand-edit `words.data.json` or write ad-hoc SQL; the
override table is the only supported way (see CLAUDE.md > Gotchas > corpus overrides).

## What the user gives you

Usually a screenshot or a sentence: "the 'to be' card that wants *sich befinden* is a
duplicate", or "rank 464's example is wrong". You often have to **find the card first**
and **decide the fix** yourself, then confirm the concrete change with them.

## Steps

1. **Find the card's `frequency_rank`.** If the user didn't give a rank, search the
   committed corpus by the German answer or English prompt:
   ```
   npx tsx -e 'const w=require("./server/db/words.data.json"); for(const x of w) if((x.answer+" "+x.prompt).toLowerCase().includes(process.argv[1].toLowerCase())) console.log(x.frequencyRank, JSON.stringify(x))' "SEARCH_TERM"
   ```
   `frequencyRank` is the stable key — it's how the card is addressed in both
   `words.data.json` and prod. Read the matching row so you know its current fields
   and can write a fix that's actually a change.

2. **Decide the fix, then confirm it.** Restate the concrete before→after to the user
   in one line (e.g. `prompt "to be" → "to be located, to be situated"`) before editing.
   Only override what the source deck genuinely got wrong.
   - **Parser bugs go elsewhere.** If the problem is a *class* of cards mangled the same
     way (bad article parsing, a stripped suffix, reflexive handling), fix
     `server/db/words-parse.ts` instead — that's regen-safe by construction. The
     override table is for *individual* content fixes. (Precedent: 0011 was a parser
     fix; 0012/0014 were content overrides.)

3. **Add or amend the entry** in `server/db/words-overrides.ts` → `WORD_OVERRIDES`.
   One entry per rank (amend the existing one to stack fixes on the same card). Set
   only the fields that change; leave the rest out. Shape:
   ```ts
   {
     rank: 464,
     reason: "prompt was a duplicate of rank-4 'sein'; sich befinden = to be located",
     set: {
       prompt: "to be located, to be situated",
       exampleEn: "The restaurant is located near the railway station.",
     },
   },
   ```
   Overridable fields (from `OverrideFields`): `prompt`, `answer`, `answerAlts`
   (string[]), `article` (`"der"|"die"|"das"|null`), `partOfSpeech`, `notes`,
   `swedish`, `exampleEn`, `exampleDe`. `frequencyRank` is the key — never in `set`.
   The `reason` is one line and gets copied verbatim into the migration comment.
   - **Swedish glosses** are a common override: when a German word maps more cleanly
     to a Swedish cognate than to English (trotzdem → "trots det", erhalten →
     "erhålla"), set `swedish` — it's shown under the prompt as a hint for Swedish
     speakers. The source deck has none, so this field is always override-supplied.
   - **Reflexive verbs:** answer is the `"sich <verb>"` citation form with the bare
     infinitive in `answerAlts` (e.g. `answer: "sich befinden", answerAlts: ["befinden"]`).

4. **Generate the migration:**
   ```
   npx tsx scripts/apply-overrides.ts --name=<short_snake_case>
   ```
   Name it after the fix, e.g. `fix_befinden_prompt`. This rewrites
   `words.data.json`, writes `drizzle/00NN_<name>.sql` (idempotent in-place UPDATEs,
   keyed on `(deck_id, frequency_rank)` — progress preserved), and appends the journal
   entry. If it prints "already reflects every override — nothing to do", your edit
   didn't actually change the row (you set the value it already had) — recheck step 2.
   **Read the generated SQL** and confirm it matches the intended change.

5. **Verify green:**
   ```
   npm run check
   ```
   The drift-guard test in `words-overrides.test.ts` fails if the table and
   `words.data.json` disagree — i.e. if you skipped step 4.

6. **Commit all of it together** — `server/db/words-overrides.ts`,
   `server/db/words.data.json`, the new `drizzle/00NN_*.sql`, and
   `drizzle/meta/_journal.json`. If on `main`, branch first (`claude/<slug>`).
   Prod gets the fix from the CI migrate job on push to main; don't migrate prod by
   hand. (Optional local check if a dev DB is reachable: `npm run db:migrate` applies
   it to the Neon dev branch.)

## Keep it minimal

The user may just say "fix that card" from a phone. Do the lookup, propose the exact
edit in one line, and once they confirm, run steps 3–6 without further back-and-forth.
Show the generated SQL and the `npm run check` result; then commit.

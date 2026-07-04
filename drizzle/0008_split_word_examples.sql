-- Backfill the example-sentence columns for the global frequency word corpus.
-- Data migration (no schema change; the columns are added in 0007). The corpus
-- was originally seeded (0005) with the German + English sample sentences packed
-- into a single `notes` value ("<german>\n<english>"). Now that each has its own
-- column, split them out: the English gloss is shown up front for context, the
-- German sentence (which contains the answer word) only after a wrong answer.
--
-- cleanHtml collapses all whitespace, so a note holds at most one newline, and
-- every corpus note is exactly "<de>\n<en>" (verified against the source deck: no
-- English-only or German-only notes). `notes` is cleared afterwards — for the
-- corpus it only ever held the sentences; it stays free for tutor mnemonics.
-- Idempotent: after the first run `notes` is null, so the guard excludes every row.
UPDATE "cards"
SET "example_de" = split_part("notes", E'\n', 1),
    "example_en" = NULLIF(split_part("notes", E'\n', 2), ''),
    "notes" = NULL
WHERE "deck_id" = 'b7c8e3a0-6d4f-4e2a-9c1b-000000005000'::uuid
  AND "notes" IS NOT NULL;

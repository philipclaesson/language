-- Backfill: fix the example sentence on the frequency-corpus card "weiter" (further,
-- adverb; frequency_rank 221). Its German example was "Weitere Informationen zu diesem
-- Thema stehen im Internet." — which uses "weitere" (additional, the rank-182 card), not
-- "weiter" at all, so the sentence never demonstrated the word it teaches and was nearly
-- identical to the "weitere" card's example. Replaced with a sentence that actually uses
-- "weiter" in its adverbial "onwards / keep going" sense.
--
-- UPDATEs the card IN PLACE, keyed on (deck_id, frequency_rank) — no deck delete/recreate,
-- so every user's review_state/reviews (progress) is preserved. Idempotent: re-running sets
-- the same values. Applied to dev via db:migrate and to prod by the CI migrate job on push
-- to main.

UPDATE "cards"
SET "example_en" = 'We’re tired, but we walk a little further.',
    "example_de" = 'Wir sind müde, aber wir gehen noch ein bisschen weiter.'
WHERE "deck_id" = 'b7c8e3a0-6d4f-4e2a-9c1b-000000005000'::uuid AND "frequency_rank" = 221;

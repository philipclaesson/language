-- Backfill: fix the prompt on the frequency-corpus card "sich befinden" (frequency_rank
-- 464). Its English prompt was "to be" — an exact duplicate of the rank-4 card "sein",
-- so the learner had no way to know which verb was being asked. "sich befinden" means
-- "to be located / situated" (formal; where something is), which is exactly what its
-- example sentence shows, so the prompt now says that. The English gloss is nudged to
-- "is located" to reinforce the distinction (the German example already used
-- "befindet sich" and is unchanged).
--
-- UPDATEs the card IN PLACE, keyed on (deck_id, frequency_rank) — no deck delete/recreate,
-- so every user's review_state/reviews (progress) is preserved. Idempotent: re-running sets
-- the same values. Applied to dev via db:migrate and to prod by the CI migrate job on push
-- to main.

UPDATE "cards"
SET "prompt" = 'to be located, to be situated',
    "example_en" = 'The restaurant is located near the railway station.'
WHERE "deck_id" = 'b7c8e3a0-6d4f-4e2a-9c1b-000000005000'::uuid AND "frequency_rank" = 464;

-- Backfill: fix 73 frequency-corpus card answers that were mangled by a
-- parsing bug. Parenthetical groups in the source Anki headword (declension endings
-- like "andere (r, s)", abbreviation expansions like "DNA (DNS, ...)", and the reflexive
-- marker "(sich)") were split mid-parenthesis by the comma-splitter in words-parse.ts,
-- leaving answers such as "andere (r", "DNA (DNS", and "befinden (sich)". The parser now
-- strips parens first (and gives reflexive verbs a "sich <verb>" citation form with the
-- bare infinitive as an accepted alt).
--
-- This UPDATES the affected cards IN PLACE, keyed on (deck_id, frequency_rank) — it does
-- NOT delete/recreate the deck, so every user's review_state/reviews (progress) is
-- preserved. Idempotent: re-running sets the same values. The card ids are unchanged.
-- Applied to dev via db:migrate and to prod by the CI migrate job on push to main.

UPDATE "cards" SET "answer" = 'andere', "answer_alts" = ARRAY[]::text[]
WHERE "deck_id" = 'b7c8e3a0-6d4f-4e2a-9c1b-000000005000'::uuid AND "frequency_rank" = 59;
UPDATE "cards" SET "answer" = 'jede', "answer_alts" = ARRAY[]::text[]
WHERE "deck_id" = 'b7c8e3a0-6d4f-4e2a-9c1b-000000005000'::uuid AND "frequency_rank" = 87;
UPDATE "cards" SET "answer" = 'erste', "answer_alts" = ARRAY[]::text[]
WHERE "deck_id" = 'b7c8e3a0-6d4f-4e2a-9c1b-000000005000'::uuid AND "frequency_rank" = 95;
UPDATE "cards" SET "answer" = 'letzte', "answer_alts" = ARRAY[]::text[]
WHERE "deck_id" = 'b7c8e3a0-6d4f-4e2a-9c1b-000000005000'::uuid AND "frequency_rank" = 152;
UPDATE "cards" SET "answer" = 'weitere', "answer_alts" = ARRAY[]::text[]
WHERE "deck_id" = 'b7c8e3a0-6d4f-4e2a-9c1b-000000005000'::uuid AND "frequency_rank" = 182;
UPDATE "cards" SET "answer" = 'nächste', "answer_alts" = ARRAY[]::text[]
WHERE "deck_id" = 'b7c8e3a0-6d4f-4e2a-9c1b-000000005000'::uuid AND "frequency_rank" = 237;
UPDATE "cards" SET "answer" = 'beste', "answer_alts" = ARRAY[]::text[]
WHERE "deck_id" = 'b7c8e3a0-6d4f-4e2a-9c1b-000000005000'::uuid AND "frequency_rank" = 314;
UPDATE "cards" SET "answer" = 'jene', "answer_alts" = ARRAY[]::text[]
WHERE "deck_id" = 'b7c8e3a0-6d4f-4e2a-9c1b-000000005000'::uuid AND "frequency_rank" = 395;
UPDATE "cards" SET "answer" = 'USA', "answer_alts" = ARRAY[]::text[]
WHERE "deck_id" = 'b7c8e3a0-6d4f-4e2a-9c1b-000000005000'::uuid AND "frequency_rank" = 409;
UPDATE "cards" SET "answer" = 'manche', "answer_alts" = ARRAY[]::text[]
WHERE "deck_id" = 'b7c8e3a0-6d4f-4e2a-9c1b-000000005000'::uuid AND "frequency_rank" = 433;
UPDATE "cards" SET "answer" = 'sich befinden', "answer_alts" = ARRAY['befinden']::text[]
WHERE "deck_id" = 'b7c8e3a0-6d4f-4e2a-9c1b-000000005000'::uuid AND "frequency_rank" = 464;
UPDATE "cards" SET "answer" = 'besondere', "answer_alts" = ARRAY[]::text[]
WHERE "deck_id" = 'b7c8e3a0-6d4f-4e2a-9c1b-000000005000'::uuid AND "frequency_rank" = 512;
UPDATE "cards" SET "answer" = 'innere', "answer_alts" = ARRAY[]::text[]
WHERE "deck_id" = 'b7c8e3a0-6d4f-4e2a-9c1b-000000005000'::uuid AND "frequency_rank" = 671;
UPDATE "cards" SET "answer" = 'EU', "answer_alts" = ARRAY[]::text[]
WHERE "deck_id" = 'b7c8e3a0-6d4f-4e2a-9c1b-000000005000'::uuid AND "frequency_rank" = 726;
UPDATE "cards" SET "answer" = 'SPD', "answer_alts" = ARRAY[]::text[]
WHERE "deck_id" = 'b7c8e3a0-6d4f-4e2a-9c1b-000000005000'::uuid AND "frequency_rank" = 777;
UPDATE "cards" SET "answer" = 'rechte', "answer_alts" = ARRAY[]::text[]
WHERE "deck_id" = 'b7c8e3a0-6d4f-4e2a-9c1b-000000005000'::uuid AND "frequency_rank" = 786;
UPDATE "cards" SET "answer" = 'linke', "answer_alts" = ARRAY[]::text[]
WHERE "deck_id" = 'b7c8e3a0-6d4f-4e2a-9c1b-000000005000'::uuid AND "frequency_rank" = 871;
UPDATE "cards" SET "answer" = 'CDU', "answer_alts" = ARRAY[]::text[]
WHERE "deck_id" = 'b7c8e3a0-6d4f-4e2a-9c1b-000000005000'::uuid AND "frequency_rank" = 894;
UPDATE "cards" SET "answer" = 'BGB', "answer_alts" = ARRAY[]::text[]
WHERE "deck_id" = 'b7c8e3a0-6d4f-4e2a-9c1b-000000005000'::uuid AND "frequency_rank" = 946;
UPDATE "cards" SET "answer" = 'sich eignen', "answer_alts" = ARRAY['eignen']::text[]
WHERE "deck_id" = 'b7c8e3a0-6d4f-4e2a-9c1b-000000005000'::uuid AND "frequency_rank" = 960;
UPDATE "cards" SET "answer" = 'obere', "answer_alts" = ARRAY[]::text[]
WHERE "deck_id" = 'b7c8e3a0-6d4f-4e2a-9c1b-000000005000'::uuid AND "frequency_rank" = 1179;
UPDATE "cards" SET "answer" = 'sich kümmern', "answer_alts" = ARRAY['kümmern']::text[]
WHERE "deck_id" = 'b7c8e3a0-6d4f-4e2a-9c1b-000000005000'::uuid AND "frequency_rank" = 1182;
UPDATE "cards" SET "answer" = 'mittlere', "answer_alts" = ARRAY[]::text[]
WHERE "deck_id" = 'b7c8e3a0-6d4f-4e2a-9c1b-000000005000'::uuid AND "frequency_rank" = 1183;
UPDATE "cards" SET "answer" = 'VWL', "answer_alts" = ARRAY[]::text[]
WHERE "deck_id" = 'b7c8e3a0-6d4f-4e2a-9c1b-000000005000'::uuid AND "frequency_rank" = 1534;
UPDATE "cards" SET "answer" = 'sich bemühen', "answer_alts" = ARRAY['bemühen']::text[]
WHERE "deck_id" = 'b7c8e3a0-6d4f-4e2a-9c1b-000000005000'::uuid AND "frequency_rank" = 1577;
UPDATE "cards" SET "answer" = 'AfD', "answer_alts" = ARRAY[]::text[]
WHERE "deck_id" = 'b7c8e3a0-6d4f-4e2a-9c1b-000000005000'::uuid AND "frequency_rank" = 1579;
UPDATE "cards" SET "answer" = 'untere', "answer_alts" = ARRAY[]::text[]
WHERE "deck_id" = 'b7c8e3a0-6d4f-4e2a-9c1b-000000005000'::uuid AND "frequency_rank" = 1692;
UPDATE "cards" SET "answer" = 'DNA', "answer_alts" = ARRAY[]::text[]
WHERE "deck_id" = 'b7c8e3a0-6d4f-4e2a-9c1b-000000005000'::uuid AND "frequency_rank" = 1777;
UPDATE "cards" SET "answer" = 'sich vornehmen', "answer_alts" = ARRAY['vornehmen']::text[]
WHERE "deck_id" = 'b7c8e3a0-6d4f-4e2a-9c1b-000000005000'::uuid AND "frequency_rank" = 1805;
UPDATE "cards" SET "answer" = 'AG', "answer_alts" = ARRAY[]::text[]
WHERE "deck_id" = 'b7c8e3a0-6d4f-4e2a-9c1b-000000005000'::uuid AND "frequency_rank" = 1892;
UPDATE "cards" SET "answer" = 'sich unterhalten', "answer_alts" = ARRAY['unterhalten']::text[]
WHERE "deck_id" = 'b7c8e3a0-6d4f-4e2a-9c1b-000000005000'::uuid AND "frequency_rank" = 1898;
UPDATE "cards" SET "answer" = 'irgendwelche', "answer_alts" = ARRAY[]::text[]
WHERE "deck_id" = 'b7c8e3a0-6d4f-4e2a-9c1b-000000005000'::uuid AND "frequency_rank" = 1911;
UPDATE "cards" SET "answer" = 'BRD', "answer_alts" = ARRAY[]::text[]
WHERE "deck_id" = 'b7c8e3a0-6d4f-4e2a-9c1b-000000005000'::uuid AND "frequency_rank" = 2034;
UPDATE "cards" SET "answer" = 'CSU', "answer_alts" = ARRAY[]::text[]
WHERE "deck_id" = 'b7c8e3a0-6d4f-4e2a-9c1b-000000005000'::uuid AND "frequency_rank" = 2040;
UPDATE "cards" SET "answer" = 'sich lohnen', "answer_alts" = ARRAY['lohnen']::text[]
WHERE "deck_id" = 'b7c8e3a0-6d4f-4e2a-9c1b-000000005000'::uuid AND "frequency_rank" = 2103;
UPDATE "cards" SET "answer" = 'sich wundern', "answer_alts" = ARRAY['wundern']::text[]
WHERE "deck_id" = 'b7c8e3a0-6d4f-4e2a-9c1b-000000005000'::uuid AND "frequency_rank" = 2118;
UPDATE "cards" SET "answer" = 'äußere', "answer_alts" = ARRAY[]::text[]
WHERE "deck_id" = 'b7c8e3a0-6d4f-4e2a-9c1b-000000005000'::uuid AND "frequency_rank" = 2236;
UPDATE "cards" SET "answer" = 'HGB', "answer_alts" = ARRAY[]::text[]
WHERE "deck_id" = 'b7c8e3a0-6d4f-4e2a-9c1b-000000005000'::uuid AND "frequency_rank" = 2260;
UPDATE "cards" SET "answer" = 'selbe', "answer_alts" = ARRAY[]::text[]
WHERE "deck_id" = 'b7c8e3a0-6d4f-4e2a-9c1b-000000005000'::uuid AND "frequency_rank" = 2280;
UPDATE "cards" SET "answer" = 'FDP', "answer_alts" = ARRAY[]::text[]
WHERE "deck_id" = 'b7c8e3a0-6d4f-4e2a-9c1b-000000005000'::uuid AND "frequency_rank" = 2283;
UPDATE "cards" SET "answer" = 'WM', "answer_alts" = ARRAY[]::text[]
WHERE "deck_id" = 'b7c8e3a0-6d4f-4e2a-9c1b-000000005000'::uuid AND "frequency_rank" = 2370;
UPDATE "cards" SET "answer" = 'sich entschließen', "answer_alts" = ARRAY['entschließen']::text[]
WHERE "deck_id" = 'b7c8e3a0-6d4f-4e2a-9c1b-000000005000'::uuid AND "frequency_rank" = 2455;
UPDATE "cards" SET "answer" = 'sich verlieben', "answer_alts" = ARRAY['verlieben']::text[]
WHERE "deck_id" = 'b7c8e3a0-6d4f-4e2a-9c1b-000000005000'::uuid AND "frequency_rank" = 2465;
UPDATE "cards" SET "answer" = 'sich wehren', "answer_alts" = ARRAY['wehren']::text[]
WHERE "deck_id" = 'b7c8e3a0-6d4f-4e2a-9c1b-000000005000'::uuid AND "frequency_rank" = 2591;
UPDATE "cards" SET "answer" = 'sich nähern', "answer_alts" = ARRAY['nähern']::text[]
WHERE "deck_id" = 'b7c8e3a0-6d4f-4e2a-9c1b-000000005000'::uuid AND "frequency_rank" = 2714;
UPDATE "cards" SET "answer" = 'sich befassen', "answer_alts" = ARRAY['befassen']::text[]
WHERE "deck_id" = 'b7c8e3a0-6d4f-4e2a-9c1b-000000005000'::uuid AND "frequency_rank" = 2769;
UPDATE "cards" SET "answer" = 'EZB', "answer_alts" = ARRAY[]::text[]
WHERE "deck_id" = 'b7c8e3a0-6d4f-4e2a-9c1b-000000005000'::uuid AND "frequency_rank" = 2806;
UPDATE "cards" SET "answer" = 'sich herausstellen', "answer_alts" = ARRAY['herausstellen']::text[]
WHERE "deck_id" = 'b7c8e3a0-6d4f-4e2a-9c1b-000000005000'::uuid AND "frequency_rank" = 2819;
UPDATE "cards" SET "answer" = 'sich bedanken', "answer_alts" = ARRAY['bedanken']::text[]
WHERE "deck_id" = 'b7c8e3a0-6d4f-4e2a-9c1b-000000005000'::uuid AND "frequency_rank" = 2882;
UPDATE "cards" SET "answer" = 'sich auswirken', "answer_alts" = ARRAY['auswirken']::text[]
WHERE "deck_id" = 'b7c8e3a0-6d4f-4e2a-9c1b-000000005000'::uuid AND "frequency_rank" = 3071;
UPDATE "cards" SET "answer" = 'hintere', "answer_alts" = ARRAY[]::text[]
WHERE "deck_id" = 'b7c8e3a0-6d4f-4e2a-9c1b-000000005000'::uuid AND "frequency_rank" = 3129;
UPDATE "cards" SET "answer" = 'jegliche', "answer_alts" = ARRAY[]::text[]
WHERE "deck_id" = 'b7c8e3a0-6d4f-4e2a-9c1b-000000005000'::uuid AND "frequency_rank" = 3652;
UPDATE "cards" SET "answer" = 'final', "answer_alts" = ARRAY[]::text[]
WHERE "deck_id" = 'b7c8e3a0-6d4f-4e2a-9c1b-000000005000'::uuid AND "frequency_rank" = 3685;
UPDATE "cards" SET "answer" = 'sich begeben', "answer_alts" = ARRAY['begeben']::text[]
WHERE "deck_id" = 'b7c8e3a0-6d4f-4e2a-9c1b-000000005000'::uuid AND "frequency_rank" = 3728;
UPDATE "cards" SET "answer" = 'sich bewerben', "answer_alts" = ARRAY['bewerben']::text[]
WHERE "deck_id" = 'b7c8e3a0-6d4f-4e2a-9c1b-000000005000'::uuid AND "frequency_rank" = 3775;
UPDATE "cards" SET "answer" = 'sich weigern', "answer_alts" = ARRAY['weigern']::text[]
WHERE "deck_id" = 'b7c8e3a0-6d4f-4e2a-9c1b-000000005000'::uuid AND "frequency_rank" = 3858;
UPDATE "cards" SET "answer" = 'LKW', "answer_alts" = ARRAY[]::text[]
WHERE "deck_id" = 'b7c8e3a0-6d4f-4e2a-9c1b-000000005000'::uuid AND "frequency_rank" = 3892;
UPDATE "cards" SET "answer" = 'sich bewähren', "answer_alts" = ARRAY['bewähren']::text[]
WHERE "deck_id" = 'b7c8e3a0-6d4f-4e2a-9c1b-000000005000'::uuid AND "frequency_rank" = 3973;
UPDATE "cards" SET "answer" = 'sich erholen', "answer_alts" = ARRAY['erholen']::text[]
WHERE "deck_id" = 'b7c8e3a0-6d4f-4e2a-9c1b-000000005000'::uuid AND "frequency_rank" = 3976;
UPDATE "cards" SET "answer" = 'sich schämen', "answer_alts" = ARRAY['schämen']::text[]
WHERE "deck_id" = 'b7c8e3a0-6d4f-4e2a-9c1b-000000005000'::uuid AND "frequency_rank" = 4098;
UPDATE "cards" SET "answer" = 'sich verständigen', "answer_alts" = ARRAY['verständigen']::text[]
WHERE "deck_id" = 'b7c8e3a0-6d4f-4e2a-9c1b-000000005000'::uuid AND "frequency_rank" = 4147;
UPDATE "cards" SET "answer" = 'sich aufrichten', "answer_alts" = ARRAY['aufrichten']::text[]
WHERE "deck_id" = 'b7c8e3a0-6d4f-4e2a-9c1b-000000005000'::uuid AND "frequency_rank" = 4151;
UPDATE "cards" SET "answer" = 'UNO', "answer_alts" = ARRAY[]::text[]
WHERE "deck_id" = 'b7c8e3a0-6d4f-4e2a-9c1b-000000005000'::uuid AND "frequency_rank" = 4181;
UPDATE "cards" SET "answer" = 'sich erstrecken', "answer_alts" = ARRAY['erstrecken']::text[]
WHERE "deck_id" = 'b7c8e3a0-6d4f-4e2a-9c1b-000000005000'::uuid AND "frequency_rank" = 4260;
UPDATE "cards" SET "answer" = 'sich erkundigen', "answer_alts" = ARRAY['erkundigen']::text[]
WHERE "deck_id" = 'b7c8e3a0-6d4f-4e2a-9c1b-000000005000'::uuid AND "frequency_rank" = 4274;
UPDATE "cards" SET "answer" = 'ÖVP', "answer_alts" = ARRAY[]::text[]
WHERE "deck_id" = 'b7c8e3a0-6d4f-4e2a-9c1b-000000005000'::uuid AND "frequency_rank" = 4280;
UPDATE "cards" SET "answer" = 'sich irren', "answer_alts" = ARRAY['irren']::text[]
WHERE "deck_id" = 'b7c8e3a0-6d4f-4e2a-9c1b-000000005000'::uuid AND "frequency_rank" = 4288;
UPDATE "cards" SET "answer" = 'sich fügen', "answer_alts" = ARRAY['fügen']::text[]
WHERE "deck_id" = 'b7c8e3a0-6d4f-4e2a-9c1b-000000005000'::uuid AND "frequency_rank" = 4311;
UPDATE "cards" SET "answer" = 'sich betrinken', "answer_alts" = ARRAY['betrinken']::text[]
WHERE "deck_id" = 'b7c8e3a0-6d4f-4e2a-9c1b-000000005000'::uuid AND "frequency_rank" = 4338;
UPDATE "cards" SET "answer" = 'FPÖ', "answer_alts" = ARRAY[]::text[]
WHERE "deck_id" = 'b7c8e3a0-6d4f-4e2a-9c1b-000000005000'::uuid AND "frequency_rank" = 4355;
UPDATE "cards" SET "answer" = 'Stasi', "answer_alts" = ARRAY[]::text[]
WHERE "deck_id" = 'b7c8e3a0-6d4f-4e2a-9c1b-000000005000'::uuid AND "frequency_rank" = 4375;
UPDATE "cards" SET "answer" = 'DFB', "answer_alts" = ARRAY[]::text[]
WHERE "deck_id" = 'b7c8e3a0-6d4f-4e2a-9c1b-000000005000'::uuid AND "frequency_rank" = 4744;
UPDATE "cards" SET "answer" = 'sich abzeichnen', "answer_alts" = ARRAY['abzeichnen']::text[]
WHERE "deck_id" = 'b7c8e3a0-6d4f-4e2a-9c1b-000000005000'::uuid AND "frequency_rank" = 4757;

# Verbs Mode — Implementation Plan

> **Status: built (2026-07-01).** Shipped as described below; see PLAN.md status +
> decision 12. This doc is now both the plan and the reference for the feature.

> A separate practice mode for German present-tense **conjugation**. You drill the
> six present forms of a verb at once (ich / du / er-sie-es / wir / ihr / sie-Sie),
> all-or-nothing, on the same daily spaced-repetition loop as Words mode. This spec
> is self-contained; it sits alongside **PLAN.md** (§5a is the daily loop this
> reuses) and **CLAUDE.md** (the extension pattern this follows).

## Why a separate mode

Verbs are currently mixed into a normal word deck, so conjugation patterns never
get isolated and drilled. Verbs mode fixes that:

- A **fixed, pre-populated, frequency-ordered catalog** of verbs (start with the
  top ~100), rather than dynamically-authored decks.
- Each verb is marked **regular** or **irregular** in the data model, weighted
  toward irregular when introducing new verbs (they matter more), and the tag is
  shown while drilling.
- A card tests **all six present-tense forms at once**; getting the whole set
  right is the only pass (all-or-nothing).
- Reuses the exact daily loop from Words mode (§5a): a finite "today's set", the
  type-it-correctly-once completion gate, and the same FSRS scheduling.

## Decisions (resolved with the user)

1. **Catalog scope → shared global.** One `verbs` table both users draw from,
   ordered by frequency. Per-user progress lives in a separate `verb_review_state`
   (mirrors how `review_state` is split from `cards`). This is a deliberate
   departure from Words mode's *personal* libraries — verbs are reference data, so
   there's one list, edited in one place.
2. **What you type → the 6 forms only.** The card header shows the infinitive +
   English + a regular/irregular tag (e.g. "gehen · to go · irregular"). The six
   pronouns are prefilled; you fill in each conjugated form. Recall of the
   infinitive stays in Words mode — this mode is pure conjugation drilling.
3. **Daily new-verb mix → fixed 3 irregular + 2 regular.** 5 new verbs/day: take
   the next 3 unstudied irregular and next 2 regular, both in frequency order.
   Deterministic and always leans irregular. Spills over to the other bucket when
   one is exhausted so we still reach 5/day while verbs remain.
4. **Scope → present tense only, for now.** Six forms. Other tenses (Präteritum,
   Perfekt) are a later, additive extension (see "Future extensions").

---

## 1. Data model

Three new tables. The `verbs` catalog is **global** (no `owner_id`); progress and
the answer log are **per-user**, mirroring the `cards` / `review_state` /
`reviews` split so we can reuse the FSRS wrapper and day-planner logic verbatim.

```
verbs                          -- global, shared, reference data
  id              uuid pk
  infinitive      text unique notNull       -- "gehen"
  english         text notNull              -- "to go"  (shown as the prompt subtitle)
  regularity      text notNull              -- 'regular' | 'irregular'
  frequency_rank  integer notNull           -- 1 = most frequent; drives new-verb order
  form_ich        text notNull              -- present-tense forms
  form_du         text notNull
  form_er         text notNull              -- er/sie/es (one slot)
  form_wir        text notNull
  form_ihr        text notNull
  form_sie        text notNull              -- sie/Sie plural+formal (one slot)
  notes           text null                 -- optional: irregularity note / mnemonic
  created_at      timestamptz

verb_review_state              -- one row per (user, verb): FSRS scheduler state
  id              uuid pk
  user_id         uuid fk -> users
  verb_id         uuid fk -> verbs
  due             timestamptz
  stability       double precision          -- FSRS fields (identical shape to review_state)
  difficulty      double precision
  reps            int
  lapses          int
  last_review     timestamptz null
  state           text                      -- 'new' | 'learning' | 'review' | 'relearning'
  unique(user_id, verb_id)

verb_reviews                   -- append-only answer log (parity with `reviews`)
  id              uuid pk
  user_id         uuid fk -> users
  verb_id         uuid fk -> verbs
  rating          int                        -- 1 = fail, 3 = pass (all-or-nothing)
  graded          boolean notNull default true   -- first-attempt-of-day grades; re-drills = false
  typed_answer    jsonb null                 -- the 6 typed forms (analytics)
  reviewed_at     timestamptz
  elapsed_ms      int null
```

Notes:

- **Six explicit form columns** (not a JSON blob) keeps them typed and the
  answer-checker trivial, matching the explicit-column style of `cards`
  (`answer`, `article`, …). If/when we add tenses, promote to a `verb_forms`
  child table keyed by `(verb_id, tense)` rather than widening this row.
- `frequency_rank` is the single ordering key for introducing new verbs. Keep it
  a plain integer (gaps are fine) so inserting a verb between two others later
  doesn't require a renumber.
- `verb_reviews` exists for the same reasons as `reviews`: it's what the
  day-planner reads to know "reviewed today / correct today / reviewed before
  today", and it feeds a future FSRS optimizer.

### Migration + seeding both branches

Per the repo's doctrine (**migrations, never hand-edits**; CI applies prod
migrations on push to main):

1. Add the three tables to `server/db/schema.ts`, then `npm run db:generate` to
   produce the DDL migration.
2. Author the catalog in `server/db/verbs.ts` (human-readable source of truth,
   like `STARTER_WORDS` in `seed.ts`).
3. Ship the initial ~100 verbs as a **committed data migration** (hand-authored
   `drizzle/NNNN_seed_verbs.sql` with `INSERT ... ON CONFLICT (infinitive) DO
   NOTHING`). Because it's a migration, it applies to the **dev** branch via
   `npm run db:migrate` locally and to **prod** via the CI `migrate` job on push
   to main — satisfying "create the verb catalog in both dev and prod" with zero
   manual prod steps.
4. Growing/editing the catalog later = a new data migration (or an idempotent
   `db:seed:verbs` upsert script keyed on `infinitive`, run per branch). The
   global catalog is *not* user-editable from the UI in this phase.

The verb list is recited from memory (top ~100 by frequency) — good enough and
faster than sourcing a list. Shape example (a handful, illustrative):

| infinitive | english   | regularity | ich    | du       | er/sie/es | wir     | ihr    | sie/Sie |
|------------|-----------|------------|--------|----------|-----------|---------|--------|---------|
| sein       | to be     | irregular  | bin    | bist     | ist       | sind    | seid   | sind    |
| haben      | to have   | irregular  | habe   | hast     | hat       | haben   | habt   | haben   |
| werden     | to become | irregular  | werde  | wirst    | wird      | werden  | werdet | werden  |
| können     | can       | irregular  | kann   | kannst   | kann      | können  | könnt  | können  |
| machen     | to do     | regular    | mache  | machst   | macht     | machen  | macht  | machen  |
| gehen      | to go     | regular    | gehe   | gehst    | geht      | gehen   | geht   | gehen   |
| sprechen   | to speak  | irregular  | spreche| sprichst | spricht   | sprechen| sprecht| sprechen|
| spielen    | to play   | regular    | spiele | spielst  | spielt    | spielen | spielt | spielen |

`regularity` reflects the **present tense**: irregular = the present forms deviate
from the regular pattern (modals, sein/haben/werden, stem-changers like
*sprechen* → *spricht* and *fahren* → *fährt*, wissen, nehmen). A strong verb whose
present is regular (e.g. *gehen*, *kommen*, *singen*) is marked `regular` — the tag
tells the learner whether the present forms will surprise them. A finer
`stem-changing` category is a possible future refinement.

---

## 2. Shared types (`shared/types.ts`)

Add a verbs section. Critically, the per-request "session" shape **never includes
the six forms** — the forms are the answer, so leaking them would defeat the test
(the exact parallel of the "never send the answer or article" rule in Words mode).

```ts
export type VerbForm = "ich" | "du" | "er" | "wir" | "ihr" | "sie";
export type Conjugation = Record<VerbForm, string>;
export const VERB_FORMS: VerbForm[] = ["ich", "du", "er", "wir", "ihr", "sie"];
export const VERB_FORM_LABELS: Record<VerbForm, string> = {
  ich: "ich", du: "du", er: "er/sie/es", wir: "wir", ihr: "ihr", sie: "sie/Sie",
};

export type VerbRegularity = "regular" | "irregular";

// What the client sees before answering — NO forms.
export type SessionVerb = {
  id: string;
  infinitive: string;   // "gehen"
  english: string;      // "to go"
  regularity: VerbRegularity;
};

export type VerbReviewRequest = {
  verbId: string;
  typed: Conjugation;   // the six forms the user filled in
  elapsedMs?: number;
};

export type VerbReviewResult = {
  correct: boolean;                 // all six matched
  expected: Conjugation;           // full correct set, revealed on miss
  perForm: Record<VerbForm, boolean>; // which rows were right (for highlighting)
  nextDue: string;
  graded: boolean;                 // first-attempt-of-day only (§5a)
  needsRedrill: boolean;           // still needs a correct typing today
};

// Mirrors TodayResponse. `verbs` is the still-pending set.
export type VerbTodayResponse = {
  verbs: SessionVerb[];
  dueTotal: number;
  newTotal: number;
  done: number;
  pending: number;
  complete: boolean;
};

// Reuse the same MasteryTier scheme as Words.
export type VerbProgressResponse = ProgressResponse;
```

---

## 3. Server logic (thin routes, tested pure functions)

### 3a. Conjugation checker — `server/verbs/check.ts` (+ `check.test.ts`)

Pure, all-or-nothing. Reuses the umlaut/ß tolerance already in `srs/check.ts`.

- **Refactor:** export the existing `normalize()` from `srs/check.ts` (currently
  private) so both matchers share one normalization (trim, collapse whitespace,
  case-fold, `ä≈ae / ö≈oe / ü≈ue / ß≈ss`). No behavior change to Words.
- `checkConjugation(expected: Conjugation, typed: Conjugation, opts?)` returns
  `{ correct, perForm, expected }`:
  - `perForm[f]` = normalized(typed[f]) === normalized(expected[f]) for each form.
  - `correct` = every `perForm` true (all six). One wrong form fails the card.
  - `umlautTolerant` defaults to true (same as Words).
- Tests: exact match; umlaut-tolerant match (`gehoeren`-style); one wrong form
  fails; empty forms fail; whitespace/case tolerance.

### 3b. Verb day-planner — `server/verbs/plan.ts` (+ `plan.test.ts`)

Reuses the pure day helpers from `srs/day.ts` (`startOfDay`, `endOfDay`,
`isFirstAttemptOfDay`, `dayProgress`) but replaces the new-card selection with the
weighted 3-irregular/2-regular rule. Words' `planToday` is **not** touched.

Constants (module-local, like `NEW_PER_DAY`):

```ts
export const NEW_VERBS_PER_DAY = 5;
export const IRREGULAR_PER_DAY = 3;
export const REGULAR_PER_DAY = 2;
```

`planVerbDay(verbs, now, opts)` where each input verb carries the same daily facts
as `CardToday` **plus** `regularity` and `frequencyRank`. Buckets are identical to
`planToday` (due reviews / introduced-today / fresh), with one change to the fresh
selection:

- Fresh candidates are split into irregular / regular pools, each ordered by
  `frequencyRank`.
- Slots to fill = `NEW_VERBS_PER_DAY − introducedToday`.
- Fill preferring `IRREGULAR_PER_DAY` from the irregular pool and
  `REGULAR_PER_DAY` from the regular pool; if a bucket runs dry, spill the
  remaining slots into the other bucket (so we always reach 5/day while any
  unstudied verbs remain).
- Everything else — due membership, "introduced today counts regardless of
  regularity", the stable required-total, `dayProgress` — matches §5a exactly.
- Returns the same shape as `TodayPlan` (`pendingIds`, `dueTotal`, `newTotal`,
  `done`, `pending`, `complete`).
- Tests: the 3/2 split on a fresh day; spill-over when one bucket is short; carry
  the day's total stably as verbs are completed; introduced-today verbs stay
  required; nothing left when all verbs studied.

### 3c. Routes — `server/verb-routes.ts` (mounted in `index.ts` under `/api`)

Structurally a copy of `review-routes.ts`, against the verb tables. `requireAuth`
on all. **Never returns the six forms in the session/today payload.**

- `GET /api/verbs/session/today` → build `VerbTodayResponse` via `planVerbDay`
  from the global `verbs` catalog left-joined to this user's `verb_review_state`,
  plus today's / earlier `verb_reviews`. Returns pending `SessionVerb`s (id,
  infinitive, english, regularity only), shuffled, same as Words.
- `POST /api/verbs/reviews` → load the verb (global, so no ownership check beyond
  auth), run `checkConjugation`, apply the **first-attempt-of-day** grading rule
  via `scheduleNext` (reused verbatim) against `verb_review_state`, log to
  `verb_reviews` (re-drills `graded=false`), and return `VerbReviewResult`
  (including `perForm` + the revealed `expected` set on a miss).
- `GET /api/verbs/progress` → `summarizeProgress` (reused from `srs/tiers.ts`)
  over the user's verb stabilities → `VerbProgressResponse`.

Mount alongside the others in `server/index.ts`:
`api.route("/", verbRoutes); // /verbs/session/today, /verbs/reviews, /verbs/progress`.

---

## 4. Frontend

### 4a. Footer nav — `web/src/footer.tsx` + routing rework

Introduce a persistent, mobile-first bottom nav: **Tutor · Words · Verbs**. It
promotes Tutor and Words (which stay exactly as they are) to first-class tabs and
adds Verbs.

- Fixed to the bottom on the three **tab-root** screens; the active tab is
  highlighted; taps call `navigate()`.
- Routes after the rework (in `app.tsx`'s `Home`):
  - `/` → Words dashboard (unchanged) — **Words** tab
  - `/review` → Words review (unchanged) — full-screen, **footer hidden**
  - `/verbs` → Verbs dashboard — **Verbs** tab
  - `/verbs/review` → Verbs review — full-screen, **footer hidden**
  - `/chat` → Tutor (unchanged) — **Tutor** tab (footer shown; drop its `onBack`
    in favor of the footer, or keep it too)
- **Footer hidden during active review** on both modes: the review loop relies on
  a never-blurring input to keep the mobile keyboard open, so a nav bar there is
  both a focus hazard and clutter. Add bottom padding on tab-root screens so
  content clears the footer.

### 4b. Verbs dashboard — in `web/src/verbs.tsx`

Mirrors the Words dashboard card:

- Fetches `GET /api/verbs/session/today` + `GET /api/verbs/progress`.
- Shows "N verbs to conjugate today", `done / total`, and a **Start / Continue**
  button → `/verbs/review`.
- A verb **mastery bar** reusing the `TIERS` component styling from `app.tsx`
  ("X verbs mastered"). Kept **separate** from the Words mastery number — each
  mode has its own daily set, completion, and progress.

### 4c. Verb review loop — `VerbReview` in `web/src/verbs.tsx`

Same state machine as `review.tsx` (`loading | input | drill | empty | done`) and
the same "hammer until correct" queue (wrong → rotate to back of today's queue),
but the card is a **six-row conjugation grid** instead of a single input.

- **Header:** infinitive + English + a **regular/irregular tag** (e.g. a small
  pill), satisfying "indicate whether it's regular or irregular while repeating".
- **Grid:** six rows, each with a prefilled pronoun label (`ich`, `du`,
  `er/sie/es`, `wir`, `ihr`, `sie/Sie`) and a text input. Inputs use
  `autocapitalize/autocorrect/spellcheck` off like Words.
- **Keyboard flow (mobile):** `enterkeyhint="next"` on rows 1–5 moves focus to the
  next input (keyboard stays open); row 6 submits (`enterkeyhint="go"`). A visible
  **Check** button submits too. Focus starts on `ich` when a card appears.
- **Grading:** submit sends all six via `POST /api/verbs/reviews`. All-or-nothing:
  - **Correct** → green flash, auto-advance (no success screen), card done.
  - **Wrong** → red flash; reveal the correct forms; highlight the rows that were
    wrong using `perForm`. Enter the **drill**: the correct rows stay filled and
    locked; the wrong rows are cleared for you to retype. Fixing the wrong rows
    correctly (all six now match) advances and rotates the card to the back of
    today's queue for a real recall retry later — the §5a completion gate.
    - *(Simpler alternative if the locked-rows UX is fussy: require retyping all
      six to continue, matching Words' "type the full answer to continue". Start
      with fix-the-wrong-rows.)*
- **Progress + done screens:** identical to Words (`done / requiredTotal` bar,
  "Done for today 🎉").

### 4d. API client — `web/src/api.ts`

Add `getVerbToday()`, `postVerbReview(req)`, `getVerbProgress()` and import the
new shared types. Same `fetch` wrapper.

---

## 5. What does *not* change

- The Words core loop (`review-routes.ts`, `review.tsx`, `planToday`,
  `cards`/`review_state`/`reviews`) is untouched — Verbs mode is fully additive,
  the same way AI modules are (CLAUDE.md "the extension pattern").
- `srs/scheduler.ts` (`scheduleNext`, `StoredSrs`) and `srs/tiers.ts`
  (`summarizeProgress`) are **reused as-is** for verbs.
- The day-boundary logic in `srs/day.ts` is reused; only new-verb *selection* is
  new (`verbs/plan.ts`).

---

## 6. Build order

**Phase A — Data model + seed**
- `schema.ts`: add `verbs`, `verb_review_state`, `verb_reviews`. `db:generate`.
- `server/db/verbs.ts`: author the top ~100 verbs (with the 3 irregular : 2
  regular frequency ordering in mind).
- Data migration seeding the catalog (`ON CONFLICT (infinitive) DO NOTHING`).
- `npm run db:migrate` (dev branch); verify rows. Prod seeds via CI on merge.

**Phase B — Pure logic (tested)**
- Export `normalize` from `srs/check.ts`; add `verbs/check.ts` + tests.
- `verbs/plan.ts` (weighted 3/2 selection) + tests.

**Phase C — API**
- `shared/types.ts` verb section.
- `server/verb-routes.ts`; mount in `index.ts`.

**Phase D — Frontend**
- `footer.tsx` + routing rework in `app.tsx` (Tutor · Words · Verbs).
- `verbs.tsx` (dashboard + six-row review loop).
- `api.ts` client methods.

**Phase E — Docs + verify**
- Update **PLAN.md** (new §5b "Verbs mode" + roadmap + decisions), **CLAUDE.md**
  (status, layout: `verb-routes.ts`, `verbs/`, footer), **INFRA.md** (new tables +
  the verb-seed data migration).
- `npm run check` before each commit; verify a live session after deploy.

---

## 7. Future extensions (designed-in, not now)

- **More tenses** (Präteritum, Perfekt/auxiliary + participle): promote the six
  form columns to a `verb_forms` child table keyed by `(verb_id, tense)`; the
  review card gains a tense selector or interleaves tenses.
- **Finer regularity** (`stem-changing` vs fully irregular) for smarter weighting.
- **Per-user new-verb limit / weighting** if a settings screen ever lands (today
  these are constants, exactly like `NEW_PER_DAY`).
- **Umlaut helper buttons** (ä ö ü ß) shared with the Words review, useful across
  six inputs on mobile.

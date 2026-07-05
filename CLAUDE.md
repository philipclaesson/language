# CLAUDE.md

Operating guide for working on this repo. Also read **PLAN.md** (design + roadmap)
and **INFRA.md** (what's deployed). Keep all three current as things change.

## What this is

Spaced-repetition German vocabulary trainer for two people (a personal project).
Type the German for an English prompt; all-or-nothing grading; FSRS scheduling.
Built so AI modules (chat tutor, AI-authored decks, news, voice) can be added
later without touching the core loop.

## Status

- **Done:** Phase 0 (skeleton), Phase 1 (Google auth), Phase 2 (SRS core:
  answer-checking, FSRS, review API + UI, starter deck). First AI module: the
  **chat tutor** (chat to build/maintain decks; Claude tool-use, `source='ai_chat'`).
  **Verbs mode** (VERBS.md): a separate tab that drills the six present-tense
  conjugations of a global, frequency-ordered verb catalog on the same daily loop.
  **Frequency word corpus:** ~5,000 frequency-ranked German words as a single
  *global* (ownerless) deck that flows through the normal Words loop, introduced
  most-frequent-first. Each card carries an **example sentence** (English gloss shown
  up front for context; German sentence revealed on a miss). Imported from an Anki
  deck; reaches prod via data migrations.
  **Freund** (FREUND.md): a conversation partner — chat in German, get corrected
  inline (the correction replaces your message via a server-computed word diff), and
  bank your misses as cards in a single shared "Freund cards" deck. Per-message turn
  on Haiku; end-of-convo card review on Opus. Additive like the tutor; no schema change.
- **Live:** https://language.levanto.dev — Cloud Run, **auto-deploys on push to main**.
- **Next:** Phase 3 (deck management UI), Phase 4 (polish), more AI modules
  (news, voice). See PLAN.md §12.

## Stack & layout

TypeScript everywhere. One Cloud Run service serves the SPA and the API.

- `web/` — Preact + Vite + Tailwind SPA.
  - `app.tsx` auth gating + routing · `review.tsx` the review loop ·
    `decks.tsx` deck list + detail · `chat.tsx` the AI tutor chat ·
    `verbs.tsx` verbs dashboard + six-field conjugation loop ·
    `freund.tsx` the Freund conversation partner (chat + end-of-convo card review) ·
    `footer.tsx` the bottom tab bar (Tutor · Freund · Words · Verbs · Stats) ·
    `api.ts` typed fetch client · `router.ts` tiny History-API router (no dep).
  - Routes: `/` dashboard, `/review`, `/chat`, `/freund`, `/decks/:id`, `/verbs`,
    `/verbs/review`. The tab bar shows on the tab roots (`/`, `/chat`, `/freund`, `/verbs`);
    the review loops render full-screen without it. The server serves `index.html`
    for any non-API path, so deep links / refresh / back all work.
- `server/` — Hono on Node.
  - `index.ts` wiring + static serving · `auth.ts` Google OAuth + JWT session +
    `requireAuth` · `review-routes.ts` `/session/today` + `/reviews` ·
    `deck-routes.ts` `/decks` + `/decks/:id` · `verb-routes.ts` `/verbs/session/today`
    + `/verbs/reviews` + `/verbs/progress` · `chat-routes.ts` `/chat` (AI tutor:
    Claude tool-use loop + deck/card tools) · `chat/cards.ts` pure card-input
    normalizer (+ `cards.test.ts`) · `freund-routes.ts` `/freund/*` (conversation
    partner: per-message correction on Haiku, end-of-convo card review on Opus) ·
    `freund/agent.ts` models + tool schemas + prompts · `freund/diff.ts` pure
    word-diff (+ `diff.test.ts`) · `freund/seed.ts` today's-vocab seeder ·
    `freund/eval.ts` opt-in prompt eval · `srs/check.ts` pure answer matcher
    (+ `check.test.ts`) · `srs/scheduler.ts` FSRS wrapper · `srs/day.ts` daily-loop
    logic · `verbs/check.ts` conjugation matcher + `verbs/plan.ts` verb day-planner
    (both pure, tested) · `db/schema.ts` Drizzle schema · `db/seed.ts` starter deck ·
    `db/verbs.ts` the global verb catalog · `db/words.ts` loads the global word
    corpus + `db/words-parse.ts` pure Anki-note cleaner (+ `words-parse.test.ts`) ·
    `env.ts` env validation.
- `shared/types.ts` — the client/server contract. **Change types here first.**
- `drizzle/` — committed SQL migrations.
- `scripts/gen-words.ts` — one-off, re-runnable generator: reads the source Anki
  `.apkg` ("English-Deutsch (Sorted by Frequency)") and regenerates
  `server/db/words.data.json` + `drizzle/0009_replace_words.sql`. Migration lineage:
  0005 seeded the first (weaker) corpus, 0008 split its sentences into `example_*`;
  **0009 replaced it** with this higher-quality deck (same global deck row; wipes the
  old cards + their progress). 0005/0008 are frozen — re-runs only touch 0009.

## Commands

- `npm run dev` — Vite (:5173) + Hono (:8787) with hot reload. Open :5173.
- `npm run check` — typecheck + test + build. **Run before every commit.**
- `npm test` — `node:test` unit tests.
- `npm run eval:freund` — opt-in, network-hitting eval of Freund's correction
  behavior (coverage guard against dropped content). **Not** part of `npm run check`.
- `npm run db:generate` / `npm run db:migrate` — after editing `schema.ts`.
  `db:migrate` targets whatever `DATABASE_URL` is in `.env` — the Neon **dev**
  branch locally. **Prod migrations run in CI on push to main** (the `migrate`
  job); don't migrate prod by hand. See INFRA.md > Branches & migrations.
- `npm run db:seed` — give existing users the starter deck.
- `npm run db:seed:verbs` — load/refresh the global verb catalog (idempotent).
  The initial catalog reaches prod via the `0003_seed_verbs.sql` data migration.
- `npm run db:seed:words` — load the global frequency word corpus (idempotent:
  no-op if the global deck exists). Prod gets it via the `0005_seed_words.sql`
  data migration. Regenerate the corpus with `scripts/gen-words.ts`.
- Deploy = **push to main** (CI: check → migrate → deploy). Manual deploy in INFRA.md.

## How we work (to avoid breaking things / spaghetti)

1. **Thin routes, tested logic.** Route handlers only parse input, call a
   function, and return JSON. Real logic goes in pure functions like
   `srs/check.ts` — small, no I/O, easy to unit-test. Add a `*.test.ts` next to
   any logic with rules or edge cases. Don't test framework glue.
2. **Types first.** Add/adjust `shared/types.ts`, then implement server + client
   against it. `npm run check` catches drift.
3. **Migrations, never hand-edits.** Edit `schema.ts` → `db:generate` →
   `db:migrate` (applies to your **dev** branch) → commit the generated SQL.
   CI applies it to prod on push to main.
4. **Green commits.** Run `npm run check` before committing — a push to main
   deploys to prod (CI also gates on check, so a red build won't deploy).
5. **Small, focused changes.** One feature per branch/PR is ideal (PRs get CI
   checked). Working directly on main is fine for small stuff since check gates
   deploy, but branch for anything risky.
6. **Secrets never in git.** `.env` is gitignored; prod secrets live in Secret
   Manager. New env var = add to `env.ts` + `.env.example` + Secret Manager +
   the deploy `--set-secrets`/`--set-env-vars` flags.

## Adding an AI module (the extension pattern)

The core loop reads `decks`/`cards`/`review_state` and **does not change**. A new
module is additive:

1. New route file `server/<module>-routes.ts`, mounted in `index.ts` under `/api`.
2. It writes `decks` + `cards` with a new `source` value (`'ai_chat'`, `'news'`, …).
   Those cards flow into the normal SRS queue automatically.
3. Add a UI surface in `web/`.

Keep LLM calls server-side. Use the latest Claude models — consult the
`claude-api` skill for current model IDs and SDK usage.
**`chat-routes.ts` is the worked example:** a stateless `/chat` running a Claude
tool-use loop whose tools write `decks`/`cards` (`source='ai_chat'`). The model is
pinned in one constant (`MODEL = "claude-sonnet-4-6"`) — bump it there if needed.
Rules-y logic (the card-input normalizer) lives in `chat/cards.ts`, unit-tested;
the route/tool glue isn't.

## Gotchas

- **Vite pinned to v6.** v8 needs Node ≥22.12 (local dev is 22.11). Don't bump
  Vite without bumping Node.
- `/session/today` must **never** send the answer or the article to the client
  (the article reveals a noun's gender — the thing being tested). Likewise
  `/verbs/session/today` must never send the six conjugated forms — they are the
  answer. Both send only the prompt/metadata. The corpus's **example sentences**
  split along the same line: `cards.example_en` (English gloss) is sent up front for
  context and rendered under the prompt; `cards.example_de` (German sentence, which
  contains the answer word) is withheld until after answering and returned in the
  `/reviews` result, shown only in the drill panel on a miss.
- **Verbs are a global catalog**, not per-user decks: the `verbs` table has no
  owner (edited in one place, seeded to both DB branches by a data migration);
  only `verb_review_state`/`verb_reviews` are per-user. The core loop, FSRS
  wrapper (`srs/scheduler.ts`), and mastery tiers (`srs/tiers.ts`) are reused
  unchanged — Verbs mode is additive, like an AI module.
- **A `decks` row with `owner_id = NULL` is a *global* deck** (the frequency word
  corpus). Reads widen to `or(ownerId = user, ownerId IS NULL)` (review-routes +
  deck-routes); **writes stay scoped to `ownerId = user`**, so global decks are
  automatically read-only and hidden from the tutor. When adding a new read over
  `decks`, decide whether it should include globals. New cards each day are split
  **50/50** between the user's own decks and stock/global decks (`srs/day.ts`
  `pickFresh`, keyed off `CardToday.stock` = an ownerless deck), spilling into
  whichever pool still has cards. Within a pool, order is `cards.frequency_rank`
  (stock) or `createdAt` (own).
- **Freund** seeds its system prompt server-side with today's words/verbs *including*
  their German answers (`freund/seed.ts`) — fine because it never leaves the server
  (unlike `/session/today`, which must never send answers). Two model-shaped rules:
  the correction must rewrite the **whole** message (the model returns the full
  corrected text and the server diffs it — a past "one sentence" prompt dropped the
  correct sentences; guarded now by `npm run eval:freund`), and the end-of-convo
  review **flattens the transcript into one user message** because the 4.x+ models
  reject a request ending on an assistant turn (it reads as a prefill). Both AI calls
  use a **forced tool call**, not structured outputs; models are pinned in
  `freund/agent.ts` (`CHAT_MODEL` Haiku, `REVIEW_MODEL` Opus).
- Cloud Run is in **europe-west1** (domain mappings aren't supported in west3).
- The `pg` SSL deprecation warning in logs is harmless.
- `Date.now()`/`Math.random()` are fine in server code (the ban is only in
  Workflow scripts, which this project doesn't use).

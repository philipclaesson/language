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
- **Live:** https://language.levanto.dev — Cloud Run, **auto-deploys on push to main**.
- **Next:** Phase 3 (deck management UI), Phase 4 (polish), more AI modules
  (news, voice). See PLAN.md §12.

## Stack & layout

TypeScript everywhere. One Cloud Run service serves the SPA and the API.

- `web/` — Preact + Vite + Tailwind SPA.
  - `app.tsx` auth gating + routing · `review.tsx` the review loop ·
    `decks.tsx` deck list + detail · `chat.tsx` the AI tutor chat ·
    `api.ts` typed fetch client · `router.ts` tiny History-API router (no dep).
  - Routes: `/` dashboard, `/review`, `/chat`, `/decks/:id`. The server serves
    `index.html` for any non-API path, so deep links / refresh / back all work.
- `server/` — Hono on Node.
  - `index.ts` wiring + static serving · `auth.ts` Google OAuth + JWT session +
    `requireAuth` · `review-routes.ts` `/session/next` + `/reviews` ·
    `deck-routes.ts` `/decks` + `/decks/:id` · `chat-routes.ts` `/chat` (AI tutor:
    Claude tool-use loop + deck/card tools) · `chat/cards.ts` pure card-input
    normalizer (+ `cards.test.ts`) · `srs/check.ts` pure answer matcher
    (+ `check.test.ts`) · `srs/scheduler.ts` FSRS wrapper · `db/schema.ts` Drizzle
    schema · `db/seed.ts` starter deck · `env.ts` env validation.
- `shared/types.ts` — the client/server contract. **Change types here first.**
- `drizzle/` — committed SQL migrations.

## Commands

- `npm run dev` — Vite (:5173) + Hono (:8787) with hot reload. Open :5173.
- `npm run check` — typecheck + test + build. **Run before every commit.**
- `npm test` — `node:test` unit tests.
- `npm run db:generate` / `npm run db:migrate` — after editing `schema.ts`.
- `npm run db:seed` — give existing users the starter deck.
- Deploy = **push to main** (CI runs check, then deploys). Manual deploy in INFRA.md.

## How we work (to avoid breaking things / spaghetti)

1. **Thin routes, tested logic.** Route handlers only parse input, call a
   function, and return JSON. Real logic goes in pure functions like
   `srs/check.ts` — small, no I/O, easy to unit-test. Add a `*.test.ts` next to
   any logic with rules or edge cases. Don't test framework glue.
2. **Types first.** Add/adjust `shared/types.ts`, then implement server + client
   against it. `npm run check` catches drift.
3. **Migrations, never hand-edits.** Edit `schema.ts` → `db:generate` →
   `db:migrate` → commit the generated SQL.
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
- `/session/next` must **never** send the answer or the article to the client
  (the article reveals a noun's gender — the thing being tested).
- Cloud Run is in **europe-west1** (domain mappings aren't supported in west3).
- The `pg` SSL deprecation warning in logs is harmless.
- `Date.now()`/`Math.random()` are fine in server code (the ban is only in
  Workflow scripts, which this project doesn't use).

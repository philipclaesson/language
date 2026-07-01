# Language Learning App — Implementation Plan

> A spaced-repetition German vocabulary trainer for two users, designed so AI
> modules (chat, voice, AI-authored decks, news) can bolt on later without a
> rewrite.

## Status (2026-06-18)

- ✅ **Phase 0–1:** skeleton + Google auth, deployed to Cloud Run.
- ✅ **Phase 2:** SRS core — answer-checking, FSRS, review API + UI, starter deck.
- ✅ **Infra/CI:** Neon DB, custom domain (https://language.levanto.dev),
  auto-deploy on push to main (gated on `npm run check`). See INFRA.md.
- ✅ **Phase 5 (first AI module):** chat tutor — chat about German and build/edit
  decks via a server-side Claude tool-use loop (`server/chat-routes.ts`,
  `source='ai_chat'`). Model pinned to `claude-sonnet-4-6`.
- ✅ **Daily loop (§5a) — built (first cut):** `enable_short_term: false` fix +
  pure `tiers`/`day` logic (unit-tested) + `/session/today`, reworked `/reviews`
  (first-attempt-of-day grading, training-only re-drills), `/progress`, and the
  client (re-drill loop, finishable "done for today", mastery tiers bar). Retired
  `/session/next`. The `reviews.graded` migration is applied to prod (by the CI
  `migrate` job) and deployed. **Pending:** verify against a live session.
- ✅ **Verbs mode — built:** a separate tab (bottom nav: Tutor · Words · Verbs)
  that drills the six present-tense conjugations of a **global, frequency-ordered
  verb catalog** (~100 verbs, seeded to both DB branches by a data migration). New
  verbs are introduced 5/day at a fixed 3-irregular : 2-regular mix; a card tests
  all six forms all-or-nothing on the same §5a daily loop (first-attempt grading,
  drill-until-correct). Additive: new `verbs`/`verb_review_state`/`verb_reviews`
  tables, `verb-routes.ts`, `verbs/{check,plan}.ts` (pure, tested); the words core
  loop, FSRS wrapper, and tiers are reused unchanged. Full spec in **VERBS.md**.
- ⏭️ **Next:** *use the live daily loop for a few days*, then bonus work
  (designed — see **EXTRA_WORK.md**) → streaks → Phase 3 (deck UI) → Phase 4
  (polish) → more AI modules.

(Build phases detailed in §12. Operating guide in CLAUDE.md.)

## Guiding principles

- **Tight infra.** One deployable service, one database, scales to (near) zero
  when nobody is using it. No Kubernetes, no microservices.
- **Easy to maintain.** One language end-to-end (TypeScript), shared types
  between client and server, minimal dependencies, boring well-trodden tools.
- **2 users, ever.** No signup flow, no password reset, no rate limiting, no
  multi-tenant complexity. Auth is an email allowlist of two Google accounts.
- **AI-ready data model.** Every card knows where it came from. Adding a module
  that *creates* cards is just another writer against the same tables.

---

## 1. Architecture at a glance

```
                 language.levanto.dev
                         │
                         ▼
        ┌────────────────────────────────────┐
        │         Cloud Run (one service)     │
        │  ┌──────────────────────────────┐   │
        │  │  Node app (Hono)             │   │
        │  │  - serves built Preact SPA   │   │
        │  │  - /api/* JSON endpoints     │   │
        │  │  - Google OAuth + session    │   │
        │  │  - SRS engine                │   │
        │  │  - (later) /api/ai/* routes  │   │
        │  └──────────────────────────────┘   │
        └───────────────┬────────────────────┘
                        │  SQL over TLS
                        ▼
              ┌──────────────────────┐
              │  Serverless Postgres  │
              │  (Neon free tier)     │
              └──────────────────────┘
```

**Key decision: one Cloud Run service serves both the API and the static
frontend.** GitHub Pages is viable for the SPA, but splitting hosting forces you
to deal with CORS, cookie `SameSite` rules across domains, and a second deploy
pipeline. Serving the SPA from the same origin as the API makes auth cookies and
local dev trivial. We keep GitHub Pages in our back pocket but don't start there.

---

## 2. Tech stack

| Concern        | Choice                          | Why / alternative |
|----------------|---------------------------------|-------------------|
| Language       | TypeScript everywhere           | Shared types, one toolchain |
| Frontend       | **Preact** + Vite + Tailwind    | React's component/hooks model at ~3KB; keeps deps minimal but survives into the chat/news AI modules. Zero SSR needed |
| Server         | **Hono** on Node                | Tiny, fast cold starts, serves static + API in one app. (Fastify is the heavier-but-fine alternative.) |
| DB             | **Postgres via Neon**           | Serverless, scales to zero, generous free tier, real SQL for relational SRS data |
| ORM/migrations | **Drizzle ORM**                 | Lightweight, great TS types, SQL-first, fast cold start (vs Prisma's engine) |
| Auth           | Google OAuth 2.0 + signed cookie session | `arctic` + `oslo` libs, or Auth.js. Allowlist of 2 emails |
| Hosting        | Cloud Run (single container)    | Scale-to-zero, cheap, custom domain mapping |
| SRS            | **FSRS** via `ts-fsrs`          | Modern, better retention than SM-2, handles binary pass/fail cleanly |

**Why not Firestore / Cloud SQL?** Firestore is all-GCP and scales to zero, but
relational SRS + future module relationships are more natural and queryable in
SQL. Cloud SQL is Postgres but is *always-on* (min ~$10–25/mo) — wasteful for two
people. Neon gives us real Postgres that sleeps when idle, on the free tier. If
you'd rather stay 100% inside GCP, the drop-in swap is Cloud SQL (Postgres) and
the rest of the plan is unchanged — see §11.

---

## 3. Authentication

- Standard Google OAuth 2.0 "Sign in with Google" (authorization code flow).
- On callback, check the verified email against a hardcoded/env allowlist:
  `ALLOWED_EMAILS=you@gmail.com,gf@gmail.com`. Anyone else → 403.
- Create a session: signed, httpOnly, `Secure`, `SameSite=Lax` cookie holding a
  session id; session row in Postgres (or a signed JWT to skip a table — fine at
  this scale). Lax + same-origin means the cookie just works.
- No refresh tokens or offline access needed now — we only use Google to verify
  *who* you are, not to call Google APIs on your behalf.

Setup: create an OAuth consent screen (External, but in "testing" mode with the
two emails as test users — no Google verification review needed) + OAuth client
ID in the GCP project, redirect URI `https://language.levanto.dev/api/auth/callback`.

---

## 4. Data model

Designed now so AI modules are just additional rows.

```
users
  id              uuid pk
  email           text unique
  display_name    text
  created_at      timestamptz

decks                      -- "modules": a named group of cards
  id              uuid pk
  owner_id        uuid fk -> users          -- every deck (and its cards) belongs to one user — personal libraries
  name            text                      -- "Top 1000", "Sie vs sie", "News 2026-06-18"
  source          text                      -- 'manual' | 'seed' | 'ai_chat' | 'ai_module' | 'news'
  description     text null                 -- AI explanation lives here (e.g. the Sie/sie writeup)
  created_at      timestamptz

cards
  id              uuid pk
  deck_id         uuid fk -> decks
  prompt          text                      -- shown to user (English), e.g. "the dog"
  answer          text                      -- canonical German, e.g. "der Hund"
  answer_alts     text[]                    -- accepted alternatives, e.g. {"Hund"}
  part_of_speech  text null                 -- 'noun' | 'verb' | ... (drives answer-checking rules)
  article         text null                 -- der/die/das for nouns
  notes           text null                 -- example sentence, mnemonic (AI can fill this)
  source          text                      -- where this card came from (mirrors deck.source)
  created_at      timestamptz

review_state               -- one row per (user, card): the SRS scheduler state
  id              uuid pk
  user_id         uuid fk -> users
  card_id         uuid fk -> cards
  due            timestamptz                -- when it should next appear
  stability       double precision          -- FSRS fields
  difficulty      double precision
  reps            int
  lapses          int
  last_review     timestamptz null
  state           text                      -- 'new' | 'learning' | 'review' | 'relearning'
  unique(user_id, card_id)

reviews                    -- append-only log of every answer (analytics + FSRS optimization later)
  id              uuid pk
  user_id         uuid fk
  card_id         uuid fk
  rating          int                        -- 1 = fail, 3 = pass (binary mapped to FSRS grades)
  typed_answer    text                       -- what they actually typed
  reviewed_at     timestamptz
  elapsed_ms      int null
```

Notes:
- **Personal libraries.** Each user owns their own decks/cards; you and your
  girlfriend have completely separate vocabularies. `review_state` keeping the
  scheduling separate from card content is deliberate — it means that *if* we
  later want to share/copy a deck between the two of you, the card rows can be
  referenced or cloned without touching anyone's schedule. (For now `user_id` in
  `review_state` always equals the owning deck's `owner_id`.)
- The `reviews` log is cheap to keep and lets us later run FSRS's optimizer to
  tune parameters to *your* memory, and powers a future stats page.
- AI modules write `decks` + `cards` rows (owned by the requesting user) with
  `source='ai_*'`. The learning loop doesn't care who authored a card.

---

## 5. SRS engine

- Use **FSRS** (`ts-fsrs`) with **`enable_short_term: false`**. It models each
  card's memory with stability + difficulty and predicts the optimal next review
  for a target retention (~90%). We run it on a **daily grain** — no intra-day
  learning steps. (Why: the "drill until correct" behaviour you want lives in the
  session loop, not in FSRS — see §5a. Short-term steps would also leak
  minute-scale due times into a daily product and force a card to be answered
  twice to graduate.)
- **Binary grading.** Our UI is pass/fail only, so we map:
  - Correct → FSRS `Good` (3)
  - Incorrect → FSRS `Again` (1)
  - (We never expose Hard/Easy.)
- **One graded review per card per day.** The *first* attempt of the day on a
  card is the one that drives FSRS; same-day re-drills are training only (§5a).
  After a graded answer, persist `review_state`, append to `reviews`.
- New cards get an initial state on first review; daily new-card intake is capped
  per user (`daily_new_limit`, default 10) so the deck doesn't avalanche.
- The full session shape — completion gate, progress, mastery, streaks — is
  specified in **§5a**. That's the heart of the product; this section is just the
  engine it runs on.

---

## 5a. The daily loop, progress & mastery (the heart of the product)

Everything here sits **on top of** plain FSRS. The guiding split:

- **The schedule** — *when a card is next due*, in days. Owned by FSRS.
- **The daily session** — *what you do today and when you're done*. Owned by us.

Keeping these separate is what lets us run plain, day-grained FSRS while still
giving a satisfying "hammer it until I get it right" session.

### Today's set — finite and finishable

When you open the app, "today" is a known, bounded list:

- **Due reviews:** cards with `due <= end of today` in the user's timezone.
  (End-of-today, *not* `now` — so a card due later today is part of this sitting
  and the day can be finished in one go.)
- **New cards:** up to `daily_new_limit` (default 10, per user).

`required = dueReviews + newCards`. The Today screen shows a progress bar
(e.g. **23 / 31**) and one clear call to action. There is always a well-defined
"done for today" — this is the backbone of motivation and streaks.

### The completion gate — type every card correctly once

The rule that makes a day *finishable* and *worth a streak*:

- On a card's **first attempt today**:
  - **Correct** → FSRS `Good`; the card is satisfied for the day and scheduled out.
  - **Wrong** → FSRS `Again` (the card lapses; its real due moves to soon); the
    card is **not** satisfied and stays in the session.
- A card you got wrong is **re-shown until you type it correctly**. Those re-drill
  attempts are *training only* — logged to `reviews` but they do **not** re-grade
  the card (the first-attempt lapse already counted). Getting it right on the 4th
  try doesn't launder an `Again` into a `Good`.
- **The day is complete when every card in the required set has ≥1 correct typing
  today** — including hammering your last card until it's right.

Refresh-safe: "still pending today" is server-derivable — a required card is
pending until it has a correct review dated today. Note a lapsed-but-not-yet-
correct card stays in today's set even though FSRS has moved its due to tomorrow.

### Bonus work — for the motivated day

Extra work is **pure bonus on a fixed daily goal**: the required set (due + 10
new) never changes, and bonus never blocks "done for today" or (later) threatens a
streak. Bonus is surfaced separately (`+N bonus today`). Two on-ramps:

- **Learn more words** — pull another batch (~10) of fresh cards past
  `daily_new_limit`. Real first reviews (graded via FSRS), re-drilled until correct
  (you're learning them).
- **Practice words you know** — drill studied, **not-yet-due** cards,
  **weakest-first** (lowest stability). Feeds FSRS as early reviews (the gain is
  damped by how early you reviewed, so it reinforces without gaming). One-and-done
  (a miss just reschedules sooner — no completion gate). Pool excludes new cards
  (use "learn more"), cards due today (those are required), and cards already
  reviewed today.

Both grade via FSRS and grow mastery. The **first-attempt-of-day rule already caps
grading to one graded review per card per day**, so repeat practice can't inflate
stability. Entry points: the "Done for today" screen, plus a small **Practice**
link on the dashboard (drill even with nothing due).

The one mechanism this needs: a **`reviews.bonus` flag** (the client sets it on the
extra-work flows). `planToday` computes today's *required* membership from
**non-bonus** reviews only — that's what stops a *missed* bonus card from leaking
into the required set and un-completing the day. Mastery/progress count every
graded review regardless.

### Progress & mastery (the motivation layer)

Driven entirely off FSRS `stability` (days until recall would fall to ~90%) and
the `reviews` log — **no new tables needed**.

- **Tiers**, by stability, shown as a stacked bar of your whole collection
  climbing:

  | Tier      | Definition             |
  |-----------|------------------------|
  | New       | no review state yet    |
  | Learning  | stability < 7d         |
  | Familiar  | 7d ≤ stability < 21d   |
  | Mastered  | stability ≥ 21d        |

- **Headline number = current Mastered count.** Honest and live: it can dip when
  you lapse a mastered word (which visibly drops a tier in the bar). This is
  deliberate — the number reflects what you actually know *now*, and re-earning it
  is part of the loop. A goal framing like "1000 words" is UI on top of this count.

### What this needs (all small, additive)

- **Code:** `fsrs({ enable_short_term: false })` *(done)*; first-attempt-of-day
  grades, re-drills are practice; due query uses end-of-today.
- **Constants for now** (not per-user columns — there's no settings UI yet):
  `NEW_PER_DAY = 10` and a single day-boundary timezone (`'Europe/Berlin'`). These
  become `users.daily_new_limit` / `users.timezone` columns *if/when* we add a
  settings screen — not before.
- **Schema (one change):** `reviews.graded` (boolean, default `true`). Re-drill
  attempts are logged with `graded=false` so they don't pollute the `reviews` log
  that the future FSRS optimizer reads (§4); the first graded attempt of the day
  is `graded=true`. Mastery is **derived** from `review_state.stability`.
- **API:**
  - `GET /api/session/today` → required set (still never leaks answer/article) +
    `{ dueCount, newCount, pending, complete }`.
  - `POST /api/reviews` → grades only the first attempt of the day; tells the
    client whether the card still needs re-drilling.
  - `GET /api/progress` → `{ tiers, mastered, reviewsToday }`.
  - `GET /api/session/extra?type=new|practice` → bonus cards (answer/article
    omitted, as everywhere); `POST /api/reviews` gains an optional `bonus` flag.

### First-cut scope

**Shipped:** finishable "today's set" (due + up to 10 new), the
type-it-correctly-once completion gate with training-only re-drills, stability
tiers + a live Mastered count. **Designed, not yet built:** bonus work (above) —
needs the `reviews.bonus` flag + `/session/extra` + the two UI on-ramps. Full
self-contained spec in **EXTRA_WORK.md** (deferred ~late June 2026).
**Deferred:** streaks; per-user `daily_new_limit`/`timezone` settings; any settings
UI.

---

## 6. Answer checking (the part that needs care for German)

Typing German has gotchas. The matcher:

1. **Normalize** both expected and typed: trim, collapse internal whitespace,
   case-fold.
2. **Umlaut/ß tolerance (configurable):** treat `ä≈ae`, `ö≈oe`, `ü≈ue`, `ß≈ss`
   so a keyboard without umlauts still works. (Toggle per user; strict mode
   requires exact umlauts.)
3. **Multiple acceptable answers** via `answer_alts` (synonyms, with/without
   article).
4. **Articles for nouns.** Decide policy and make it explicit:
   - Default: require the correct article for nouns (gender matters in German),
     i.e. "der Hund" not "Hund". But accept the bare noun as a *partial* — show
     "almost — don't forget the article" but still count per your all-or-nothing
     rule (recommend: counts as fail, but message teaches). Configurable.
5. On mismatch, show the correct answer clearly and a diff highlight.

This logic is a single pure function (`checkAnswer(expected, typed, opts)`),
unit-tested — it's the highest-bug-risk piece, so it's the one thing we test hard.

---

## 7. API surface (v1)

```
GET  /api/auth/login            -> redirect to Google
GET  /api/auth/callback         -> verify, allowlist check, set session, redirect /
POST /api/auth/logout

GET  /api/me                    -> current user

GET  /api/session/next          -> next batch of due+new cards for review
POST /api/reviews               -> { cardId, typedAnswer } => { correct, expected, newDue }

GET  /api/decks                 -> list decks with due/new counts
POST /api/decks                 -> create deck (manual)
POST /api/decks/:id/cards       -> add card(s) manually
GET  /api/decks/:id             -> deck detail + cards

# Reserved for later (designed-in, not built yet):
POST /api/ai/chat               -> German chat; returns reply + extracted weak words
POST /api/ai/module             -> "explain Sie vs sie" -> deck + cards + explanation
POST /api/ai/news               -> news clip + comprehension quiz
```

---

## 8. Frontend (friendly + minimal)

- **Preact** single-page app, mobile-first (you'll drill on your phone).
  Components + hooks (`@preact/signals` optional for state), JSX via Vite's
  preact preset. Same mental model carries into the AI module UIs later.
- Screens:
  - **Login** — one big "Sign in with Google" button.
  - **Home / Today** — "X cards due", big **Start review** button, deck list with
    progress.
  - **Review** — the core loop: English prompt, one always-focused text input,
    Enter to submit. **Correct** flashes the border green and auto-advances (no
    success screen, no extra tap). **Wrong** flashes red, reveals the answer, and
    you must *type it to continue* — the only way forward, so there's no Continue
    button. The input never blurs, so the mobile keyboard stays open the whole
    session (iOS won't reopen it programmatically). Wrong cards still rotate to
    the back to re-drill (§5a). Umlaut helper buttons (ä ö ü ß) for mobile (todo).
  - **Decks** — browse/add cards manually; (later) "Ask AI to make a module".
  - **Stats** (nice-to-have) — streak, reviews/day, retention.
- State/data fetching: a tiny `fetch` wrapper + hooks is enough at this size.
  (TanStack Query works with Preact via `preact/compat` if we want caching/retry
  niceties — add it only if the hand-rolled version starts to hurt.)

---

## 9. Seeding initial vocabulary

Don't start from an empty app. Ship a seed deck:
- A curated German A1/A2 frequency list (top ~500–1000 words) as a checked-in
  JSON/CSV, loaded by a `db:seed` script that creates a `source='seed'` deck
  **per user** (each library starts with its own copy of the starter words).
- This gives you something to do on day one and exercises the whole loop.

---

## 10. Infra & deployment

- **Container:** one Dockerfile. Multi-stage: build the Vite SPA → copy into the
  Node server's static dir → run Hono. Single image.
- **Deploy:** `gcloud run deploy` from a GitHub Action on push to `main`.
  Cloud Run configured `min-instances=0` (scale to zero), `max-instances=1–2`.
- **Domain:** Cloud Run **domain mapping** for `language.levanto.dev`; add the
  CNAME/records at your DNS for levanto.dev. (Or a serverless NEG + HTTPS LB if
  you outgrow domain mapping — not needed now.)
- **Secrets:** Google OAuth client id/secret, DB URL, session signing key in
  **Secret Manager**, injected as env vars into Cloud Run.
- **DB:** Neon project, Postgres database on the `production` branch, connection
  string in Secret Manager. Drizzle migrations run as the `migrate` job in the
  deploy action (check → migrate → deploy) on push to `main`.
- **Local dev:** `vite dev` for the SPA proxying `/api` to a local
  `node server`, pointed at a Neon `dev` branch (migrated locally with
  `npm run db:migrate`).

Estimated cost: effectively **$0/mo** at this usage — Cloud Run free tier covers
two users easily, Neon free tier covers the DB. Only real cost later is AI API
calls (pay per use).

---

## 11. How the AI modules slot in later (designed-in now)

The data model already supports all four. Each is a new `/api/ai/*` route plus a
frontend surface; none require schema changes beyond minor additions.

- **Chat in German.** Call an LLM with a "correct me + tutor" system prompt.
  After each exchange, a second extraction step pulls words/phrases you stumbled
  on and writes them as `cards` into an `source='ai_chat'` deck. They enter your
  normal SRS queue automatically.
- **Voice chat.** Same as chat with speech-to-text in / text-to-speech out
  layered on. Same card-extraction backend. Pick STT/TTS later (browser
  SpeechRecognition is free; cloud STT is better).
- **AI-authored modules.** "Explain Sie vs sie" → LLM returns an explanation
  (stored in `decks.description`) + a set of cards/exercises (`source='ai_module'`).
- **News.** Fetch/transcribe a German news clip → comprehension quiz → words you
  mark as "didn't understand" become cards (`source='news'`).

Because everything funnels into the same `decks`/`cards`/`review_state` tables,
the core review loop never changes — it just sees more cards.

> For LLM calls, default to the latest Claude models (e.g. Claude Opus / Sonnet
> 4.x) via the Anthropic API. Confirm exact model ids when we build that phase.

**All-GCP variant:** if you decide against Neon, swap the DB for Cloud SQL
(Postgres) with the Cloud Run ↔ Cloud SQL connector. Everything else — Drizzle,
schema, code — is identical. Tradeoff: Cloud SQL is always-on (~$10–25/mo) vs
Neon's free scale-to-zero.

---

## 12. Build phases / milestones

**Phase 0 — Skeleton (½ day)**
- Repo layout (monorepo: `/web` SPA, `/server`, shared `/packages/types`).
- Hono server serving a "hello" SPA. Dockerfile. Deploy to Cloud Run. Domain
  mapping working at language.levanto.dev. Neon DB connected, Drizzle set up.

**Phase 1 — Auth (½ day)**
- Google OAuth, allowlist, session cookie, `/api/me`, login screen. Lock the
  whole app behind login.

**Phase 2 — Core SRS (1–2 days)** ← the real product
- Schema + migrations. Seed deck loaded.
- `checkAnswer` function + unit tests.
- FSRS integration, `/api/session/next` + `/api/reviews`.
- Review UI: prompt → type → grade → next. Today/Home screen with due counts.

**Phase 3 — Deck management (½ day)**
- List decks, add cards manually, deck detail.

**Phase 4 — Polish**
- Umlaut helper, stats page, streaks, mobile niceties, PWA install.

**Phase 5+ — AI modules** (separate efforts, in priority order you choose):
chat → AI modules → news → voice.

---

## 13. Decisions (resolved)

1. **DB → Neon.** Serverless Postgres, free tier, scales to zero. (Cloud SQL
   remains the drop-in all-GCP swap if we ever want it.)
2. **Article policy → required.** Nouns must be typed with the correct article
   ("der Hund", not "Hund") — learning genders is a goal. Bare-noun answers count
   as a miss but show a teaching nudge.
3. **Umlaut strictness → tolerant by default.** Accept `ä≈ae / ö≈oe / ü≈ue /
   ß≈ss`, with a per-user toggle to demand exact umlauts later.
4. **Libraries → personal.** Each user has their own decks/cards and schedule;
   no sharing for now. Schema keeps card content separate from `review_state` so
   deck sharing/cloning between the two of you is a clean addition later.
5. **Frontend → Preact** (see §2/§8).
6. **FSRS grain → daily, `enable_short_term: false`.** Plain day-grained FSRS;
   one graded review per card per day. "Drill until correct" is a session
   completion gate (§5a), not FSRS learning steps. *(Also fixes a bug where cards
   never graduated out of `learning` because `learning_steps` wasn't persisted.)*
7. **Mastery → tiered by stability.** New / Learning (<7d) / Familiar (7–21d) /
   Mastered (≥21d). Headline = current Mastered count.
8. **Headline number → honest & live.** It drops when you lapse a mastered word,
   rather than being a lifetime high-water mark — reflects what you know *now*.
9. **Bonus practice → feeds FSRS.** Early reviews of known cards reschedule via
   FSRS (which dampens early-review gains), rather than being practice-only.
10. **Extra work → pure bonus on a fixed goal.** "Learn more" and "practice" grow
    mastery but never change the day's goal/completion. A `reviews.bonus` flag
    keeps bonus reviews out of `planToday`'s required set (so a missed bonus card
    can't un-complete the day).
11. **Practice ordering → weakest-first.** Practice serves studied, not-yet-due
    cards by lowest stability first; one-and-done (no re-drill gate).
12. **Verbs → global catalog, present tense, all-or-nothing.** One shared,
    frequency-ordered `verbs` table (not per-user decks); per-user progress only.
    Cards drill the six present-tense forms at once and pass only if all six match.
    New verbs introduced 5/day at a fixed 3-irregular : 2-regular mix (irregular =
    present-tense deviation). Reuses the §5a daily loop wholesale. See VERBS.md.
```

# Extra work (bonus) — feature spec

> **Status:** Designed, **not built**. Deliberately deferred on 2026-06-21 to live
> with the core daily loop for a few days first (real usage is the best signal for
> whether bonus is even needed yet, and how it should feel). Revisit ~late June 2026.
>
> This is the full context for the feature so it can be picked up cold. The core
> daily loop it builds on is **live** (PLAN.md §5a). Summary also in PLAN.md §5a
> ("Bonus work") + decisions §13.10–11; this file is the detailed version.

## Why this exists

One of the original product goals (PLAN.md §5a backstory): *"I want to be able to
do extra work for a given day if I have extra motivation — adding more new cards or
repeating things I already know pretty well."*

That's **two different things** with different natures:

1. **Learn more words** — pull *new* (unstudied) cards beyond the daily quota of
   10. Their first review is a genuine graded review; you're really learning them.
2. **Practice words you know** — drill cards that *aren't due yet*. Reinforcement.

## The core decision: fixed goal, everything extra is pure bonus

The daily goal stays **locked** at `due reviews + 10 new`. Completion ("Done for
today") and any future streak depend **only** on that fixed set. Extra work grades
via FSRS and grows mastery, but it **never**:
- changes the day's goal / the `done / total` denominator, or
- blocks "Done for today", or
- (later) threatens a streak.

Bonus is surfaced separately as `+N bonus today`.

**Why this model (vs. letting extra work expand the goal):** it protects the thing
that matters most about the loop — a finishable, predictable day you can always
close out. A motivated day must never accidentally make the day *un*-finishable.
"Done for today 🎉" is sacred; bonus is gravy on top. (The rejected alternative was
"learning more expands the required set" — it adds streak risk and makes "required"
and "streak requirement" diverge.)

## The two on-ramps in detail

### Learn more words
- Pull another batch (~10) of fresh (unstudied) cards beyond `NEW_PER_DAY`.
- Real **first reviews** → graded via FSRS (first-attempt-of-day, see below).
- **Re-drill until correct** (same as the main loop — you're learning them).
- Tagged `bonus` so they don't expand today's required set / denominator.

### Practice words you know
- Drill **studied, not-yet-due** cards, **weakest-first** (lowest FSRS stability).
- Feeds FSRS as **early reviews** (decision §13.9). FSRS damps the stability gain
  by *how early* you reviewed, so it reinforces honestly and can't game the
  schedule.
- **One-and-done** (no completion gate): a miss just reschedules the card sooner
  (FSRS `Again`); you're not forced to re-drill it. You stop whenever you like.
- **Practice pool** = cards that are:
  - studied (have a `review_state` row), AND
  - **not** due today (`due >= end of today`), AND
  - **not** already reviewed today (don't re-serve today's work),
  - ordered by `stability` ascending (weakest first).
  - Excludes new/unstudied cards — those are reached via "Learn more".

## The one mechanism it needs: a `reviews.bonus` flag

Add `bonus boolean NOT NULL DEFAULT false` to the `reviews` table (additive, same
shape as the existing `graded` column — safe to apply while old code runs). The
client sets `bonus: true` on the review requests it sends from the extra-work
flows.

**Why it's required — the "leak" problem this solves:** bonus practice grades via
FSRS, so a *missed* bonus card produces a review row today. Without a marker,
`planToday` would see that card as "reviewed today" and pull it into the **required
set** as *pending* — silently un-completing your finished day and demanding a
re-drill of a bonus card. The flag lets `planToday` compute today's *required*
membership from **non-bonus reviews only**, which closes the leak.

Mastery/progress counts **every** graded review regardless of `bonus` (a bonus
correct legitimately raised that card's stability).

### Interaction with the first-attempt-of-day rule (already live)
The existing rule — *only the first attempt of the day on a card is graded; later
same-day attempts are training-only re-drills* — already caps grading at **one
graded review per card per day**. Consequences for free:
- Repeat-practicing a card can't inflate its stability.
- Practicing a card you already did as a required review today does **nothing** to
  the schedule (the required review was first-of-day; the practice attempt is a
  re-drill → not graded). This is *fine* — that card is excluded from the practice
  pool anyway ("not already reviewed today").

## Build plan (same shape as the core loop build)

1. **Schema/types**
   - Migration: `reviews.bonus boolean NOT NULL DEFAULT false`
     (`schema.ts` → `db:generate` → `db:migrate` **before** deploying code).
   - `shared/types.ts`: add `bonus?: boolean` to `ReviewRequest`.
     (`ExtraType = "new" | "practice"` and `ExtraResponse = { cards: SessionCard[] }`
     **already exist** — added speculatively during the core build.)
2. **Logic (pure / tested)**
   - Point `/session/today`'s "reviewed today / correct today / reviewed before
     today" signals at **non-bonus** reviews (the leak fix). This is in the
     `/session/today` route's gather step; `planToday` itself in
     `server/srs/day.ts` already takes the booleans — just feed it non-bonus data.
   - A `practicePool` query/helper: studied + not-due + not-reviewed-today,
     ordered by stability asc. Mostly a Drizzle query; keep any rules-y bits pure
     and unit-test them next to `day.ts`/`tiers.ts`.
3. **Routes** (`server/review-routes.ts`)
   - `GET /session/extra?type=new|practice` → returns `ExtraResponse` (answer &
     article omitted, like `/session/today`). `new` = next fresh cards beyond the
     quota; `practice` = the practice pool.
   - `POST /reviews`: accept optional `bonus` flag, record it on the `reviews`
     row. Grading still goes through the first-attempt-of-day path unchanged.
4. **UI** (`web/`)
   - `review.tsx`: a bonus mode — passes `bonus: true`; for **practice** use
     one-and-done (no re-drill rotate); for **learn-more** keep re-drill-until-
     correct. Show a `+N bonus` counter distinct from the `done / total` goal bar.
   - "Done for today" screen: **Learn more** + **Practice** buttons.
   - Dashboard (`app.tsx`): a small **Practice** link so you can drill even when
     nothing is due. (The `MasteryCard` already shows tiers + Mastered count.)

## Smaller defaults (decided, change if they feel wrong in use)
- **Re-drill:** learn-more → hammer-until-correct; practice → one-and-done.
- **Batch size:** "Learn more" pulls ~10; repeatable.
- **Entry points:** "Done for today" screen + a dashboard "Practice" link.

## Open questions / possible refinements (not blocking)
- **Deck-scoped practice** ("practice my verbs deck") — nice later; first cut is
  global, weakest-first across all studied cards.
- Whether to show a separate **bonus stat** anywhere persistent (vs. just the
  in-session `+N`). Tie-in with the deferred stats/streaks work.
- If a user *always* wants >10 new/day, the right fix is raising their
  `daily_new_limit` (a deferred per-user setting), not daily bonus — keep an eye on
  whether "Learn more" is being used as a daily crutch.

## Relevant code (as of 2026-06-21)
- `server/srs/day.ts` — `planToday` (required-set + progress), day-boundary helpers.
- `server/review-routes.ts` — `/session/today`, `/reviews`, `/progress`; the
  `/session/today` gather step is where the non-bonus filtering goes.
- `server/srs/tiers.ts` — stability → mastery tiers.
- `shared/types.ts` — `ExtraType`, `ExtraResponse` already present; `ReviewRequest`.
- `web/src/review.tsx` — the review loop (queue/re-drill); add bonus mode here.
- `web/src/app.tsx` — dashboard + `MasteryCard`.
- `server/db/schema.ts` — add `reviews.bonus` here.

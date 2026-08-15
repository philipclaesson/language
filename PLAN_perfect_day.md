# Perfect days — feature spec

> **Status: BUILT (2026-08-15).** A motivation layer on top of the existing Stats
> tab. Three pieces, all shipped: (1) recalibrated the activity heatmap so a good day
> and a grind day look different; (2) the **perfect day** concept — a day where you
> finished *all* your words, *all* your verbs, and chatted with Freund at least once —
> surfaced as a per-cell emerald ring on the grid and a 30-day percentage; and (3) a
> daily **Freund push nudge** that rides on the same new table (see **the notification
> hook** below).

## Why this exists

Two problems, one doc:

1. **The heatmap is saturated.** `cellClass` in `web/src/stats.tsx` uses *absolute*
   count buckets (`≤5 / ≤12 / ≤24 / >24`) tuned to an assumption that no longer
   holds: a normal day (due + up to 10 new + bonus) already clears 24, so nearly
   every active day pins to `blue-800`. You can't tell a good day from a day you
   really ground. The less/more nuance is lost.
2. **The streak rewards only showing up.** Today the streak = *any* activity (>0
   graded reviews that day; `srs/stats.ts` `computeStreaks`). There's no signal for
   "I actually finished everything." We want a gentle carrot for a complete day —
   **without** making the streak itself strict enough to punish (an all-words,
   all-verbs, Freund-every-day streak dies the day you forget one, which is
   demotivating for a two-person app).

The resolution: **keep the lenient streak exactly as-is**, and layer a separate,
non-punishing "perfect day" concept on top of it.

## The core decisions

### 1. The streak stays lenient; "perfect" is a separate, additive signal

The streak (`computeStreaks`, "any activity") does **not** change. Perfect days are
a parallel signal you can never *lose* your streak over — you either hit them or you
don't, shown as a running percentage. Carrot, not stick.

### 2. A perfect day = all words done AND all verbs done AND ≥1 Freund message

Measured against *that day's* required set:

- **words done** — `planToday(...).complete` was true (today's required word set
  fully typed correctly).
- **verbs done** — `planVerbDay(...).complete` was true.
- **Freund** — at least one message sent to Freund that day.

### 3. Completion must be *persisted*, because it is not retroactively derivable

This is the crux and the only reason a new table exists. "Was the day complete" is a
**point-in-time** fact: the required set for a day depends on FSRS due dates, which
move forward as you review. You cannot reconstruct "was day X finished" from the
append-only `reviews` / `verb_reviews` logs after the fact — the due dates that
defined that day's goal are gone. So completion must be recorded *on the day it
happens*.

Contrast this with the heatmap counts and the lenient streak, which **are** derivable
from the logs and therefore stay derived (mirroring how `pendingTodayFor` reuses the
session helpers so "due today" can never drift). **We persist completion; we do not
persist counts.** Freund is the exception in the other direction: it's currently
fully stateless (`freund-routes.ts` stores nothing), so a perfect day needs *some*
server-side Freund marker — a bare per-day counter, not conversation content.

### 4. Volume and "perfect" are orthogonal → orthogonal visual channels

Volume is continuous; perfect is binary. Folding perfect into the color ramp (green
days, or a green intensity scale) overloads *color* with two meanings and is hard to
read at ~44px. So:

- **color = volume** (recalibrated blue ramp),
- **an emerald ring around the cell = perfect.**

A cell can then say both "I did a lot" and "I hit all three" at once. (Decided over
a corner ✓ and a center dot: the ring reads on any fill, light or dark, with no
contrast halo needed, and stays calm on a busy grid.)

### 5. The color ramp becomes relative, not absolute

Fix saturation by making intensity relative to *your own* history rather than
re-picking magic numbers that will drift out of tune again. The `/stats` route
already scans every day's count; compute quantile thresholds over your **non-zero**
daily counts and emit a `level: 0–4` per cell. `cellClass` becomes a dumb
`level → class` lookup; the legend stays "less → more."

Tradeoff, accepted: relative scaling **moves the goalposts** — a day that looked dark
last month can read mid-tier once you start grinding harder. For a personal
motivation tool that's the desired behavior (it keeps rewarding *relative* effort),
and it's what GitHub's contribution graph does.

## Data model — one thin table

```
daily_progress
  id            uuid pk
  user_id       uuid  → users.id (cascade)
  day           date            -- local calendar date in DAY_TZ
  words_done    boolean not null default false
  verbs_done    boolean not null default false
  freund_count  integer not null default 0
  unique(user_id, day)
```

- **Upserted from three existing routes** (all idempotent on `(user_id, day)`):
  - `/reviews` — set `words_done = true` when `planToday(...).complete` flips true.
  - `/verbs/reviews` — set `verbs_done = true` when `planVerbDay(...).complete` flips.
  - `/freund/message` — `freund_count = freund_count + 1`.
- `day` is the **local** date in `DAY_TZ` (`localDateString(now, DAY_TZ)`), matching
  how the heatmap buckets — so a perfect flag lines up with its grid cell.
- **Perfect day** = `words_done && verbs_done && freund_count > 0`. Derived at read
  time, never stored as its own column (so the definition lives in one place and can
  change without a backfill).

Nothing else stores counts — the logs remain the source of truth for the heatmap,
the lenient streak, mastery, and analytics.

## Types (`shared/types.ts` — change here first)

- `HeatmapCell` gains:
  - `level: number` — `0–4`, the relative intensity bucket (replaces the client's
    absolute count bucketing; `count` stays for the tooltip).
  - `perfect: boolean` — whether that day met all three conditions.
- `StatsResponse` gains:
  - `perfectDays30: number` — percentage (0–100) of the last 30 local days that were
    perfect. Computed server-side so the client stays dumb.

## Server (`server/stats-routes.ts`, `server/srs/stats.ts`)

- `/stats` already scans daily counts. Additionally:
  - compute quantile thresholds over the non-zero counts and attach `level` per cell
    (put the pure bucketing in `srs/stats.ts` next to `buildHeatmap`, unit-tested);
  - read `daily_progress` for the window, mark each cell `perfect`;
  - compute `perfectDays30` over the last 30 local days.
- The lenient streak path (`computeStreaks`) is untouched.
- New pure helper(s) in `srs/stats.ts` get a `*.test.ts` (quantile bucketing has edge
  cases: all-equal counts, a single active day, fewer than 4 distinct values).

## Client (`web/src/stats.tsx`)

- `cellClass` → a `level → blue-{200,400,600,800}` lookup (drop the absolute buckets).
- When `cell.perfect`, add an inset emerald ring (`ring-2 ring-emerald-500` + inset)
  over the volume fill.
- Add a **Perfect days** stat ("73% · last 30 days"), emerald accent so it visually
  rhymes with the grid rings. Either a three-up with the two streak cards or its own
  full-width card beneath them.
- Extend the legend / cell tooltip to mention perfect days.

## The notification hook — BUILT (2026-08-15)

The `daily_progress.freund_count` powers a daily **Freund nudge**: a second cron
(`.github/workflows/freund-nudge.yml`, `cron "0 14 * * *"` ≈ 16:00 CEST — earlier than
the 16:00-UTC review reminder so they don't stack) POSTs `/push/send-freund-nudge`,
which pushes a role-play invitation only to users with `freund_count = 0` today. Each
user gets a random scenario; the payload's URL deep-links straight into it
(`/freund?scenario=…`), and the Freund page auto-starts that exact scenario on mount
(`/freund/start` now accepts an optional scenario, validated against `SCENARIOS`). The
nudge carries its own notification `tag` so it doesn't collapse with the review
reminder (`web/public/sw.js` now reads `data.tag`). Reuses the existing push
subscriptions + `CRON_SECRET` — no new secret, no new table. Pure copy in
`push/message.ts` `freundNudge` (tested). See INFRA.md > Web Push.

## Build plan (two commits, independently shippable)

1. **Relative color scaling.** Pure win, no schema. `level` on `HeatmapCell`, quantile
   bucketing in `srs/stats.ts` (+ test), `cellClass` lookup, legend copy. Ship alone.
2. **Perfect days.** `daily_progress` table (migration) + three route upserts +
   `perfect`/`perfectDays30` in types & `/stats` + emerald rings + the stat card.

## Open questions / possible refinements (not blocking)

- **Window sizes.** Heatmap is currently 6 weeks (42 days); the perfect % is over 30
  days. Fine to leave mismatched, or unify.
- **Backfill.** `daily_progress` starts empty, so early perfect % and grid rings only
  reflect days from launch forward. Acceptable (completion genuinely can't be
  reconstructed — that's the whole point of §3). No backfill migration.
- **Freund threshold.** `≥1 message` is the bar. Could later require a *substantive*
  exchange (≥N turns) if one-liners feel like gaming it.
- **Longest perfect streak.** Not in scope, but the table supports adding a "longest
  run of perfect days" stat cheaply later.

## Relevant code (as of 2026-08-15)

- `web/src/stats.tsx` — `cellClass`, `Heatmap`, `StatCard` (the surfaces that change).
- `server/stats-routes.ts` — `/stats`, `dailyCounts` (add `level` + perfect join).
- `server/srs/stats.ts` — `computeStreaks` (unchanged), `buildHeatmap` (+ new quantile
  helper); `*.test.ts` alongside.
- `server/db/schema.ts` — new `daily_progress` table.
- `server/review-routes.ts` / `server/verb-routes.ts` / `server/freund-routes.ts` —
  the three upsert points.
- `shared/types.ts` — `HeatmapCell`, `StatsResponse`.
- `push/reminders.ts`, `web/public/sw.js` — the deferred notification hook.

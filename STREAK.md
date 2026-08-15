# Streak & perfect days — feature spec

> **Status: BUILT (2026-08-15).** A motivation layer on the Stats tab. The lenient
> daily streak is unchanged; on top of it sits the **perfect day** — a day you
> finished all words, all verbs, and chatted with Freund — shown as an emerald ring
> on the heatmap and a rolling 30-day percentage. Plus a daily **Freund push nudge**
> into a role-play when you haven't chatted yet. Also recalibrated the heatmap's
> intensity to be relative to your own volume, so a good day and a grind day differ.

## The streak stays lenient; perfect days are a separate signal

The streak (`computeStreaks` in `srs/stats.ts`) counts consecutive days with *any*
activity — unchanged. Perfect days are a parallel, non-punishing signal: you can't
lose your streak by missing one. Carrot, not stick — a strict all-three-every-day
streak would die the day you forget one, which is demotivating for a two-person app.

## A perfect day = all words + all verbs + ≥1 Freund message

Measured against *that day's* required set:

- **words done** — `planToday(...).complete` was true;
- **verbs done** — `planVerbDay(...).complete` was true;
- **Freund** — at least one message sent that day.

`perfect = wordsDone && verbsDone && freundCount > 0`, derived at read time in
`stats-routes.ts` so the definition lives in one place (no stored `perfect` column).

## Why completion is persisted (the one table)

Completion is a **point-in-time** fact: today's required set depends on FSRS due
dates that move forward, so "was day X finished" can't be reconstructed from the
`reviews` log afterward. So it's recorded on the day, in **`daily_progress`** (one row
per user/local-day: `words_done`, `verbs_done`, `freund_count`, unique on
`(user_id, day)`; `day` is the local date in `DAY_TZ`, matching the heatmap buckets).

Counts, the heatmap, and the lenient streak stay **derived** from the append-only
logs — **only completion is stored** (mirroring how `pendingTodayFor` reuses the
session helpers so "due today" can't drift). Freund, otherwise stateless, gains just a
per-day counter — no conversation content.

Upserts happen where completion is *already* computed, so there are no extra queries
on the hot path:

- `words_done` in `/session/today` — the client re-fetches it on reaching "done";
- `verbs_done` in `/verbs/session/today`;
- `freund_count++` in `/freund/message`.

All idempotent; a day never un-completes. Helpers live in `server/db/daily-progress.ts`.

## Heatmap: relative intensity + emerald rings

- **Intensity is relative to your own history.** Quartile thresholds over your
  non-zero daily counts → a `level` 0–4 per cell (`computeLevelThresholds`/`levelFor`,
  pure + tested). Fixed absolute buckets had saturated once a normal day routinely
  cleared them (everything pinned to the darkest blue); this self-recalibrates as your
  volume grows, like GitHub's contribution graph. Tradeoff: the goalposts move — a day
  that looked dark last month can read mid-tier once you grind harder. Intended.
- **Volume and perfect are orthogonal → orthogonal channels.** Colour = volume; an
  **emerald ring** = a perfect day, so a cell shows both at once (folding perfect into
  the colour ramp would overload one channel and read poorly at ~44px). The
  `PerfectCard` on Stats shows the **30-day perfect %** (`perfectPct`, a *fixed*
  30-day denominator so skipped days count against you).

## The daily Freund nudge

`daily_progress.freund_count` also powers a second daily push (see INFRA.md > Web
Push): a cron (`.github/workflows/freund-nudge.yml`, `0 14 * * *` ≈ 16:00 CEST, ahead
of the 16:00-UTC review reminder so they don't stack) POSTs `/push/send-freund-nudge`,
which invites only users with `freund_count = 0` today into a random role-play. The
payload deep-links into that exact scenario (`/freund?scenario=…`); `/freund/start`
honours a requested scenario (validated against `SCENARIOS` to block prompt-injection
via the URL) and the Freund page auto-starts it on mount. Its own notification `tag`
so it doesn't collapse with the review reminder. Reuses the existing subscriptions +
`CRON_SECRET` — no new secret, no new table.

## Caveats / possible refinements

- **No backfill.** `daily_progress` starts empty, so perfect % and rings only accrue
  from 2026-08-15 forward (completion genuinely can't be reconstructed).
- **The Freund bar is ≥1 message** — easy to game with a one-liner; could later
  require a substantive exchange (≥N turns).
- **One subscription for both pushes.** The nudge and the review reminder share the
  single "Daily reminder" toggle; an independent on/off would be a small follow-up.
- **Longest perfect-day run** isn't surfaced, but the table supports it cheaply.

## Files

- `web/src/stats.tsx` — heatmap cells, emerald rings, `PerfectCard`, legend.
- `server/srs/stats.ts` — `computeLevelThresholds`/`levelFor`, `buildHeatmap`,
  `perfectPct` (+ `stats.test.ts`); `computeStreaks` unchanged.
- `server/stats-routes.ts` — `/stats` (level + perfect + 30-day %).
- `server/db/schema.ts` `daily_progress` · `server/db/daily-progress.ts` (upserts +
  `freundCountToday`).
- Upsert points: `server/review-routes.ts`, `server/verb-routes.ts`,
  `server/freund-routes.ts`.
- Nudge: `server/push/message.ts` `freundNudge`, `server/push-routes.ts`
  `/push/send-freund-nudge`, `.github/workflows/freund-nudge.yml`, `web/public/sw.js`.

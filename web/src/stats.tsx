import { useEffect, useRef, useState } from "preact/hooks";
import type { HeatmapCell, StatsResponse, TierHistoryPoint } from "../../shared/types";
import { getStats, getTierHistory, getPushConfig } from "./api";
import { currentPushState, disablePush, enablePush, needsInstall } from "./push";
import { navigate } from "./router";
import { TIERS } from "./tiers";

const WEEKDAYS = ["M", "T", "W", "T", "F", "S", "S"];

// Blue intensity by the server's relative level (0 = empty … 4 = a big day for you),
// calibrated to the user's own volume so a good day and a grind day differ. Empty
// days are faint grey; future days blank.
function cellClass(cell: HeatmapCell): string {
  if (cell.future) return "bg-transparent";
  return ["bg-slate-100", "bg-blue-200", "bg-blue-400", "bg-blue-600", "bg-blue-800"][
    cell.level
  ];
}

export function Stats() {
  const [stats, setStats] = useState<StatsResponse | null>(null);
  const [err, setErr] = useState(false);

  useEffect(() => {
    getStats().then(setStats).catch(() => setErr(true));
  }, []);

  return (
    <div class="mx-auto flex min-h-screen max-w-md flex-col px-5 pb-24 pt-10">
      <header>
        <h1 class="text-2xl font-semibold tracking-tight text-slate-900">Stats</h1>
      </header>

      {err ? (
        <p class="mt-8 text-slate-500">Couldn't load stats.</p>
      ) : stats === null ? (
        <p class="mt-8 text-slate-400">…</p>
      ) : (
        <main class="mt-8 space-y-6">
          <div class="grid grid-cols-2 gap-3">
            <StatCard value={stats.currentStreak} label="Current streak" accent />
            <StatCard value={stats.longestStreak} label="Longest streak" />
          </div>

          <p class="text-center text-slate-600">
            You've practiced <span class="font-semibold text-slate-900">{stats.practicedLastWeek}</span>{" "}
            {stats.practicedLastWeek === 1 ? "card" : "cards"} in the last week.
          </p>

          <PerfectCard pct={stats.perfectDays30} />

          <Heatmap cells={stats.heatmap} />

          <MasteryBar mastery={stats.mastery} />

          <MasteryHistory />
        </main>
      )}

      <ReminderToggle />
    </div>
  );
}

// Daily-reminder switch. Hidden entirely unless the server has push configured
// (VAPID keys present). On iPhone it shows install guidance instead of a dead
// switch, since Web Push there needs the home-screen PWA. See web/src/push.ts.
type ToggleState = "loading" | "hidden" | "install" | "denied" | "off" | "on";

function ReminderToggle() {
  const [state, setState] = useState<ToggleState>("loading");
  const [busy, setBusy] = useState(false);

  useEffect(() => {
    let cancelled = false;
    (async () => {
      try {
        const config = await getPushConfig();
        if (cancelled) return;
        if (!config.enabled) return setState("hidden");
        if (needsInstall()) return setState("install");
        const s = await currentPushState();
        if (cancelled) return;
        setState(s === "unsupported" ? "hidden" : s);
      } catch {
        if (!cancelled) setState("hidden");
      }
    })();
    return () => {
      cancelled = true;
    };
  }, []);

  if (state === "loading" || state === "hidden") return null;

  async function toggle() {
    setBusy(true);
    try {
      const next = state === "on" ? await disablePush() : await enablePush();
      setState(next === "unsupported" ? "install" : next);
    } finally {
      setBusy(false);
    }
  }

  const subtitle =
    state === "on"
      ? "On — a nudge every day when cards are due."
      : state === "off"
        ? "Get a nudge every day when cards are due."
        : state === "denied"
          ? "Blocked. Enable notifications for this site in your browser settings."
          : "On iPhone: tap Share → Add to Home Screen, then open the app here to enable.";

  return (
    <div class="mt-6 flex items-center justify-between gap-4 rounded-2xl border border-slate-200 px-5 py-4">
      <div>
        <p class="font-medium text-slate-900">Daily reminder</p>
        <p class="mt-0.5 text-sm text-slate-500">{subtitle}</p>
      </div>
      {(state === "on" || state === "off") && (
        <button
          onClick={toggle}
          disabled={busy}
          class={`shrink-0 rounded-xl px-4 py-2 text-sm font-medium transition disabled:opacity-50 ${
            state === "on"
              ? "border border-slate-300 text-slate-700 hover:bg-slate-50"
              : "bg-slate-900 text-white hover:bg-slate-700"
          }`}
        >
          {busy ? "…" : state === "on" ? "Turn off" : "Turn on"}
        </button>
      )}
    </div>
  );
}

function StatCard({ value, label, accent }: { value: number; label: string; accent?: boolean }) {
  return (
    <div class={`rounded-2xl p-5 ${accent ? "bg-blue-600 text-white" : "bg-slate-50 text-slate-900"}`}>
      <div class="flex items-baseline gap-1">
        <span class="text-3xl font-semibold tracking-tight">{value}</span>
        <span class="text-sm font-normal opacity-70">{value === 1 ? "day" : "days"}</span>
        {/* The 🔥 doubles as the door to the games corner (hehe). Always tappable
            on the streak card — just dimmed while the streak is cold. */}
        {accent && (
          <button
            onClick={() => navigate("/games")}
            aria-label="Games"
            title="Games"
            class={`ml-0.5 text-xl transition hover:scale-125 ${value === 0 ? "opacity-40 grayscale" : ""}`}
          >
            🔥
          </button>
        )}
      </div>
      <p class={`mt-1 text-xs ${accent ? "text-blue-100" : "text-slate-500"}`}>{label}</p>
    </div>
  );
}

function Heatmap({ cells }: { cells: HeatmapCell[] }) {
  return (
    <div class="rounded-2xl border border-slate-200 p-5">
      <div class="mb-2 grid grid-cols-7 gap-1.5 text-center text-[10px] text-slate-400">
        {WEEKDAYS.map((d, i) => (
          <span key={i}>{d}</span>
        ))}
      </div>
      {/* CSS grid fills row-by-row, so each 7-cell row is one Monday-first week. */}
      <div class="grid grid-cols-7 gap-1.5">
        {cells.map((cell) => (
          <div
            key={cell.date}
            class={`aspect-square rounded-[3px] ${cellClass(cell)} ${
              cell.perfect ? "ring-2 ring-inset ring-emerald-500" : ""
            }`}
            title={
              cell.future
                ? cell.date
                : `${cell.date}: ${cell.count} ${cell.count === 1 ? "card" : "cards"}${
                    cell.perfect ? " · perfect day" : ""
                  }`
            }
          />
        ))}
      </div>
      <div class="mt-3 flex items-center justify-end gap-1 text-[10px] text-slate-400">
        <span>less</span>
        <span class="h-2.5 w-2.5 rounded-[2px] bg-slate-100" />
        <span class="h-2.5 w-2.5 rounded-[2px] bg-blue-200" />
        <span class="h-2.5 w-2.5 rounded-[2px] bg-blue-400" />
        <span class="h-2.5 w-2.5 rounded-[2px] bg-blue-600" />
        <span class="h-2.5 w-2.5 rounded-[2px] bg-blue-800" />
        <span>more</span>
      </div>
      <div class="mt-1.5 flex items-center justify-end gap-1 text-[10px] text-slate-400">
        <span class="h-2.5 w-2.5 rounded-[2px] bg-blue-400 ring-2 ring-inset ring-emerald-500" />
        <span>perfect day</span>
      </div>
    </div>
  );
}

// The carrot: how consistent you've been over the last 30 days. A "perfect day" is
// all words done + all verbs done + a chat with Freund; the emerald echoes the grid
// rings so the number and the marks read as the same thing.
function PerfectCard({ pct }: { pct: number }) {
  return (
    <div class="rounded-2xl border border-emerald-200 bg-emerald-50 p-5">
      <div class="flex items-baseline gap-2">
        <span class="text-3xl font-semibold tracking-tight text-emerald-700">{pct}%</span>
        <span class="text-sm text-emerald-600">perfect days · last 30</span>
      </div>
      <p class="mt-1.5 text-xs text-slate-500">
        A perfect day: all words, all verbs, and a chat with Freund.
      </p>
    </div>
  );
}

// The mastery bar from the home cards, over the whole library (words + verbs).
function MasteryBar({ mastery }: { mastery: StatsResponse["mastery"] }) {
  const { tiers, mastered, total } = mastery;
  if (total === 0) return null;
  return (
    <div class="rounded-2xl border border-slate-200 p-5">
      <div class="flex items-baseline justify-between">
        <div>
          <span class="text-3xl font-semibold tracking-tight text-slate-900">{mastered}</span>
          <span class="ml-2 text-slate-500">mastered</span>
        </div>
        <span class="text-sm text-slate-400">{total} total</span>
      </div>

      <div class="mt-4 flex h-2.5 w-full overflow-hidden rounded-full bg-slate-100">
        {TIERS.map((t) =>
          tiers[t.key] > 0 ? (
            <div
              key={t.key}
              class={t.bar}
              style={{ width: `${(tiers[t.key] / total) * 100}%` }}
              title={`${t.label}: ${tiers[t.key]}`}
            />
          ) : null,
        )}
      </div>
      <div class="mt-3 flex flex-wrap gap-x-4 gap-y-1 text-xs text-slate-500">
        {TIERS.map((t) => (
          <span key={t.key} class="inline-flex items-center gap-1.5">
            <span class={`h-2 w-2 rounded-full ${t.dot}`} />
            {t.label} <span class="font-medium text-slate-700">{tiers[t.key]}</span>
          </span>
        ))}
      </div>
    </div>
  );
}

// Mastery over the last 30 days: a stacked area of the growing library. Stacked
// bottom→top learning → familiar → mastered, so mastered crowns the stack and the
// whole height is "cards you've actually learned" (the untouched-corpus "new" tier
// is excluded — see TierHistoryPoint). Colours are the validated, colourblind-safe
// steps of the same three tier hues used everywhere else (one shade darker than the
// bar's dots, for legible fills). Own fetch + loading state so the main Stats paint
// isn't blocked on the second log read.
const HISTORY_SERIES = [
  { key: "learning", label: "Learning", color: "#f59e0b" }, // amber-500 (base)
  { key: "familiar", label: "Familiar", color: "#0ea5e9" }, // sky-500 (middle)
  { key: "mastered", label: "Mastered", color: "#059669" }, // emerald-600 (top)
] as const;
// Painting order, bottom→top of the stack.
const STACK_ORDER = ["learning", "familiar", "mastered"] as const;

const MONTHS = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
function shortDate(iso: string): string {
  const [, m, d] = iso.split("-").map(Number);
  return `${d} ${MONTHS[m - 1]}`;
}

// viewBox units (the SVG scales to the card width). Left/bottom padding leaves room
// for the y-max tick and the date labels.
const VB = { w: 300, h: 150, padL: 22, padR: 6, padT: 10, padB: 18 };
const PLOT_W = VB.w - VB.padL - VB.padR;
const PLOT_H = VB.h - VB.padT - VB.padB;

function MasteryHistory() {
  const [history, setHistory] = useState<TierHistoryPoint[] | null>(null);
  const [failed, setFailed] = useState(false);
  const [hover, setHover] = useState<number | null>(null);
  const svgRef = useRef<SVGSVGElement>(null);

  useEffect(() => {
    getTierHistory()
      .then((r) => setHistory(r.history))
      .catch(() => setFailed(true));
  }, []);

  if (failed || history === null) return null;

  const n = history.length;
  const totals = history.map((p) => p.learning + p.familiar + p.mastered);
  const peak = Math.max(0, ...totals);
  if (peak === 0) return null; // nothing learned yet — same as the mastery bar hiding

  const x = (i: number) => VB.padL + (n === 1 ? 0 : (i / (n - 1)) * PLOT_W);
  const y = (v: number) => VB.padT + PLOT_H * (1 - v / peak);

  // Cumulative upper edge of each series per point (bottom→top stack).
  const cum: Record<string, number[]> = { learning: [], familiar: [], mastered: [] };
  history.forEach((p) => {
    const l = p.learning;
    const f = l + p.familiar;
    cum.learning.push(l);
    cum.familiar.push(f);
    cum.mastered.push(f + p.mastered);
  });
  const lowerOf: Record<string, number[]> = {
    learning: history.map(() => 0),
    familiar: cum.learning,
    mastered: cum.familiar,
  };

  // A filled band: along its upper edge left→right, back along its lower edge.
  const areaPath = (key: string) => {
    const upper = cum[key].map((v, i) => `${x(i)},${y(v)}`);
    const lower = lowerOf[key].map((v, i) => `${x(i)},${y(v)}`).reverse();
    return `M ${upper.join(" L ")} L ${lower.join(" L ")} Z`;
  };
  // White separators between bands = the 2px surface gap that keeps fills distinct.
  const boundary = (key: "learning" | "familiar") =>
    cum[key].map((v, i) => `${x(i)},${y(v)}`).join(" ");

  const onMove = (e: PointerEvent) => {
    const rect = svgRef.current?.getBoundingClientRect();
    if (!rect) return;
    const ratio = (e.clientX - rect.left) / rect.width;
    const plotRatio = (ratio * VB.w - VB.padL) / PLOT_W;
    setHover(Math.max(0, Math.min(n - 1, Math.round(plotRatio * (n - 1)))));
  };

  const hp = hover === null ? null : history[hover];
  const ticks = [0, Math.floor((n - 1) / 2), n - 1];

  return (
    <div class="rounded-2xl border border-slate-200 p-5">
      <div class="flex items-baseline justify-between">
        <p class="font-medium text-slate-900">Mastery over time</p>
        <span class="text-sm text-slate-400">last 30 days</span>
      </div>

      <div class="relative mt-3">
        <svg
          ref={svgRef}
          viewBox={`0 0 ${VB.w} ${VB.h}`}
          class="w-full touch-none"
          onPointerMove={onMove}
          onPointerLeave={() => setHover(null)}
        >
          {/* y-axis: baseline + peak gridline, labelled with the peak count. */}
          <line x1={VB.padL} y1={y(0)} x2={VB.w - VB.padR} y2={y(0)} stroke="#e2e8f0" stroke-width="1" />
          <line x1={VB.padL} y1={y(peak)} x2={VB.w - VB.padR} y2={y(peak)} stroke="#f1f5f9" stroke-width="1" />
          <text x={VB.padL - 4} y={y(peak) + 3} text-anchor="end" font-size="8" fill="#94a3b8">
            {peak}
          </text>
          <text x={VB.padL - 4} y={y(0) + 3} text-anchor="end" font-size="8" fill="#94a3b8">
            0
          </text>

          {STACK_ORDER.map((key) => {
            const s = HISTORY_SERIES.find((c) => c.key === key)!;
            return <path key={key} d={areaPath(key)} fill={s.color} />;
          })}
          <polyline points={boundary("learning")} fill="none" stroke="#fff" stroke-width="1.5" />
          <polyline points={boundary("familiar")} fill="none" stroke="#fff" stroke-width="1.5" />

          {/* x-axis date labels */}
          {ticks.map((i) => (
            <text
              key={i}
              x={x(i)}
              y={VB.h - 5}
              text-anchor={i === 0 ? "start" : i === n - 1 ? "end" : "middle"}
              font-size="8"
              fill="#94a3b8"
            >
              {shortDate(history[i].date)}
            </text>
          ))}

          {hover !== null && (
            <line
              x1={x(hover)}
              y1={VB.padT}
              x2={x(hover)}
              y2={y(0)}
              stroke="#64748b"
              stroke-width="1"
              stroke-dasharray="2 2"
            />
          )}
        </svg>

        {hp && (
          <div
            class="pointer-events-none absolute top-0 z-10 -translate-x-1/2 rounded-lg border border-slate-200 bg-white px-2.5 py-1.5 text-[11px] shadow-sm"
            style={{ left: `${((x(hover!) - VB.padL) / PLOT_W) * 100}%` }}
          >
            <p class="mb-0.5 font-medium text-slate-500">{shortDate(hp.date)}</p>
            {HISTORY_SERIES.map((s) => (
              <p key={s.key} class="flex items-center gap-1.5 whitespace-nowrap text-slate-700">
                <span class="h-2 w-2 rounded-full" style={{ background: s.color }} />
                {s.label} <span class="font-semibold">{hp[s.key]}</span>
              </p>
            ))}
          </div>
        )}
      </div>

      {/* Legend doubles as direct labels: each tier's current (today's) count. */}
      <div class="mt-3 flex flex-wrap gap-x-4 gap-y-1 text-xs text-slate-500">
        {HISTORY_SERIES.map((s) => (
          <span key={s.key} class="inline-flex items-center gap-1.5">
            <span class="h-2 w-2 rounded-full" style={{ background: s.color }} />
            {s.label} <span class="font-medium text-slate-700">{history[n - 1][s.key]}</span>
          </span>
        ))}
      </div>
    </div>
  );
}

import { useEffect, useState } from "preact/hooks";
import type { HeatmapCell, StatsResponse } from "../../shared/types";
import { getStats } from "./api";
import { TIERS } from "./tiers";

const WEEKDAYS = ["M", "T", "W", "T", "F", "S", "S"];

// Blue intensity by cards-done that day, tuned to a typical day's volume
// (due + up to 10 new + any bonus). Empty days are faint grey; future days blank.
function cellClass(cell: HeatmapCell): string {
  if (cell.future) return "bg-transparent";
  const n = cell.count;
  if (n === 0) return "bg-slate-100";
  if (n <= 5) return "bg-blue-200";
  if (n <= 12) return "bg-blue-400";
  if (n <= 24) return "bg-blue-600";
  return "bg-blue-800";
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
        <p class="mt-1 text-slate-500">Your progress, just for the fun of it.</p>
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

          <Heatmap cells={stats.heatmap} />

          <MasteryBar mastery={stats.mastery} />
        </main>
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
        {value > 0 && accent && <span class="ml-0.5 text-xl">🔥</span>}
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
            class={`aspect-square rounded-[3px] ${cellClass(cell)}`}
            title={cell.future ? cell.date : `${cell.date}: ${cell.count} ${cell.count === 1 ? "card" : "cards"}`}
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

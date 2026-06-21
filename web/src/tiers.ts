import type { MasteryTier } from "../../shared/types";

// Mastery-tier display config (strongest first), shared by the dashboard mastery
// card, the deck list, and the deck detail view so colours/labels stay in sync.
export const TIERS: { key: MasteryTier; label: string; bar: string; dot: string }[] = [
  { key: "mastered", label: "Mastered", bar: "bg-emerald-500", dot: "bg-emerald-500" },
  { key: "familiar", label: "Familiar", bar: "bg-sky-400", dot: "bg-sky-400" },
  { key: "learning", label: "Learning", bar: "bg-amber-400", dot: "bg-amber-400" },
  { key: "new", label: "New", bar: "bg-slate-200", dot: "bg-slate-200" },
];

export const TIER_BY_KEY: Record<MasteryTier, (typeof TIERS)[number]> = Object.fromEntries(
  TIERS.map((t) => [t.key, t]),
) as Record<MasteryTier, (typeof TIERS)[number]>;

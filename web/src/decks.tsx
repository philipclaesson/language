import { useEffect, useState } from "preact/hooks";
import type { DeckCardState, DeckDetail, DeckSummary } from "../../shared/types";
import { getDeck, getDecks } from "./api";

function masteryEmoji(pct: number): string {
  if (pct >= 100) return "🏆";
  if (pct >= 50) return "🌿";
  return "🌱";
}

/** Deck list with per-deck progress, shown on the dashboard. */
export function DeckList({ onOpen }: { onOpen: (id: string) => void }) {
  const [decks, setDecks] = useState<DeckSummary[] | null>(null);

  useEffect(() => {
    getDecks().then(setDecks).catch(() => setDecks([]));
  }, []);

  if (decks === null) return <p class="text-sm text-slate-400">…</p>;
  if (decks.length === 0) return <p class="text-sm text-slate-400">No decks yet.</p>;

  return (
    <div class="space-y-3">
      {decks.map((d) => {
        const pct = d.total ? Math.round((d.known / d.total) * 100) : 0;
        return (
          <button
            key={d.id}
            onClick={() => onOpen(d.id)}
            class="w-full rounded-xl border border-slate-200 px-4 py-3 text-left transition-colors hover:border-slate-300 hover:bg-slate-50"
          >
            <div class="flex items-center justify-between">
              <span class="font-medium text-slate-900">
                {masteryEmoji(pct)} {d.name}
              </span>
              {d.due > 0 && (
                <span class="rounded-full bg-amber-100 px-2 py-0.5 text-xs font-medium text-amber-800">
                  {d.due} due
                </span>
              )}
            </div>
            <div class="mt-2 h-2 w-full overflow-hidden rounded-full bg-slate-100">
              <div class="h-full rounded-full bg-green-500 transition-[width] duration-500" style={{ width: `${pct}%` }} />
            </div>
            <div class="mt-1.5 flex justify-between text-xs text-slate-400">
              <span>
                {d.known} / {d.total} mastered
              </span>
              <span>{pct}%</span>
            </div>
          </button>
        );
      })}
    </div>
  );
}

const STATE_LABEL: Record<DeckCardState, string> = {
  new: "New",
  learning: "Learning",
  relearning: "Learning",
  review: "Mastered",
};
const STATE_DOT: Record<DeckCardState, string> = {
  new: "bg-slate-300",
  learning: "bg-amber-400",
  relearning: "bg-amber-400",
  review: "bg-green-500",
};

/** A single deck and all its words (read-only reference view). */
export function DeckDetailView({ deckId, onBack }: { deckId: string; onBack: () => void }) {
  const [deck, setDeck] = useState<DeckDetail | null>(null);
  const [err, setErr] = useState(false);

  useEffect(() => {
    getDeck(deckId).then(setDeck).catch(() => setErr(true));
  }, [deckId]);

  return (
    <div class="mx-auto min-h-screen max-w-md px-5 py-10">
      <button onClick={onBack} class="text-sm text-slate-500 hover:text-slate-900 hover:underline">
        ← Back
      </button>

      {err ? (
        <p class="mt-8 text-slate-500">Deck not found.</p>
      ) : deck === null ? (
        <p class="mt-8 text-slate-400">…</p>
      ) : (
        <>
          <h1 class="mt-4 text-2xl font-semibold tracking-tight text-slate-900">{deck.name}</h1>
          {deck.description && <p class="mt-1 text-sm text-slate-500">{deck.description}</p>}

          <div class="mt-3 flex gap-4 text-xs text-slate-400">
            <span>{deck.cards.length} words</span>
            <span class="flex items-center gap-1">
              <span class="h-2 w-2 rounded-full bg-green-500" /> mastered
            </span>
            <span class="flex items-center gap-1">
              <span class="h-2 w-2 rounded-full bg-amber-400" /> learning
            </span>
            <span class="flex items-center gap-1">
              <span class="h-2 w-2 rounded-full bg-slate-300" /> new
            </span>
          </div>

          <ul class="mt-6 divide-y divide-slate-100">
            {deck.cards.map((card) => (
              <li key={card.id} class="flex items-center gap-3 py-3">
                <span
                  class={`h-2 w-2 shrink-0 rounded-full ${STATE_DOT[card.state]}`}
                  title={STATE_LABEL[card.state]}
                />
                <p class="min-w-0 flex-1 truncate text-slate-900">{card.prompt}</p>
                <div class="text-right">
                  <p class="font-medium text-slate-900">
                    {card.article ? `${card.article} ${card.answer}` : card.answer}
                  </p>
                  {card.partOfSpeech && <p class="text-xs text-slate-400">{card.partOfSpeech}</p>}
                </div>
              </li>
            ))}
          </ul>
        </>
      )}
    </div>
  );
}

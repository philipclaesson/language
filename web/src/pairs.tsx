import { useEffect, useRef, useState } from "preact/hooks";
import type { MatchPair } from "../../shared/types";
import { getMatchPairs } from "./api";
import { boardDone, clearPair, createBoard, type Board } from "./pairs-game";

// Match-the-pairs: a fast, game-y way to re-drill a set of cards (board rules in
// pairs-game.ts). MatchGame is pure UI over MatchPair[] so any card source can
// feed it; MatchMisses below wires it to today's misses.

type Side = "en" | "de";
type Pos = { en: number; de: number };
type Phase = "ready" | "playing" | "done";

export function MatchGame({ pairs, onExit }: { pairs: MatchPair[]; onExit: () => void }) {
  const [phase, setPhase] = useState<Phase>("ready");
  const [board, setBoard] = useState<Board | null>(null);
  const [selected, setSelected] = useState<{ side: Side; idx: number } | null>(null);
  const [wrong, setWrong] = useState<Pos | null>(null);
  const [matched, setMatched] = useState<Pos | null>(null);
  const [errors, setErrors] = useState(0);
  const [elapsedMs, setElapsedMs] = useState(0);
  const startedAt = useRef(0);

  useEffect(() => {
    if (phase !== "playing") return;
    const t = setInterval(() => setElapsedMs(Date.now() - startedAt.current), 250);
    return () => clearInterval(t);
  }, [phase]);

  function start() {
    setBoard(createBoard(pairs));
    setSelected(null);
    setWrong(null);
    setMatched(null);
    setErrors(0);
    setElapsedMs(0);
    startedAt.current = Date.now();
    setPhase("playing");
  }

  function tap(side: Side, idx: number) {
    if (!board || matched) return; // locked during the brief match animation
    const tile = board[side][idx];
    if (!tile) return;
    setWrong(null);
    if (!selected) {
      setSelected({ side, idx });
      return;
    }
    if (selected.side === side) {
      // Same column: re-select (or tap again to deselect).
      setSelected(selected.idx === idx ? null : { side, idx });
      return;
    }
    const other = board[selected.side][selected.idx]!;
    const pos: Pos =
      side === "en" ? { en: idx, de: selected.idx } : { en: selected.idx, de: idx };
    setSelected(null);
    if (other.pairId === tile.pairId) {
      // Flash green, then remove the pair (and let the board refill).
      setMatched(pos);
      const next = clearPair(board, pos.en, pos.de);
      setTimeout(() => {
        setMatched(null);
        setBoard(next);
        if (boardDone(next)) {
          setElapsedMs(Date.now() - startedAt.current);
          setPhase("done");
        }
      }, 250);
    } else {
      setErrors((e) => e + 1);
      setWrong(pos);
      setTimeout(() => setWrong((w) => (w === pos ? null : w)), 500);
    }
  }

  if (phase === "ready") {
    return (
      <Shell>
        <div class="w-full max-w-sm text-center">
          <p class="text-3xl">🧩</p>
          <p class="mt-3 text-2xl font-semibold text-slate-900">Match the pairs</p>
          <p class="mt-2 text-slate-600">
            {pairs.length} {pairs.length === 1 ? "card" : "cards"} to repeat. Connect each
            English word with its German — against the clock.
          </p>
          <button
            onClick={start}
            class="mt-6 w-full rounded-xl bg-slate-900 px-5 py-3 font-medium text-white transition hover:bg-slate-700"
          >
            Start
          </button>
          <button
            onClick={onExit}
            class="mt-3 text-sm text-slate-500 underline-offset-2 hover:text-slate-900 hover:underline"
          >
            Back
          </button>
        </div>
      </Shell>
    );
  }

  if (phase === "done") {
    return (
      <Shell>
        <div class="w-full max-w-sm text-center">
          <p class="text-3xl">🎉</p>
          <p class="mt-3 text-2xl font-semibold text-slate-900">Good job!</p>
          <p class="mt-2 text-slate-600">
            Repeated {pairs.length} {pairs.length === 1 ? "card" : "cards"} with {errors}{" "}
            {errors === 1 ? "error" : "errors"} in {formatDuration(elapsedMs)}.
          </p>
          <button
            onClick={start}
            class="mt-6 w-full rounded-xl bg-slate-900 px-5 py-3 font-medium text-white transition hover:bg-slate-700"
          >
            Play again
          </button>
          <button
            onClick={onExit}
            class="mt-3 text-sm text-slate-500 underline-offset-2 hover:text-slate-900 hover:underline"
          >
            Back to home
          </button>
        </div>
      </Shell>
    );
  }

  const b = board!;
  return (
    <Shell align="start">
      <div class="w-full max-w-md">
        <div class="mb-6 flex items-center justify-between text-sm text-slate-400">
          <span class="tabular-nums font-medium text-slate-700">{formatClock(elapsedMs)}</span>
          <span>
            {b.cleared} / {pairs.length}
          </span>
          <button onClick={onExit} class="hover:text-slate-700 hover:underline">
            End game
          </button>
        </div>

        <div class="grid grid-cols-2 gap-2.5">
          {b.en.map((_, i) => (
            <>
              <TileButton
                tile={b.en[i]}
                state={tileState("en", i, selected, wrong, matched)}
                onTap={() => tap("en", i)}
              />
              <TileButton
                tile={b.de[i]}
                state={tileState("de", i, selected, wrong, matched)}
                onTap={() => tap("de", i)}
              />
            </>
          ))}
        </div>
      </div>
    </Shell>
  );
}

// Loads today's misses into the game. The entry buttons only show when there are
// misses, but the empty state still handles a stale link / direct navigation.
export function MatchMisses({ onExit }: { onExit: () => void }) {
  const [pairs, setPairs] = useState<MatchPair[] | null>(null);
  const [failed, setFailed] = useState(false);

  useEffect(() => {
    getMatchPairs()
      .then((r) => setPairs(r.pairs))
      .catch(() => setFailed(true));
  }, []);

  if (failed || pairs?.length === 0) {
    return (
      <Shell>
        <div class="text-center">
          <p class="text-2xl">🌙</p>
          <p class="mt-2 text-slate-600">Nothing to match — you aced today's words.</p>
          <button
            onClick={onExit}
            class="mt-6 rounded-xl bg-slate-900 px-5 py-2.5 font-medium text-white hover:bg-slate-700"
          >
            Back
          </button>
        </div>
      </Shell>
    );
  }
  if (!pairs) return <Shell>…</Shell>;
  return <MatchGame pairs={pairs} onExit={onExit} />;
}

type TileState = "idle" | "selected" | "wrong" | "matched";

function tileState(
  side: Side,
  idx: number,
  selected: { side: Side; idx: number } | null,
  wrong: Pos | null,
  matched: Pos | null,
): TileState {
  if (matched && matched[side] === idx) return "matched";
  if (wrong && wrong[side] === idx) return "wrong";
  if (selected && selected.side === side && selected.idx === idx) return "selected";
  return "idle";
}

const TILE_CLASSES: Record<TileState, string> = {
  idle: "border-slate-200 bg-white text-slate-800 hover:bg-slate-50",
  selected: "border-slate-900 bg-slate-100 text-slate-900",
  wrong: "border-red-400 bg-red-50 text-red-900",
  matched: "border-green-500 bg-green-50 text-green-900",
};

function TileButton({
  tile,
  state,
  onTap,
}: {
  tile: { text: string } | null;
  state: TileState;
  onTap: () => void;
}) {
  // A cleared slot keeps its space (invisible) so the board doesn't jump around.
  if (!tile) return <div class="invisible rounded-xl border px-3 py-3.5 text-sm">·</div>;
  return (
    <button
      onClick={onTap}
      class={`min-w-0 break-words rounded-xl border px-3 py-3.5 text-sm font-medium transition-colors ${TILE_CLASSES[state]}`}
    >
      {tile.text}
    </button>
  );
}

function formatClock(ms: number): string {
  const s = Math.floor(ms / 1000);
  return `${Math.floor(s / 60)}:${String(s % 60).padStart(2, "0")}`;
}

// "2 minutes and 5 seconds" / "42 seconds", for the results line.
function formatDuration(ms: number): string {
  const total = Math.round(ms / 1000);
  const m = Math.floor(total / 60);
  const s = total % 60;
  const secs = `${s} ${s === 1 ? "second" : "seconds"}`;
  if (m === 0) return secs;
  return `${m} ${m === 1 ? "minute" : "minutes"} and ${secs}`;
}

function Shell({
  children,
  align = "center",
}: {
  children: preact.ComponentChildren;
  align?: "center" | "start";
}) {
  return (
    <div
      class={`flex min-h-screen justify-center bg-white px-5 py-10 text-slate-900 ${
        align === "start" ? "items-start pt-14" : "items-center"
      }`}
    >
      {children}
    </div>
  );
}

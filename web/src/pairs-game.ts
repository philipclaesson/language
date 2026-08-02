// Board mechanics for the match-the-pairs game (pairs.tsx renders it). Pure —
// randomness is injected so tests can pass an identity "shuffle".
//
// The board shows up to BOARD_PAIRS pairs at once: an English tile column and a
// German tile column, each independently shuffled. Matched pairs leave empty
// (null) slots; once REFILL_AT pairs have been cleared, the next pairs from the
// queue drop into randomly chosen empty slots. The game ends when the queue and
// the board are both empty.

import type { MatchPair } from "../../shared/types";

export const BOARD_PAIRS = 6;
export const REFILL_AT = 3;

export type Tile = { pairId: string; text: string };

export type Board = {
  en: (Tile | null)[];
  de: (Tile | null)[];
  queue: MatchPair[]; // pairs not yet shown
  cleared: number; // pairs matched away so far
  sinceRefill: number; // pairs cleared since the last refill
};

export type Shuffler = <T>(arr: T[]) => T[];

// Fisher-Yates over a copy.
export function shuffle<T>(arr: T[]): T[] {
  const a = [...arr];
  for (let i = a.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [a[i], a[j]] = [a[j], a[i]];
  }
  return a;
}

export function createBoard(pairs: MatchPair[], shuf: Shuffler = shuffle): Board {
  const order = shuf(pairs);
  const first = order.slice(0, BOARD_PAIRS);
  return {
    en: shuf(first).map((p) => ({ pairId: p.id, text: p.en })),
    de: shuf(first).map((p) => ({ pairId: p.id, text: p.de })),
    queue: order.slice(BOARD_PAIRS),
    cleared: 0,
    sinceRefill: 0,
  };
}

/**
 * Remove a matched pair, then refill: once REFILL_AT pairs have been cleared
 * (or whatever the queue still holds at the tail end), the next queued pairs
 * drop into randomly chosen empty slots on each side.
 */
export function clearPair(
  board: Board,
  enIdx: number,
  deIdx: number,
  shuf: Shuffler = shuffle,
): Board {
  const en = [...board.en];
  const de = [...board.de];
  en[enIdx] = null;
  de[deIdx] = null;

  let queue = board.queue;
  let sinceRefill = board.sinceRefill + 1;
  if (queue.length > 0 && sinceRefill >= REFILL_AT) {
    const incoming = queue.slice(0, REFILL_AT);
    queue = queue.slice(incoming.length);
    const enSlots = shuf(emptySlots(en)).slice(0, incoming.length);
    const deSlots = shuf(emptySlots(de)).slice(0, incoming.length);
    incoming.forEach((p, k) => {
      en[enSlots[k]] = { pairId: p.id, text: p.en };
      de[deSlots[k]] = { pairId: p.id, text: p.de };
    });
    sinceRefill = 0;
  }

  return { en, de, queue, cleared: board.cleared + 1, sinceRefill };
}

export function boardDone(board: Board): boolean {
  return board.queue.length === 0 && board.en.every((t) => t === null);
}

function emptySlots(tiles: (Tile | null)[]): number[] {
  return tiles.flatMap((t, i) => (t === null ? [i] : []));
}

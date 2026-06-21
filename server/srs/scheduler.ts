import { fsrs, createEmptyCard, Rating, State, type Card as FsrsCard } from "ts-fsrs";

// Day-grained FSRS: no intra-day learning steps. The "drill until correct"
// behaviour is a session-completion gate (see PLAN.md §5a), not FSRS steps.
// `enable_short_term: false` means we never schedule sub-day intervals, so the
// `learning_steps` field (which we don't persist) is irrelevant — without this,
// cards get stuck in `learning` forever and never graduate to real intervals.
// Later we can run the optimizer on the `reviews` log to tune parameters.
const scheduler = fsrs({ enable_short_term: false });

// The subset of FSRS state we persist (the rest is recomputed each review).
export type StoredSrs = {
  due: Date;
  stability: number;
  difficulty: number;
  reps: number;
  lapses: number;
  lastReview: Date | null;
  state: string; // 'new' | 'learning' | 'review' | 'relearning'
};

const STATE_TO_ENUM: Record<string, State> = {
  new: State.New,
  learning: State.Learning,
  review: State.Review,
  relearning: State.Relearning,
};
const ENUM_TO_STATE = ["new", "learning", "review", "relearning"] as const;

function toFsrs(s: StoredSrs): FsrsCard {
  return {
    due: s.due,
    stability: s.stability,
    difficulty: s.difficulty,
    elapsed_days: 0, // recomputed by next()
    scheduled_days: 0,
    learning_steps: 0,
    reps: s.reps,
    lapses: s.lapses,
    state: STATE_TO_ENUM[s.state] ?? State.New,
    last_review: s.lastReview ?? undefined,
  };
}

function fromFsrs(c: FsrsCard): StoredSrs {
  return {
    due: c.due,
    stability: c.stability,
    difficulty: c.difficulty,
    reps: c.reps,
    lapses: c.lapses,
    lastReview: c.last_review ?? null,
    state: ENUM_TO_STATE[c.state],
  };
}

/**
 * Advance a card's schedule. Binary grading: pass -> Good, fail -> Again.
 * `prev` is null for a card being reviewed for the very first time.
 */
export function scheduleNext(prev: StoredSrs | null, pass: boolean, now: Date): StoredSrs {
  const card = prev ? toFsrs(prev) : createEmptyCard(now);
  const grade = pass ? Rating.Good : Rating.Again;
  const { card: next } = scheduler.next(card, now, grade);
  return fromFsrs(next);
}

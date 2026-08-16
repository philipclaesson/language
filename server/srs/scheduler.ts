import {
  fsrs,
  createEmptyCard,
  Rating,
  State,
  type Card as FsrsCard,
  // FSRS's own rating-minus-Manual union. Named to keep it apart from *our* Grade
  // (the pass/near/fail vocabulary the rest of the app speaks).
  type Grade as FsrsGrade,
} from "ts-fsrs";
import type { Grade } from "../../shared/types";

// Day-grained FSRS: no intra-day learning steps. The "drill until correct"
// behaviour is a session-completion gate (see PLAN.md §5a), not FSRS steps.
// `enable_short_term: false` means we never schedule sub-day intervals, so the
// `learning_steps` field (which we don't persist) is irrelevant — without this,
// cards get stuck in `learning` forever and never graduate to real intervals.
//
// Params: stock defaults, on purpose. We fit FSRS to our own review log
// (`npm run optimize:fsrs`, 2026-08-17: 5,414 graded reviews, 128 mature lapses)
// and it was a wash — +1.1% rmse / −0.6% logLoss on held-out data, i.e. no real
// gain over stock. The fit also *confirmed* the harsh post-lapse reset (a mastered
// card really does collapse to a few days when forgotten): that's data-justified,
// not a bug, so we don't hand-soften it. Re-run the optimizer as the log grows;
// only pin a `w: [...]` here if it clearly beats stock on both metrics.
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

// Our three grades map onto three of the four FSRS ratings (Easy is never
// exposed — we have no way to know an answer was *easy*, only that it was right).
//
// The one that earns its keep is `near` -> Hard: FSRS treats Hard as a successful
// recall, so the card keeps its stability (the gain is damped, not reversed) and
// counts no lapse; only its difficulty ticks up. That's the honest reading of
// "wrote die instead of der": you knew the word. A `fail` (Again) instead RESETS
// stability and counts a lapse. Measured on a familiar card (stability 12d, D 5):
//   pass -> due in 38d, stability 37.6, D 4.99
//   near -> due in 27d, stability 27.4, D 6.67, no lapse
//   fail -> due in  2d, stability  1.5, D 8.34, +1 lapse
// See PLAN.md §5 / srs/check.ts for what counts as near.
const RATING_BY_GRADE: Record<Grade, FsrsGrade> = {
  pass: Rating.Good,
  near: Rating.Hard,
  fail: Rating.Again,
};

// What we write to `reviews.rating` (FSRS's own 1-4 scale, so a future optimizer
// run over the log reads it directly). The daily loop keys off this: **rating >= 3
// means "satisfied the day"**, so a near miss (2) still has to be re-drilled.
const RATING_VALUE: Record<Grade, number> = { pass: 3, near: 2, fail: 1 };

/** The `reviews.rating` value to log for a grade. */
export function ratingFor(grade: Grade): number {
  return RATING_VALUE[grade];
}

/**
 * Advance a card's schedule: pass -> Good, near -> Hard, fail -> Again.
 * `prev` is null for a card being reviewed for the very first time.
 */
export function scheduleNext(prev: StoredSrs | null, grade: Grade, now: Date): StoredSrs {
  const card = prev ? toFsrs(prev) : createEmptyCard(now);
  const { card: next } = scheduler.next(card, now, RATING_BY_GRADE[grade]);
  return fromFsrs(next);
}

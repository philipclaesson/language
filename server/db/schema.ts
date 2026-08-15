import {
  pgTable,
  uuid,
  text,
  timestamp,
  date,
  doublePrecision,
  integer,
  boolean,
  jsonb,
  unique,
} from "drizzle-orm/pg-core";

export const users = pgTable("users", {
  id: uuid("id").primaryKey().defaultRandom(),
  email: text("email").notNull().unique(),
  displayName: text("display_name"),
  createdAt: timestamp("created_at", { withTimezone: true }).notNull().defaultNow(),
});

// A "module": a named group of cards. Usually personal (belongs to one user).
// A NULL owner marks a GLOBAL deck: shared reference data (the frequency word
// corpus, seeded by a data migration) that every user reviews but nobody owns —
// so it's read-only (all mutations scope to owner_id = the user) and surfaced by
// the review queries via `or(ownerId = user, ownerId IS NULL)`. Cf. the verbs
// catalog, which is global by living in its own table.
export const decks = pgTable("decks", {
  id: uuid("id").primaryKey().defaultRandom(),
  ownerId: uuid("owner_id").references(() => users.id, { onDelete: "cascade" }),
  name: text("name").notNull(),
  // 'manual' | 'seed' | 'ai_chat' | 'ai_module' | 'news'
  source: text("source").notNull().default("manual"),
  description: text("description"),
  createdAt: timestamp("created_at", { withTimezone: true }).notNull().defaultNow(),
});

export const cards = pgTable("cards", {
  id: uuid("id").primaryKey().defaultRandom(),
  deckId: uuid("deck_id")
    .notNull()
    .references(() => decks.id, { onDelete: "cascade" }),
  prompt: text("prompt").notNull(), // shown to user (English), e.g. "the dog"
  answer: text("answer").notNull(), // canonical German, e.g. "der Hund"
  answerAlts: text("answer_alts").array().notNull().default([]),
  partOfSpeech: text("part_of_speech"), // drives answer-checking rules
  article: text("article"), // der/die/das for nouns
  notes: text("notes"), // mnemonic / free-form note (tutor cards)
  // Optional Swedish gloss (set on frequency-corpus cards via overrides; null
  // elsewhere). Some German words map cleanly to a Swedish cognate but poorly to
  // English (trotzdem → "trots det", erhalten → "erhålla"); when present it's shown
  // up front alongside the prompt as a learning aid for Swedish speakers. Safe
  // pre-answer: a translation, it carries no article/gender and isn't the graded
  // German answer. See review-routes.ts + server/db/words-overrides.ts.
  swedish: text("swedish"),
  // Example sentences (set on the frequency corpus; null elsewhere). `exampleEn` is
  // the English gloss — safe to show before answering, for disambiguating context.
  // `exampleDe` is the German sentence — it embeds the answer word, so it's only
  // revealed after a wrong answer (in the drill panel). See review-routes.ts.
  exampleEn: text("example_en"),
  exampleDe: text("example_de"),
  // Lower = more frequent. Set on the global frequency corpus; null for manual /
  // AI / starter cards. Drives new-card introduction order (frequency_rank asc,
  // nulls first) so personal cards come before the corpus. See srs/day.ts.
  frequencyRank: integer("frequency_rank"),
  source: text("source").notNull().default("manual"),
  createdAt: timestamp("created_at", { withTimezone: true }).notNull().defaultNow(),
});

// SRS scheduler state: one row per (user, card). Separate from card content so
// decks can later be shared/cloned between users without touching schedules.
export const reviewState = pgTable(
  "review_state",
  {
    id: uuid("id").primaryKey().defaultRandom(),
    userId: uuid("user_id")
      .notNull()
      .references(() => users.id, { onDelete: "cascade" }),
    cardId: uuid("card_id")
      .notNull()
      .references(() => cards.id, { onDelete: "cascade" }),
    due: timestamp("due", { withTimezone: true }).notNull().defaultNow(),
    stability: doublePrecision("stability").notNull().default(0),
    difficulty: doublePrecision("difficulty").notNull().default(0),
    reps: integer("reps").notNull().default(0),
    lapses: integer("lapses").notNull().default(0),
    lastReview: timestamp("last_review", { withTimezone: true }),
    // 'new' | 'learning' | 'review' | 'relearning'
    state: text("state").notNull().default("new"),
  },
  (t) => [unique("review_state_user_card").on(t.userId, t.cardId)],
);

// One shared high-score table for all games (game-routes.ts): `game` is the game
// id ('article-mania', …), `score` an integer whose meaning is per-game (Article
// Mania stores percent 0–100). Append-only; rankings are derived at read time
// (score desc, earlier submission wins ties).
export const gameScores = pgTable("game_scores", {
  id: uuid("id").primaryKey().defaultRandom(),
  userId: uuid("user_id")
    .notNull()
    .references(() => users.id, { onDelete: "cascade" }),
  game: text("game").notNull(),
  score: integer("score").notNull(),
  createdAt: timestamp("created_at", { withTimezone: true }).notNull().defaultNow(),
});

// Web Push subscriptions for the daily training reminder (push-routes.ts). One
// row per browser/device the user enabled reminders on; `endpoint` is the push
// service URL and is globally unique (the natural key). A user can have several
// (phone + laptop). Rows are pruned when the push service reports the sub is gone
// (404/410) at send time. No owner-scoping subtlety here — always the user's own.
export const pushSubscriptions = pgTable("push_subscriptions", {
  id: uuid("id").primaryKey().defaultRandom(),
  userId: uuid("user_id")
    .notNull()
    .references(() => users.id, { onDelete: "cascade" }),
  endpoint: text("endpoint").notNull().unique(),
  // The two keys from the browser PushSubscription (`getKey('p256dh')` / `'auth'`),
  // base64url-encoded — web-push needs both to encrypt the payload.
  p256dh: text("p256dh").notNull(),
  auth: text("auth").notNull(),
  createdAt: timestamp("created_at", { withTimezone: true }).notNull().defaultNow(),
});

// One row per (user, local day) recording whether the day was "perfect" — all words
// done, all verbs done, and at least one Freund message. Persisted (not derived from
// the reviews log) because completion is a point-in-time fact: today's required set
// depends on FSRS due dates that move forward, so "was day X finished" can't be
// reconstructed after the fact. `day` is the local calendar date in DAY_TZ, matching
// how the heatmap buckets. Upserted from /session/today, /verbs/session/today, and
// /freund/message; read by /stats for the grid rings + the 30-day perfect %. See
// STREAK.md. Counts stay derived from the logs — only completion lives here.
export const dailyProgress = pgTable(
  "daily_progress",
  {
    id: uuid("id").primaryKey().defaultRandom(),
    userId: uuid("user_id")
      .notNull()
      .references(() => users.id, { onDelete: "cascade" }),
    day: date("day").notNull(), // local calendar date "YYYY-MM-DD" in DAY_TZ
    wordsDone: boolean("words_done").notNull().default(false),
    verbsDone: boolean("verbs_done").notNull().default(false),
    freundCount: integer("freund_count").notNull().default(0),
  },
  (t) => [unique("daily_progress_user_day").on(t.userId, t.day)],
);

// ---- Verbs mode (VERBS.md) ----
// A GLOBAL, shared catalog of verbs to drill (no owner) — reference data, ordered
// by frequency. This departs from the personal-libraries model of decks/cards on
// purpose: there's one verb list, edited in one place. Per-user progress lives in
// verb_review_state, mirroring the cards/review_state split.
export const verbs = pgTable("verbs", {
  id: uuid("id").primaryKey().defaultRandom(),
  infinitive: text("infinitive").notNull().unique(), // "gehen"
  english: text("english").notNull(), // "to go" — shown as the prompt subtitle
  regularity: text("regularity").notNull(), // 'regular' | 'irregular'
  frequencyRank: integer("frequency_rank").notNull(), // 1 = most frequent; new-verb order
  // Present-tense forms. er = er/sie/es; sie = sie/Sie (plural + formal).
  formIch: text("form_ich").notNull(),
  formDu: text("form_du").notNull(),
  formEr: text("form_er").notNull(),
  formWir: text("form_wir").notNull(),
  formIhr: text("form_ihr").notNull(),
  formSie: text("form_sie").notNull(),
  notes: text("notes"), // optional irregularity note / mnemonic
  createdAt: timestamp("created_at", { withTimezone: true }).notNull().defaultNow(),
});

// SRS scheduler state per (user, verb) — identical shape to review_state so the
// FSRS wrapper (srs/scheduler.ts) and tiers (srs/tiers.ts) are reused as-is.
export const verbReviewState = pgTable(
  "verb_review_state",
  {
    id: uuid("id").primaryKey().defaultRandom(),
    userId: uuid("user_id")
      .notNull()
      .references(() => users.id, { onDelete: "cascade" }),
    verbId: uuid("verb_id")
      .notNull()
      .references(() => verbs.id, { onDelete: "cascade" }),
    due: timestamp("due", { withTimezone: true }).notNull().defaultNow(),
    stability: doublePrecision("stability").notNull().default(0),
    difficulty: doublePrecision("difficulty").notNull().default(0),
    reps: integer("reps").notNull().default(0),
    lapses: integer("lapses").notNull().default(0),
    lastReview: timestamp("last_review", { withTimezone: true }),
    state: text("state").notNull().default("new"),
  },
  (t) => [unique("verb_review_state_user_verb").on(t.userId, t.verbId)],
);

// Append-only log of every verb attempt (parity with `reviews`; drives the day-
// planner's "reviewed/correct today" and a future FSRS optimizer).
export const verbReviews = pgTable("verb_reviews", {
  id: uuid("id").primaryKey().defaultRandom(),
  userId: uuid("user_id")
    .notNull()
    .references(() => users.id, { onDelete: "cascade" }),
  verbId: uuid("verb_id")
    .notNull()
    .references(() => verbs.id, { onDelete: "cascade" }),
  rating: integer("rating").notNull(), // 1 = fail, 3 = pass (all-or-nothing)
  graded: boolean("graded").notNull().default(true), // first-attempt-of-day only
  // Extra/bonus work (EXTRA_WORK.md): a review done via "learn more"/"practice"
  // beyond the day's required set. The day planner reads today's REQUIRED
  // membership from non-bonus reviews only, so a missed bonus card can't silently
  // un-complete your finished day. Mastery/progress still counts every graded row.
  bonus: boolean("bonus").notNull().default(false),
  typedAnswer: jsonb("typed_answer"), // the six typed forms
  reviewedAt: timestamp("reviewed_at", { withTimezone: true }).notNull().defaultNow(),
  elapsedMs: integer("elapsed_ms"),
});

// Append-only log of every answer (analytics + future FSRS optimization).
export const reviews = pgTable("reviews", {
  id: uuid("id").primaryKey().defaultRandom(),
  userId: uuid("user_id")
    .notNull()
    .references(() => users.id, { onDelete: "cascade" }),
  cardId: uuid("card_id")
    .notNull()
    .references(() => cards.id, { onDelete: "cascade" }),
  // FSRS's own rating scale: 1 = fail (Again), 2 = near miss (Hard — right word,
  // wrong article or one letter off; see srs/check.ts), 3 = pass (Good). Only
  // >= 3 satisfies the day. Rows written before near misses shipped are 1 or 3.
  rating: integer("rating").notNull(),
  // Whether this attempt drove the FSRS schedule. The first attempt of the day on
  // a card is graded; later same-day attempts are training-only re-drills logged
  // with graded=false, so they don't pollute the optimizer's view. See PLAN.md §5a.
  graded: boolean("graded").notNull().default(true),
  // Extra/bonus work (EXTRA_WORK.md) — see verb_reviews.bonus for the rationale.
  bonus: boolean("bonus").notNull().default(false),
  typedAnswer: text("typed_answer"),
  reviewedAt: timestamp("reviewed_at", { withTimezone: true }).notNull().defaultNow(),
  elapsedMs: integer("elapsed_ms"),
});

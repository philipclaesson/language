import {
  pgTable,
  uuid,
  text,
  timestamp,
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
  notes: text("notes"), // example sentence / mnemonic
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
  rating: integer("rating").notNull(), // 1 = fail, 3 = pass
  // Whether this attempt drove the FSRS schedule. The first attempt of the day on
  // a card is graded; later same-day attempts are training-only re-drills logged
  // with graded=false, so they don't pollute the optimizer's view. See PLAN.md §5a.
  graded: boolean("graded").notNull().default(true),
  typedAnswer: text("typed_answer"),
  reviewedAt: timestamp("reviewed_at", { withTimezone: true }).notNull().defaultNow(),
  elapsedMs: integer("elapsed_ms"),
});

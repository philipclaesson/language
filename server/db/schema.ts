import {
  pgTable,
  uuid,
  text,
  timestamp,
  doublePrecision,
  integer,
  unique,
} from "drizzle-orm/pg-core";

export const users = pgTable("users", {
  id: uuid("id").primaryKey().defaultRandom(),
  email: text("email").notNull().unique(),
  displayName: text("display_name"),
  createdAt: timestamp("created_at", { withTimezone: true }).notNull().defaultNow(),
});

// A "module": a named group of cards. Personal — every deck belongs to one user.
export const decks = pgTable("decks", {
  id: uuid("id").primaryKey().defaultRandom(),
  ownerId: uuid("owner_id")
    .notNull()
    .references(() => users.id, { onDelete: "cascade" }),
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
  typedAnswer: text("typed_answer"),
  reviewedAt: timestamp("reviewed_at", { withTimezone: true }).notNull().defaultNow(),
  elapsedMs: integer("elapsed_ms"),
});

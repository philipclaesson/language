import { Hono } from "hono";
import { and, eq, inArray, isNull, sql } from "drizzle-orm";
import { db } from "./db/client";
import { cards, decks, gameScores, users } from "./db/schema";
import { orderScores, rankOf, topScores } from "./games/scores";
import { requireAuth, type AppEnv } from "./auth";
import type {
  ArticleRoundResponse,
  GameId,
  GermanArticle,
  HighScoreEntry,
  HighScoresResponse,
  SubmitScoreRequest,
  SubmitScoreResponse,
} from "../shared/types";
import { GERMAN_ARTICLES } from "../shared/types";

export const gameRoutes = new Hono<AppEnv>();
gameRoutes.use("*", requireAuth);

// Games that persist to the shared high-score table. Article Mania stores
// percent (0–100); add future games here with their own score range.
const KNOWN_GAMES: GameId[] = ["article-mania"];
const ROUND_SIZE = 50;

// A round of Article Mania: random nouns (with their articles) from the global
// frequency corpus. The payload carries the article on purpose — see the
// ArticleNoun comment in shared/types.ts for why that's OK here when it isn't
// for /session/today.
gameRoutes.get("/games/article-mania/round", async (c) => {
  const rows = await db
    .select({ id: cards.id, noun: cards.answer, article: cards.article })
    .from(cards)
    .innerJoin(decks, eq(decks.id, cards.deckId))
    .where(
      and(
        isNull(decks.ownerId), // global corpus only — curated, article always set
        eq(cards.partOfSpeech, "noun"),
        inArray(cards.article, GERMAN_ARTICLES),
      ),
    )
    .orderBy(sql`random()`)
    .limit(ROUND_SIZE);

  const body: ArticleRoundResponse = {
    nouns: rows.map((r) => ({
      id: r.id,
      noun: r.noun,
      article: r.article as GermanArticle,
    })),
  };
  return c.json(body);
});

// All entries for one game, joined with player names. The table is tiny (a few
// rows per play for two users), so ranking in JS keeps the logic pure + tested.
async function loadScores(game: GameId) {
  const rows = await db
    .select({
      id: gameScores.id,
      score: gameScores.score,
      createdAt: gameScores.createdAt,
      displayName: users.displayName,
      email: users.email,
    })
    .from(gameScores)
    .innerJoin(users, eq(users.id, gameScores.userId))
    .where(eq(gameScores.game, game));
  return rows.map((r) => ({
    id: r.id,
    score: r.score,
    createdAt: r.createdAt,
    player: r.displayName?.split(" ")[0] || r.email.split("@")[0],
  }));
}

function toEntry(
  game: GameId,
  r: { id: string; score: number; createdAt: Date; player: string },
): HighScoreEntry {
  return {
    id: r.id,
    game,
    player: r.player,
    score: r.score,
    createdAt: r.createdAt.toISOString(),
  };
}

// Top of the shared high-score table for one game (the menu's leaderboard).
gameRoutes.get("/games/scores", async (c) => {
  const game = c.req.query("game") as GameId;
  if (!KNOWN_GAMES.includes(game)) return c.json({ error: "unknown game" }, 400);

  const rows = await loadScores(game);
  const body: HighScoresResponse = {
    entries: topScores(rows).map((r) => toEntry(game, r)),
  };
  return c.json(body);
});

// Persist a finished game's score and return the results-screen payload: the
// saved entry, its overall rank, and the top table (highlight by entry.id).
gameRoutes.post("/games/scores", async (c) => {
  const { game, score } = (await c.req.json()) as SubmitScoreRequest;
  if (!KNOWN_GAMES.includes(game)) return c.json({ error: "unknown game" }, 400);
  // Article Mania scores are percent; keep future games honest about range too.
  if (!Number.isInteger(score) || score < 0 || score > 100)
    return c.json({ error: "score must be an integer 0–100" }, 400);

  const [saved] = await db
    .insert(gameScores)
    .values({ userId: c.get("user").id, game, score })
    .returning({ id: gameScores.id, createdAt: gameScores.createdAt });

  const rows = await loadScores(game);
  const ordered = orderScores(rows);
  const mine = ordered.find((r) => r.id === saved.id)!;

  const body: SubmitScoreResponse = {
    entry: toEntry(game, mine),
    rank: rankOf(ordered, saved.id),
    top: topScores(ordered).map((r) => toEntry(game, r)),
  };
  return c.json(body);
});

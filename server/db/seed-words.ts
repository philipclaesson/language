// `npm run db:seed:words` — load the global frequency word corpus into the
// current DATABASE_URL's DB (idempotent). The initial prod load happens via the
// data migration (drizzle/0005_seed_words.sql); use this locally, or after
// regenerating words.data.json with scripts/gen-words.ts.
import { seedWords } from "./words";

const inserted = await seedWords();
console.log(
  inserted === 0 ? "Word corpus already present." : `Seeded ${inserted} words.`,
);
process.exit(0);

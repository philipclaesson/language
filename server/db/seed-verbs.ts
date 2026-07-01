// `npm run db:seed:verbs` — load the global verb catalog into the current
// DATABASE_URL's DB (idempotent). The initial prod load happens via the
// data migration (drizzle/0003_seed_verbs.sql); use this locally, or to grow
// the catalog after editing server/db/verbs.ts.
import { seedVerbs } from "./verbs";

const inserted = await seedVerbs();
console.log(inserted === 0 ? "Verb catalog already up to date." : `Seeded ${inserted} new verbs.`);
process.exit(0);

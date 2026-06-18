// `npm run db:seed` — give every existing user their starter deck (idempotent).
import { db } from "./client";
import { users } from "./schema";
import { seedUser } from "./seed";

const all = await db.select().from(users);
if (all.length === 0) {
  console.log("No users yet. They get a starter deck automatically on first login.");
}
for (const u of all) {
  const created = await seedUser(u.id);
  console.log(`${u.email}: ${created ? "seeded starter deck" : "already had one"}`);
}
process.exit(0);

import { drizzle } from "drizzle-orm/node-postgres";
import pg from "pg";
import { env } from "../env";
import * as schema from "./schema";

const isLocal =
  env.databaseUrl.includes("localhost") || env.databaseUrl.includes("127.0.0.1");

const pool = new pg.Pool({
  connectionString: env.databaseUrl,
  // Neon (and most hosted Postgres) require TLS; local Postgres usually doesn't.
  ssl: isLocal ? false : { rejectUnauthorized: false },
});

export const db = drizzle(pool, { schema });

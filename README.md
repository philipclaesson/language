# Sprachen — German vocabulary trainer

Spaced-repetition German trainer for two people. See [PLAN.md](./PLAN.md) for the
full design. This README covers running it.

## Stack

- **Frontend:** Preact + Vite + Tailwind (in `web/`)
- **Server:** Hono on Node, serves the API and (in prod) the built SPA (in `server/`)
- **DB:** Postgres (Neon) via Drizzle ORM (`server/db/`)
- **Auth:** Google OAuth, two-email allowlist, JWT session cookie

## Local development

1. **Install deps**

   ```sh
   npm install
   ```

2. **Set up a Neon database** (free tier) at <https://neon.tech>, then copy the
   *pooled* connection string.

3. **Set up Google OAuth** in the GCP console:
   - APIs & Services → OAuth consent screen → External, **Testing** mode, add both
     Google accounts as test users (no Google verification review needed).
   - Credentials → Create OAuth client ID → Web application.
   - Authorized redirect URI: `http://localhost:5173/api/auth/callback` (dev) and
     `https://language.levanto.dev/api/auth/callback` (prod).

4. **Create `.env`** from the template and fill it in:

   ```sh
   cp .env.example .env
   # generate a session secret:
   openssl rand -base64 48
   ```

5. **Run migrations**

   ```sh
   npm run db:generate   # creates SQL from server/db/schema.ts (commit the output)
   npm run db:migrate    # applies it to the DB in DATABASE_URL
   ```

6. **Start dev servers** (Vite on :5173, Hono on :8787, with /api proxied)

   ```sh
   npm run dev
   ```

   Open <http://localhost:5173>.

## Deploy (Cloud Run)

One-time setup:

1. Create the secrets in Secret Manager: `DATABASE_URL`, `GOOGLE_CLIENT_ID`,
   `GOOGLE_CLIENT_SECRET`, `SESSION_SECRET`, `ALLOWED_EMAILS`.
2. Set up Workload Identity Federation for GitHub Actions and add repo secrets
   `GCP_WIF_PROVIDER` and `GCP_DEPLOY_SA`.
3. Edit `PROJECT_ID` / `REGION` in `.github/workflows/deploy.yml`.
4. Map the domain: `gcloud run domain-mappings create --service=language --domain=language.levanto.dev`
   and add the resulting DNS record at levanto.dev.

After that, pushing to `main` deploys. The OAuth redirect URI for prod must be
registered in the Google OAuth client (step 3 above).

## Scripts

| Command | What |
|---|---|
| `npm run dev` | Vite + Hono with hot reload |
| `npm run build` | Build the SPA to `web/dist` |
| `npm start` | Run the server (serves built SPA + API) |
| `npm run typecheck` | `tsc --noEmit` |
| `npm run db:generate` | Generate a migration from the schema |
| `npm run db:migrate` | Apply migrations |
| `npm run db:studio` | Drizzle Studio (DB browser) |

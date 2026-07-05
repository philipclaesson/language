# Infrastructure

Plain-markdown record of everything we provisioned (no IaC). Update this file
when infra changes. Secret *values* are never stored here — only names.

Last updated: 2026-07-05 (added Web Push daily reminders: `push_subscriptions`
table, `VAPID_*`/`CRON_SECRET` secrets, and the `reminders.yml` scheduled workflow —
see **Web Push** below).

## Summary

| Thing | Value |
|---|---|
| GCP project | `language-499814` (project number `639264903663`) |
| Region | `europe-west1` (Belgium — near the Frankfurt Neon DB) |
| Cloud Run service | `language` |
| Live URL (Cloud Run) | https://language-639264903663.europe-west1.run.app |
| Custom domain | https://language.levanto.dev *(mapping created — awaiting DNS CNAME + cert)* |
| Database | Neon Postgres (`neondb`, region eu-central-1 / Frankfurt) |
| Auth | Google OAuth (client in project `language-499814`) |

## Google Cloud

### Enabled APIs
`run.googleapis.com`, `cloudbuild.googleapis.com`,
`artifactregistry.googleapis.com`, `secretmanager.googleapis.com`.

### Cloud Run service `language`
- Region `europe-west1` (chosen because Cloud Run **domain mappings are not
  supported in europe-west3**; west1 is the nearest region that supports them).
- **scales to zero** (`min-instances=0`, `max-instances=2`), `512Mi`.
- `--allow-unauthenticated`: the service is public at the network level; the app
  gates everything itself via Google login + the email allowlist.
- Runtime service account: the default compute SA
  `639264903663-compute@developer.gserviceaccount.com`.
- **Env var:** `BASE_URL=https://language.levanto.dev`,
  `VAPID_SUBJECT=mailto:philip.claesson@sanalabs.com`
  (also `NODE_ENV=production`, `PORT=8080` baked into the Docker image).
- **Secrets** (mounted as env vars, all `:latest`): `DATABASE_URL`,
  `GOOGLE_CLIENT_ID`, `GOOGLE_CLIENT_SECRET`, `SESSION_SECRET`, `ALLOWED_EMAILS`,
  `ANTHROPIC_API_KEY`, `VAPID_PUBLIC_KEY`, `VAPID_PRIVATE_KEY`, `CRON_SECRET`
  (the last three power daily reminders — see **Web Push** below).

### Secret Manager
Secrets (values not shown): `DATABASE_URL`, `GOOGLE_CLIENT_ID`,
`GOOGLE_CLIENT_SECRET`, `SESSION_SECRET`, `ALLOWED_EMAILS`, `ANTHROPIC_API_KEY`
(the AI chat tutor; create with
`printf '%s' "sk-ant-…" | gcloud secrets create ANTHROPIC_API_KEY --data-file=- --project=language-499814`).
The runtime SA has `roles/secretmanager.secretAccessor` (granted project-wide).

### Artifact Registry
Repo `cloud-run-source-deploy` (auto-created by `gcloud run deploy --source`) in
`europe-west1` holds the built container images.

### Build
`gcloud run deploy --source .` uses **Cloud Build** to build the `Dockerfile`,
push the image to Artifact Registry, and deploy a new revision.

## Database — Neon

- Serverless Postgres, free tier, **scales to zero**. Region eu-central-1 (Frankfurt).
- Database: `neondb`. Connection string is the **direct** (non-pooled) endpoint
  `ep-soft-sea-asykboyr...` — fine at this scale; for higher concurrency switch
  to the `-pooler` host.
- Schema is managed by **Drizzle**; migrations live in `drizzle/`.
- Neon Auth: **not used** (we run our own Google auth).
- **Verbs mode (VERBS.md)** adds three tables — `verbs` (a *global*, shared
  catalog, no owner), `verb_review_state`, `verb_reviews` — via
  `drizzle/0002_*.sql`. The ~100-verb catalog itself is seeded by a **data
  migration** (`drizzle/0003_seed_verbs.sql`, `INSERT … ON CONFLICT (infinitive)
  DO NOTHING`, generated from `server/db/verbs.ts`), so it lands in **both**
  branches through the normal `db:migrate` path — dev locally, prod via the CI
  `migrate` job. To grow the catalog later: edit `server/db/verbs.ts`, then either
  `npm run db:seed:verbs` (idempotent upsert against the current `DATABASE_URL`)
  or add a new data migration.
- **Frequency word corpus.** `drizzle/0004_*.sql` makes `decks.owner_id` nullable
  and adds `cards.frequency_rank`; `drizzle/0005_seed_words.sql` inserts one
  *global* (null-owner) deck + ~3,700 cards — a plain multi-row `INSERT` (like the
  verb seed), guarded so a hand re-run won't duplicate the deck. Same
  `db:migrate` path lands it in both branches (dev locally, prod via CI). The
  corpus + this migration are regenerated from the source Anki `.apkg` by
  `scripts/gen-words.ts`; `npm run db:seed:words` loads it against the current
  `DATABASE_URL` for a fresh DB.

### Branches & migrations

- **`main`** (production) — the branch Cloud Run connects to (`DATABASE_URL`
  secret). Migrations are applied by **CI** on push to `main` (see CI/CD below),
  so prod schema tracks `main` automatically. Don't run `db:migrate` against prod
  by hand.
- **`dev`** — a Neon branch (copy-on-write clone of `main`) used for **local
  development**. Local `.env` `DATABASE_URL` points here, so `npm run dev` and
  local scripts never touch real prod data. Apply migrations to it locally with
  `npm run db:migrate` while iterating on `schema.ts`.
- Create/manage branches in the Neon console (Project → Branches). Each branch
  has its own connection string; the `dev` branch's string goes in local `.env`
  only (never committed).

## Auth — Google OAuth

- OAuth client (Web application) in project `language-499814`,
  client id `639264903663-41pk8tu0cb9315k0t4glnj207bl6bm7b.apps.googleusercontent.com`.
- Consent screen: **External**, in **Testing** mode (no Google review needed).
  Allowed sign-ins are the **test users** + the app's own `ALLOWED_EMAILS`.
- Authorized redirect URIs:
  - `http://localhost:5173/api/auth/callback` (dev)
  - `https://language.levanto.dev/api/auth/callback` (prod)
- App-level allowlist: `ALLOWED_EMAILS` secret (currently the two personal Gmail
  accounts). The Google client secret is the `GOOGLE_CLIENT_SECRET` secret.

## Web Push — daily training reminders

Opt-in push notification each morning when a user has cards/verbs due. No always-on
server: a **GitHub Actions schedule** (`.github/workflows/reminders.yml`, `cron
"0 16 * * *"` = 18:00 CEST / 17:00 CET; GitHub cron is UTC and can lag a few minutes)
POSTs `/api/push/send-reminders`, which wakes Cloud Run, computes each subscribed
user's pending set, and pushes only to those with work left (never nags on an empty
day). Dead subscriptions (404/410) are pruned at send time.

**Pieces:** `server/push-routes.ts` (routes) + `server/push/*` (send wrapper, due
counts, message) + `web/src/push.ts` + `web/public/{sw.js,manifest.webmanifest,
icon.svg}`. Uses the `web-push` library (VAPID). The whole feature is gated on the
VAPID pair being present — with it unset, the endpoint returns 503 and the client
hides the toggle, so local dev / PR CI run fine without any of these.

**One-time setup (required for it to actually send):**

1. **Generate a VAPID pair** (once, reused forever):
   ```sh
   npx web-push generate-vapid-keys   # prints publicKey / privateKey (base64url)
   ```
2. **Generate a cron secret:** `openssl rand -hex 32`.
3. **Create the three secrets** in Secret Manager (project `language-499814`):
   ```sh
   printf '%s' "<publicKey>"  | gcloud secrets create VAPID_PUBLIC_KEY  --data-file=- --project=language-499814
   printf '%s' "<privateKey>" | gcloud secrets create VAPID_PRIVATE_KEY --data-file=- --project=language-499814
   printf '%s' "<cronSecret>" | gcloud secrets create CRON_SECRET       --data-file=- --project=language-499814
   ```
   (The runtime SA already has project-wide `secretAccessor`.) They're wired into the
   deploy's `--set-secrets` in `.github/workflows/deploy.yml`; the next push to main
   picks them up.
4. **Add the GitHub repo secret `CRON_SECRET`** (same value as step 2) so the
   reminders workflow can authenticate: repo → Settings → Secrets and variables →
   Actions → New repository secret.
5. **Trigger a test run:** Actions → *Daily reminders* → *Run workflow*. With no
   subscribers yet it's a no-op; enable the "Daily reminder" toggle in the app first
   (on iPhone: Share → *Add to Home Screen*, open the installed app, then toggle on —
   iOS only delivers Web Push to an installed PWA).

**Rotating keys:** add a new secret version and redeploy. Rotating the VAPID pair
invalidates every existing subscription — users must toggle reminders off/on again.

## Domain — levanto.dev

- `language.levanto.dev` is the public URL.
- `levanto.dev` is **verified** for the Google account (Search Console TXT record).
- Cloud Run **domain mapping created** in europe-west1 for `language.levanto.dev`.
- **Required DNS record** at the `levanto.dev` zone:

  | Host | Type | Value |
  |---|---|---|
  | `language` | `CNAME` | `ghs.googlehosted.com.` |

- After the CNAME resolves, Google auto-provisions the TLS cert (minutes to ~1h).
  Until then the app is reachable at the run.app URL above.

## CI/CD

**Active.** `.github/workflows/deploy.yml` runs on every push to `main` (and via
manual `workflow_dispatch`) as three jobs: **check** → **migrate** → **deploy**.
`check` (typecheck + test + build) also runs on PRs and gates everything.
`migrate` applies pending Drizzle migrations to the **prod** Neon branch, reading
`DATABASE_URL` from Secret Manager. `deploy` does `gcloud run deploy --source .`.
Auth is via **Workload Identity Federation** — no service-account keys.

- The deploy SA needs `roles/secretmanager.secretAccessor` on the `DATABASE_URL`
  secret so the `migrate` job can read the prod connection string:
  ```sh
  gcloud secrets add-iam-policy-binding DATABASE_URL \
    --member="serviceAccount:github-deployer@language-499814.iam.gserviceaccount.com" \
    --role="roles/secretmanager.secretAccessor" --project=language-499814
  ```

WIF setup (project `language-499814`):
- Deploy service account: `github-deployer@language-499814.iam.gserviceaccount.com`,
  with roles: `run.admin`, `cloudbuild.builds.editor`, `artifactregistry.admin`,
  `storage.admin`, `iam.serviceAccountUser`, `secretmanager.viewer`.
- Workload Identity Pool `github`, OIDC provider `github-provider`
  (issuer `https://token.actions.githubusercontent.com`), restricted by
  attribute condition `assertion.repository=='philipclaesson/language'`.
- The repo is allowed to impersonate the deploy SA via `roles/iam.workloadIdentityUser`
  on member
  `principalSet://iam.googleapis.com/projects/639264903663/locations/global/workloadIdentityPools/github/attribute.repository/philipclaesson/language`.
- GitHub repo secrets: `GCP_WIF_PROVIDER` (the provider resource name) and
  `GCP_DEPLOY_SA` (the deploy SA email).

Manual CLI deploys still work too (see below) — useful for hotfixes.

A second workflow, `.github/workflows/reminders.yml`, runs on a daily `schedule`
(and `workflow_dispatch`) and just curls `/api/push/send-reminders` with the
`CRON_SECRET` repo secret — no GCP auth needed. See **Web Push** above.

## Common operations

```sh
# Manual deploy (from repo root, authenticated as an owner of the project)
gcloud run deploy language --project=language-499814 --region=europe-west1 \
  --source=. --allow-unauthenticated --min-instances=0 --max-instances=2 \
  --memory=512Mi --set-env-vars=BASE_URL=https://language.levanto.dev \
  --set-secrets=DATABASE_URL=DATABASE_URL:latest,GOOGLE_CLIENT_ID=GOOGLE_CLIENT_ID:latest,GOOGLE_CLIENT_SECRET=GOOGLE_CLIENT_SECRET:latest,SESSION_SECRET=SESSION_SECRET:latest,ALLOWED_EMAILS=ALLOWED_EMAILS:latest,ANTHROPIC_API_KEY=ANTHROPIC_API_KEY:latest

# Update a secret (adds a new version; redeploy or it picks up :latest on next revision)
printf '%s' "NEW_VALUE" | gcloud secrets versions add SESSION_SECRET --data-file=- --project=language-499814

# Add an allowed user: update ALLOWED_EMAILS secret, then redeploy
# Roll back to a previous revision
gcloud run services update-traffic language --region=europe-west1 --to-revisions=REVISION=100

# Tail logs
gcloud run services logs read language --region=europe-west1 --project=language-499814
```

## Cost

Effectively **$0/month** at two-user scale: Cloud Run and Neon both scale to zero,
Secret Manager and Artifact Registry storage are negligible. The only usage-based
cost is LLM API calls from the AI chat tutor (Anthropic, Sonnet 4.6) — a few cents
for occasional deck-building chats at two-user volume.

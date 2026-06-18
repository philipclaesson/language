# Infrastructure

Plain-markdown record of everything we provisioned (no IaC). Update this file
when infra changes. Secret *values* are never stored here — only names.

Last updated: 2026-06-18.

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
- **Env var:** `BASE_URL=https://language.levanto.dev`
  (also `NODE_ENV=production`, `PORT=8080` baked into the Docker image).
- **Secrets** (mounted as env vars, all `:latest`): `DATABASE_URL`,
  `GOOGLE_CLIENT_ID`, `GOOGLE_CLIENT_SECRET`, `SESSION_SECRET`, `ALLOWED_EMAILS`.

### Secret Manager
Secrets (values not shown): `DATABASE_URL`, `GOOGLE_CLIENT_ID`,
`GOOGLE_CLIENT_SECRET`, `SESSION_SECRET`, `ALLOWED_EMAILS`.
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
- Schema is managed by **Drizzle**; migrations live in `drizzle/` and are applied
  with `npm run db:migrate`.
- Neon Auth: **not used** (we run our own Google auth).

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

- `.github/workflows/deploy.yml`: deploys on push to `main` via
  `gcloud run deploy --source .`. **Not active yet** — needs Workload Identity
  Federation set up and repo secrets `GCP_WIF_PROVIDER` + `GCP_DEPLOY_SA`.
- Until CI is wired up, deploys are done manually from the CLI (see below).

## Common operations

```sh
# Manual deploy (from repo root, authenticated as an owner of the project)
gcloud run deploy language --project=language-499814 --region=europe-west1 \
  --source=. --allow-unauthenticated --min-instances=0 --max-instances=2 \
  --memory=512Mi --set-env-vars=BASE_URL=https://language.levanto.dev \
  --set-secrets=DATABASE_URL=DATABASE_URL:latest,GOOGLE_CLIENT_ID=GOOGLE_CLIENT_ID:latest,GOOGLE_CLIENT_SECRET=GOOGLE_CLIENT_SECRET:latest,SESSION_SECRET=SESSION_SECRET:latest,ALLOWED_EMAILS=ALLOWED_EMAILS:latest

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
cost later will be LLM API calls when the AI modules land.

# lockdown-api (Hexcore)

The `api` service in `docker-compose.yml` runs **[lockdown-api](https://github.com/Hexcore-Labs/agent-lockdown-web/tree/development/packages/lockdown-api)** from the **agent-lockdown-web** monorepo.

## Image

| Registry | Tag (default) |
|----------|----------------|
| `ghcr.io/hexcore-labs/lockdown-api` | `development` (monorepo `development` branch CI) |

Override in `.env`:

```env
LOCKDOWN_API_IMAGE_TAG=development
# production after merge to main: latest or main
```

CI publishes from [agent-lockdown-web `.github/workflows/docker-build.yml`](https://github.com/Hexcore-Labs/agent-lockdown-web/blob/development/.github/workflows/docker-build.yml).

The standalone [Hexcore-Labs/lockdown-api](https://github.com/Hexcore-Labs/lockdown-api) repository is **deprecated** — do not build or publish from it.

## Required env (shared `.env`)

| Variable | Purpose |
|----------|---------|
| `DATABASE_URL` | CTFd DB (also used by lockdown-api) |
| `API_KEY` | lockdown-api auth (`x-api-key` / tRPC) |
| `LOCKDOWN_PUBLIC_URL` | Public origin for snapshot download URLs |
| `SNAPSHOTS_DIR` | `/data/snapshots` |
| `SNAPSHOT_MODE` | `strict` (native SQL snapshots) |
| `UPLOAD_FOLDER` | `/var/uploads` (shared with CTFd when `UPLOAD_PROVIDER=filesystem`) |
| `CTFD_URL` | Set in compose: `http://ctfd:8000` |

Dokploy provisioning (agent-lockdown-web) injects these automatically.

## Redeploy after monorepo updates

```bash
docker compose pull api
docker compose up -d api
```

Or trigger **compose.deploy** from Dokploy for provisioned competitions.

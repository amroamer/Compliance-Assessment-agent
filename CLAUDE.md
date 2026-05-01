# CLAUDE.md — Compliance Assessment Platform

> **Purpose:** KPMG Saudi Arabia's unified regulatory compliance assessment platform covering NDI, NAII, Qiyas, SAMA ITGF, and AI Badges frameworks across Saudi government entities.

---

## Core Principle

**Never report a task as "done" unless you have actually run and verified the result.** Saying it works is not the same as proving it works. Run the verification loop below before any "done" claim.

---

## Stack

| Layer | Technology | Version |
|-------|-----------|---------|
| Frontend | Next.js 15 (App Router) + React 19 + TypeScript | 15.x |
| Backend | FastAPI (async Python) | 0.115.x |
| Database | PostgreSQL + asyncpg | 16 |
| ORM | SQLAlchemy (async) | 2.x |
| Proxy | Nginx (reverse proxy + static) | latest |
| Containers | Docker Compose (4 services: db, backend, frontend, nginx) | - |
| AI Engine | Ollama (local) + Gemma 4 / Qwen | - |
| Styling | Tailwind CSS (KPMG design tokens) | 3.x |

**Frontend principles:** App Router server components where possible, TanStack Query for data fetching, KPMG brand palette (blue anchor + teal accent), Arial typography, squared radii (2-4px), tabular-nums.

**Backend principles:** Async-first, Pydantic schemas for every endpoint, SQLAlchemy ORM with `selectinload` for relations, JWT auth with 3 roles (admin/kpmg_user/client), per-route `require_role()` guards.

---

## Ports

| Service | Internal | External | URL |
|---------|----------|----------|-----|
| Nginx (gateway) | 80 | **4200** | http://localhost:4200 |
| Backend API | 8000 | 4201 | http://localhost:4201 |
| Frontend Dev | 3000 | 3001 | http://localhost:3001 |
| PostgreSQL | 5432 | 5432 | - |

---

## Commands (Copy-Paste Ready)

### Build / Run
```bash
# Full rebuild all 4 services (use for dependency changes or first start)
docker compose up -d --build

# Frontend only (after TSX/CSS changes)
docker compose up -d --build frontend

# Backend restarts automatically via uvicorn --reload, but if imports change:
docker restart ai-badges-backend-1

# After ANY container recreation, restart nginx to fix 502:
docker restart ai-badges-nginx-1
```

### Logs
```bash
docker logs ai-badges-backend-1 --tail 30
docker logs ai-badges-frontend-1 --tail 10
docker logs ai-badges-db-1 --tail 20
```

### Database
```bash
# Shell
docker exec -it ai-badges-db-1 psql -U aibadges -d aibadges

# Backup
docker exec ai-badges-db-1 pg_dump -U aibadges -d aibadges --no-owner --no-acl > backups/backup_$(date +%Y%m%d).sql

# Restore
cat backups/backup.sql | docker exec -i ai-badges-db-1 psql -U aibadges -d aibadges

# Full server-style migration (drop all + recreate + load seed data)
docker cp migrations/ ai-badges-db-1:/tmp/migrations/
docker exec ai-badges-db-1 sh -c "chmod +x /tmp/migrations/migrate.sh && /tmp/migrations/migrate.sh"
```

### Tests (only when user requests)
```bash
# Run all backend tests (248 tests across 23 files)
docker exec ai-badges-backend-1 pytest backend/tests/ -v

# Run one test file
docker exec ai-badges-backend-1 pytest backend/tests/test_assessment_engine.py -v

# Run one specific test
docker exec ai-badges-backend-1 pytest -k "test_login_fails_with_expired_token" -v
```

### Lint / Type-check (only when user requests)
```bash
# Frontend
docker exec ai-badges-frontend-1 npm run lint
docker exec ai-badges-frontend-1 npx tsc --noEmit

# Backend (no linter configured; Pydantic handles runtime validation)
```

### Deploy (Azure VM)
```bash
# On the VM
cd /opt/AI-Badges
git pull origin main
docker compose up -d --build
docker restart ai-badges-nginx-1

# If schema/data needs updating:
docker cp migrations/ ai-badges-db-1:/tmp/migrations/
docker exec ai-badges-db-1 sh -c "chmod +x /tmp/migrations/migrate.sh && /tmp/migrations/migrate.sh"
```

---

## Verification Loop (MANDATORY before "done")

After any non-trivial change, run these in order:

1. **Build succeeds:**
   ```bash
   docker compose up -d --build <service>
   ```
   No `ERROR` lines, no TypeScript errors, no SQLAlchemy warnings.

2. **Container stays up:**
   ```bash
   docker logs ai-badges-<service>-1 --tail 20
   ```
   Last line should be `Application startup complete.` (backend) or `Ready in Xms` (frontend). If you see a traceback, STOP and fix the root cause.

3. **Nginx restarted** (if any container was recreated):
   ```bash
   docker restart ai-badges-nginx-1
   ```

4. **Endpoint smoke test** (for API changes):
   ```bash
   curl -s -o /dev/null -w "%{http_code}" http://localhost:4200/api/health  # Must be 200
   ```

5. **UI smoke test** (for frontend changes):
   ```bash
   curl -s -o /dev/null -w "%{http_code}" http://localhost:4200/  # Must be 200
   ```

6. **Report** exactly what was changed + which URL/screen is affected.

If any step fails, STOP. Do not pile more changes on broken code. Diagnose the root cause before attempting another fix.

---

## DO NOT TOUCH

These files/paths require explicit user permission:

| Path | Why |
|------|-----|
| `.env` | Contains secrets (JWT, DB password). Never commit. Never paste contents into chat. |
| `migrations/001_schema.sql` | Regenerated from pg_dump only when schema is locked in. Don't hand-edit. |
| `migrations/002_seed_data.sql` | Regenerated from pg_dump only. Don't hand-edit. |
| `backend/app/models/*.py` | Model changes break migrations. Coordinate with schema/data export. |
| `docker-compose.yml` | Port mappings and service wiring are stable. Changing ports breaks nginx. |
| `nginx/nginx.conf` | Wiring for local + `/AICompAgent` subpath. Adding new routes requires both locations. |
| `backend/app/main.py` lifespan + `_run_migrations` | DB bootstrap on startup. Only add `ADD COLUMN IF NOT EXISTS` style changes here. |
| Production DB | Never run destructive queries (DROP, TRUNCATE, DELETE without WHERE) on any DB named `aibadges` without a backup first. |

If a task genuinely needs one of these touched, tell the user first, wait for confirmation, and take a backup if it's the DB.

---

## Default Behaviors

**Do automatically:**
- Build + verify after code changes (per the Verification Loop above)
- Import new files/routes where they belong (e.g. `main.py` router registration)
- Remove dead code, unused imports, commented-out blocks you created
- Match existing code style (file naming, indent, quote style, component patterns)

**Do ONLY when asked:**
- Run tests (`pytest`)
- Run linter
- Commit to git
- Push to GitHub
- Create new files if an existing one would do

**Never:**
- Push to `main` with `--force` on any branch except throwaway work-branches
- Skip hooks (`--no-verify`, `--no-gpg-sign`) unless the user explicitly asks
- Assume an import or config change works without running it
- Say "this should work" — either prove it or flag what you couldn't verify

---

## Key Patterns (Cheat Sheet)

**Frontend:**
- `API_BASE` = `(process.env.NEXT_PUBLIC_BASE_PATH || "") + "/api"` — every fetch uses this
- Auto-save in workspace: 1.5s debounce, `useEffect` on formData changes
- Blob downloads for exports: `fetch()` + `Authorization: Bearer`, NOT `<a href>` (loses token)
- Confirmation dialogs: `useConfirm()` hook, never `window.confirm()`
- Search inputs: add `autoComplete="off"` to prevent browser from filling with email
- KPMG logo: use the squares + wordmark lockup (see Sidebar.tsx)

**Backend:**
- All routers registered in `main.py` under `app.include_router(...)`
- Models registered in `app/models/__init__.py` for Base.metadata.create_all() to pick them up
- Use `require_role("admin")` for writes, `get_current_user` for reads
- Idempotent migrations go in `_run_migrations()` in main.py (`ALTER TABLE ADD COLUMN IF NOT EXISTS`)
- Multi-line text fields (Arabic, long descriptions): use `Text`, not `String(n)`
- Per-entity data (assessments, phases): use `assessment_instance.current_phase_id`, NOT cycle-level

**Database:**
- UUIDs everywhere (`uuid.uuid4()` default)
- `created_at` / `updated_at` with `DEFAULT NOW()` and `onupdate`
- `ON DELETE CASCADE` for dependent data, `ON DELETE SET NULL` for optional refs
- Circular FKs (phase ↔ instance): handle via `ALTER TABLE` in `_run_migrations`

---

## Frameworks Reference

| Framework | Abbr | Hierarchy | Assessable Level | Total Nodes | Regulator |
|-----------|------|-----------|-----------------|-------------|-----------|
| National Data Index | NDI | Domain > Question > Specification | Specification | 478 | SDAIA |
| National AI Index | NAII | Domain > Sub-Domain > Question | Question | 26 | SDAIA |
| Qiyas Digital Transformation | QIYAS | Perspective > Axis > Standard > Requirement | Requirement | 390 | DGA |
| SAMA IT Governance Framework | ITGF | Domain > Sub-Domain > Control | Control | 513 | SAMA |
| AI Badges (Ethics) | AI_BADGES | Report > Requirement | Requirement | 48/product | SDAIA |

Default admin: `admin@kpmg.com` / `Admin123!`

---

## Common Issues (Seen Before)

| Symptom | Cause | Fix |
|---------|-------|-----|
| 502 Bad Gateway on any URL | Container recreated but nginx not restarted | `docker restart ai-badges-nginx-1` |
| Arabic shows as `??????` in PDF/Excel | Missing IBM Plex Sans Arabic font | Ensure font imported in tailwind config & Excel cells use openpyxl with proper font |
| Export returns 401 | Using `<a href>` download (no auth header) | Switch to `fetch()` + blob download with Bearer token |
| FK constraint error on delete | Deleting parent with children | Nullify references first or add CASCADE to FK |
| Search input auto-fills with email | Browser autocomplete | Add `autoComplete="off"` to the input |
| Excel import shows `#REF!` | Reading across sheets with formulas | Use `openpyxl.load_workbook(path, data_only=True)` |
| Multi-line COPY data fails in seed import | psql can't parse INSERT with embedded newlines | Use `pg_dump` default COPY format, not `--inserts` |
| `psycopg2` can't find tables after schema load | pg_dump sets `search_path = ''` | Reset with `SET search_path TO public` |

---

## Testing Notes (Only When Requested)

- 248 backend tests in `backend/tests/`
- pytest + httpx async, runs against live Docker on port 8000
- Use UUID-suffix names to avoid collisions across parallel runs
- Share fixtures via `conftest.py`: `http`, `base_url`, `admin_headers`
- Test names must describe the case: `test_X_fails_when_Y`, not `test_case_1`

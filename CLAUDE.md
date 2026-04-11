# CLAUDE.md

## Core Principle
Never report a task as "done" or "complete" unless you have **actually run and verified** the result. Saying it works is not the same as proving it works.

## Step 1: Detect the Project
Before making any changes, identify:
- The language and framework (check package.json, requirements.txt, pom.xml, Cargo.toml, go.mod, Gemfile, etc.)
- The build command (npm run build, pip install, mvn package, cargo build, go build, dotnet build, etc.)
- The run command (npm run dev, python app.py, ./gradlew bootRun, cargo run, etc.)
- The test command (npm test, pytest, mvn test, cargo test, go test, etc.)
- List these at the start of every session so we are aligned.

## Step 2: After Every Code Change
1. **Build the project** using the detected build command. Fix all errors before moving on.
2. **Run the linter** if one is configured (eslint, flake8, ruff, clippy, etc.). Fix warnings.
3. **Run existing tests** if any exist. Fix failures before reporting done.
4. **Start the application** and confirm it launches without crashing.
5. If you created a new file, route, component, endpoint, or module — verify it is properly imported, registered, and reachable.

## Step 3: Before Reporting Done
1. Run `git diff --stat` and list every file you added or modified.
2. Summarize what changed and why in plain language.
3. Confirm build passes (exit code 0).
4. Confirm the app starts cleanly (no stacktraces, no missing modules).
5. If the task is UI-related, state which URL or screen the change appears on.

## Do NOT
- Skip the build or test step for any reason.
- Assume an import, dependency, or config change works without running it.
- Leave dead code, unused imports, or commented-out blocks.
- Say "this should work" — either verify it does or say you could not verify and explain why.
- Make changes to multiple files without building after each logical chunk.
- Ignore warnings — treat them as errors unless I explicitly say otherwise.

## If Something Breaks
- Stop immediately. Do not keep making more changes on top of broken code.
- Show the full error output.
- Diagnose the root cause before attempting a fix.
- After fixing, re-run the full build + test cycle from scratch.

## General Standards
- Keep changes minimal and focused. One task = one logical change.
- Prefer editing existing files over creating new ones when possible.
- Match the existing code style, naming conventions, and patterns in the project.
- If a task requires installing a new dependency, state it explicitly and explain why.

---

## Project: Compliance Assessment Platform (AI Badges)

### Stack
| Layer | Technology | Version |
|-------|-----------|---------|
| Frontend | Next.js (React 19, TypeScript) | 15.x |
| Backend | FastAPI (Python, async) | 0.115.x |
| Database | PostgreSQL (asyncpg) | 16 |
| Proxy | Nginx | latest |
| Containerization | Docker Compose (4 services) | - |

### Build & Run Commands
```bash
# Full rebuild + start
docker compose up -d --build

# Restart after code change (hot-reload works for backend, frontend needs rebuild)
docker compose up -d --build frontend   # Frontend changes
docker restart ai-badges-backend-1      # Backend changes (hot-reload via uvicorn --reload)
docker restart ai-badges-nginx-1        # After container recreation (fixes 502)

# Logs
docker logs ai-badges-backend-1 --tail 20
docker logs ai-badges-frontend-1 --tail 10

# Database access
docker exec ai-badges-db-1 psql -U aibadges -d aibadges
```

### Ports
| Service | Internal | External | URL |
|---------|----------|----------|-----|
| Nginx (gateway) | 80 | **4200** | http://localhost:4200 |
| Backend (FastAPI) | 8000 | 4201 | http://localhost:4201 |
| Frontend (Next.js) | 3000 | 3001 | http://localhost:3001 |
| Database (PostgreSQL) | 5432 | 5432 | - |

### Auth
- JWT-based, roles: `admin`, `kpmg_user`, `client`
- Default admin: `admin@kpmg.com` / `Admin123!`
- Token stored in `localStorage("token")`

### Directory Structure
```
AI-Badges/
  backend/
    app/
      api/                    # FastAPI route handlers
        assessment_engine.py  # Main API (60+ endpoints)
        ai_products.py        # AI product CRUD
        framework_docs.py     # Bulk export/import
        hierarchy.py          # Framework node CRUD
        regulatory_entities.py
      models/                 # SQLAlchemy models
        assessment_engine.py  # Core models (Entity, Instance, Response, etc.)
        framework_node.py     # FrameworkNode, NodeType
        compliance_framework.py
      services/               # Business logic
        pdf_report_service.py # PDF report generation
        assessment_report_service.py # Excel report
        prompt_assembly.py    # AI assessment prompt builder
      core/                   # Auth, permissions, config
    requirements.txt
  frontend/
    src/
      app/                    # Next.js App Router pages
        assessments/          # Assessment workspace
        dashboard/            # Main dashboard
        settings/             # Admin config pages
        entities/             # Entity detail pages
        frameworks/           # Framework config
      components/             # Reusable UI components
      lib/api.ts              # API client (API_BASE export)
      providers/              # Auth, Locale, Confirm providers
    next.config.ts
  nginx/nginx.conf
  scripts/                    # Data loader scripts
  backups/                    # Database backups
  docker-compose.yml
```

### Frameworks (5 total)
| Framework | Abbreviation | Levels | Assessable Level | Nodes |
|-----------|-------------|--------|-----------------|-------|
| NDI | NDI | Domain > Question > Specification | Specification | 478 |
| NAII | NAII | Domain > Sub-Domain > Question | Question | 26 |
| Qiyas | QIYAS | Perspective > Axis > Standard > Requirement | Requirement | 390 |
| ITGF | ITGF | Domain > Sub-Domain > Control | Control | 513 |
| AI Badges | AI_BADGES | Report > Requirement | Requirement | 48 |

### Key Patterns
- **API_BASE**: `(process.env.NEXT_PUBLIC_BASE_PATH || "") + "/api"` — all frontend fetch calls use this
- **Auto-save**: Assessment workspace uses 1.5s debounce for form fields
- **Multi-product**: AI Badges creates `nodes x products` responses per assessment instance
- **Export buttons**: Use `fetch()` + blob download (not `<a href>`) to include auth token
- **ConfirmProvider**: Global `useConfirm()` hook replaces all browser `confirm()` calls
- **Node types**: Each framework has configurable node types with `is_assessable_default` flag
- **Assessment forms**: Per-field `scale_id` allows multiple scales per form template

### Database Backup & Restore
```bash
# Backup
docker exec ai-badges-db-1 pg_dump -U aibadges -d aibadges --no-owner --no-acl > backups/backup.sql

# Restore
cat backups/backup.sql | docker exec -i ai-badges-db-1 psql -U aibadges -d aibadges
```

### Common Issues
- **502 from nginx**: Run `docker restart ai-badges-nginx-1` after container rebuilds
- **Arabic text as ??????**: Ensure IBM Plex Sans Arabic font is in tailwind.config.ts font-family
- **Export 401**: Use `fetch()` with Bearer token, not `<a href>` links
- **FK constraint on delete**: Nullify references before deleting (scales, nodes, etc.)
- **`#REF!` in Excel imports**: Use data_only=True with openpyxl; cross-reference from other sheets

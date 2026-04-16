# Database Migration Guide — Azure VM Deployment

> **Project:** Compliance Assessment Platform (AI Badges)
> **Source:** Local dev environment (Windows, Docker Compose)
> **Target:** Azure VM with PostgreSQL in Docker
> **Last Updated:** April 2026

---

## Table of Contents

1. [What Was Migrated](#1-what-was-migrated)
2. [Prerequisites](#2-prerequisites)
3. [Migration Files](#3-migration-files)
4. [Step-by-Step: Fresh Deployment](#4-step-by-step-fresh-deployment)
5. [Step-by-Step: Updating Existing Deployment](#5-step-by-step-updating-existing-deployment)
6. [Verification](#6-verification)
7. [Rollback](#7-rollback)
8. [Environment Variables](#8-environment-variables)
9. [Appendix: Table Reference](#9-appendix-table-reference)

---

## 1. What Was Migrated

### Schema (47 tables)

The platform uses **SQLAlchemy ORM** with `Base.metadata.create_all()` on startup — tables are auto-created from Python model definitions. The migration script (`migrate.py`) provides a standalone alternative using `pg_dump` schema output for environments without the app running.

### Key tables by function:

| Category | Tables | Description |
|----------|--------|-------------|
| **Auth** | `users` | 3 roles: admin, kpmg_user, client |
| **Frameworks** | `compliance_frameworks`, `framework_nodes`, `node_types`, `framework_documents` | 5 frameworks, 1769 nodes |
| **Scales & Forms** | `assessment_scales`, `assessment_scale_levels`, `assessment_form_templates`, `assessment_form_fields` | Scoring scales and form config |
| **Scoring** | `aggregation_rules`, `assessment_node_scores` | Score roll-up rules |
| **Entities** | `assessed_entities`, `regulatory_entities`, `entity_frameworks`, `entity_regulatory_entities` | Government entities and regulators |
| **Departments** | `entity_departments`, `entity_department_users`, `node_assignments` | Department-based node responsibility |
| **AI Products** | `ai_products` | Products assessed under AI Badges framework |
| **Cycles & Phases** | `assessment_cycle_configs`, `assessment_cycle_phases`, `phase_templates` | Assessment periods with lifecycle phases |
| **Assessments** | `assessment_instances`, `assessment_responses`, `assessment_evidence`, `assessment_response_history` | Runtime assessment data |
| **Phase Tracking** | `assessment_phase_log` | Per-instance phase transitions |
| **Regulator Feedback** | `regulator_feedback`, `regulator_evidence` | Regulator review feedback per node |
| **AI Assessment** | `ai_assessment_logs`, `llm_models` | LLM model config and assessment logs |
| **Legacy** | `entities`, `products`, `documents`, `domain_assessments`, etc. | Kept for backward compatibility |

### Data (3,781 rows)

| Table | Rows | Notes |
|-------|------|-------|
| `framework_nodes` | 1,769 | NDI (478), Qiyas (516), NAII (26), ITGF (513), AI Badges (48) + parents |
| `assessment_responses` | 964 | MOTLS Qiyas (390) + AI Badges responses |
| `node_assignments` | 516 | MOTLS department → node mappings |
| `llm_models` | 198 | AI model configurations |
| `users` | 3 | admin@kpmg.com (Admin123!), + 2 test users |
| `compliance_frameworks` | 5 | NDI, NAII, Qiyas, ITGF, AI Badges |
| `regulatory_entities` | 3 | SDAIA, DGA, SAMA |
| `assessed_entities` | 3 | MOF, MOH, MOTLS |
| All others | ~300 | Scales, forms, cycles, phases, etc. |

### Startup Migrations (run automatically by the app)

On every application startup, `main.py` runs:

```python
# 1. Auto-create all tables from SQLAlchemy models
await conn.run_sync(Base.metadata.create_all)

# 2. Add columns that create_all won't ALTER onto existing tables
ALTER TABLE assessment_instances
  ADD COLUMN IF NOT EXISTS current_phase_id UUID
  REFERENCES assessment_cycle_phases(id) ON DELETE SET NULL;

# 3. Backfill Phase 1 for existing assessment instances
UPDATE assessment_instances SET current_phase_id = (
    SELECT acp.id FROM assessment_cycle_phases acp
    WHERE acp.cycle_id = assessment_instances.cycle_id
    ORDER BY acp.sort_order ASC LIMIT 1
) WHERE current_phase_id IS NULL AND EXISTS (
    SELECT 1 FROM assessment_cycle_phases WHERE cycle_id = assessment_instances.cycle_id
);

# 4. Seed admin user if none exists
INSERT admin@kpmg.com / Admin123! (if users table is empty)
```

---

## 2. Prerequisites

### On the Azure VM

- **Docker** and **Docker Compose** installed
- **Git** access to the repository
- **PostgreSQL 16** container (created by docker-compose)
- Ports: `4200` (nginx), `4201` (backend API), `3001` (frontend dev), `5432` (postgres)

### Files needed

All files are in the git repository:

```
backend/scripts/
  migrate.py              # Migration runner script
  migration_schema.sql    # Full schema DDL (pg_dump output)
  migration_data.sql      # All seed data (pg_dump COPY format)
```

---

## 3. Migration Files

### `backend/scripts/migrate.py`

Self-contained Python script that:
1. Connects to PostgreSQL using `psycopg2`
2. Creates all 47 tables from `migration_schema.sql`
3. Loads all data from `migration_data.sql` using COPY format
4. Reports success/failure with row counts

### `backend/scripts/migration_schema.sql`

Generated by: `pg_dump --schema-only --no-owner --no-acl`

Contains:
- All `CREATE TABLE` statements with full column definitions
- All `CREATE INDEX` statements
- All `ALTER TABLE ... ADD CONSTRAINT` for foreign keys
- All `CREATE SEQUENCE` statements

### `backend/scripts/migration_data.sql`

Generated by: `pg_dump --data-only --disable-triggers`

Contains:
- `COPY tablename (columns) FROM stdin;` blocks with tab-delimited data
- `SELECT pg_catalog.setval()` calls to reset sequences
- Triggers disabled during load (handles circular FK deps)

---

## 4. Step-by-Step: Fresh Deployment

### 4.1 Clone the repository

```bash
ssh azureuser@<VM_IP>
cd /opt  # or wherever you deploy
git clone https://github.com/amroamer/Compliance-Assessment-agent.git AI-Badges
cd AI-Badges
```

### 4.2 Configure environment

```bash
# Create .env file (or copy from repo)
cat > .env << 'EOF'
POSTGRES_USER=aibadges
POSTGRES_PASSWORD=aibadges_secret_2024
POSTGRES_DB=aibadges
DATABASE_URL=postgresql+asyncpg://aibadges:aibadges_secret_2024@db:5432/aibadges

JWT_SECRET_KEY=change-this-to-a-random-string-in-production
JWT_ALGORITHM=HS256
JWT_ACCESS_TOKEN_EXPIRE_MINUTES=480

UPLOAD_DIR=/app/uploads
BACKEND_CORS_ORIGINS=["http://localhost:3000","http://localhost:80","http://localhost","http://<VM_IP>:4200"]

NEXT_PUBLIC_API_URL=http://<VM_IP>/api
NEXT_PUBLIC_BASE_PATH=
EOF
```

> Replace `<VM_IP>` with the actual Azure VM IP or domain name.
> For subpath deployment (e.g., `/AICompAgent`), set `NEXT_PUBLIC_BASE_PATH=/AICompAgent`.

### 4.3 Build and start containers

```bash
docker compose up -d --build
```

Wait for all 4 services to be healthy:

```bash
docker compose ps
# Should show: db (healthy), backend (running), frontend (running), nginx (running)
```

### 4.4 Verify auto-migration

The app automatically creates all tables on first startup via `Base.metadata.create_all()`. Check:

```bash
docker logs ai-badges-backend-1 --tail 10
# Should show: "Application startup complete."
```

### 4.5 Run data migration (seed data)

The app creates empty tables but no data. To load all framework nodes, entities, scales, etc.:

**Option A: Using migrate.py (recommended)**

```bash
# Install psycopg2 in the backend container
docker exec ai-badges-backend-1 pip install psycopg2-binary

# Run migration (uses DATABASE_URL from environment automatically)
docker exec ai-badges-backend-1 sh -c "cd /app && python scripts/migrate.py"
```

**Option B: Using pg_dump restore directly**

```bash
# Schema (if tables don't exist yet)
docker exec -i ai-badges-db-1 psql -U aibadges -d aibadges < backend/scripts/migration_schema.sql

# Data
docker exec -i ai-badges-db-1 psql -U aibadges -d aibadges < backend/scripts/migration_data.sql
```

**Option C: Full database dump/restore**

On your local machine:
```bash
docker exec ai-badges-db-1 pg_dump -U aibadges -d aibadges --no-owner --no-acl > full_backup.sql
```

On the Azure VM:
```bash
docker exec -i ai-badges-db-1 psql -U aibadges -d aibadges < full_backup.sql
```

### 4.6 Restart the application

```bash
docker compose restart backend
docker restart ai-badges-nginx-1
```

### 4.7 Test access

```bash
# API health check
curl http://localhost:4200/api/health

# Login test
curl -X POST http://localhost:4200/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@kpmg.com","password":"Admin123!"}'
```

Open in browser: `http://<VM_IP>:4200`

---

## 5. Step-by-Step: Updating Existing Deployment

If the app is already running on Azure and you need to update:

### 5.1 Pull latest code

```bash
cd /opt/AI-Badges  # or your deploy directory
git pull origin main
```

### 5.2 Rebuild containers

```bash
docker compose up -d --build
```

The app's startup `lifespan()` will:
- Run `Base.metadata.create_all()` — creates any NEW tables, skips existing ones
- Run `_run_migrations()` — adds new columns with `ADD COLUMN IF NOT EXISTS`
- Both are idempotent (safe to re-run)

### 5.3 Run data migration for new seed data (if needed)

```bash
docker exec ai-badges-backend-1 pip install psycopg2-binary
docker exec ai-badges-backend-1 sh -c "cd /app && python scripts/migrate.py"
```

The migrate script uses:
- `CREATE TABLE IF NOT EXISTS` for schema (skips existing tables)
- `COPY` with trigger-disabled mode (skips duplicate rows via unique constraints)

### 5.4 Verify

```bash
docker exec ai-badges-backend-1 sh -c "cd /app && python scripts/migrate.py --check-only"
```

---

## 6. Verification

### Check all tables exist (47 expected)

```bash
docker exec ai-badges-db-1 psql -U aibadges -d aibadges -c \
  "SELECT count(*) as tables FROM pg_tables WHERE schemaname = 'public';"
```

### Check row counts

```bash
docker exec ai-badges-db-1 psql -U aibadges -d aibadges -c "
SELECT t.tablename, (xpath('/row/cnt/text()', x.xml_count))[1]::text::int as rows
FROM pg_tables t
LEFT JOIN LATERAL (
  SELECT query_to_xml('SELECT count(*) as cnt FROM ' || quote_ident(t.tablename), false, true, '') as xml_count
) x ON true
WHERE t.schemaname = 'public' ORDER BY rows DESC;"
```

**Expected key counts:**

| Table | Expected Rows |
|-------|---------------|
| `framework_nodes` | 1,769 |
| `assessment_responses` | 964 |
| `node_assignments` | 516 |
| `users` | 3+ |
| `compliance_frameworks` | 5 |
| `regulatory_entities` | 3 |
| `assessed_entities` | 3 |

### Check login works

```bash
curl -s http://localhost:4200/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@kpmg.com","password":"Admin123!"}' | python -c "
import sys, json
r = json.load(sys.stdin)
print('Login OK' if 'access_token' in r else 'FAILED: ' + str(r))
"
```

### Check frameworks loaded

```bash
TOKEN=$(curl -s http://localhost:4200/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@kpmg.com","password":"Admin123!"}' | python -c "import sys,json;print(json.load(sys.stdin)['access_token'])")

curl -s http://localhost:4200/api/frameworks/ \
  -H "Authorization: Bearer $TOKEN" | python -c "
import sys, json
fws = json.load(sys.stdin)
for fw in fws:
    print(f\"  {fw['abbreviation']}: {fw['name']}\")
print(f'Total: {len(fws)} frameworks')
"
```

---

## 7. Rollback

### Full database reset (destructive)

```bash
# Stop the app
docker compose stop backend frontend nginx

# Drop and recreate database
docker exec ai-badges-db-1 psql -U aibadges -d postgres -c "DROP DATABASE aibadges;"
docker exec ai-badges-db-1 psql -U aibadges -d postgres -c "CREATE DATABASE aibadges;"

# Restart (creates fresh empty tables)
docker compose up -d
```

### Restore from backup

```bash
# If you took a backup before migration:
docker exec -i ai-badges-db-1 psql -U aibadges -d aibadges < backup_before_migration.sql
```

### Take a backup before any migration

```bash
docker exec ai-badges-db-1 pg_dump -U aibadges -d aibadges \
  --no-owner --no-acl > backup_$(date +%Y%m%d_%H%M%S).sql
```

---

## 8. Environment Variables

| Variable | Local Value | Azure Notes |
|----------|-------------|-------------|
| `POSTGRES_USER` | `aibadges` | Can keep same |
| `POSTGRES_PASSWORD` | `aibadges_secret_2024` | **Change in production** |
| `POSTGRES_DB` | `aibadges` | Can keep same |
| `DATABASE_URL` | `postgresql+asyncpg://aibadges:aibadges_secret_2024@db:5432/aibadges` | Must match PG credentials |
| `JWT_SECRET_KEY` | `super-secret-jwt-key-change-in-production-2024` | **Must change in production** |
| `NEXT_PUBLIC_API_URL` | `http://localhost/api` | Set to `http://<VM_IP>/api` or domain |
| `NEXT_PUBLIC_BASE_PATH` | `` (empty) | Set to `/AICompAgent` for subpath deployment |
| `UPLOAD_DIR` | `/app/uploads` | Persistent volume via Docker |

---

## 9. Appendix: Table Reference

### Complete table list (47 tables, dependency order)

```
Level 0 (no dependencies):
  users, regulatory_entities, entities, llm_models, phase_templates

Level 1:
  compliance_frameworks (→ regulatory_entities)
  assessed_entities (→ regulatory_entities)
  products (→ entities)
  customer_info (→ entities)

Level 2:
  node_types (→ compliance_frameworks)
  assessment_scales (→ compliance_frameworks)
  framework_nodes (→ compliance_frameworks, self-referencing)
  framework_documents (→ compliance_frameworks, users)
  entity_frameworks (→ assessed_entities, compliance_frameworks)
  ai_products (→ assessed_entities)
  entity_departments (→ assessed_entities)
  assessment_cycle_configs (→ compliance_frameworks)
  entity_regulatory_entities (→ assessed_entities, regulatory_entities)

Level 3:
  assessment_scale_levels (→ assessment_scales)
  assessment_form_templates (→ compliance_frameworks, node_types, assessment_scales)
  aggregation_rules (→ compliance_frameworks, node_types, assessment_scales)
  assessment_cycle_phases (→ assessment_cycle_configs)
  entity_department_users (→ entity_departments, users)
  node_assignments (→ assessed_entities, compliance_frameworks, framework_nodes, entity_departments)

Level 4:
  assessment_form_fields (→ assessment_form_templates, assessment_scales)
  assessment_template_scales (→ assessment_form_templates, assessment_scales)
  assessment_instances (→ assessment_cycle_configs, compliance_frameworks, assessed_entities, assessment_cycle_phases)

Level 5:
  assessment_responses (→ assessment_instances, framework_nodes, ai_products, assessment_form_templates)
  assessment_node_scores (→ assessment_instances, framework_nodes, ai_products)
  assessment_phase_log (→ assessment_instances, assessment_cycle_phases, users)
  regulator_feedback (→ assessment_instances, framework_nodes, assessment_cycle_phases)

Level 6:
  assessment_evidence (→ assessment_responses, users)
  assessment_response_history (→ assessment_responses, users)
  ai_assessment_logs (→ assessment_instances, framework_nodes, llm_models)
  regulator_evidence (→ regulator_feedback, users)
```

### Default admin credentials

| Email | Password | Role |
|-------|----------|------|
| `admin@kpmg.com` | `Admin123!` | admin |

> **Change the password immediately after first login in production.**

---

## Quick Reference: Common Commands

```bash
# Full rebuild + start
docker compose up -d --build

# View logs
docker logs ai-badges-backend-1 --tail 20
docker logs ai-badges-frontend-1 --tail 10

# Database shell
docker exec -it ai-badges-db-1 psql -U aibadges -d aibadges

# Run migration
docker exec ai-badges-backend-1 sh -c "pip install psycopg2-binary && cd /app && python scripts/migrate.py"

# Check migration status
docker exec ai-badges-backend-1 sh -c "cd /app && python scripts/migrate.py --check-only"

# Backup database
docker exec ai-badges-db-1 pg_dump -U aibadges -d aibadges --no-owner > backup.sql

# Restore database
docker exec -i ai-badges-db-1 psql -U aibadges -d aibadges < backup.sql

# Restart after code changes
docker compose up -d --build backend
docker restart ai-badges-nginx-1
```

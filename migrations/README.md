# AICompAgent — Database Migration

Migrates the full database (schema + data) to a fresh PostgreSQL 16 instance on an Azure VM.

## Files

| File | Description | Size |
|------|-------------|------|
| `001_schema.sql` | 47 tables, PKs, unique constraints, indexes, FKs | ~75 KB |
| `002_seed_data.sql` | All reference + operational data (INSERT statements) | ~3.1 MB |
| `migrate.sh` | Runner script — applies schema, verifies, imports data | — |
| `verify.sh` | Post-migration health check (row counts, FK integrity) | — |

## Prerequisites

- Docker Compose stack running (`docker compose up -d`)
- PostgreSQL 16 container named `badges-db` (or set `DB_CONTAINER` env var)
- Database `aibadges` with user `aibadges` (or set `DB_USER` / `DB_NAME`)

## Quick Start

```bash
# 1. Copy migrations/ folder to the VM project root
scp -r migrations/ user@vm:/path/to/AI-Badges/

# 2. SSH into VM
ssh user@vm

# 3. Start the stack
cd /path/to/AI-Badges
docker compose up -d

# 4. Run migration
chmod +x migrations/migrate.sh migrations/verify.sh
./migrations/migrate.sh

# 5. Verify (optional)
./migrations/verify.sh
```

## Configuration

Override defaults via environment variables:

```bash
DB_CONTAINER=my-pg-container DB_USER=myuser DB_NAME=mydb ./migrations/migrate.sh
```

## What migrate.sh Does

1. **Schema** — Runs `001_schema.sql` (all `CREATE TABLE IF NOT EXISTS`, idempotent)
2. **Verify** — Checks all 47 tables exist
3. **Data** — Runs `002_seed_data.sql`:
   - Disables FK checks (`session_replication_role = 'replica'`)
   - Truncates all tables (reverse dependency order)
   - Inserts all data (dependency order from pg_dump)
   - Re-enables FK checks
4. **Summary** — Prints row counts for key tables

## Expected Row Counts

| Table | Rows |
|-------|------|
| framework_nodes | 1,769 |
| assessment_responses | 964 |
| llm_models | 198 |
| assessment_form_fields | 40 |
| assessment_scale_levels | 34 |
| node_types | 15 |
| compliance_frameworks | 5 |
| entities | 3 |
| users | 3 |
| assessed_entities | 3 |
| regulatory_entities | 3 |

## Re-running

Both scripts are safe to re-run:
- Schema uses `IF NOT EXISTS` for all DDL
- Seed data truncates before inserting
- No manual cleanup needed

## Troubleshooting

**Container not found**: Make sure `docker compose up -d` has started. Check container name with `docker ps`.

**Permission denied**: Run `chmod +x migrations/*.sh`

**FK violation on import**: The seed data disables FK checks during import. If you see FK errors, the schema may be out of date — re-run `001_schema.sql` first.

**Wrong container name**: Default is `badges-db`. Override: `DB_CONTAINER=ai-badges-db-1 ./migrations/migrate.sh`

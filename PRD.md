# PRD — Compliance Assessment Platform

> **One page. Any task that drifts off this page needs scope-change approval from the product owner.**

**Owner:** KPMG Saudi Arabia · **Version:** 1.1 · **Last updated:** 2026-04-19

---

## Problem

Saudi government entities are assessed against 5+ regulatory frameworks (NDI, NAII, Qiyas, SAMA ITGF, AI Badges) by different regulators (SDAIA, DGA, SAMA) on overlapping cycles. KPMG consultants currently juggle Excel spreadsheets, PDF forms, and email threads per entity per framework. Evidence gets lost, scores get recalculated by hand, regulators can't see what stage each entity is at, and there's no single source of truth across cycles.

## Solution (one line)

A web platform that runs the entire assessment lifecycle — framework authoring, entity/department setup, phase-gated data entry, AI-assisted evidence review, regulator feedback, and scoring — for all 5 frameworks from one account.

---

## Personas

| Persona | Role | Primary need |
|---------|------|--------------|
| **KPMG Consultant** | `kpmg_user` | Configure frameworks, open/manage assessments across all entities, run AI Assess, export reports |
| **Entity Assessor** | `client` | Self-assess against requirements, upload evidence, respond to regulator feedback during corrections |
| **Entity Lead** | `client` (Lead role in department) | Approve responses, advance assessment phase, manage department members |
| **Regulator Reviewer** | `admin` (scoped) | Enter agree/disagree feedback per node, attach review reports, advance to next phase |
| **Platform Admin** | `admin` | Manage frameworks, cycles, phases, users, LLM model config, troubleshoot |

---

## In Scope

**Framework authoring**
- Multi-level hierarchy (2–4 levels) with per-node reference codes, weights, maturity levels
- Per-node-type form builder (which fields show in the Edit Node modal)
- Assessment scales (ordinal / binary / percentage) with named levels and color coding
- Form templates per node type (fields shown in the workspace)
- Scoring rules (aggregation methods: weighted_average, percentage_compliant, simple_average, etc.)
- Framework reference documents (uploaded PDFs/Excel, indexed for AI)

**Entity & organization**
- Assessed entity registry with logos, branding colors, multiple regulatory entity links
- Department structure per entity (IT, DMO, etc.) with role-based membership (Lead/Contributor/Reviewer)
- Node assignment: map framework nodes to responsible departments
- AI product registry for product-scoped frameworks (AI Badges)

**Assessment lifecycle**
- Assessment cycles per framework per year, with configurable phase lifecycle
- Per-instance phase progression (each entity moves independently through phases)
- Phase permissions enforce what's editable (data entry / upload / submit / review / corrections / read-only)
- Phase stepper and banner in the workspace; admin can advance/revert per instance
- Regulator feedback per node per phase (agree/disagree/partial) with required actions

**AI assistance**
- Ollama-backed local LLM (Gemma 4 / Qwen) analyzes uploaded evidence per node
- Returns compliance status, score, justification, document verification (approval/date/signature)
- User accepts/dismisses; accepted suggestions auto-fill the form

**Reporting & exports**
- Per-entity dashboard with per-framework scores and trends
- Excel and PDF report export per assessment
- Bulk import/export: frameworks, entities, cycles, users via Excel

**Platform**
- Bilingual UI (English/Arabic) with RTL support
- Three roles (admin, kpmg_user, client) with per-endpoint enforcement
- JWT authentication, 8-hour sessions
- Docker Compose deployment (local + Azure VM) with migration scripts

## Explicitly Out of Scope (v1.x)

- ❌ Direct regulator portal (regulators log in as `admin` users; no separate tenant model)
- ❌ Automated regulator notifications (no email/SMS on phase transitions)
- ❌ Mobile apps (responsive web only)
- ❌ Multi-tenant isolation (single KPMG instance; entities share the DB)
- ❌ Version history / time-travel on framework node edits (response history exists; framework history does not)
- ❌ Real-time collaboration (no presence, no conflict resolution beyond last-write-wins)
- ❌ Custom framework creation by non-admins (admin only)
- ❌ Public API for third-party integrations (internal only)
- ❌ Integration with SDAIA/DGA/SAMA systems (manual data transfer only)
- ❌ Payment, billing, licensing flow
- ❌ On-cloud LLMs in production (local Ollama only, for data residency)

## Assumptions & Constraints

- **Data residency:** All PII and assessment data stays in-country. No cloud LLMs in production.
- **Users:** < 500 total users, < 50 entities, < 10 cycles active at any time.
- **Load:** < 10 concurrent users during assessment windows; single-server deployment is sufficient.
- **Browser support:** Chrome/Edge latest 2 versions. Firefox/Safari work but not tested.
- **Languages:** English (primary) and Arabic (full RTL). No other languages planned.

---

## Success Criteria

### Functional (MUST have all)
- ✅ A KPMG consultant can open a new assessment cycle for an entity in < 2 minutes
- ✅ An entity assessor can fill in 10 requirements with evidence in < 5 minutes, with auto-save
- ✅ AI Assess returns a suggestion for a node with uploaded evidence in < 30 seconds
- ✅ Phase advancement is audit-logged and visible in the phase log
- ✅ Regulator feedback on 50+ nodes can be bulk-uploaded via Excel
- ✅ Per-entity overall score is calculated automatically from leaf-node scores
- ✅ Excel export of a full assessment includes all responses + evidence metadata

### Quality
- ✅ All 5 frameworks bootstrap from the migration script with zero errors
- ✅ No page in the app shows a blank state without a call-to-action
- ✅ Arabic text renders correctly in EN fields when no translation is provided (no `?????`)
- ✅ Export files do not require manual authentication reset after download

### Operational
- ✅ Fresh VM deployment: clone → `docker compose up -d --build` → migrate → live in < 10 minutes
- ✅ Backup: `pg_dump` completes in < 30 seconds; restore < 2 minutes
- ✅ 248 backend tests pass on every commit

### What we are NOT measuring (explicitly)
- Page load times under adversarial conditions
- Multi-region latency
- 99.9% uptime SLA
- User NPS scores

---

## Out-of-Scope Change Protocol

If during a task you realize something needs to be done that isn't in the "In Scope" list:

1. **Stop.** Don't build it silently.
2. **Write one sentence** describing what's needed and why.
3. **Ask the user** whether to add it to this PRD (moves in-scope) or defer it.
4. Only proceed after an explicit answer.

This PRD is the scope boundary. Everything else is scope creep.

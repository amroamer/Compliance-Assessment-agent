import uuid
from datetime import datetime, timezone

from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.audit import log_change
from app.data.framework_registry import get_framework, VALID_FRAMEWORKS
from app.models.assessment_cycle import AssessmentCycle
from app.models.naii_assessment import NaiiAssessment, NaiiDomainResponse
from app.schemas.assessment_cycle import AssessmentCycleCreate


async def create_cycle(
    db: AsyncSession, client_id: uuid.UUID, data: AssessmentCycleCreate, user_id: uuid.UUID
) -> AssessmentCycle:
    if data.framework_type not in VALID_FRAMEWORKS:
        raise ValueError(f"Invalid framework: {data.framework_type}. Must be one of {VALID_FRAMEWORKS}")

    cycle = AssessmentCycle(
        client_id=client_id,
        framework_type=data.framework_type,
        cycle_name=data.cycle_name,
        period_start=data.period_start,
        period_end=data.period_end,
        notes=data.notes,
        created_by=user_id,
    )
    db.add(cycle)
    await db.flush()

    # Framework-specific initialization
    fw = get_framework(data.framework_type)
    if data.framework_type in ("naii", "ndi", "qiyas") and fw and fw["get_all_domains"]:
        # Create assessment + domain responses (same pattern as NAII)
        year = data.period_start.year if data.period_start else datetime.now().year

        if data.framework_type == "naii":
            # Check for existing NAII assessment for this year, link if found
            existing = await db.execute(
                select(NaiiAssessment).where(
                    NaiiAssessment.entity_id == client_id,
                    NaiiAssessment.assessment_year == year,
                )
            )
            existing_naii = existing.scalar_one_or_none()
            if existing_naii:
                existing_naii.cycle_id = cycle.id
                cycle.overall_score = existing_naii.overall_score
                cycle.maturity_level = existing_naii.maturity_level
                if existing_naii.status != "not_started":
                    cycle.status = existing_naii.status
                await db.flush()
            else:
                from app.services.naii_assessment_service import create_assessment
                naii = await create_assessment(db, client_id, year, user_id)
                naii.cycle_id = cycle.id
                await db.flush()
        else:
            # Generic: create NaiiAssessment-like records for NDI/Qiyas
            assessment = NaiiAssessment(
                entity_id=client_id,
                assessment_year=year,
                status="not_started",
                cycle_id=cycle.id,
                created_by=user_id,
            )
            db.add(assessment)
            await db.flush()

            all_domains = fw["get_all_domains"]()
            for d in all_domains:
                dr = NaiiDomainResponse(
                    assessment_id=assessment.id,
                    domain_id=d["domain_id"],
                    status="not_started",
                )
                db.add(dr)
            await db.flush()

    # ai_badges: cycle created, products/domains managed separately

    await log_change(
        db, user_id, "CREATE", "assessment_cycle", cycle.id,
        after_value={"framework_type": data.framework_type, "cycle_name": data.cycle_name},
    )

    await db.refresh(cycle)
    return cycle


async def list_cycles(
    db: AsyncSession, client_id: uuid.UUID
) -> list[AssessmentCycle]:
    result = await db.execute(
        select(AssessmentCycle)
        .where(AssessmentCycle.client_id == client_id)
        .order_by(AssessmentCycle.created_at.desc())
    )
    return result.scalars().all()


async def get_cycle(db: AsyncSession, cycle_id: uuid.UUID) -> AssessmentCycle | None:
    result = await db.execute(
        select(AssessmentCycle).where(AssessmentCycle.id == cycle_id)
    )
    return result.scalar_one_or_none()


async def update_cycle_status(
    db: AsyncSession, cycle: AssessmentCycle, status: str, user_id: uuid.UUID
) -> AssessmentCycle:
    old = cycle.status
    cycle.status = status
    cycle.updated_by = user_id
    cycle.updated_at = datetime.now(timezone.utc)
    await db.flush()

    await log_change(
        db, user_id, "UPDATE", "assessment_cycle", cycle.id,
        before_value={"status": old}, after_value={"status": status},
    )
    return cycle


async def get_linked_naii_assessment(
    db: AsyncSession, cycle_id: uuid.UUID
) -> NaiiAssessment | None:
    """Get the NAII/NDI/Qiyas assessment linked to a cycle."""
    from sqlalchemy.orm import selectinload
    result = await db.execute(
        select(NaiiAssessment)
        .options(
            selectinload(NaiiAssessment.domain_responses),
            selectinload(NaiiAssessment.scores),
        )
        .where(NaiiAssessment.cycle_id == cycle_id)
    )
    return result.scalar_one_or_none()

import uuid
from datetime import datetime, timezone

from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import selectinload

from app.core.audit import log_change
from app.models.domain_assessment import DomainAssessment
from app.models.sub_requirement_response import SubRequirementResponse
from app.schemas.assessment import SubRequirementSave


async def get_assessments_for_product(
    db: AsyncSession, product_id: uuid.UUID
) -> list[DomainAssessment]:
    result = await db.execute(
        select(DomainAssessment)
        .options(selectinload(DomainAssessment.responses))
        .where(DomainAssessment.product_id == product_id)
        .order_by(DomainAssessment.domain_id)
    )
    return result.scalars().unique().all()


async def get_assessment_detail(
    db: AsyncSession, product_id: uuid.UUID, domain_id: int
) -> DomainAssessment | None:
    result = await db.execute(
        select(DomainAssessment)
        .options(selectinload(DomainAssessment.responses))
        .where(
            DomainAssessment.product_id == product_id,
            DomainAssessment.domain_id == domain_id,
        )
    )
    return result.scalar_one_or_none()


async def save_domain_responses(
    db: AsyncSession,
    assessment: DomainAssessment,
    responses: list[SubRequirementSave],
    user_id: uuid.UUID,
) -> DomainAssessment:
    for resp in responses:
        existing = await db.execute(
            select(SubRequirementResponse).where(
                SubRequirementResponse.assessment_id == assessment.id,
                SubRequirementResponse.sub_requirement_id == resp.sub_requirement_id,
            )
        )
        existing_row = existing.scalar_one_or_none()

        if existing_row:
            existing_row.field_value = resp.field_value
            existing_row.updated_at = datetime.now(timezone.utc)
        else:
            new_resp = SubRequirementResponse(
                assessment_id=assessment.id,
                sub_requirement_id=resp.sub_requirement_id,
                field_value=resp.field_value,
            )
            db.add(new_resp)

    # Auto-update status to in_progress if currently not_started
    if assessment.status == "not_started":
        assessment.status = "in_progress"

    assessment.updated_by = user_id
    assessment.updated_at = datetime.now(timezone.utc)

    await db.flush()

    await log_change(
        db, user_id, "UPDATE", "domain_assessment", assessment.id,
        after_value={
            "domain_id": assessment.domain_id,
            "responses_saved": len(responses),
        },
    )

    # Expire cached relationships and re-fetch
    await db.commit()
    return await get_assessment_detail(db, assessment.product_id, assessment.domain_id)


async def save_single_response(
    db: AsyncSession,
    assessment: DomainAssessment,
    sub_req_id: str,
    field_value: dict,
    user_id: uuid.UUID,
) -> SubRequirementResponse:
    existing = await db.execute(
        select(SubRequirementResponse).where(
            SubRequirementResponse.assessment_id == assessment.id,
            SubRequirementResponse.sub_requirement_id == sub_req_id,
        )
    )
    row = existing.scalar_one_or_none()

    if row:
        row.field_value = field_value
        row.updated_at = datetime.now(timezone.utc)
    else:
        row = SubRequirementResponse(
            assessment_id=assessment.id,
            sub_requirement_id=sub_req_id,
            field_value=field_value,
        )
        db.add(row)

    if assessment.status == "not_started":
        assessment.status = "in_progress"
    assessment.updated_by = user_id
    assessment.updated_at = datetime.now(timezone.utc)

    await db.flush()
    await db.refresh(row)
    return row


async def update_assessment_status(
    db: AsyncSession,
    assessment: DomainAssessment,
    new_status: str,
    user_id: uuid.UUID,
) -> DomainAssessment:
    old_status = assessment.status
    assessment.status = new_status
    assessment.updated_by = user_id
    assessment.updated_at = datetime.now(timezone.utc)
    await db.flush()

    await log_change(
        db, user_id, "UPDATE", "domain_assessment", assessment.id,
        before_value={"status": old_status},
        after_value={"status": new_status},
    )

    return assessment

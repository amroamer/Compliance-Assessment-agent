import uuid
from sqlalchemy.ext.asyncio import AsyncSession
from app.models.audit_log import AuditLog


async def log_change(
    db: AsyncSession,
    user_id: uuid.UUID,
    action: str,
    resource_type: str,
    resource_id: uuid.UUID,
    before_value: dict | None = None,
    after_value: dict | None = None,
):
    entry = AuditLog(
        user_id=user_id,
        action=action,
        resource_type=resource_type,
        resource_id=resource_id,
        before_value=before_value,
        after_value=after_value,
    )
    db.add(entry)

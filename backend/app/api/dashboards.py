import uuid

from fastapi import APIRouter, Depends, HTTPException
from fastapi.responses import StreamingResponse
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.permissions import require_role
from app.database import get_db
from app.dependencies import get_current_user
from app.models.user import User
from app.services import dashboard_service, export_service

router = APIRouter(prefix="/api/dashboard", tags=["dashboards"])


@router.get("/stats")
async def platform_stats(
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    return await dashboard_service.get_platform_stats(db)


@router.get("/entities/{entity_id}")
async def entity_dashboard(
    entity_id: uuid.UUID,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    result = await dashboard_service.get_entity_dashboard(db, entity_id)
    if not result:
        raise HTTPException(status_code=404, detail="Entity not found")
    return result


@router.get("/entities/{entity_id}/completion-matrix")
async def completion_matrix(
    entity_id: uuid.UUID,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    return await dashboard_service.get_completion_matrix(db, entity_id)


@router.get("/workload")
async def consultant_workload(
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_role("admin")),
):
    return await dashboard_service.get_consultant_workload(db)


@router.get("/entities/{entity_id}/export/excel")
async def export_excel(
    entity_id: uuid.UUID,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    try:
        buffer = await export_service.export_excel(db, entity_id)
    except ValueError as e:
        raise HTTPException(status_code=404, detail=str(e))
    except RuntimeError as e:
        raise HTTPException(status_code=500, detail=str(e))

    return StreamingResponse(
        buffer,
        media_type="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
        headers={"Content-Disposition": f"attachment; filename=entity_{entity_id}_report.xlsx"},
    )

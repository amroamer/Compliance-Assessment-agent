import uuid

from fastapi import APIRouter, Depends, File, Form, HTTPException, UploadFile, status
from fastapi.responses import FileResponse, StreamingResponse
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.permissions import require_role
from app.database import get_db
from app.dependencies import get_current_user
from app.models.user import User
from app.schemas.document import DocumentListResponse, DocumentResponse
from app.services import document_service

router = APIRouter(tags=["documents"])


@router.post(
    "/api/products/{product_id}/assessments/{domain_id}/documents",
    response_model=DocumentResponse,
    status_code=status.HTTP_201_CREATED,
)
async def upload_document(
    product_id: uuid.UUID,
    domain_id: int,
    file: UploadFile = File(...),
    sub_requirement_id: str | None = Form(None),
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_role("admin", "kpmg_user")),
):
    from app.services.assessment_service import get_assessment_detail

    assessment = await get_assessment_detail(db, product_id, domain_id)
    if not assessment:
        raise HTTPException(status_code=404, detail="Assessment not found")

    content = await file.read()
    try:
        doc = await document_service.upload_document(
            db, assessment.id, sub_requirement_id,
            file.filename or "unnamed", content, file.content_type or "", current_user.id,
        )
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))

    return doc


@router.get("/api/products/{product_id}/assessments/{domain_id}/documents", response_model=DocumentListResponse)
async def list_documents(
    product_id: uuid.UUID,
    domain_id: int,
    sub_requirement_id: str | None = None,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    from app.services.assessment_service import get_assessment_detail

    assessment = await get_assessment_detail(db, product_id, domain_id)
    if not assessment:
        raise HTTPException(status_code=404, detail="Assessment not found")

    docs = await document_service.list_documents(db, assessment.id, sub_requirement_id)
    return DocumentListResponse(items=docs, total=len(docs))


@router.get("/api/documents/{doc_id}/download")
async def download_document(
    doc_id: uuid.UUID,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    doc = await document_service.get_document(db, doc_id)
    if not doc:
        raise HTTPException(status_code=404, detail="Document not found")

    return FileResponse(
        doc.file_path,
        filename=doc.file_name,
        media_type="application/octet-stream",
    )


@router.get("/api/documents/{doc_id}/preview")
async def preview_document(
    doc_id: uuid.UUID,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    doc = await document_service.get_document(db, doc_id)
    if not doc:
        raise HTTPException(status_code=404, detail="Document not found")

    content_types = {
        "pdf": "application/pdf",
        "png": "image/png",
        "jpg": "image/jpeg",
        "jpeg": "image/jpeg",
    }
    ext = doc.file_name.rsplit(".", 1)[-1].lower() if "." in doc.file_name else ""
    content_type = content_types.get(ext, "application/octet-stream")

    return FileResponse(
        doc.file_path,
        media_type=content_type,
        headers={"Content-Disposition": f"inline; filename=\"{doc.file_name}\""},
    )


@router.get("/api/documents/{doc_id}/versions", response_model=list[DocumentResponse])
async def get_versions(
    doc_id: uuid.UUID,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    doc = await document_service.get_document(db, doc_id)
    if not doc:
        raise HTTPException(status_code=404, detail="Document not found")
    return await document_service.get_version_history(db, doc.document_group_id)


@router.post("/api/documents/{doc_id}/new-version", response_model=DocumentResponse, status_code=status.HTTP_201_CREATED)
async def upload_new_version(
    doc_id: uuid.UUID,
    file: UploadFile = File(...),
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_role("admin", "kpmg_user")),
):
    doc = await document_service.get_document(db, doc_id)
    if not doc:
        raise HTTPException(status_code=404, detail="Document not found")

    content = await file.read()
    try:
        new_doc = await document_service.upload_new_version(
            db, doc, file.filename or "unnamed", content, file.content_type or "", current_user.id,
        )
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))

    return new_doc


@router.delete("/api/documents/{doc_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_document(
    doc_id: uuid.UUID,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_role("admin", "kpmg_user")),
):
    doc = await document_service.get_document(db, doc_id)
    if not doc:
        raise HTTPException(status_code=404, detail="Document not found")
    await document_service.soft_delete_document(db, doc, current_user.id)


@router.get("/api/products/{product_id}/documents/bulk-download")
async def bulk_download_product(
    product_id: uuid.UUID,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    buffer = await document_service.build_bulk_zip(db, product_id=product_id)
    return StreamingResponse(
        buffer,
        media_type="application/zip",
        headers={"Content-Disposition": f"attachment; filename=product_{product_id}_docs.zip"},
    )


@router.get("/api/entities/{entity_id}/documents/bulk-download")
async def bulk_download_entity(
    entity_id: uuid.UUID,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    buffer = await document_service.build_bulk_zip(db, entity_id=entity_id)
    return StreamingResponse(
        buffer,
        media_type="application/zip",
        headers={"Content-Disposition": f"attachment; filename=entity_{entity_id}_docs.zip"},
    )

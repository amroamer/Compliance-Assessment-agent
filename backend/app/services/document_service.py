import os
import uuid
import zipfile
from io import BytesIO

import aiofiles
from sqlalchemy import func, select
from sqlalchemy.ext.asyncio import AsyncSession

from app.config import settings
from app.core.audit import log_change
from app.models.document import Document
from app.models.domain_assessment import DomainAssessment

ALLOWED_TYPES = {
    "application/pdf", "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
    "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
    "application/vnd.openxmlformats-officedocument.presentationml.presentation",
    "image/png", "image/jpeg", "image/jpg",
}

ALLOWED_EXTENSIONS = {".pdf", ".docx", ".xlsx", ".pptx", ".png", ".jpg", ".jpeg"}

MAX_FILE_SIZE = 25 * 1024 * 1024  # 25MB


async def upload_document(
    db: AsyncSession,
    assessment_id: uuid.UUID,
    sub_requirement_id: str | None,
    file_name: str,
    file_content: bytes,
    file_type: str,
    user_id: uuid.UUID,
) -> Document:
    ext = os.path.splitext(file_name)[1].lower()
    if ext not in ALLOWED_EXTENSIONS:
        raise ValueError(f"File type {ext} not allowed")
    if len(file_content) > MAX_FILE_SIZE:
        raise ValueError("File exceeds 25MB limit")

    # Get assessment to find entity/product for path
    result = await db.execute(
        select(DomainAssessment).where(DomainAssessment.id == assessment_id)
    )
    assessment = result.scalar_one_or_none()
    if not assessment:
        raise ValueError("Assessment not found")

    doc_id = uuid.uuid4()
    group_id = uuid.uuid4()

    # Build file path
    dir_path = os.path.join(
        settings.UPLOAD_DIR,
        str(assessment.product_id),
        str(assessment.domain_id),
    )
    os.makedirs(dir_path, exist_ok=True)

    file_path = os.path.join(dir_path, f"{doc_id}_v1{ext}")

    async with aiofiles.open(file_path, "wb") as f:
        await f.write(file_content)

    doc = Document(
        id=doc_id,
        assessment_id=assessment_id,
        sub_requirement_id=sub_requirement_id,
        document_group_id=group_id,
        file_name=file_name,
        file_type=file_type or ext.lstrip("."),
        file_size=len(file_content),
        file_path=file_path,
        version=1,
        uploaded_by=user_id,
    )
    db.add(doc)
    await db.flush()

    await log_change(
        db, user_id, "CREATE", "document", doc.id,
        after_value={"file_name": file_name, "assessment_id": str(assessment_id)},
    )

    return doc


async def upload_new_version(
    db: AsyncSession,
    original_doc: Document,
    file_name: str,
    file_content: bytes,
    file_type: str,
    user_id: uuid.UUID,
) -> Document:
    ext = os.path.splitext(file_name)[1].lower()
    if ext not in ALLOWED_EXTENSIONS:
        raise ValueError(f"File type {ext} not allowed")
    if len(file_content) > MAX_FILE_SIZE:
        raise ValueError("File exceeds 25MB limit")

    new_version = original_doc.version + 1
    doc_id = uuid.uuid4()

    dir_path = os.path.dirname(original_doc.file_path)
    file_path = os.path.join(dir_path, f"{doc_id}_v{new_version}{ext}")

    async with aiofiles.open(file_path, "wb") as f:
        await f.write(file_content)

    doc = Document(
        id=doc_id,
        assessment_id=original_doc.assessment_id,
        sub_requirement_id=original_doc.sub_requirement_id,
        document_group_id=original_doc.document_group_id,
        file_name=file_name,
        file_type=file_type or ext.lstrip("."),
        file_size=len(file_content),
        file_path=file_path,
        version=new_version,
        uploaded_by=user_id,
    )
    db.add(doc)
    await db.flush()

    await log_change(
        db, user_id, "CREATE", "document", doc.id,
        after_value={"file_name": file_name, "version": new_version},
    )

    return doc


async def list_documents(
    db: AsyncSession,
    assessment_id: uuid.UUID,
    sub_requirement_id: str | None = None,
) -> list[Document]:
    query = select(Document).where(
        Document.assessment_id == assessment_id,
        Document.is_deleted == False,
    )
    if sub_requirement_id:
        query = query.where(Document.sub_requirement_id == sub_requirement_id)
    query = query.order_by(Document.uploaded_at.desc())
    result = await db.execute(query)
    return result.scalars().all()


async def get_document(db: AsyncSession, doc_id: uuid.UUID) -> Document | None:
    result = await db.execute(
        select(Document).where(Document.id == doc_id, Document.is_deleted == False)
    )
    return result.scalar_one_or_none()


async def get_version_history(db: AsyncSession, group_id: uuid.UUID) -> list[Document]:
    result = await db.execute(
        select(Document)
        .where(Document.document_group_id == group_id, Document.is_deleted == False)
        .order_by(Document.version.desc())
    )
    return result.scalars().all()


async def soft_delete_document(
    db: AsyncSession, doc: Document, user_id: uuid.UUID
) -> None:
    doc.is_deleted = True
    await db.flush()
    await log_change(db, user_id, "DELETE", "document", doc.id)


async def build_bulk_zip(
    db: AsyncSession,
    product_id: uuid.UUID | None = None,
    entity_id: uuid.UUID | None = None,
) -> BytesIO:
    """Build ZIP of all documents for a product or entity."""
    query = (
        select(Document)
        .join(DomainAssessment)
        .where(Document.is_deleted == False)
    )
    if product_id:
        query = query.where(DomainAssessment.product_id == product_id)
    elif entity_id:
        from app.models.product import Product
        query = query.join(Product, DomainAssessment.product_id == Product.id).where(
            Product.entity_id == entity_id, Product.is_deleted == False
        )

    result = await db.execute(query)
    docs = result.scalars().all()

    buffer = BytesIO()
    with zipfile.ZipFile(buffer, "w", zipfile.ZIP_DEFLATED) as zf:
        for doc in docs:
            if os.path.exists(doc.file_path):
                arc_name = f"domain_{doc.assessment_id}/{doc.file_name}"
                zf.write(doc.file_path, arc_name)

    buffer.seek(0)
    return buffer

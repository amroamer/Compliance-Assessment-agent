import uuid

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.permissions import require_role
from app.database import get_db
from app.dependencies import get_current_user
from app.models.user import User
from app.schemas.product import (
    CustomerInfoResponse,
    CustomerInfoUpsert,
    ProductCreate,
    ProductListResponse,
    ProductResponse,
    ProductUpdate,
)
from app.services import product_service, entity_service

router = APIRouter(tags=["products"])


@router.get("/api/entities/{entity_id}/products", response_model=ProductListResponse)
async def list_products(
    entity_id: uuid.UUID,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    entity = await entity_service.get_entity(db, entity_id)
    if not entity:
        raise HTTPException(status_code=404, detail="Entity not found")
    products, total = await product_service.list_products(db, entity_id)
    return ProductListResponse(items=products, total=total)


@router.post(
    "/api/entities/{entity_id}/products",
    response_model=ProductResponse,
    status_code=status.HTTP_201_CREATED,
)
async def create_product(
    entity_id: uuid.UUID,
    data: ProductCreate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_role("admin", "kpmg_user")),
):
    entity = await entity_service.get_entity(db, entity_id)
    if not entity:
        raise HTTPException(status_code=404, detail="Entity not found")
    product = await product_service.create_product(db, entity_id, data, current_user.id)
    return product


@router.get("/api/products/{product_id}", response_model=ProductResponse)
async def get_product(
    product_id: uuid.UUID,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    product = await product_service.get_product(db, product_id)
    if not product:
        raise HTTPException(status_code=404, detail="Product not found")
    return product


@router.put("/api/products/{product_id}", response_model=ProductResponse)
async def update_product(
    product_id: uuid.UUID,
    data: ProductUpdate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_role("admin", "kpmg_user")),
):
    product = await product_service.get_product(db, product_id)
    if not product:
        raise HTTPException(status_code=404, detail="Product not found")
    return await product_service.update_product(db, product, data, current_user.id)


@router.delete("/api/products/{product_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_product(
    product_id: uuid.UUID,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_role("admin", "kpmg_user")),
):
    product = await product_service.get_product(db, product_id)
    if not product:
        raise HTTPException(status_code=404, detail="Product not found")
    await product_service.soft_delete_product(db, product, current_user.id)


@router.put("/api/products/{product_id}/customer-info", response_model=CustomerInfoResponse)
async def upsert_customer_info(
    product_id: uuid.UUID,
    data: CustomerInfoUpsert,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_role("admin", "kpmg_user")),
):
    product = await product_service.get_product(db, product_id)
    if not product:
        raise HTTPException(status_code=404, detail="Product not found")
    return await product_service.upsert_customer_info(db, product_id, data, current_user.id)


@router.post("/api/products/{product_id}/auto-save", response_model=ProductResponse)
async def auto_save_product(
    product_id: uuid.UUID,
    data: dict,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_role("admin", "kpmg_user")),
):
    product = await product_service.get_product(db, product_id)
    if not product:
        raise HTTPException(status_code=404, detail="Product not found")
    return await product_service.auto_save_product(db, product, data, current_user.id)

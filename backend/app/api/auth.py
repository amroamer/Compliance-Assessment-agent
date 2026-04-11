import secrets
from datetime import datetime, timedelta, timezone

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.permissions import require_role
from app.core.security import create_access_token, get_password_hash, verify_password
from app.database import get_db
from app.dependencies import get_current_user
from app.models.user import User
from app.schemas.user import LoginRequest, TokenResponse, UserCreate, UserResponse, UserUpdate, ForgotPasswordRequest, ResetPasswordRequest, BulkDeactivateUsersRequest

router = APIRouter(prefix="/api/auth", tags=["auth"])

# In-memory reset token store: {token: {"email": str, "expires": datetime}}
_reset_tokens: dict[str, dict] = {}


@router.post("/login", response_model=TokenResponse)
async def login(data: LoginRequest, db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(User).where(User.email == data.email))
    user = result.scalar_one_or_none()

    if not user or not verify_password(data.password, user.hashed_password):
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid email or password")

    if not user.is_active:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Account is disabled")

    user.last_login = datetime.now(timezone.utc)
    token = create_access_token(data={"sub": str(user.id)})
    return TokenResponse(access_token=token)


@router.get("/me", response_model=UserResponse)
async def get_me(current_user: User = Depends(get_current_user)):
    return current_user


@router.post("/register", response_model=UserResponse, status_code=status.HTTP_201_CREATED)
async def register(
    data: UserCreate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_role("admin")),
):
    existing = await db.execute(select(User).where(User.email == data.email))
    if existing.scalar_one_or_none():
        raise HTTPException(status_code=status.HTTP_409_CONFLICT, detail="Email already registered")

    if data.role not in ("admin", "kpmg_user", "client"):
        raise HTTPException(400, "Invalid role. Must be admin, kpmg_user, or client")
    if data.role == "client" and not data.assessed_entity_id:
        raise HTTPException(400, "Client users must be linked to an assessed entity")
    user = User(
        email=data.email,
        name=data.name,
        hashed_password=get_password_hash(data.password),
        role=data.role,
        assessed_entity_id=data.assessed_entity_id if data.role == "client" else None,
    )
    db.add(user)
    await db.flush()
    await db.refresh(user)
    return user


@router.post("/forgot-password")
async def forgot_password(data: ForgotPasswordRequest, db: AsyncSession = Depends(get_db)):
    """Generate a password reset token. Token is returned in response (no email server configured)."""
    result = await db.execute(select(User).where(User.email == data.email))
    user = result.scalar_one_or_none()
    # Always return success to avoid email enumeration, but only store token if user exists
    if user and user.is_active:
        token = secrets.token_urlsafe(32)
        _reset_tokens[token] = {
            "email": data.email,
            "expires": datetime.now(timezone.utc) + timedelta(minutes=15),
        }
        # Return token directly since no email server is configured
        return {"message": "Reset token generated", "reset_token": token, "expires_in_minutes": 15}
    return {"message": "If that email exists, a reset token has been generated", "reset_token": None}


@router.post("/reset-password")
async def reset_password(data: ResetPasswordRequest, db: AsyncSession = Depends(get_db)):
    """Reset password using a token from /forgot-password."""
    token_data = _reset_tokens.get(data.token)
    if not token_data:
        raise HTTPException(status_code=400, detail="Invalid or expired reset token")
    if datetime.now(timezone.utc) > token_data["expires"]:
        del _reset_tokens[data.token]
        raise HTTPException(status_code=400, detail="Reset token has expired. Please request a new one.")
    if len(data.new_password) < 8:
        raise HTTPException(status_code=400, detail="Password must be at least 8 characters")

    result = await db.execute(select(User).where(User.email == token_data["email"]))
    user = result.scalar_one_or_none()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    user.hashed_password = get_password_hash(data.new_password)
    await db.flush()
    del _reset_tokens[data.token]
    return {"message": "Password updated successfully"}


users_router = APIRouter(prefix="/api/users", tags=["users"])


@users_router.get("/", response_model=list[UserResponse])
async def list_users(
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_role("admin")),
):
    result = await db.execute(select(User).order_by(User.created_at.desc()))
    return result.scalars().all()


@users_router.patch("/{user_id}", response_model=UserResponse)
async def update_user(
    user_id: str,
    data: UserUpdate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_role("admin")),
):
    result = await db.execute(select(User).where(User.id == user_id))
    user = result.scalar_one_or_none()
    if not user:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="User not found")

    for field, value in data.model_dump(exclude_unset=True).items():
        setattr(user, field, value)

    await db.flush()
    await db.refresh(user)
    return user


@users_router.delete("/{user_id}", status_code=204)
async def deactivate_user(
    user_id: str,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_role("admin")),
):
    """Deactivate (soft-delete) a single user. Cannot deactivate yourself."""
    if str(current_user.id) == user_id:
        raise HTTPException(status_code=400, detail="You cannot deactivate your own account")
    result = await db.execute(select(User).where(User.id == user_id))
    user = result.scalar_one_or_none()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    user.is_active = False
    await db.flush()


@users_router.post("/bulk-deactivate")
async def bulk_deactivate_users(
    data: BulkDeactivateUsersRequest,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_role("admin")),
):
    """Deactivate multiple users at once. Cannot include your own account."""
    if not data.ids:
        raise HTTPException(status_code=400, detail="No user IDs provided")

    # Prevent self-deactivation in the bulk selection
    str_ids = [str(uid) for uid in data.ids]
    if str(current_user.id) in str_ids:
        raise HTTPException(status_code=400, detail="You cannot deactivate your own account")

    result = await db.execute(select(User).where(User.id.in_(data.ids)))
    users = result.scalars().all()
    if not users:
        raise HTTPException(status_code=404, detail="No matching users found")

    deactivated = 0
    already_inactive = 0
    for u in users:
        if u.is_active:
            u.is_active = False
            deactivated += 1
        else:
            already_inactive += 1

    await db.flush()
    return {
        "deactivated": deactivated,
        "already_inactive": already_inactive,
        "requested": len(data.ids),
    }

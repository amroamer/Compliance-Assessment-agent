"""Ollama model discovery, health-check, and default-model bootstrap."""
import logging
import time
import uuid
from datetime import datetime, timezone
from decimal import Decimal

import httpx
from sqlalchemy import select, update
from sqlalchemy.ext.asyncio import AsyncSession

from app.config import settings
from app.database import async_session
from app.models.llm_model import LlmModel

log = logging.getLogger("ollama_bootstrap")

_LAST_STATUS: dict = {
    "reachable": False,
    "models_count": 0,
    "default_model_id": None,
    "default_healthy": False,
    "last_bootstrap_at": None,
    "last_bootstrap_reason": "not_started",
}


def _base_url() -> str:
    return settings.OLLAMA_BASE_URL.rstrip("/")


async def list_ollama_models() -> list[dict]:
    """GET /api/tags. Returns [{name, size}] or [] on any failure."""
    try:
        async with httpx.AsyncClient(timeout=10.0) as client:
            resp = await client.get(f"{_base_url()}/api/tags")
            resp.raise_for_status()
            data = resp.json()
            return data.get("models", []) or []
    except Exception as e:
        log.warning(f"Ollama /api/tags failed: {e}")
        return []


async def test_ollama_model(model_id: str) -> tuple[bool, int]:
    """Send a minimal chat probe. Returns (success, latency_ms)."""
    start = time.time()
    payload = {
        "model": model_id,
        "messages": [{"role": "user", "content": "Say OK"}],
        "stream": False,
        "options": {"temperature": 0.0},
    }
    try:
        async with httpx.AsyncClient(timeout=60.0) as client:
            resp = await client.post(f"{_base_url()}/api/chat", json=payload)
            resp.raise_for_status()
            body = resp.json()
            ok = bool(body.get("message", {}).get("content"))
            return ok, int((time.time() - start) * 1000)
    except Exception as e:
        log.warning(f"Ollama test failed for {model_id}: {e}")
        return False, int((time.time() - start) * 1000)


async def _clear_other_defaults(db: AsyncSession, keep_id: uuid.UUID | None = None) -> None:
    stmt = update(LlmModel).values(is_default=False)
    if keep_id is not None:
        stmt = stmt.where(LlmModel.id != keep_id)
    await db.execute(stmt)


async def _upsert_default(db: AsyncSession, model_id: str) -> LlmModel:
    """Find an existing row by model_id or create one; mark is_default=True."""
    existing = (await db.execute(select(LlmModel).where(LlmModel.model_id == model_id))).scalar_one_or_none()
    if existing:
        existing.is_active = True
        existing.is_default = True
        existing.last_tested_at = datetime.now(timezone.utc)
        await db.flush()
        await _clear_other_defaults(db, keep_id=existing.id)
        return existing
    row = LlmModel(
        name=model_id,
        model_id=model_id,
        max_tokens=4096,
        temperature=Decimal("0.00"),
        context_window=8192,
        supports_documents=False,
        is_default=True,
        is_active=True,
        description="Auto-configured from Ollama on startup",
        last_tested_at=datetime.now(timezone.utc),
    )
    db.add(row)
    await db.flush()
    await _clear_other_defaults(db, keep_id=row.id)
    return row


def _set_status(**kw) -> None:
    _LAST_STATUS.update(kw)
    _LAST_STATUS["last_bootstrap_at"] = datetime.now(timezone.utc).isoformat()


def get_status() -> dict:
    return dict(_LAST_STATUS)


async def ensure_default(db: AsyncSession) -> dict:
    """Discover Ollama models, pick the first that passes a test, promote to default.

    Idempotent: if current default still works, keep it. Never raises — returns
    {"status": "healthy"|"degraded", "reason": str, "model_id": str|None}.
    """
    available = await list_ollama_models()
    names = [m.get("name") for m in available if m.get("name")]

    if not names:
        _set_status(
            reachable=False,
            models_count=0,
            default_healthy=False,
            last_bootstrap_reason="ollama_unreachable_or_no_models",
        )
        return {"status": "degraded", "reason": "ollama_unreachable_or_no_models", "model_id": None}

    # Keep existing default if it still works
    current = (await db.execute(
        select(LlmModel).where(LlmModel.is_default == True, LlmModel.is_active == True)
    )).scalar_one_or_none()

    if current and current.model_id in names:
        ok, _ = await test_ollama_model(current.model_id)
        if ok:
            _set_status(
                reachable=True,
                models_count=len(names),
                default_model_id=current.model_id,
                default_healthy=True,
                last_bootstrap_reason="kept_existing_default",
            )
            return {"status": "healthy", "reason": "kept_existing_default", "model_id": current.model_id}
        current.is_active = False
        await db.flush()

    # Pick first available model that passes a test
    for candidate in names:
        ok, _ = await test_ollama_model(candidate)
        if not ok:
            continue
        row = await _upsert_default(db, candidate)
        await db.commit()
        _set_status(
            reachable=True,
            models_count=len(names),
            default_model_id=row.model_id,
            default_healthy=True,
            last_bootstrap_reason="promoted_new_default",
        )
        return {"status": "healthy", "reason": "promoted_new_default", "model_id": row.model_id}

    _set_status(
        reachable=True,
        models_count=len(names),
        default_healthy=False,
        last_bootstrap_reason="all_tests_failed",
    )
    return {"status": "degraded", "reason": "all_tests_failed", "model_id": None}


async def ensure_default_in_new_session() -> dict:
    """Wrapper that opens its own session — for background tasks."""
    async with async_session() as db:
        try:
            return await ensure_default(db)
        except Exception as e:
            log.exception(f"ensure_default failed: {e}")
            _set_status(
                reachable=False,
                default_healthy=False,
                last_bootstrap_reason=f"error: {e}",
            )
            return {"status": "degraded", "reason": f"error: {e}", "model_id": None}

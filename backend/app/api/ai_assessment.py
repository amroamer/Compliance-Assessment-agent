"""AI Assessment API — LLM Models CRUD + AI Assess endpoints."""
import json
import time
import uuid
from datetime import datetime, timezone
from decimal import Decimal

import httpx
from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel
from sqlalchemy import select, update
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.permissions import require_role
from app.database import get_db
from app.dependencies import get_current_user
from app.models.llm_model import LlmModel
from app.models.ai_assessment_log import AiAssessmentLog
from app.models.assessment_engine import AssessmentInstance, AssessmentResponse, AssessmentEvidence
from app.models.user import User

router = APIRouter(tags=["ai-assessment"])


# ============ LLM MODELS CRUD ============

class LlmModelCreate(BaseModel):
    name: str; provider: str; model_id: str; endpoint_url: str
    api_key: str | None = None; max_tokens: int = 4096; temperature: float = 0.1
    context_window: int = 8192; supports_documents: bool = False
    is_default: bool = False; description: str | None = None

class BulkDeleteModelsRequest(BaseModel):
    ids: list[uuid.UUID]

def _mask_key(key: str | None) -> str | None:
    if not key: return None
    return "****" + key[-4:] if len(key) > 4 else "****"

def _model_resp(m: LlmModel) -> dict:
    return {
        "id": str(m.id), "name": m.name, "provider": m.provider, "model_id": m.model_id,
        "endpoint_url": m.endpoint_url, "api_key_masked": _mask_key(m.api_key),
        "max_tokens": m.max_tokens, "temperature": float(m.temperature),
        "context_window": m.context_window, "supports_documents": m.supports_documents,
        "is_default": m.is_default, "is_active": m.is_active, "description": m.description,
        "last_tested_at": m.last_tested_at.isoformat() if m.last_tested_at else None,
        "created_at": m.created_at.isoformat() if m.created_at else "",
    }

@router.get("/api/settings/llm-models")
async def list_models(db: AsyncSession = Depends(get_db), current_user: User = Depends(get_current_user)):
    result = await db.execute(select(LlmModel).where(LlmModel.is_active == True).order_by(LlmModel.name))
    return [_model_resp(m) for m in result.scalars().all()]

@router.get("/api/settings/llm-models/{model_id}")
async def get_model(model_id: uuid.UUID, db: AsyncSession = Depends(get_db), current_user: User = Depends(get_current_user)):
    m = (await db.execute(select(LlmModel).where(LlmModel.id == model_id))).scalar_one_or_none()
    if not m: raise HTTPException(404, "Model not found")
    return _model_resp(m)

@router.post("/api/settings/llm-models", status_code=201)
async def create_model(data: LlmModelCreate, db: AsyncSession = Depends(get_db), current_user: User = Depends(require_role("admin"))):
    if data.is_default:
        await db.execute(update(LlmModel).values(is_default=False))
    m = LlmModel(name=data.name, provider=data.provider, model_id=data.model_id, endpoint_url=data.endpoint_url,
        api_key=data.api_key, max_tokens=data.max_tokens, temperature=Decimal(str(data.temperature)),
        context_window=data.context_window, supports_documents=data.supports_documents,
        is_default=data.is_default, description=data.description)
    db.add(m); await db.flush(); await db.refresh(m)
    return _model_resp(m)

@router.put("/api/settings/llm-models/{model_id}")
async def update_model(model_id: uuid.UUID, data: LlmModelCreate, db: AsyncSession = Depends(get_db), current_user: User = Depends(require_role("admin"))):
    m = (await db.execute(select(LlmModel).where(LlmModel.id == model_id))).scalar_one_or_none()
    if not m: raise HTTPException(404, "Model not found")
    if data.is_default and not m.is_default:
        await db.execute(update(LlmModel).where(LlmModel.id != model_id).values(is_default=False))
    for k, v in data.model_dump(exclude_unset=True).items():
        if k == "api_key" and not v: continue  # keep existing key if empty
        if k == "temperature": v = Decimal(str(v))
        setattr(m, k, v)
    await db.flush(); await db.refresh(m)
    return _model_resp(m)

@router.delete("/api/settings/llm-models/{model_id}", status_code=204)
async def delete_model(model_id: uuid.UUID, db: AsyncSession = Depends(get_db), current_user: User = Depends(require_role("admin"))):
    m = (await db.execute(select(LlmModel).where(LlmModel.id == model_id))).scalar_one_or_none()
    if not m: raise HTTPException(404, "Model not found")
    m.is_active = False; await db.flush()

@router.post("/api/settings/llm-models/bulk-delete")
async def bulk_delete_models(data: BulkDeleteModelsRequest, db: AsyncSession = Depends(get_db), current_user: User = Depends(require_role("admin"))):
    """Soft-delete multiple LLM models at once."""
    if not data.ids:
        raise HTTPException(400, "No model IDs provided")
    result = await db.execute(select(LlmModel).where(LlmModel.id.in_(data.ids)))
    models = result.scalars().all()
    if not models:
        raise HTTPException(404, "No matching models found")
    deleted = 0
    already_removed = 0
    had_default = False
    for m in models:
        if m.is_default:
            had_default = True
        if m.is_active:
            m.is_active = False
            deleted += 1
        else:
            already_removed += 1
    await db.flush()
    return {
        "deleted": deleted,
        "already_removed": already_removed,
        "requested": len(data.ids),
        "had_default": had_default,
    }

@router.post("/api/settings/llm-models/{model_id}/test")
async def test_model(model_id: uuid.UUID, db: AsyncSession = Depends(get_db), current_user: User = Depends(require_role("admin"))):
    m = (await db.execute(select(LlmModel).where(LlmModel.id == model_id))).scalar_one_or_none()
    if not m: raise HTTPException(404, "Model not found")
    start = time.time()
    try:
        response_text = await _call_llm(m, "You are a test assistant.", "Say 'Hello, I am working correctly.' in exactly those words.")
        elapsed = int((time.time() - start) * 1000)
        m.last_tested_at = datetime.now(timezone.utc)
        await db.flush()
        return {"success": True, "response": response_text[:200], "response_time_ms": elapsed}
    except Exception as e:
        return {"success": False, "error": str(e), "response_time_ms": int((time.time() - start) * 1000)}


# ============ AI ASSESSMENT ENDPOINTS ============

class AssessRequest(BaseModel):
    model_id: uuid.UUID | None = None
    ai_product_id: uuid.UUID | None = None

@router.post("/api/assessments/{inst_id}/ai-assess/{node_id}")
async def assess_node(inst_id: uuid.UUID, node_id: uuid.UUID, data: AssessRequest = AssessRequest(), db: AsyncSession = Depends(get_db), current_user: User = Depends(get_current_user)):
    from app.services.prompt_assembly import build_prompt

    # Get model
    if data.model_id:
        model = (await db.execute(select(LlmModel).where(LlmModel.id == data.model_id, LlmModel.is_active == True))).scalar_one_or_none()
    else:
        model = (await db.execute(select(LlmModel).where(LlmModel.is_default == True, LlmModel.is_active == True))).scalar_one_or_none()
    if not model:
        raise HTTPException(400, "No AI model configured. Go to Settings → LLM Models to register one.")

    # Build prompts dynamically from database
    prompts = await build_prompt(db, inst_id, node_id, ai_product_id=data.ai_product_id)
    system_prompt = prompts["system_prompt"]
    user_prompt = prompts["user_prompt"]

    # Call LLM
    start = time.time()
    error_msg = None
    raw_response = None
    parsed = None
    try:
        raw_response = await _call_llm(model, system_prompt, user_prompt)
        parsed = _parse_suggestion(raw_response)
    except Exception as e:
        error_msg = str(e)

    elapsed = int((time.time() - start) * 1000)

    # Log
    log = AiAssessmentLog(
        instance_id=inst_id, node_id=node_id, model_id=model.id,
        system_prompt_sent=system_prompt, user_prompt_sent=user_prompt,
        raw_response=raw_response, parsed_suggestion=parsed,
        processing_time_ms=elapsed, error=error_msg,
    )
    db.add(log)
    await db.flush()

    if error_msg:
        raise HTTPException(500, f"AI assessment failed: {error_msg}")

    return {
        "suggestion": parsed,
        "model_name": model.name,
        "processing_time_ms": elapsed,
        "log_id": str(log.id),
    }


class AcceptRequest(BaseModel):
    suggestion: dict

@router.post("/api/assessments/{inst_id}/ai-assess/{node_id}/accept")
async def accept_suggestion(inst_id: uuid.UUID, node_id: uuid.UUID, data: AcceptRequest, db: AsyncSession = Depends(get_db), current_user: User = Depends(get_current_user)):
    ai_product_id = data.suggestion.get("_ai_product_id")
    q = select(AssessmentResponse).where(AssessmentResponse.instance_id == inst_id, AssessmentResponse.node_id == node_id)
    if ai_product_id:
        q = q.where(AssessmentResponse.ai_product_id == uuid.UUID(ai_product_id))
    else:
        q = q.where(AssessmentResponse.ai_product_id.is_(None))
    resp = (await db.execute(q)).scalar_one_or_none()
    if not resp: raise HTTPException(404, "Response not found")

    suggestion = data.suggestion
    rd = dict(resp.response_data) if resp.response_data else {}
    rd["review_feedback"] = suggestion.get("review_feedback", "")
    rd["justification"] = suggestion.get("justification", "")
    rd["recommendation"] = suggestion.get("recommendations", "")
    rd["compliance_status"] = suggestion.get("compliance_status", "")
    rd["ai_assessment"] = suggestion
    # Store document verification as top-level fields
    doc_analysis = suggestion.get("document_analysis", [])
    if doc_analysis:
        rd["doc_approved"] = all(d.get("is_approved", False) for d in doc_analysis)
        rd["doc_signed"] = all(d.get("has_signature", False) for d in doc_analysis)
    else:
        rd["doc_approved"] = None
        rd["doc_signed"] = None
    resp.response_data = rd
    resp.status = "draft"
    resp.computed_score_label = suggestion.get("compliance_status")
    resp.scored_by = current_user.id
    resp.scored_at = datetime.now(timezone.utc)

    # Mark log as accepted
    await db.execute(update(AiAssessmentLog).where(
        AiAssessmentLog.instance_id == inst_id, AiAssessmentLog.node_id == node_id, AiAssessmentLog.accepted.is_(None)
    ).values(accepted=True))

    # Update evidence metadata from AI document_analysis
    doc_analysis = suggestion.get("document_analysis", [])
    if doc_analysis and resp:
        from app.models.assessment_engine import AssessmentEvidence
        evs = (await db.execute(select(AssessmentEvidence).where(AssessmentEvidence.response_id == resp.id))).scalars().all()
        ev_map = {e.file_name: e for e in evs}
        for da in doc_analysis:
            ev = ev_map.get(da.get("file_name"))
            if not ev:
                continue
            if da.get("document_date"):
                try:
                    from datetime import date as date_type
                    ev.document_date = date_type.fromisoformat(da["document_date"])
                except (ValueError, TypeError):
                    pass
            if da.get("is_approved") is not None:
                ev.is_approved = da["is_approved"]
            if da.get("approved_by"):
                ev.approved_by = da["approved_by"]
            if da.get("has_signature") is not None:
                ev.has_signature = da["has_signature"]
            if da.get("notes"):
                ev.reviewer_notes = da["notes"]

    await db.flush()
    return {"status": "accepted", "compliance_status": suggestion.get("compliance_status")}


@router.post("/api/assessments/{inst_id}/ai-assess/{node_id}/dismiss")
async def dismiss_suggestion(inst_id: uuid.UUID, node_id: uuid.UUID, db: AsyncSession = Depends(get_db), current_user: User = Depends(get_current_user)):
    await db.execute(update(AiAssessmentLog).where(
        AiAssessmentLog.instance_id == inst_id, AiAssessmentLog.node_id == node_id, AiAssessmentLog.accepted.is_(None)
    ).values(accepted=False))
    await db.flush()
    return {"status": "dismissed"}


# ============ LLM CALL HELPER ============

async def _call_llm(model: LlmModel, system_prompt: str, user_prompt: str) -> str:
    """Call an LLM based on provider config."""
    headers = {"Content-Type": "application/json"}
    if model.api_key:
        if model.provider == "anthropic":
            headers["x-api-key"] = model.api_key
            headers["anthropic-version"] = "2023-06-01"
        else:
            headers["Authorization"] = f"Bearer {model.api_key}"

    if model.provider == "ollama":
        payload = {
            "model": model.model_id,
            "messages": [{"role": "system", "content": system_prompt}, {"role": "user", "content": user_prompt}],
            "stream": False,
            "options": {"temperature": float(model.temperature)},
        }
        async with httpx.AsyncClient(timeout=120) as client:
            resp = await client.post(model.endpoint_url, json=payload, headers=headers)
            resp.raise_for_status()
            return resp.json()["message"]["content"]

    elif model.provider == "anthropic":
        payload = {
            "model": model.model_id,
            "system": system_prompt,
            "messages": [{"role": "user", "content": user_prompt}],
            "temperature": float(model.temperature),
            "max_tokens": model.max_tokens,
        }
        async with httpx.AsyncClient(timeout=120) as client:
            resp = await client.post(model.endpoint_url, json=payload, headers=headers)
            resp.raise_for_status()
            return resp.json()["content"][0]["text"]

    else:  # openai, azure_openai, custom — all OpenAI-compatible
        payload = {
            "model": model.model_id,
            "messages": [{"role": "system", "content": system_prompt}, {"role": "user", "content": user_prompt}],
            "temperature": float(model.temperature),
            "max_tokens": model.max_tokens,
        }
        async with httpx.AsyncClient(timeout=120) as client:
            resp = await client.post(model.endpoint_url, json=payload, headers=headers)
            resp.raise_for_status()
            return resp.json()["choices"][0]["message"]["content"]


def _parse_suggestion(raw: str) -> dict:
    """Parse LLM response — handle markdown code fences."""
    text = raw.strip()
    if text.startswith("```"):
        text = text.split("\n", 1)[1] if "\n" in text else text[3:]
        if text.endswith("```"):
            text = text[:-3]
        text = text.strip()
    try:
        parsed = json.loads(text)
    except json.JSONDecodeError:
        start = text.find("{")
        end = text.rfind("}") + 1
        if start >= 0 and end > start:
            parsed = json.loads(text[start:end])
        else:
            raise ValueError(f"Could not parse JSON from LLM response: {text[:200]}")

    required = ["compliance_status", "review_feedback", "justification"]
    for field in required:
        if field not in parsed:
            raise ValueError(f"Missing required field in suggestion: {field}")
    # Normalize compliance_status
    status = parsed.get("compliance_status", "").strip()
    valid = {"Compliant", "Semi-Compliant", "Non-Compliant"}
    if status not in valid:
        # Try fuzzy match
        lower = status.lower()
        if "non" in lower:
            parsed["compliance_status"] = "Non-Compliant"
        elif "semi" in lower or "partial" in lower:
            parsed["compliance_status"] = "Semi-Compliant"
        else:
            parsed["compliance_status"] = "Compliant"
    return parsed

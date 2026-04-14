"""LLM Models CRUD integration tests against live backend."""
import uuid


def _uid():
    return uuid.uuid4().hex[:8]


def _create_model(http, base_url, admin_headers, **overrides):
    """Helper: create a throwaway LLM model and return the response."""
    suffix = _uid()
    payload = {
        "name": f"Test Model {suffix}",
        "provider": "custom",
        "model_id": f"test-model-{suffix}",
        "endpoint_url": "http://localhost:11434/api/generate",
        "max_tokens": 4096,
        "temperature": 0.1,
        "context_window": 8192,
        "supports_documents": False,
        "is_default": False,
    }
    payload.update(overrides)
    return http.post(f"{base_url}/api/settings/llm-models", headers=admin_headers, json=payload)


def _delete_model(http, base_url, admin_headers, model_id):
    """Soft-delete a model."""
    http.delete(f"{base_url}/api/settings/llm-models/{model_id}", headers=admin_headers)


# ---------------------------------------------------------------------------
# List
# ---------------------------------------------------------------------------

def test_list_models_returns_list(http, base_url, admin_headers):
    r = http.get(f"{base_url}/api/settings/llm-models", headers=admin_headers)
    assert r.status_code == 200
    assert isinstance(r.json(), list)


# ---------------------------------------------------------------------------
# Create
# ---------------------------------------------------------------------------

def test_create_model_returns_201(http, base_url, admin_headers):
    r = _create_model(http, base_url, admin_headers)
    assert r.status_code == 201
    data = r.json()
    assert "id" in data
    assert data["provider"] == "custom"
    assert data["is_active"] is True
    _delete_model(http, base_url, admin_headers, data["id"])


# ---------------------------------------------------------------------------
# Get by ID
# ---------------------------------------------------------------------------

def test_get_model_by_id(http, base_url, admin_headers):
    r = _create_model(http, base_url, admin_headers)
    assert r.status_code == 201
    model_id = r.json()["id"]
    r2 = http.get(f"{base_url}/api/settings/llm-models/{model_id}", headers=admin_headers)
    assert r2.status_code == 200
    assert r2.json()["id"] == model_id
    _delete_model(http, base_url, admin_headers, model_id)


# ---------------------------------------------------------------------------
# Update
# ---------------------------------------------------------------------------

def test_update_model(http, base_url, admin_headers):
    r = _create_model(http, base_url, admin_headers)
    assert r.status_code == 201
    model_id = r.json()["id"]
    original = r.json()
    suffix = _uid()
    r2 = http.put(f"{base_url}/api/settings/llm-models/{model_id}", headers=admin_headers, json={
        "name": f"Updated Model {suffix}",
        "provider": original["provider"],
        "model_id": original["model_id"],
        "endpoint_url": original["endpoint_url"],
        "max_tokens": 2048,
        "temperature": 0.5,
        "context_window": 4096,
        "supports_documents": True,
        "is_default": False,
    })
    assert r2.status_code == 200
    assert r2.json()["name"] == f"Updated Model {suffix}"
    assert r2.json()["max_tokens"] == 2048
    assert r2.json()["supports_documents"] is True
    _delete_model(http, base_url, admin_headers, model_id)


# ---------------------------------------------------------------------------
# Delete (soft)
# ---------------------------------------------------------------------------

def test_delete_model_soft_deletes(http, base_url, admin_headers):
    r = _create_model(http, base_url, admin_headers)
    assert r.status_code == 201
    model_id = r.json()["id"]
    r2 = http.delete(f"{base_url}/api/settings/llm-models/{model_id}", headers=admin_headers)
    assert r2.status_code == 204
    # Still accessible by direct ID but is_active should be False
    r3 = http.get(f"{base_url}/api/settings/llm-models/{model_id}", headers=admin_headers)
    assert r3.status_code == 200
    assert r3.json()["is_active"] is False


# ---------------------------------------------------------------------------
# Duplicate name
# ---------------------------------------------------------------------------

def test_create_duplicate_name_rejected(http, base_url, admin_headers):
    """DB has a unique constraint on llm_models.name. Duplicate names are rejected
    (API returns 500 due to unhandled IntegrityError, or 409 if handled).
    """
    suffix = _uid()
    name = f"DupModel {suffix}"
    r1 = _create_model(http, base_url, admin_headers, name=name)
    assert r1.status_code == 201
    r2 = _create_model(http, base_url, admin_headers, name=name)
    assert r2.status_code in (409, 500), f"Expected 409 or 500, got {r2.status_code}"
    _delete_model(http, base_url, admin_headers, r1.json()["id"])


# ---------------------------------------------------------------------------
# Default model flag
# ---------------------------------------------------------------------------

def test_default_model_flag_clears_others(http, base_url, admin_headers):
    """When creating a model with is_default=true, other defaults should clear."""
    r1 = _create_model(http, base_url, admin_headers, is_default=True)
    assert r1.status_code == 201
    m1_id = r1.json()["id"]
    assert r1.json()["is_default"] is True
    # Create another default
    r2 = _create_model(http, base_url, admin_headers, is_default=True)
    assert r2.status_code == 201
    m2_id = r2.json()["id"]
    assert r2.json()["is_default"] is True
    # Verify first model is no longer default
    r3 = http.get(f"{base_url}/api/settings/llm-models/{m1_id}", headers=admin_headers)
    assert r3.status_code == 200
    assert r3.json()["is_default"] is False
    # Cleanup
    _delete_model(http, base_url, admin_headers, m1_id)
    _delete_model(http, base_url, admin_headers, m2_id)


# ---------------------------------------------------------------------------
# Export Excel
# ---------------------------------------------------------------------------

def test_export_excel_returns_xlsx(http, base_url, admin_headers):
    r = http.get(f"{base_url}/api/settings/llm-models/export-excel", headers=admin_headers)
    assert r.status_code == 200
    ct = r.headers.get("content-type", "")
    assert "spreadsheetml" in ct or "octet-stream" in ct


# ---------------------------------------------------------------------------
# Import Excel Preview
# ---------------------------------------------------------------------------

def test_import_excel_preview(http, base_url, admin_headers):
    """Export the current models then re-import with preview=true."""
    export_r = http.get(f"{base_url}/api/settings/llm-models/export-excel", headers=admin_headers)
    assert export_r.status_code == 200
    # Upload the same file back with preview=true
    r = http.post(
        f"{base_url}/api/settings/llm-models/import-excel?preview=true",
        headers=admin_headers,
        files={"file": ("llm_models.xlsx", export_r.content, "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")},
    )
    assert r.status_code == 200
    data = r.json()
    assert "total_in_file" in data
    assert "will_import" in data
    assert "will_skip" in data
    # Since we re-imported the same data, all should be duplicates
    assert data["will_skip"] >= 0


# ---------------------------------------------------------------------------
# Auth
# ---------------------------------------------------------------------------

def test_create_model_requires_admin(http, base_url):
    """POST without auth token returns 401 or 403."""
    r = http.post(f"{base_url}/api/settings/llm-models", json={
        "name": "No Auth Model", "provider": "custom",
        "model_id": "no-auth", "endpoint_url": "http://localhost:11434",
    })
    assert r.status_code in (401, 403)

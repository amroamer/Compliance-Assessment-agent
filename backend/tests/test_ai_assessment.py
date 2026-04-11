"""Module 11: LLM Models CRUD + bulk delete tests."""
import uuid as _uuid


def _create_model(http, base_url, admin_headers, name=None, is_default=False):
    """Helper: create a throwaway LLM model and return its id."""
    if name is None:
        name = f"Test LLM Model {_uuid.uuid4().hex[:8]}"
    r = http.post(f"{base_url}/api/settings/llm-models", headers=admin_headers, json={
        "name": name,
        "provider": "ollama",
        "model_id": "test:7b",
        "endpoint_url": "http://localhost:11434/api/chat",
        "max_tokens": 1024,
        "temperature": 0.1,
        "context_window": 4096,
        "is_default": is_default,
    })
    assert r.status_code == 201, f"Failed to create model: {r.text}"
    return r.json()["id"]


# ── CRUD basics ──

def test_list_llm_models(http, base_url, admin_headers):
    """List endpoint returns an array."""
    r = http.get(f"{base_url}/api/settings/llm-models", headers=admin_headers)
    assert r.status_code == 200
    assert isinstance(r.json(), list)


def test_create_llm_model(http, base_url, admin_headers):
    """Creating a model returns 201 with expected fields."""
    unique_name = f"Create Test Model {_uuid.uuid4().hex[:8]}"
    r = http.post(f"{base_url}/api/settings/llm-models", headers=admin_headers, json={
        "name": unique_name,
        "provider": "openai",
        "model_id": "gpt-4o",
        "endpoint_url": "https://api.openai.com/v1/chat/completions",
        "max_tokens": 2048,
        "temperature": 0.2,
        "context_window": 8192,
        "is_default": False,
        "description": "Test description",
    })
    assert r.status_code == 201
    data = r.json()
    assert data["name"] == unique_name
    assert data["provider"] == "openai"
    assert data["model_id"] == "gpt-4o"
    assert data["is_active"] is True
    # Cleanup
    http.delete(f"{base_url}/api/settings/llm-models/{data['id']}", headers=admin_headers)


def test_create_model_requires_admin(http, base_url):
    """Unauthenticated create is rejected."""
    r = http.post(f"{base_url}/api/settings/llm-models", json={
        "name": "x", "provider": "ollama", "model_id": "x", "endpoint_url": "http://x"
    })
    assert r.status_code in (401, 403)


def test_get_model_not_found(http, base_url, admin_headers):
    """Getting a non-existent model returns 404."""
    r = http.get(f"{base_url}/api/settings/llm-models/00000000-0000-0000-0000-000000000000", headers=admin_headers)
    assert r.status_code == 404


# ── Single delete ──

def test_delete_model_success(http, base_url, admin_headers):
    """Soft-deleting a model sets is_active=False (removed from list)."""
    mid = _create_model(http, base_url, admin_headers)
    r = http.delete(f"{base_url}/api/settings/llm-models/{mid}", headers=admin_headers)
    assert r.status_code == 204
    # Should no longer appear in the active list
    models = http.get(f"{base_url}/api/settings/llm-models", headers=admin_headers).json()
    assert all(m["id"] != mid for m in models)


def test_delete_model_not_found(http, base_url, admin_headers):
    """Deleting a non-existent model returns 404."""
    r = http.delete(f"{base_url}/api/settings/llm-models/00000000-0000-0000-0000-000000000099", headers=admin_headers)
    assert r.status_code == 404
    assert "not found" in r.json()["detail"].lower()


def test_delete_model_requires_admin(http, base_url):
    """Unauthenticated delete is rejected."""
    r = http.delete(f"{base_url}/api/settings/llm-models/00000000-0000-0000-0000-000000000099")
    assert r.status_code in (401, 403)


# ── Bulk delete ──

def test_bulk_delete_single_model(http, base_url, admin_headers):
    """Bulk delete with one ID works and returns correct counts."""
    mid = _create_model(http, base_url, admin_headers)
    r = http.post(f"{base_url}/api/settings/llm-models/bulk-delete", headers=admin_headers, json={"ids": [mid]})
    assert r.status_code == 200
    data = r.json()
    assert data["deleted"] == 1
    assert data["requested"] == 1
    assert data["already_removed"] == 0
    # Confirm gone from active list
    models = http.get(f"{base_url}/api/settings/llm-models", headers=admin_headers).json()
    assert all(m["id"] != mid for m in models)


def test_bulk_delete_multiple_models(http, base_url, admin_headers):
    """Bulk delete removes all specified models."""
    ids = [_create_model(http, base_url, admin_headers) for _ in range(3)]
    r = http.post(f"{base_url}/api/settings/llm-models/bulk-delete", headers=admin_headers, json={"ids": ids})
    assert r.status_code == 200
    data = r.json()
    assert data["deleted"] == 3
    assert data["requested"] == 3
    # All gone from active list
    models = http.get(f"{base_url}/api/settings/llm-models", headers=admin_headers).json()
    for mid in ids:
        assert all(m["id"] != mid for m in models)


def test_bulk_delete_already_removed_counted(http, base_url, admin_headers):
    """Deleting an already-inactive model counts it in already_removed."""
    mid = _create_model(http, base_url, admin_headers)
    # First deletion
    http.post(f"{base_url}/api/settings/llm-models/bulk-delete", headers=admin_headers, json={"ids": [mid]})
    # Second deletion of same ID
    r = http.post(f"{base_url}/api/settings/llm-models/bulk-delete", headers=admin_headers, json={"ids": [mid]})
    assert r.status_code == 200
    data = r.json()
    assert data["deleted"] == 0
    assert data["already_removed"] == 1


def test_bulk_delete_default_model_flagged(http, base_url, admin_headers):
    """Deleting the default model sets had_default=True in response."""
    mid = _create_model(http, base_url, admin_headers, is_default=True)
    r = http.post(f"{base_url}/api/settings/llm-models/bulk-delete", headers=admin_headers, json={"ids": [mid]})
    assert r.status_code == 200
    assert r.json()["had_default"] is True


def test_bulk_delete_empty_ids(http, base_url, admin_headers):
    """Empty IDs list returns 400."""
    r = http.post(f"{base_url}/api/settings/llm-models/bulk-delete", headers=admin_headers, json={"ids": []})
    assert r.status_code == 400


def test_bulk_delete_nonexistent_ids(http, base_url, admin_headers):
    """All-nonexistent IDs returns 404."""
    r = http.post(f"{base_url}/api/settings/llm-models/bulk-delete", headers=admin_headers, json={
        "ids": ["00000000-0000-0000-0000-000000000001", "00000000-0000-0000-0000-000000000002"]
    })
    assert r.status_code == 404


def test_bulk_delete_requires_admin(http, base_url):
    """Unauthenticated bulk delete is rejected."""
    r = http.post(f"{base_url}/api/settings/llm-models/bulk-delete", json={
        "ids": ["00000000-0000-0000-0000-000000000001"]
    })
    assert r.status_code in (401, 403)

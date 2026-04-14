"""Framework CRUD integration tests against live backend."""
import uuid


def _uid():
    return uuid.uuid4().hex[:8]


def _get_entity_id(http, base_url, admin_headers):
    """Return the id of the first active regulatory entity."""
    r = http.get(f"{base_url}/api/regulatory-entities/", headers=admin_headers)
    assert r.status_code == 200
    entities = [e for e in r.json() if e.get("status") == "Active"]
    assert len(entities) > 0, "No active regulatory entities found"
    return entities[0]["id"]


def _create_framework(http, base_url, admin_headers, **overrides):
    """Helper: create a throwaway framework and return its JSON."""
    entity_id = overrides.pop("entity_id", None) or _get_entity_id(http, base_url, admin_headers)
    suffix = _uid()
    payload = {
        "name": f"Test FW {suffix}",
        "abbreviation": f"TFW{suffix}".upper(),
        "entity_id": entity_id,
        "status": "Draft",
    }
    payload.update(overrides)
    r = http.post(f"{base_url}/api/frameworks/", headers=admin_headers, json=payload)
    return r


def _cleanup_framework(http, base_url, admin_headers, fw_id):
    """Permanently delete a framework and all related data."""
    http.post(
        f"{base_url}/api/frameworks/bulk-delete",
        headers=admin_headers,
        json={"ids": [fw_id]},
    )


# ---------------------------------------------------------------------------
# List
# ---------------------------------------------------------------------------

def test_list_frameworks_returns_list(http, base_url, admin_headers):
    r = http.get(f"{base_url}/api/frameworks/", headers=admin_headers)
    assert r.status_code == 200
    data = r.json()
    assert isinstance(data, list)
    assert len(data) >= 1


def test_list_frameworks_contains_expected_fields(http, base_url, admin_headers):
    r = http.get(f"{base_url}/api/frameworks/", headers=admin_headers)
    fw = r.json()[0]
    for key in ("id", "name", "abbreviation", "entity_id", "status"):
        assert key in fw, f"Missing key: {key}"


# ---------------------------------------------------------------------------
# Create
# ---------------------------------------------------------------------------

def test_create_framework_returns_201(http, base_url, admin_headers):
    r = _create_framework(http, base_url, admin_headers)
    assert r.status_code == 201
    data = r.json()
    assert "id" in data
    assert data["status"] == "Draft"
    _cleanup_framework(http, base_url, admin_headers, data["id"])


def test_create_framework_abbreviation_uppercased(http, base_url, admin_headers):
    suffix = _uid()
    r = _create_framework(http, base_url, admin_headers, abbreviation=f"low{suffix}")
    assert r.status_code == 201
    assert r.json()["abbreviation"] == f"LOW{suffix}".upper()
    _cleanup_framework(http, base_url, admin_headers, r.json()["id"])


# ---------------------------------------------------------------------------
# Get by ID
# ---------------------------------------------------------------------------

def test_get_framework_by_id(http, base_url, admin_headers):
    r = _create_framework(http, base_url, admin_headers)
    fw_id = r.json()["id"]
    r2 = http.get(f"{base_url}/api/frameworks/{fw_id}", headers=admin_headers)
    assert r2.status_code == 200
    assert r2.json()["id"] == fw_id
    _cleanup_framework(http, base_url, admin_headers, fw_id)


def test_get_nonexistent_framework_returns_404(http, base_url, admin_headers):
    fake_id = str(uuid.uuid4())
    r = http.get(f"{base_url}/api/frameworks/{fake_id}", headers=admin_headers)
    assert r.status_code == 404


# ---------------------------------------------------------------------------
# Update
# ---------------------------------------------------------------------------

def test_update_framework_name(http, base_url, admin_headers):
    r = _create_framework(http, base_url, admin_headers)
    fw = r.json()
    new_name = f"Renamed FW {_uid()}"
    r2 = http.put(
        f"{base_url}/api/frameworks/{fw['id']}",
        headers=admin_headers,
        json={"name": new_name},
    )
    assert r2.status_code == 200
    assert r2.json()["name"] == new_name
    _cleanup_framework(http, base_url, admin_headers, fw["id"])


def test_update_framework_version(http, base_url, admin_headers):
    r = _create_framework(http, base_url, admin_headers)
    fw = r.json()
    r2 = http.put(
        f"{base_url}/api/frameworks/{fw['id']}",
        headers=admin_headers,
        json={"version": "2.0"},
    )
    assert r2.status_code == 200
    assert r2.json()["version"] == "2.0"
    _cleanup_framework(http, base_url, admin_headers, fw["id"])


def test_update_nonexistent_framework_returns_404(http, base_url, admin_headers):
    fake_id = str(uuid.uuid4())
    r = http.put(
        f"{base_url}/api/frameworks/{fake_id}",
        headers=admin_headers,
        json={"name": "nope"},
    )
    assert r.status_code == 404


# ---------------------------------------------------------------------------
# Duplicate abbreviation
# ---------------------------------------------------------------------------

def test_duplicate_abbreviation_rejected_on_create(http, base_url, admin_headers):
    r1 = _create_framework(http, base_url, admin_headers)
    assert r1.status_code == 201
    abbr = r1.json()["abbreviation"]
    r2 = _create_framework(http, base_url, admin_headers, abbreviation=abbr)
    assert r2.status_code == 409
    _cleanup_framework(http, base_url, admin_headers, r1.json()["id"])


def test_duplicate_abbreviation_rejected_on_update(http, base_url, admin_headers):
    r1 = _create_framework(http, base_url, admin_headers)
    r2 = _create_framework(http, base_url, admin_headers)
    assert r1.status_code == 201
    assert r2.status_code == 201
    abbr1 = r1.json()["abbreviation"]
    r3 = http.put(
        f"{base_url}/api/frameworks/{r2.json()['id']}",
        headers=admin_headers,
        json={"abbreviation": abbr1},
    )
    assert r3.status_code == 409
    _cleanup_framework(http, base_url, admin_headers, r1.json()["id"])
    _cleanup_framework(http, base_url, admin_headers, r2.json()["id"])


# ---------------------------------------------------------------------------
# Archive (DELETE soft-deletes)
# ---------------------------------------------------------------------------

def test_archive_framework_returns_204(http, base_url, admin_headers):
    r = _create_framework(http, base_url, admin_headers)
    fw_id = r.json()["id"]
    r2 = http.delete(f"{base_url}/api/frameworks/{fw_id}", headers=admin_headers)
    assert r2.status_code == 204
    r3 = http.get(f"{base_url}/api/frameworks/{fw_id}", headers=admin_headers)
    assert r3.json()["status"] == "Archived"
    _cleanup_framework(http, base_url, admin_headers, fw_id)


# ---------------------------------------------------------------------------
# Invalid status
# ---------------------------------------------------------------------------

def test_invalid_status_rejected_on_create(http, base_url, admin_headers):
    r = _create_framework(http, base_url, admin_headers, status="BadStatus")
    assert r.status_code == 400


def test_invalid_status_rejected_on_update(http, base_url, admin_headers):
    r = _create_framework(http, base_url, admin_headers)
    fw_id = r.json()["id"]
    r2 = http.put(
        f"{base_url}/api/frameworks/{fw_id}",
        headers=admin_headers,
        json={"status": "BadStatus"},
    )
    assert r2.status_code == 400
    _cleanup_framework(http, base_url, admin_headers, fw_id)


# ---------------------------------------------------------------------------
# Auth
# ---------------------------------------------------------------------------

def test_create_framework_requires_admin(http, base_url):
    """POST without auth token returns 401 or 403."""
    r = http.post(f"{base_url}/api/frameworks/", json={
        "name": "No Auth", "abbreviation": "NOAUTH",
        "entity_id": "00000000-0000-0000-0000-000000000001",
    })
    assert r.status_code in (401, 403)

"""Module 3b: Frameworks bulk archive tests."""
import uuid as _uuid


def _get_any_entity_id(http, base_url, admin_headers):
    """Return first active regulatory entity ID, or None."""
    entities = http.get(f"{base_url}/api/regulatory-entities/", headers=admin_headers).json()
    active = [e for e in entities if e.get("status") == "Active"]
    return active[0]["id"] if active else None


def _create_framework(http, base_url, admin_headers, entity_id, prefix="BFW"):
    """Helper: create a throwaway framework with a unique abbreviation in Draft status."""
    suffix = _uuid.uuid4().hex[:6].upper()
    abbr = f"{prefix}{suffix}"[:12]  # keep within DB limits
    name = f"Test Framework {suffix}"
    r = http.post(f"{base_url}/api/frameworks/", headers=admin_headers, json={
        "name": name,
        "abbreviation": abbr,
        "entity_id": entity_id,
        "status": "Draft",
        "icon": "book",
    })
    assert r.status_code == 201, f"Failed to create framework: {r.text}"
    return r.json()["id"]


def test_bulk_archive_single_framework(http, base_url, admin_headers):
    """Bulk archive with one ID works and returns correct counts."""
    entity_id = _get_any_entity_id(http, base_url, admin_headers)
    if not entity_id:
        return  # skip
    fwid = _create_framework(http, base_url, admin_headers, entity_id)
    r = http.post(f"{base_url}/api/frameworks/bulk-archive", headers=admin_headers, json={"ids": [fwid]})
    assert r.status_code == 200, f"Expected 200, got {r.status_code}: {r.text}"
    data = r.json()
    assert data["archived"] == 1
    assert data["requested"] == 1
    assert data["already_archived"] == 0


def test_bulk_archive_multiple_frameworks(http, base_url, admin_headers):
    """Bulk archive removes all specified frameworks."""
    entity_id = _get_any_entity_id(http, base_url, admin_headers)
    if not entity_id:
        return
    ids = [_create_framework(http, base_url, admin_headers, entity_id) for _ in range(3)]
    r = http.post(f"{base_url}/api/frameworks/bulk-archive", headers=admin_headers, json={"ids": ids})
    assert r.status_code == 200
    data = r.json()
    assert data["archived"] == 3
    assert data["requested"] == 3


def test_bulk_archive_already_archived_counted(http, base_url, admin_headers):
    """Archiving an already-archived framework counts in already_archived."""
    entity_id = _get_any_entity_id(http, base_url, admin_headers)
    if not entity_id:
        return
    fwid = _create_framework(http, base_url, admin_headers, entity_id)
    # First archive
    http.post(f"{base_url}/api/frameworks/bulk-archive", headers=admin_headers, json={"ids": [fwid]})
    # Second archive
    r = http.post(f"{base_url}/api/frameworks/bulk-archive", headers=admin_headers, json={"ids": [fwid]})
    assert r.status_code == 200
    data = r.json()
    assert data["archived"] == 0
    assert data["already_archived"] == 1


def test_bulk_archive_empty_ids(http, base_url, admin_headers):
    """Empty IDs list returns 400."""
    r = http.post(f"{base_url}/api/frameworks/bulk-archive", headers=admin_headers, json={"ids": []})
    assert r.status_code == 400


def test_bulk_archive_nonexistent_ids(http, base_url, admin_headers):
    """All-nonexistent IDs returns 404."""
    r = http.post(f"{base_url}/api/frameworks/bulk-archive", headers=admin_headers, json={
        "ids": ["00000000-0000-0000-0000-000000000001"]
    })
    assert r.status_code == 404


def test_bulk_archive_requires_admin(http, base_url):
    """Unauthenticated bulk archive is rejected."""
    r = http.post(f"{base_url}/api/frameworks/bulk-archive", json={
        "ids": ["00000000-0000-0000-0000-000000000001"]
    })
    assert r.status_code in (401, 403)

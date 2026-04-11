"""Module 2: Regulatory Entities tests."""


def test_list_regulatory_entities(http, base_url, admin_headers):
    r = http.get(f"{base_url}/api/regulatory-entities/", headers=admin_headers)
    assert r.status_code == 200
    assert isinstance(r.json(), list)


def test_create_and_delete_regulatory_entity(http, base_url, admin_headers):
    # Create
    r = http.post(f"{base_url}/api/regulatory-entities/", headers=admin_headers, json={
        "name": "Test Reg Entity", "abbreviation": "TRE", "status": "Active", "frameworks": [],
    })
    assert r.status_code == 201
    data = r.json()
    assert data["abbreviation"] == "TRE"
    # Permanent delete
    r2 = http.delete(f"{base_url}/api/regulatory-entities/{data['id']}?permanent=true", headers=admin_headers)
    assert r2.status_code == 204
    # Verify gone
    r3 = http.get(f"{base_url}/api/regulatory-entities/{data['id']}", headers=admin_headers)
    assert r3.status_code == 404


def test_create_duplicate_abbreviation_rejected(http, base_url, admin_headers):
    r1 = http.post(f"{base_url}/api/regulatory-entities/", headers=admin_headers, json={
        "name": "Dup Test 1", "abbreviation": "DDUP", "status": "Active", "frameworks": [],
    })
    assert r1.status_code == 201
    r2 = http.post(f"{base_url}/api/regulatory-entities/", headers=admin_headers, json={
        "name": "Dup Test 2", "abbreviation": "DDUP", "status": "Active", "frameworks": [],
    })
    assert r2.status_code == 409
    # Cleanup
    http.delete(f"{base_url}/api/regulatory-entities/{r1.json()['id']}?permanent=true", headers=admin_headers)


def test_deactivate_regulatory_entity(http, base_url, admin_headers):
    r = http.post(f"{base_url}/api/regulatory-entities/", headers=admin_headers, json={
        "name": "Deact Test", "abbreviation": "DACT", "status": "Active", "frameworks": [],
    })
    eid = r.json()["id"]
    r2 = http.delete(f"{base_url}/api/regulatory-entities/{eid}", headers=admin_headers)
    assert r2.status_code == 204
    r3 = http.get(f"{base_url}/api/regulatory-entities/{eid}", headers=admin_headers)
    assert r3.json()["status"] == "Inactive"
    http.delete(f"{base_url}/api/regulatory-entities/{eid}?permanent=true", headers=admin_headers)


def test_delete_blocked_by_frameworks(http, base_url, admin_headers):
    r = http.get(f"{base_url}/api/regulatory-entities/", headers=admin_headers)
    sdaia = next((e for e in r.json() if e["abbreviation"] == "SDAIA"), None)
    if not sdaia:
        return  # skip if no SDAIA
    r2 = http.delete(f"{base_url}/api/regulatory-entities/{sdaia['id']}?permanent=true", headers=admin_headers)
    assert r2.status_code == 409
    # Verify the error message is descriptive (not a generic 500)
    detail = r2.json().get("detail", "")
    assert "Cannot delete" in detail or "framework" in detail.lower(), f"Expected descriptive error, got: {detail}"


# ---------------------------------------------------------------------------
# Bulk operation helpers and tests
# ---------------------------------------------------------------------------

def _create_reg_entity(http, base_url, admin_headers, name, abbreviation):
    """Helper: create a throwaway regulatory entity and return its id."""
    r = http.post(f"{base_url}/api/regulatory-entities/", headers=admin_headers, json={
        "name": name, "abbreviation": abbreviation, "status": "Active", "frameworks": [],
    })
    assert r.status_code == 201, f"Failed to create entity: {r.text}"
    return r.json()["id"]


def test_bulk_deactivate_single_entity(http, base_url, admin_headers):
    """Bulk deactivate with one ID works and returns correct counts."""
    eid = _create_reg_entity(http, base_url, admin_headers, "Bulk Deact Single", "BDSA")
    r = http.post(f"{base_url}/api/regulatory-entities/bulk-deactivate", headers=admin_headers, json={"ids": [eid]})
    assert r.status_code == 200
    data = r.json()
    assert data["deactivated"] == 1
    assert data["requested"] == 1
    assert data["already_inactive"] == 0
    # Cleanup
    http.delete(f"{base_url}/api/regulatory-entities/{eid}?permanent=true", headers=admin_headers)


def test_bulk_deactivate_multiple_entities(http, base_url, admin_headers):
    """Bulk deactivate removes all specified entities."""
    ids = [
        _create_reg_entity(http, base_url, admin_headers, f"Bulk Deact Multi {i}", f"BDM{i}")
        for i in range(3)
    ]
    r = http.post(f"{base_url}/api/regulatory-entities/bulk-deactivate", headers=admin_headers, json={"ids": ids})
    assert r.status_code == 200
    data = r.json()
    assert data["deactivated"] == 3
    assert data["requested"] == 3
    # Cleanup
    for eid in ids:
        http.delete(f"{base_url}/api/regulatory-entities/{eid}?permanent=true", headers=admin_headers)


def test_bulk_deactivate_already_inactive_counted(http, base_url, admin_headers):
    """Deactivating an already-inactive entity counts in already_inactive."""
    eid = _create_reg_entity(http, base_url, admin_headers, "Bulk Already Inactive", "BAIN")
    # First deactivation
    http.post(f"{base_url}/api/regulatory-entities/bulk-deactivate", headers=admin_headers, json={"ids": [eid]})
    # Second deactivation
    r = http.post(f"{base_url}/api/regulatory-entities/bulk-deactivate", headers=admin_headers, json={"ids": [eid]})
    assert r.status_code == 200
    data = r.json()
    assert data["deactivated"] == 0
    assert data["already_inactive"] == 1
    # Cleanup
    http.delete(f"{base_url}/api/regulatory-entities/{eid}?permanent=true", headers=admin_headers)


def test_bulk_deactivate_empty_ids(http, base_url, admin_headers):
    """Empty IDs list returns 400."""
    r = http.post(f"{base_url}/api/regulatory-entities/bulk-deactivate", headers=admin_headers, json={"ids": []})
    assert r.status_code == 400


def test_bulk_delete_entities_no_frameworks(http, base_url, admin_headers):
    """Bulk delete entities that own no frameworks succeeds."""
    ids = [
        _create_reg_entity(http, base_url, admin_headers, f"Bulk Del No FW {i}", f"BNF{i}")
        for i in range(2)
    ]
    r = http.post(f"{base_url}/api/regulatory-entities/bulk-delete", headers=admin_headers, json={"ids": ids})
    assert r.status_code == 200
    data = r.json()
    assert data["deleted"] == 2
    assert data["requested"] == 2


def test_bulk_delete_blocked_by_frameworks(http, base_url, admin_headers):
    """Bulk delete is blocked when entities own compliance frameworks."""
    entities = http.get(f"{base_url}/api/regulatory-entities/", headers=admin_headers).json()
    sdaia = next((e for e in entities if e.get("frameworks") and len(e["frameworks"]) > 0), None)
    if not sdaia:
        return  # skip if no entity with frameworks
    r = http.post(f"{base_url}/api/regulatory-entities/bulk-delete", headers=admin_headers, json={"ids": [sdaia["id"]]})
    assert r.status_code == 409
    detail = r.json().get("detail", "")
    assert "Cannot delete" in detail or "framework" in detail.lower()


def test_bulk_delete_empty_ids(http, base_url, admin_headers):
    """Empty IDs list returns 400."""
    r = http.post(f"{base_url}/api/regulatory-entities/bulk-delete", headers=admin_headers, json={"ids": []})
    assert r.status_code == 400


def test_bulk_delete_requires_admin(http, base_url):
    """Unauthenticated bulk delete is rejected."""
    r = http.post(f"{base_url}/api/regulatory-entities/bulk-delete", json={
        "ids": ["00000000-0000-0000-0000-000000000001"]
    })
    assert r.status_code in (401, 403)

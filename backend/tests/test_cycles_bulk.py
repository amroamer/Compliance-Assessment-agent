"""Module 4b: Assessment Cycles bulk delete tests."""
import uuid


def _get_any_framework_id(http, base_url, admin_headers):
    """Return the first active framework ID, or None."""
    fws = http.get(f"{base_url}/api/frameworks", headers=admin_headers).json()
    active = [fw for fw in fws if fw.get("status") not in ("Archived",)]
    return active[0]["id"] if active else None


def _create_cycle(http, base_url, admin_headers, name, fw_id):
    """Helper: create a throwaway cycle and return its id. Uses Inactive status to avoid conflicts."""
    r = http.post(f"{base_url}/api/assessment-cycle-configs", headers=admin_headers, json={
        "framework_id": fw_id,
        "cycle_name": name,
        "start_date": "2099-01-01",
        "end_date": "2099-12-31",
        "status": "Inactive",
    })
    assert r.status_code == 201, f"Failed to create cycle: {r.text}"
    return r.json()["id"]


def test_bulk_delete_single_cycle(http, base_url, admin_headers):
    """Bulk delete with one ID works and returns correct counts."""
    fw_id = _get_any_framework_id(http, base_url, admin_headers)
    if not fw_id:
        return  # skip if no frameworks
    cid = _create_cycle(http, base_url, admin_headers, "Bulk Del Single 2099", fw_id)
    r = http.post(f"{base_url}/api/assessment-cycle-configs/bulk-delete", headers=admin_headers, json={"ids": [cid]})
    assert r.status_code == 200, f"Expected 200, got {r.status_code}: {r.text}"
    data = r.json()
    assert data["deleted"] == 1
    assert data["requested"] == 1


def test_bulk_delete_multiple_cycles(http, base_url, admin_headers):
    """Bulk delete removes all specified cycles."""
    fw_id = _get_any_framework_id(http, base_url, admin_headers)
    if not fw_id:
        return
    ids = [_create_cycle(http, base_url, admin_headers, f"Bulk Del Multi {i} 2099", fw_id) for i in range(3)]
    r = http.post(f"{base_url}/api/assessment-cycle-configs/bulk-delete", headers=admin_headers, json={"ids": ids})
    assert r.status_code == 200
    data = r.json()
    assert data["deleted"] == 3
    assert data["requested"] == 3


def test_bulk_delete_cycles_empty_ids(http, base_url, admin_headers):
    """Empty IDs list returns 400."""
    r = http.post(f"{base_url}/api/assessment-cycle-configs/bulk-delete", headers=admin_headers, json={"ids": []})
    assert r.status_code == 400


def test_bulk_delete_cycles_nonexistent_ids(http, base_url, admin_headers):
    """All-nonexistent IDs returns 404."""
    r = http.post(f"{base_url}/api/assessment-cycle-configs/bulk-delete", headers=admin_headers, json={
        "ids": ["00000000-0000-0000-0000-000000000001"]
    })
    assert r.status_code == 404


def test_bulk_delete_cycles_requires_admin(http, base_url):
    """Unauthenticated bulk delete is rejected."""
    r = http.post(f"{base_url}/api/assessment-cycle-configs/bulk-delete", json={
        "ids": ["00000000-0000-0000-0000-000000000001"]
    })
    assert r.status_code in (401, 403)

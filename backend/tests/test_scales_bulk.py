"""Scale bulk-delete + single hard-delete tests."""
import uuid as _uuid


def _get_fw_id(http, base_url, admin_headers):
    return http.get(f"{base_url}/api/frameworks", headers=admin_headers).json()[0]["id"]


def _create_scale(http, base_url, admin_headers, fw_id=None, name=None):
    """Helper: create a throwaway scale and return its id."""
    if fw_id is None:
        fw_id = _get_fw_id(http, base_url, admin_headers)
    if name is None:
        name = f"Test Scale UT {_uuid.uuid4().hex[:8]}"
    r = http.post(f"{base_url}/api/frameworks/{fw_id}/scales", headers=admin_headers, json={
        "name": name,
        "scale_type": "ordinal",
        "is_cumulative": False,
        "levels": [
            {"value": 0, "label": "Low", "label_ar": "", "color": "#FF0000", "sort_order": 0},
            {"value": 1, "label": "High", "label_ar": "", "color": "#00FF00", "sort_order": 1},
        ],
    })
    assert r.status_code == 201, f"Create scale failed: {r.text}"
    return fw_id, r.json()["id"]


# ── Single hard delete ──

def test_delete_single_scale_success(http, base_url, admin_headers):
    """DELETE single scale returns 204 and scale no longer appears in list."""
    fw_id, sid = _create_scale(http, base_url, admin_headers)
    r = http.delete(f"{base_url}/api/frameworks/{fw_id}/scales/{sid}", headers=admin_headers)
    assert r.status_code == 204
    # Verify removed from list
    scales = http.get(f"{base_url}/api/frameworks/{fw_id}/scales", headers=admin_headers).json()
    assert all(s["id"] != sid for s in scales)


def test_delete_single_scale_not_found(http, base_url, admin_headers):
    """DELETE non-existent scale returns 404."""
    fw_id = _get_fw_id(http, base_url, admin_headers)
    r = http.delete(f"{base_url}/api/frameworks/{fw_id}/scales/00000000-0000-0000-0000-000000000000", headers=admin_headers)
    assert r.status_code == 404


def test_delete_single_scale_requires_admin(http, base_url):
    """Unauthenticated single scale delete is rejected."""
    r = http.delete(f"{base_url}/api/frameworks/00000000-0000-0000-0000-000000000001/scales/00000000-0000-0000-0000-000000000001")
    assert r.status_code in (401, 403)


# ── Bulk delete ──

def test_bulk_delete_single_scale(http, base_url, admin_headers):
    """Bulk delete with one ID works and returns correct counts."""
    fw_id, sid = _create_scale(http, base_url, admin_headers)
    r = http.post(f"{base_url}/api/frameworks/{fw_id}/scales/bulk-delete", headers=admin_headers, json={"ids": [sid]})
    assert r.status_code == 200
    data = r.json()
    assert data["deleted"] == 1
    assert data["requested"] == 1
    assert data["not_found"] == 0
    # Verify removed from list
    scales = http.get(f"{base_url}/api/frameworks/{fw_id}/scales", headers=admin_headers).json()
    assert all(s["id"] != sid for s in scales)


def test_bulk_delete_multiple_scales(http, base_url, admin_headers):
    """Bulk delete removes all specified scales."""
    fw_id = _get_fw_id(http, base_url, admin_headers)
    ids = [_create_scale(http, base_url, admin_headers, fw_id=fw_id)[1] for _ in range(3)]
    r = http.post(f"{base_url}/api/frameworks/{fw_id}/scales/bulk-delete", headers=admin_headers, json={"ids": ids})
    assert r.status_code == 200
    data = r.json()
    assert data["deleted"] == 3
    assert data["requested"] == 3
    # Confirm all gone
    scales = http.get(f"{base_url}/api/frameworks/{fw_id}/scales", headers=admin_headers).json()
    for sid in ids:
        assert all(s["id"] != sid for s in scales)


def test_bulk_delete_partial_nonexistent(http, base_url, admin_headers):
    """Bulk delete with some valid, some nonexistent IDs deletes the valid ones."""
    fw_id, sid = _create_scale(http, base_url, admin_headers)
    fake_id = "00000000-0000-0000-0000-000000000099"
    r = http.post(f"{base_url}/api/frameworks/{fw_id}/scales/bulk-delete", headers=admin_headers, json={"ids": [sid, fake_id]})
    assert r.status_code == 200
    data = r.json()
    assert data["deleted"] == 1
    assert data["requested"] == 2
    assert data["not_found"] == 1


def test_bulk_delete_empty_ids(http, base_url, admin_headers):
    """Empty IDs list returns 400."""
    fw_id = _get_fw_id(http, base_url, admin_headers)
    r = http.post(f"{base_url}/api/frameworks/{fw_id}/scales/bulk-delete", headers=admin_headers, json={"ids": []})
    assert r.status_code == 400


def test_bulk_delete_all_nonexistent(http, base_url, admin_headers):
    """All-nonexistent IDs returns 404."""
    fw_id = _get_fw_id(http, base_url, admin_headers)
    r = http.post(f"{base_url}/api/frameworks/{fw_id}/scales/bulk-delete", headers=admin_headers, json={
        "ids": ["00000000-0000-0000-0000-000000000001", "00000000-0000-0000-0000-000000000002"]
    })
    assert r.status_code == 404


def test_bulk_delete_requires_admin(http, base_url):
    """Unauthenticated bulk delete is rejected."""
    r = http.post(f"{base_url}/api/frameworks/00000000-0000-0000-0000-000000000001/scales/bulk-delete", json={
        "ids": ["00000000-0000-0000-0000-000000000001"]
    })
    assert r.status_code in (401, 403)

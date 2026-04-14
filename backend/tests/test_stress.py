"""Stress and load integration tests.

These tests create bulk data, measure response times, and verify the
system handles concurrent-style rapid requests gracefully.
"""
import time
import uuid


# ── Helpers ──


def _get_fw_id(http, base_url, admin_headers):
    """Return the first active framework ID, or None."""
    fws = http.get(f"{base_url}/api/frameworks", headers=admin_headers).json()
    active = [fw for fw in fws if fw.get("status") not in ("Archived",)]
    return active[0]["id"] if active else None


def _create_entity(http, base_url, admin_headers, suffix):
    """Create a single entity and return its ID."""
    r = http.post(f"{base_url}/api/assessed-entities", headers=admin_headers, json={
        "name": f"Stress Entity {suffix}", "abbreviation": f"SE{suffix[:4].upper()}", "status": "Active",
    })
    assert r.status_code == 201, f"Entity create failed: {r.text}"
    return r.json()["id"]


def _create_user(http, base_url, admin_headers, suffix):
    """Create a single user and return its ID."""
    email = f"stress_{suffix}@test.com"
    r = http.post(f"{base_url}/api/auth/register", headers=admin_headers, json={
        "email": email, "name": f"Stress User {suffix}", "password": "StressPass123!", "role": "kpmg_user",
    })
    assert r.status_code == 201, f"User create failed: {r.text}"
    return r.json()["id"]


def _create_assessment(http, base_url, admin_headers):
    """Create entity + cycle + instance. Return (inst_id, entity_id, cycle_id)."""
    suffix = uuid.uuid4().hex[:8]
    entity_id = _create_entity(http, base_url, admin_headers, suffix)
    fw_id = _get_fw_id(http, base_url, admin_headers)
    assert fw_id, "No active framework for stress test"
    existing = http.get(f"{base_url}/api/assessment-cycle-configs?framework_id={fw_id}", headers=admin_headers).json()
    if existing:
        cycle_id = existing[0]["id"]
    else:
        r_cyc = http.post(f"{base_url}/api/assessment-cycle-configs", headers=admin_headers, json={
            "framework_id": fw_id, "cycle_name": f"StressCycle {suffix}",
            "start_date": "2099-01-01", "end_date": "2099-12-31", "status": "Inactive",
        })
        assert r_cyc.status_code == 201, f"Cycle create failed: {r_cyc.text}"
        cycle_id = r_cyc.json()["id"]
    r_inst = http.post(f"{base_url}/api/assessments", headers=admin_headers, json={
        "cycle_id": cycle_id, "assessed_entity_id": entity_id,
    })
    assert r_inst.status_code == 201, f"Instance create failed: {r_inst.text}"
    return r_inst.json()["id"], entity_id, cycle_id


def _cleanup_assessment(http, base_url, admin_headers, inst_id, cycle_id):
    http.delete(f"{base_url}/api/assessments/{inst_id}", headers=admin_headers)
    http.delete(f"{base_url}/api/assessment-cycle-configs/{cycle_id}", headers=admin_headers)


# ── Bulk Entity Tests ──


def test_bulk_create_50_entities(http, base_url, admin_headers):
    """Create 50 entities in a loop and verify all were created."""
    tag = uuid.uuid4().hex[:6]
    ids = []
    for i in range(50):
        suffix = f"{tag}_{i:03d}"
        eid = _create_entity(http, base_url, admin_headers, suffix)
        ids.append(eid)

    assert len(ids) == 50

    # Verify they all show up in the listing
    all_entities = http.get(f"{base_url}/api/assessed-entities", headers=admin_headers).json()
    all_ids = {e["id"] for e in all_entities}
    for eid in ids:
        assert eid in all_ids, f"Entity {eid} not found in listing"

    # Cleanup via bulk deactivate
    http.post(f"{base_url}/api/assessed-entities/bulk-deactivate", headers=admin_headers, json={"ids": ids})


def test_bulk_create_50_users(http, base_url, admin_headers):
    """Create 50 users in a loop and verify all were created."""
    tag = uuid.uuid4().hex[:6]
    ids = []
    for i in range(50):
        suffix = f"{tag}_{i:03d}"
        uid = _create_user(http, base_url, admin_headers, suffix)
        ids.append(uid)

    assert len(ids) == 50

    # Verify they appear in user list
    all_users = http.get(f"{base_url}/api/users/", headers=admin_headers).json()
    all_ids = {u["id"] for u in all_users}
    for uid in ids:
        assert uid in all_ids, f"User {uid} not found in listing"

    # Cleanup via bulk deactivate
    http.post(f"{base_url}/api/users/bulk-deactivate", headers=admin_headers, json={"ids": ids})


# ── List Performance ──


def test_bulk_list_entities_performance(http, base_url, admin_headers):
    """Listing all entities completes in under 2 seconds."""
    start = time.time()
    r = http.get(f"{base_url}/api/assessed-entities", headers=admin_headers)
    elapsed = time.time() - start
    assert r.status_code == 200
    assert elapsed < 2.0, f"Entity listing took {elapsed:.2f}s (limit 2s)"


def test_bulk_list_users_performance(http, base_url, admin_headers):
    """Listing all users completes in under 2 seconds."""
    start = time.time()
    r = http.get(f"{base_url}/api/users/", headers=admin_headers)
    elapsed = time.time() - start
    assert r.status_code == 200
    assert elapsed < 2.0, f"User listing took {elapsed:.2f}s (limit 2s)"


# ── Rapid Response Saving ──


def test_large_assessment_response_batch(http, base_url, admin_headers):
    """Save 20 responses rapidly in an assessment."""
    inst_id, ent_id, cyc_id = _create_assessment(http, base_url, admin_headers)
    try:
        responses = http.get(f"{base_url}/api/assessments/{inst_id}/responses", headers=admin_headers).json()
        # Save up to 20 responses
        saved = 0
        for resp in responses[:20]:
            node_id = resp["node_id"]
            r = http.put(
                f"{base_url}/api/assessments/{inst_id}/responses/{node_id}",
                headers=admin_headers,
                json={"response_data": {"notes": f"batch note {saved}"}, "status": "draft"},
            )
            if r.status_code == 200:
                saved += 1
        # At least some responses should have been saved (if the framework has nodes)
        if responses:
            assert saved > 0, "No responses were saved"
    finally:
        _cleanup_assessment(http, base_url, admin_headers, inst_id, cyc_id)


# ── Concurrent-style Compliance Stats ──


def test_concurrent_compliance_stats(http, base_url, admin_headers):
    """Call compliance-stats 10 times rapidly — all should return 200."""
    inst_id, ent_id, cyc_id = _create_assessment(http, base_url, admin_headers)
    try:
        results = []
        for _ in range(10):
            r = http.get(f"{base_url}/api/assessments/{inst_id}/compliance-stats", headers=admin_headers)
            results.append(r.status_code)
        assert all(s == 200 for s in results), f"Some compliance-stats calls failed: {results}"
    finally:
        _cleanup_assessment(http, base_url, admin_headers, inst_id, cyc_id)


# ── Export After Bulk Create ──


def test_export_large_entities(http, base_url, admin_headers):
    """Export entities Excel after bulk creation returns 200."""
    tag = uuid.uuid4().hex[:6]
    ids = []
    for i in range(10):
        eid = _create_entity(http, base_url, admin_headers, f"{tag}_{i:03d}")
        ids.append(eid)

    r = http.get(f"{base_url}/api/bulk-entities/export-excel", headers=admin_headers)
    assert r.status_code == 200
    assert "spreadsheet" in r.headers.get("content-type", "")

    # Cleanup
    http.post(f"{base_url}/api/assessed-entities/bulk-deactivate", headers=admin_headers, json={"ids": ids})


# ── Bulk Delete ──


def test_bulk_delete_50_entities(http, base_url, admin_headers):
    """Create 50 entities, then bulk-deactivate them all."""
    tag = uuid.uuid4().hex[:6]
    ids = []
    for i in range(50):
        eid = _create_entity(http, base_url, admin_headers, f"{tag}_{i:03d}")
        ids.append(eid)

    r = http.post(f"{base_url}/api/assessed-entities/bulk-deactivate", headers=admin_headers, json={"ids": ids})
    assert r.status_code == 200
    data = r.json()
    assert data["deactivated"] == 50
    assert data["requested"] == 50


def test_bulk_delete_50_users(http, base_url, admin_headers):
    """Create 50 users, then bulk-deactivate them all."""
    tag = uuid.uuid4().hex[:6]
    ids = []
    for i in range(50):
        uid = _create_user(http, base_url, admin_headers, f"{tag}_{i:03d}")
        ids.append(uid)

    r = http.post(f"{base_url}/api/users/bulk-deactivate", headers=admin_headers, json={"ids": ids})
    assert r.status_code == 200
    data = r.json()
    assert data["deactivated"] == 50
    assert data["requested"] == 50


# ── Score Calculation Performance ──


def test_score_calculation_performance(http, base_url, admin_headers):
    """POST /api/assessments/{id}/calculate-scores completes in under 5 seconds."""
    inst_id, ent_id, cyc_id = _create_assessment(http, base_url, admin_headers)
    try:
        start = time.time()
        r = http.post(f"{base_url}/api/assessments/{inst_id}/calculate-scores", headers=admin_headers)
        elapsed = time.time() - start
        assert r.status_code == 200
        assert elapsed < 5.0, f"Score calculation took {elapsed:.2f}s (limit 5s)"
    finally:
        _cleanup_assessment(http, base_url, admin_headers, inst_id, cyc_id)


# ── Assessment List With Many Instances ──


def test_assessment_list_with_many_instances(http, base_url, admin_headers):
    """Listing assessments completes quickly even with data in the system."""
    start = time.time()
    r = http.get(f"{base_url}/api/assessments", headers=admin_headers)
    elapsed = time.time() - start
    assert r.status_code == 200
    assert isinstance(r.json(), list)
    assert elapsed < 2.0, f"Assessment list took {elapsed:.2f}s (limit 2s)"


# ── Framework With Many Nodes ──


def test_framework_with_many_nodes(http, base_url, admin_headers):
    """GET /api/frameworks/{fw_id}/nodes returns quickly."""
    fw_id = _get_fw_id(http, base_url, admin_headers)
    if not fw_id:
        return
    start = time.time()
    r = http.get(f"{base_url}/api/frameworks/{fw_id}/nodes", headers=admin_headers)
    elapsed = time.time() - start
    assert r.status_code == 200
    assert isinstance(r.json(), list)
    assert elapsed < 2.0, f"Framework node listing took {elapsed:.2f}s (limit 2s)"

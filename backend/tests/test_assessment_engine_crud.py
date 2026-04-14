"""Assessment Engine CRUD — full lifecycle integration tests.

Covers: list, create, get, responses, compliance stats, scoring,
status transitions, exports, delete, auth checks, and history.
"""
import uuid


# ── Helpers ──


def _get_fw_id(http, base_url, admin_headers):
    """Return the first active framework ID, or None."""
    fws = http.get(f"{base_url}/api/frameworks", headers=admin_headers).json()
    active = [fw for fw in fws if fw.get("status") not in ("Archived",)]
    return active[0]["id"] if active else None


def _get_entity_id(http, base_url, admin_headers):
    """Return the first assessed-entity ID, or None."""
    entities = http.get(f"{base_url}/api/assessed-entities", headers=admin_headers).json()
    return entities[0]["id"] if entities else None


def _get_cycle_id(http, base_url, admin_headers):
    """Return the first assessment-cycle-config ID, or None."""
    cycles = http.get(f"{base_url}/api/assessment-cycle-configs", headers=admin_headers).json()
    return cycles[0]["id"] if cycles else None


def _create_assessment(http, base_url, admin_headers):
    """Create a fresh assessment instance and return its ID.

    Creates a throwaway entity and a throwaway cycle so there is no
    duplicate-instance conflict with existing data.  Returns
    (instance_id, entity_id, cycle_id) so callers can clean up.
    """
    # Unique entity
    suffix = uuid.uuid4().hex[:8]
    r_ent = http.post(f"{base_url}/api/assessed-entities", headers=admin_headers, json={
        "name": f"CrudTest Entity {suffix}", "abbreviation": f"CT{suffix[:4].upper()}", "status": "Active",
    })
    assert r_ent.status_code == 201, f"Entity create failed: {r_ent.text}"
    entity_id = r_ent.json()["id"]

    # Need a framework + cycle
    fw_id = _get_fw_id(http, base_url, admin_headers)
    assert fw_id, "No active framework available for test"

    # Use existing cycle if available, else create one with Inactive status
    existing_cycles = http.get(f"{base_url}/api/assessment-cycle-configs?framework_id={fw_id}", headers=admin_headers).json()
    if existing_cycles:
        cycle_id_val = existing_cycles[0]["id"]
    else:
        cycle_name = f"CrudCycle {suffix}"
        r_cyc = http.post(f"{base_url}/api/assessment-cycle-configs", headers=admin_headers, json={
            "framework_id": fw_id, "cycle_name": cycle_name,
            "start_date": "2099-01-01", "end_date": "2099-12-31", "status": "Inactive",
        })
        assert r_cyc.status_code == 201, f"Cycle create failed: {r_cyc.text}"
        cycle_id_val = r_cyc.json()["id"]

    # Create instance
    r_inst = http.post(f"{base_url}/api/assessments", headers=admin_headers, json={
        "cycle_id": cycle_id_val, "assessed_entity_id": entity_id,
    })
    assert r_inst.status_code == 201, f"Instance create failed: {r_inst.text}"
    instance_id = r_inst.json()["id"]

    return instance_id, entity_id, cycle_id_val


def _cleanup_assessment(http, base_url, admin_headers, instance_id, cycle_id):
    """Best-effort cleanup of instance + cycle."""
    http.delete(f"{base_url}/api/assessments/{instance_id}", headers=admin_headers)
    http.delete(f"{base_url}/api/assessment-cycle-configs/{cycle_id}", headers=admin_headers)


# ── Tests ──


def test_list_assessments(http, base_url, admin_headers):
    """GET /api/assessments returns a list."""
    r = http.get(f"{base_url}/api/assessments", headers=admin_headers)
    assert r.status_code == 200
    assert isinstance(r.json(), list)


def test_create_assessment(http, base_url, admin_headers):
    """POST /api/assessments creates an instance with correct fields."""
    inst_id, ent_id, cyc_id = _create_assessment(http, base_url, admin_headers)
    try:
        r = http.get(f"{base_url}/api/assessments/{inst_id}", headers=admin_headers)
        assert r.status_code == 200
        data = r.json()
        assert data["id"] == inst_id
        assert data["assessed_entity"]["id"] == ent_id
        assert data["status"] in ("not_started", "in_progress")
    finally:
        _cleanup_assessment(http, base_url, admin_headers, inst_id, cyc_id)


def test_get_assessment(http, base_url, admin_headers):
    """GET /api/assessments/{id} returns detailed instance data."""
    inst_id, ent_id, cyc_id = _create_assessment(http, base_url, admin_headers)
    try:
        r = http.get(f"{base_url}/api/assessments/{inst_id}", headers=admin_headers)
        assert r.status_code == 200
        data = r.json()
        assert "framework" in data
        assert "assessed_entity" in data
        assert "total_assessable_nodes" in data
    finally:
        _cleanup_assessment(http, base_url, admin_headers, inst_id, cyc_id)


def test_get_assessment_not_found(http, base_url, admin_headers):
    """GET /api/assessments/{bogus_id} returns 404."""
    r = http.get(f"{base_url}/api/assessments/00000000-0000-0000-0000-000000000000", headers=admin_headers)
    assert r.status_code == 404


def test_list_responses(http, base_url, admin_headers):
    """GET /api/assessments/{id}/responses returns a list of responses."""
    inst_id, _, cyc_id = _create_assessment(http, base_url, admin_headers)
    try:
        r = http.get(f"{base_url}/api/assessments/{inst_id}/responses", headers=admin_headers)
        assert r.status_code == 200
        assert isinstance(r.json(), list)
    finally:
        _cleanup_assessment(http, base_url, admin_headers, inst_id, cyc_id)


def test_save_response(http, base_url, admin_headers):
    """PUT /api/assessments/{id}/responses/{node_id} saves response data."""
    inst_id, _, cyc_id = _create_assessment(http, base_url, admin_headers)
    try:
        responses = http.get(f"{base_url}/api/assessments/{inst_id}/responses", headers=admin_headers).json()
        if not responses:
            return
        node_id = responses[0]["node_id"]
        r = http.put(
            f"{base_url}/api/assessments/{inst_id}/responses/{node_id}",
            headers=admin_headers,
            json={"response_data": {"notes": "test note"}, "status": "draft"},
        )
        assert r.status_code == 200
        assert r.json()["status"] == "draft"
    finally:
        _cleanup_assessment(http, base_url, admin_headers, inst_id, cyc_id)


def test_get_response_by_node(http, base_url, admin_headers):
    """GET /api/assessments/{id}/responses/by-node/{node_id} returns single response."""
    inst_id, _, cyc_id = _create_assessment(http, base_url, admin_headers)
    try:
        responses = http.get(f"{base_url}/api/assessments/{inst_id}/responses", headers=admin_headers).json()
        if not responses:
            return
        node_id = responses[0]["node_id"]
        r = http.get(f"{base_url}/api/assessments/{inst_id}/responses/by-node/{node_id}", headers=admin_headers)
        assert r.status_code == 200
    finally:
        _cleanup_assessment(http, base_url, admin_headers, inst_id, cyc_id)


def test_compliance_stats(http, base_url, admin_headers):
    """GET /api/assessments/{id}/compliance-stats returns expected keys."""
    inst_id, _, cyc_id = _create_assessment(http, base_url, admin_headers)
    try:
        r = http.get(f"{base_url}/api/assessments/{inst_id}/compliance-stats", headers=admin_headers)
        assert r.status_code == 200
        data = r.json()
        for key in ("total", "pending", "answered", "compliant", "semi_compliant", "non_compliant"):
            assert key in data, f"Missing key: {key}"
    finally:
        _cleanup_assessment(http, base_url, admin_headers, inst_id, cyc_id)


def test_compliance_stats_per_product(http, base_url, admin_headers):
    """GET /api/assessments/{id}/compliance-stats?ai_product_id=... filters by product."""
    inst_id, ent_id, cyc_id = _create_assessment(http, base_url, admin_headers)
    try:
        # Create an AI product on the entity
        r_prod = http.post(f"{base_url}/api/assessed-entities/{ent_id}/ai-products", headers=admin_headers, json={
            "name": f"StatsProduct {uuid.uuid4().hex[:6]}", "product_type": "Chatbot", "status": "Active",
        })
        if r_prod.status_code == 201:
            pid = r_prod.json()["id"]
            r = http.get(
                f"{base_url}/api/assessments/{inst_id}/compliance-stats?ai_product_id={pid}",
                headers=admin_headers,
            )
            assert r.status_code == 200
            assert "total" in r.json()
            # Cleanup product
            http.delete(f"{base_url}/api/assessed-entities/{ent_id}/ai-products/{pid}", headers=admin_headers)
    finally:
        _cleanup_assessment(http, base_url, admin_headers, inst_id, cyc_id)


def test_calculate_scores(http, base_url, admin_headers):
    """POST /api/assessments/{id}/calculate-scores triggers score calculation."""
    inst_id, _, cyc_id = _create_assessment(http, base_url, admin_headers)
    try:
        r = http.post(f"{base_url}/api/assessments/{inst_id}/calculate-scores", headers=admin_headers)
        assert r.status_code == 200
        assert "status" in r.json()
    finally:
        _cleanup_assessment(http, base_url, admin_headers, inst_id, cyc_id)


def test_get_scores(http, base_url, admin_headers):
    """GET /api/assessments/{id}/scores returns node_scores array."""
    inst_id, _, cyc_id = _create_assessment(http, base_url, admin_headers)
    try:
        # Ensure scores are calculated first
        http.post(f"{base_url}/api/assessments/{inst_id}/calculate-scores", headers=admin_headers)
        r = http.get(f"{base_url}/api/assessments/{inst_id}/scores", headers=admin_headers)
        assert r.status_code == 200
        data = r.json()
        assert "node_scores" in data
        assert isinstance(data["node_scores"], list)
    finally:
        _cleanup_assessment(http, base_url, admin_headers, inst_id, cyc_id)


def test_status_transition_submit(http, base_url, admin_headers):
    """PUT /api/assessments/{id}/submit transitions from in_progress to submitted."""
    inst_id, _, cyc_id = _create_assessment(http, base_url, admin_headers)
    try:
        # Need to move to in_progress first by saving a response
        responses = http.get(f"{base_url}/api/assessments/{inst_id}/responses", headers=admin_headers).json()
        if responses:
            node_id = responses[0]["node_id"]
            http.put(
                f"{base_url}/api/assessments/{inst_id}/responses/{node_id}",
                headers=admin_headers,
                json={"response_data": {"notes": "move to in_progress"}, "status": "draft"},
            )

        r = http.put(f"{base_url}/api/assessments/{inst_id}/submit", headers=admin_headers)
        assert r.status_code == 200
        assert r.json()["status"] == "submitted"
    finally:
        _cleanup_assessment(http, base_url, admin_headers, inst_id, cyc_id)


def test_status_transition_complete(http, base_url, admin_headers):
    """Full lifecycle: in_progress -> submitted -> under_review -> completed."""
    inst_id, _, cyc_id = _create_assessment(http, base_url, admin_headers)
    try:
        # Move to in_progress via response save
        responses = http.get(f"{base_url}/api/assessments/{inst_id}/responses", headers=admin_headers).json()
        if responses:
            node_id = responses[0]["node_id"]
            http.put(
                f"{base_url}/api/assessments/{inst_id}/responses/{node_id}",
                headers=admin_headers,
                json={"response_data": {"notes": "lifecycle test"}, "status": "draft"},
            )

        # Submit
        r_sub = http.put(f"{base_url}/api/assessments/{inst_id}/submit", headers=admin_headers)
        assert r_sub.status_code == 200

        # Pickup (under_review)
        r_pick = http.put(f"{base_url}/api/assessments/{inst_id}/pickup", headers=admin_headers)
        assert r_pick.status_code == 200
        assert r_pick.json()["status"] == "under_review"

        # Complete
        r_done = http.put(f"{base_url}/api/assessments/{inst_id}/complete", headers=admin_headers)
        assert r_done.status_code == 200
        assert r_done.json()["status"] == "completed"
    finally:
        _cleanup_assessment(http, base_url, admin_headers, inst_id, cyc_id)


def test_status_transition_invalid(http, base_url, admin_headers):
    """Attempting an invalid transition returns 400."""
    inst_id, _, cyc_id = _create_assessment(http, base_url, admin_headers)
    try:
        # Trying to complete a not_started/in_progress assessment directly should fail
        r = http.put(f"{base_url}/api/assessments/{inst_id}/complete", headers=admin_headers)
        assert r.status_code == 400
    finally:
        _cleanup_assessment(http, base_url, admin_headers, inst_id, cyc_id)


def test_export_excel_report(http, base_url, admin_headers):
    """GET /api/assessments/{id}/export/report returns Excel file."""
    inst_id, _, cyc_id = _create_assessment(http, base_url, admin_headers)
    try:
        r = http.get(f"{base_url}/api/assessments/{inst_id}/export/report", headers=admin_headers)
        assert r.status_code == 200
        assert "spreadsheet" in r.headers.get("content-type", "")
    finally:
        _cleanup_assessment(http, base_url, admin_headers, inst_id, cyc_id)


def test_export_pdf_report(http, base_url, admin_headers):
    """GET /api/assessments/{id}/export/pdf returns PDF file."""
    inst_id, _, cyc_id = _create_assessment(http, base_url, admin_headers)
    try:
        r = http.get(f"{base_url}/api/assessments/{inst_id}/export/pdf", headers=admin_headers, timeout=30)
        assert r.status_code == 200
        assert "pdf" in r.headers.get("content-type", "")
    finally:
        _cleanup_assessment(http, base_url, admin_headers, inst_id, cyc_id)


def test_delete_assessment(http, base_url, admin_headers):
    """DELETE /api/assessments/{id} removes the instance."""
    inst_id, _, cyc_id = _create_assessment(http, base_url, admin_headers)
    r = http.delete(f"{base_url}/api/assessments/{inst_id}", headers=admin_headers)
    assert r.status_code == 204

    # Confirm it is gone
    r2 = http.get(f"{base_url}/api/assessments/{inst_id}", headers=admin_headers)
    assert r2.status_code == 404

    # Cleanup cycle
    http.delete(f"{base_url}/api/assessment-cycle-configs/{cyc_id}", headers=admin_headers)


def test_create_assessment_requires_auth(http, base_url):
    """POST /api/assessments without token returns 401/403."""
    r = http.post(f"{base_url}/api/assessments", json={
        "cycle_id": "00000000-0000-0000-0000-000000000001",
        "assessed_entity_id": "00000000-0000-0000-0000-000000000001",
    })
    assert r.status_code in (401, 403)


def test_response_history(http, base_url, admin_headers):
    """GET /api/assessments/{id}/responses/{node_id}/history returns list."""
    inst_id, _, cyc_id = _create_assessment(http, base_url, admin_headers)
    try:
        responses = http.get(f"{base_url}/api/assessments/{inst_id}/responses", headers=admin_headers).json()
        if not responses:
            return
        node_id = responses[0]["node_id"]
        # Save a response to create history
        http.put(
            f"{base_url}/api/assessments/{inst_id}/responses/{node_id}",
            headers=admin_headers,
            json={"response_data": {"notes": "history test"}, "status": "draft"},
        )
        r = http.get(f"{base_url}/api/assessments/{inst_id}/responses/{node_id}/history", headers=admin_headers)
        assert r.status_code == 200
        assert isinstance(r.json(), list)
    finally:
        _cleanup_assessment(http, base_url, admin_headers, inst_id, cyc_id)


def test_create_duplicate_assessment_rejected(http, base_url, admin_headers):
    """Creating two instances for the same cycle+entity returns 409."""
    inst_id, ent_id, cyc_id = _create_assessment(http, base_url, admin_headers)
    try:
        r = http.post(f"{base_url}/api/assessments", headers=admin_headers, json={
            "cycle_id": cyc_id, "assessed_entity_id": ent_id,
        })
        assert r.status_code == 409
    finally:
        _cleanup_assessment(http, base_url, admin_headers, inst_id, cyc_id)


def test_list_assessments_filter_by_status(http, base_url, admin_headers):
    """GET /api/assessments?status=... filters results."""
    r = http.get(f"{base_url}/api/assessments?status=completed", headers=admin_headers)
    assert r.status_code == 200
    data = r.json()
    assert isinstance(data, list)
    for inst in data:
        assert inst["status"] == "completed"


def test_list_assessments_filter_by_entity(http, base_url, admin_headers):
    """GET /api/assessments?assessed_entity_id=... filters results."""
    eid = _get_entity_id(http, base_url, admin_headers)
    if not eid:
        return
    r = http.get(f"{base_url}/api/assessments?assessed_entity_id={eid}", headers=admin_headers)
    assert r.status_code == 200
    data = r.json()
    assert isinstance(data, list)
    for inst in data:
        assert inst["assessed_entity"]["id"] == eid


def test_get_products_for_instance(http, base_url, admin_headers):
    """GET /api/assessments/{id}/products returns product list."""
    inst_id, _, cyc_id = _create_assessment(http, base_url, admin_headers)
    try:
        r = http.get(f"{base_url}/api/assessments/{inst_id}/products", headers=admin_headers)
        assert r.status_code == 200
        assert isinstance(r.json(), list)
    finally:
        _cleanup_assessment(http, base_url, admin_headers, inst_id, cyc_id)


def test_archive_assessment(http, base_url, admin_headers):
    """Full lifecycle to archived status."""
    inst_id, _, cyc_id = _create_assessment(http, base_url, admin_headers)
    try:
        # Move through lifecycle: save response -> submit -> pickup -> complete -> archive
        responses = http.get(f"{base_url}/api/assessments/{inst_id}/responses", headers=admin_headers).json()
        if responses:
            node_id = responses[0]["node_id"]
            http.put(
                f"{base_url}/api/assessments/{inst_id}/responses/{node_id}",
                headers=admin_headers,
                json={"response_data": {"notes": "archive test"}, "status": "draft"},
            )
        http.put(f"{base_url}/api/assessments/{inst_id}/submit", headers=admin_headers)
        http.put(f"{base_url}/api/assessments/{inst_id}/pickup", headers=admin_headers)
        http.put(f"{base_url}/api/assessments/{inst_id}/complete", headers=admin_headers)
        r = http.put(f"{base_url}/api/assessments/{inst_id}/archive", headers=admin_headers)
        assert r.status_code == 200
        assert r.json()["status"] == "archived"
    finally:
        _cleanup_assessment(http, base_url, admin_headers, inst_id, cyc_id)


def test_send_back_assessment(http, base_url, admin_headers):
    """PUT /api/assessments/{id}/send-back returns to in_progress with comments."""
    inst_id, _, cyc_id = _create_assessment(http, base_url, admin_headers)
    try:
        # Move to submitted -> pickup -> send-back
        responses = http.get(f"{base_url}/api/assessments/{inst_id}/responses", headers=admin_headers).json()
        if responses:
            node_id = responses[0]["node_id"]
            http.put(
                f"{base_url}/api/assessments/{inst_id}/responses/{node_id}",
                headers=admin_headers,
                json={"response_data": {"notes": "send-back test"}, "status": "draft"},
            )
        http.put(f"{base_url}/api/assessments/{inst_id}/submit", headers=admin_headers)
        http.put(f"{base_url}/api/assessments/{inst_id}/pickup", headers=admin_headers)

        r = http.put(f"{base_url}/api/assessments/{inst_id}/send-back", headers=admin_headers, json={
            "review_comments": "Needs more detail",
        })
        assert r.status_code == 200
        assert r.json()["status"] == "in_progress"
        assert r.json()["review_comments"] == "Needs more detail"
    finally:
        _cleanup_assessment(http, base_url, admin_headers, inst_id, cyc_id)

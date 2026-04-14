"""Entity Dashboard and AI Product CRUD integration tests.

Covers: entity listing, entity dashboard, entity scores,
AI product CRUD, and the main dashboard health endpoint.
"""
import uuid


# ── Helpers ──


def _get_entity_id(http, base_url, admin_headers):
    """Return the first assessed-entity ID, or None."""
    entities = http.get(f"{base_url}/api/assessed-entities", headers=admin_headers).json()
    return entities[0]["id"] if entities else None


def _get_fw_id(http, base_url, admin_headers):
    """Return the first active framework ID, or None."""
    fws = http.get(f"{base_url}/api/frameworks", headers=admin_headers).json()
    active = [fw for fw in fws if fw.get("status") not in ("Archived",)]
    return active[0]["id"] if active else None


# ── Entity Listing ──


def test_list_entities_page(http, base_url, admin_headers):
    """GET /api/assessed-entities returns a list of entities."""
    r = http.get(f"{base_url}/api/assessed-entities", headers=admin_headers)
    assert r.status_code == 200
    data = r.json()
    assert isinstance(data, list)
    if data:
        entity = data[0]
        assert "id" in entity
        assert "name" in entity
        assert "status" in entity


# ── Entity Dashboard ──


def test_get_entity_dashboard(http, base_url, admin_headers):
    """GET /api/assessed-entities/{id}/dashboard returns structured dashboard."""
    eid = _get_entity_id(http, base_url, admin_headers)
    if not eid:
        return
    r = http.get(f"{base_url}/api/assessed-entities/{eid}/dashboard", headers=admin_headers)
    assert r.status_code == 200
    data = r.json()
    assert "entity" in data
    assert "summary" in data


def test_entity_dashboard_with_data(http, base_url, admin_headers):
    """Entity dashboard summary contains expected aggregate fields."""
    eid = _get_entity_id(http, base_url, admin_headers)
    if not eid:
        return
    r = http.get(f"{base_url}/api/assessed-entities/{eid}/dashboard", headers=admin_headers)
    assert r.status_code == 200
    summary = r.json()["summary"]
    for key in ("frameworks_assessed", "active_assessments", "completed_assessments",
                "ai_products_count", "overall_compliance_pct"):
        assert key in summary, f"Missing summary key: {key}"
    # Check nested sections exist
    data = r.json()
    assert "current_cycle_assessments" in data
    assert "recent_activity" in data
    assert "ai_products_summary" in data


def test_entity_dashboard_not_found(http, base_url, admin_headers):
    """Dashboard for a non-existent entity returns 404."""
    r = http.get(
        f"{base_url}/api/assessed-entities/00000000-0000-0000-0000-000000000000/dashboard",
        headers=admin_headers,
    )
    assert r.status_code == 404


# ── Entity Scores ──


def test_get_entity_scores(http, base_url, admin_headers):
    """GET /api/assessed-entities/{id}/scores returns score data."""
    eid = _get_entity_id(http, base_url, admin_headers)
    if not eid:
        return
    r = http.get(f"{base_url}/api/assessed-entities/{eid}/scores", headers=admin_headers)
    assert r.status_code == 200
    data = r.json()
    assert isinstance(data, (list, dict))


def test_entity_scores_with_framework_filter(http, base_url, admin_headers):
    """GET /api/assessed-entities/{id}/scores?framework_id=... filters by framework."""
    eid = _get_entity_id(http, base_url, admin_headers)
    fw_id = _get_fw_id(http, base_url, admin_headers)
    if not eid or not fw_id:
        return
    r = http.get(
        f"{base_url}/api/assessed-entities/{eid}/scores?framework_id={fw_id}",
        headers=admin_headers,
    )
    assert r.status_code == 200


# ── AI Products CRUD ──


def test_list_ai_products(http, base_url, admin_headers):
    """GET /api/assessed-entities/{id}/ai-products returns a list."""
    eid = _get_entity_id(http, base_url, admin_headers)
    if not eid:
        return
    r = http.get(f"{base_url}/api/assessed-entities/{eid}/ai-products", headers=admin_headers)
    assert r.status_code == 200
    assert isinstance(r.json(), list)


def test_create_ai_product(http, base_url, admin_headers):
    """POST /api/assessed-entities/{id}/ai-products creates a product."""
    eid = _get_entity_id(http, base_url, admin_headers)
    if not eid:
        return
    suffix = uuid.uuid4().hex[:6]
    r = http.post(f"{base_url}/api/assessed-entities/{eid}/ai-products", headers=admin_headers, json={
        "name": f"DashTest Product {suffix}", "product_type": "Chatbot",
        "risk_level": "Low", "status": "Active",
    })
    assert r.status_code == 201
    data = r.json()
    assert data["name"] == f"DashTest Product {suffix}"
    assert data["product_type"] == "Chatbot"
    # Cleanup
    http.delete(f"{base_url}/api/assessed-entities/{eid}/ai-products/{data['id']}", headers=admin_headers)


def test_update_ai_product(http, base_url, admin_headers):
    """PUT /api/assessed-entities/{id}/ai-products/{pid} updates fields."""
    eid = _get_entity_id(http, base_url, admin_headers)
    if not eid:
        return
    suffix = uuid.uuid4().hex[:6]
    r_create = http.post(f"{base_url}/api/assessed-entities/{eid}/ai-products", headers=admin_headers, json={
        "name": f"UpdProd {suffix}", "product_type": "ML Model", "status": "Active",
    })
    assert r_create.status_code == 201
    pid = r_create.json()["id"]

    r_upd = http.put(f"{base_url}/api/assessed-entities/{eid}/ai-products/{pid}", headers=admin_headers, json={
        "name": f"UpdProd {suffix} v2", "risk_level": "High",
    })
    assert r_upd.status_code == 200
    assert r_upd.json()["name"] == f"UpdProd {suffix} v2"
    assert r_upd.json()["risk_level"] == "High"

    # Cleanup
    http.delete(f"{base_url}/api/assessed-entities/{eid}/ai-products/{pid}", headers=admin_headers)


def test_delete_ai_product(http, base_url, admin_headers):
    """DELETE /api/assessed-entities/{id}/ai-products/{pid} removes the product."""
    eid = _get_entity_id(http, base_url, admin_headers)
    if not eid:
        return
    suffix = uuid.uuid4().hex[:6]
    r_create = http.post(f"{base_url}/api/assessed-entities/{eid}/ai-products", headers=admin_headers, json={
        "name": f"DelProd {suffix}", "product_type": "Chatbot", "status": "Active",
    })
    assert r_create.status_code == 201
    pid = r_create.json()["id"]

    r_del = http.delete(f"{base_url}/api/assessed-entities/{eid}/ai-products/{pid}", headers=admin_headers)
    assert r_del.status_code == 204

    # Confirm gone
    r_get = http.get(f"{base_url}/api/assessed-entities/{eid}/ai-products/{pid}", headers=admin_headers)
    assert r_get.status_code == 404


# ── Main Dashboard Health ──


def test_dashboard_health(http, base_url, admin_headers):
    """GET /api/dashboard-v2 returns aggregated dashboard data."""
    r = http.get(f"{base_url}/api/dashboard-v2", headers=admin_headers)
    assert r.status_code == 200
    assert isinstance(r.json(), dict)

"""Module 8: AI Products tests."""


def _get_entity_id(http, base_url, admin_headers):
    entities = http.get(f"{base_url}/api/assessed-entities", headers=admin_headers).json()
    return entities[0]["id"] if entities else None


def test_list_ai_products(http, base_url, admin_headers):
    eid = _get_entity_id(http, base_url, admin_headers)
    if not eid:
        return
    r = http.get(f"{base_url}/api/assessed-entities/{eid}/ai-products", headers=admin_headers)
    assert r.status_code == 200
    assert isinstance(r.json(), list)


def test_create_and_delete_ai_product(http, base_url, admin_headers):
    eid = _get_entity_id(http, base_url, admin_headers)
    if not eid:
        return
    r = http.post(f"{base_url}/api/assessed-entities/{eid}/ai-products", headers=admin_headers, json={
        "name": "Test AI Product", "product_type": "Chatbot", "risk_level": "Low", "status": "Active",
    })
    assert r.status_code == 201
    assert r.json()["name"] == "Test AI Product"
    pid = r.json()["id"]
    r2 = http.delete(f"{base_url}/api/assessed-entities/{eid}/ai-products/{pid}", headers=admin_headers)
    assert r2.status_code == 204


def test_update_ai_product(http, base_url, admin_headers):
    eid = _get_entity_id(http, base_url, admin_headers)
    if not eid:
        return
    r = http.post(f"{base_url}/api/assessed-entities/{eid}/ai-products", headers=admin_headers, json={
        "name": "Upd Product", "product_type": "ML Model", "status": "Active",
    })
    pid = r.json()["id"]
    r2 = http.put(f"{base_url}/api/assessed-entities/{eid}/ai-products/{pid}", headers=admin_headers, json={
        "name": "Updated Name", "risk_level": "High",
    })
    assert r2.status_code == 200
    assert r2.json()["name"] == "Updated Name"
    http.delete(f"{base_url}/api/assessed-entities/{eid}/ai-products/{pid}", headers=admin_headers)

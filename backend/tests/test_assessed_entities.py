"""Module 3: Assessed Entities tests."""


def test_list_assessed_entities(http, base_url, admin_headers):
    r = http.get(f"{base_url}/api/assessed-entities", headers=admin_headers)
    assert r.status_code == 200
    assert isinstance(r.json(), list)


def test_create_entity_with_all_fields(http, base_url, admin_headers):
    r = http.post(f"{base_url}/api/assessed-entities", headers=admin_headers, json={
        "name": "Test Entity Full", "name_ar": "كيان اختبار", "abbreviation": "TEF",
        "entity_type": "Government", "sector": "Government", "government_category": "Ministries",
        "primary_color": "#FF0000", "secondary_color": "#00FF00",
        "contact_person": "John Doe", "contact_email": "john@test.com", "status": "Active",
    })
    assert r.status_code == 201
    data = r.json()
    assert data["entity_type"] == "Government"
    assert data["government_category"] == "Ministries"
    assert data["primary_color"] == "#FF0000"
    http.delete(f"{base_url}/api/assessed-entities/{data['id']}", headers=admin_headers)


def test_create_entity_private(http, base_url, admin_headers):
    r = http.post(f"{base_url}/api/assessed-entities", headers=admin_headers, json={
        "name": "Private Corp Test", "entity_type": "Private", "sector": "Financial", "status": "Active",
    })
    assert r.status_code == 201
    assert r.json()["entity_type"] == "Private"
    http.delete(f"{base_url}/api/assessed-entities/{r.json()['id']}", headers=admin_headers)


def test_multi_regulatory_entities(http, base_url, admin_headers):
    reg = http.get(f"{base_url}/api/regulatory-entities/", headers=admin_headers)
    reg_ids = [e["id"] for e in reg.json()[:2]]
    if len(reg_ids) < 2:
        return
    r = http.post(f"{base_url}/api/assessed-entities", headers=admin_headers, json={
        "name": "Multi Reg Test", "abbreviation": "MRT", "regulatory_entity_ids": reg_ids, "status": "Active",
    })
    assert r.status_code == 201
    assert len(r.json()["regulatory_entities"]) == 2
    http.delete(f"{base_url}/api/assessed-entities/{r.json()['id']}", headers=admin_headers)


def test_get_entity_not_found(http, base_url, admin_headers):
    r = http.get(f"{base_url}/api/assessed-entities/00000000-0000-0000-0000-000000000000", headers=admin_headers)
    assert r.status_code == 404


def test_deactivate_entity(http, base_url, admin_headers):
    r = http.post(f"{base_url}/api/assessed-entities", headers=admin_headers, json={
        "name": "Deactivate AE", "status": "Active",
    })
    eid = r.json()["id"]
    r2 = http.delete(f"{base_url}/api/assessed-entities/{eid}", headers=admin_headers)
    assert r2.status_code == 204

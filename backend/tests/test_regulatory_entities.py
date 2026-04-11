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

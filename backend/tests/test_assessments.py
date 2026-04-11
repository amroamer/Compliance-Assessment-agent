"""Module 7: Assessment Instances & Responses tests."""


def test_list_assessment_instances(http, base_url, admin_headers):
    r = http.get(f"{base_url}/api/assessments", headers=admin_headers)
    assert r.status_code == 200
    assert isinstance(r.json(), list)


def test_get_assessment_instance(http, base_url, admin_headers):
    instances = http.get(f"{base_url}/api/assessments", headers=admin_headers).json()
    if not instances:
        return
    r = http.get(f"{base_url}/api/assessments/{instances[0]['id']}", headers=admin_headers)
    assert r.status_code == 200
    data = r.json()
    assert "framework" in data
    assert "assessed_entity" in data
    assert "total_assessable_nodes" in data


def test_get_responses(http, base_url, admin_headers):
    instances = http.get(f"{base_url}/api/assessments", headers=admin_headers).json()
    if not instances:
        return
    r = http.get(f"{base_url}/api/assessments/{instances[0]['id']}/responses", headers=admin_headers)
    assert r.status_code == 200
    assert isinstance(r.json(), list)


def test_compliance_stats(http, base_url, admin_headers):
    instances = http.get(f"{base_url}/api/assessments", headers=admin_headers).json()
    if not instances:
        return
    r = http.get(f"{base_url}/api/assessments/{instances[0]['id']}/compliance-stats", headers=admin_headers)
    assert r.status_code == 200
    data = r.json()
    assert "compliant" in data


def test_get_products_for_instance(http, base_url, admin_headers):
    instances = http.get(f"{base_url}/api/assessments", headers=admin_headers).json()
    if not instances:
        return
    r = http.get(f"{base_url}/api/assessments/{instances[0]['id']}/products", headers=admin_headers)
    assert r.status_code == 200
    assert isinstance(r.json(), list)


def test_create_duplicate_instance_rejected(http, base_url, admin_headers):
    instances = http.get(f"{base_url}/api/assessments", headers=admin_headers).json()
    if not instances:
        return
    inst = instances[0]
    r = http.post(f"{base_url}/api/assessments", headers=admin_headers, json={
        "cycle_id": inst["cycle"]["id"], "assessed_entity_id": inst["assessed_entity"]["id"],
    })
    assert r.status_code == 409


def test_get_assessment_not_found(http, base_url, admin_headers):
    r = http.get(f"{base_url}/api/assessments/00000000-0000-0000-0000-000000000000", headers=admin_headers)
    assert r.status_code == 404

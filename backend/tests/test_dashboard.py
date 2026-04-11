"""Module 12: Dashboard tests."""


def test_health_endpoint(http, base_url):
    r = http.get(f"{base_url}/api/health")
    assert r.status_code == 200


def test_dashboard_v2(http, base_url, admin_headers):
    r = http.get(f"{base_url}/api/dashboard-v2", headers=admin_headers)
    assert r.status_code == 200
    assert isinstance(r.json(), dict)


def test_entity_dashboard(http, base_url, admin_headers):
    entities = http.get(f"{base_url}/api/assessed-entities", headers=admin_headers).json()
    if not entities:
        return
    r = http.get(f"{base_url}/api/assessed-entities/{entities[0]['id']}/dashboard", headers=admin_headers)
    assert r.status_code == 200


def test_framework_performance(http, base_url, admin_headers):
    fws = http.get(f"{base_url}/api/frameworks", headers=admin_headers).json()
    if not fws:
        return
    r = http.get(f"{base_url}/api/dashboard-v2/framework-performance?framework_id={fws[0]['id']}", headers=admin_headers)
    assert r.status_code == 200

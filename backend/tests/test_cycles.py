"""Module 4: Assessment Cycles tests."""


def test_list_cycles(http, base_url, admin_headers):
    r = http.get(f"{base_url}/api/assessment-cycle-configs", headers=admin_headers)
    assert r.status_code == 200
    assert isinstance(r.json(), list)


def test_get_cycle(http, base_url, admin_headers):
    r = http.get(f"{base_url}/api/assessment-cycle-configs", headers=admin_headers)
    cycles = r.json()
    if not cycles:
        return
    r2 = http.get(f"{base_url}/api/assessment-cycle-configs/{cycles[0]['id']}", headers=admin_headers)
    assert r2.status_code == 200
    assert r2.json()["id"] == cycles[0]["id"]


def test_create_and_delete_cycle(http, base_url, admin_headers):
    fws = http.get(f"{base_url}/api/frameworks", headers=admin_headers).json()
    if not fws:
        return
    fw_id = fws[0]["id"]
    r = http.post(f"{base_url}/api/assessment-cycle-configs", headers=admin_headers, json={
        "framework_id": fw_id, "cycle_name": "Test Cycle 2099",
        "start_date": "2099-01-01", "end_date": "2099-12-31", "status": "Active",
    })
    assert r.status_code in (201, 409), f"Expected 201 or 409, got {r.status_code}: {r.text}"
    if r.status_code == 201:
        cid = r.json()["id"]
        r2 = http.delete(f"{base_url}/api/assessment-cycle-configs/{cid}", headers=admin_headers)
        assert r2.status_code == 204

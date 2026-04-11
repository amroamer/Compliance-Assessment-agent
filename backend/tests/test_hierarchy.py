"""Module 5: Framework Hierarchy tests."""


def test_list_frameworks(http, base_url, admin_headers):
    r = http.get(f"{base_url}/api/frameworks", headers=admin_headers)
    assert r.status_code == 200
    abbrs = [f["abbreviation"] for f in r.json()]
    assert len(abbrs) >= 3  # NDI, NAII, QIYAS, ITGF, AI_BADGES


def test_list_node_types(http, base_url, admin_headers):
    fws = http.get(f"{base_url}/api/frameworks", headers=admin_headers).json()
    if not fws:
        return
    r = http.get(f"{base_url}/api/frameworks/{fws[0]['id']}/node-types", headers=admin_headers)
    assert r.status_code == 200
    assert len(r.json()) >= 1


def test_list_nodes(http, base_url, admin_headers):
    fws = http.get(f"{base_url}/api/frameworks", headers=admin_headers).json()
    if not fws:
        return
    r = http.get(f"{base_url}/api/frameworks/{fws[0]['id']}/nodes", headers=admin_headers)
    assert r.status_code == 200
    assert len(r.json()) > 0


def test_create_and_delete_node_type(http, base_url, admin_headers):
    fws = http.get(f"{base_url}/api/frameworks", headers=admin_headers).json()
    if not fws:
        return
    fw_id = fws[0]["id"]
    r = http.post(f"{base_url}/api/frameworks/{fw_id}/node-types", headers=admin_headers, json={
        "name": "TestNT", "label": "Test NT", "color": "#FF0000", "sort_order": 99, "is_assessable_default": False,
    })
    assert r.status_code == 201
    nt_id = r.json()["id"]
    r2 = http.delete(f"{base_url}/api/frameworks/{fw_id}/node-types/{nt_id}", headers=admin_headers)
    assert r2.status_code == 204


def test_get_single_node(http, base_url, admin_headers):
    fws = http.get(f"{base_url}/api/frameworks", headers=admin_headers).json()
    if not fws:
        return
    nodes = http.get(f"{base_url}/api/frameworks/{fws[0]['id']}/nodes", headers=admin_headers).json()
    if not nodes:
        return
    r = http.get(f"{base_url}/api/frameworks/{fws[0]['id']}/nodes/{nodes[0]['id']}", headers=admin_headers)
    assert r.status_code == 200

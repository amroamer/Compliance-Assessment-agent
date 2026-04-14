"""Hierarchy (node types + nodes) CRUD integration tests against live backend."""
import uuid


def _uid():
    return uuid.uuid4().hex[:8]


def _get_fw_id(http, base_url, admin_headers):
    """Return the id of the first framework."""
    r = http.get(f"{base_url}/api/frameworks/", headers=admin_headers)
    assert r.status_code == 200
    fws = r.json()
    assert len(fws) > 0, "No frameworks found"
    return fws[0]["id"]


def _get_first_node_type_name(http, base_url, admin_headers, fw_id):
    """Return the name of the first node type for a framework."""
    r = http.get(f"{base_url}/api/frameworks/{fw_id}/node-types", headers=admin_headers)
    assert r.status_code == 200
    types = r.json()
    assert len(types) > 0, "No node types found"
    return types[0]["name"]


# ---------------------------------------------------------------------------
# Node Types
# ---------------------------------------------------------------------------

def test_list_node_types_returns_list(http, base_url, admin_headers):
    fw_id = _get_fw_id(http, base_url, admin_headers)
    r = http.get(f"{base_url}/api/frameworks/{fw_id}/node-types", headers=admin_headers)
    assert r.status_code == 200
    data = r.json()
    assert isinstance(data, list)
    assert len(data) >= 1


def test_list_node_types_has_expected_fields(http, base_url, admin_headers):
    fw_id = _get_fw_id(http, base_url, admin_headers)
    r = http.get(f"{base_url}/api/frameworks/{fw_id}/node-types", headers=admin_headers)
    nt = r.json()[0]
    for key in ("id", "framework_id", "name", "label", "sort_order", "is_assessable_default"):
        assert key in nt, f"Missing key: {key}"


def test_create_node_type_returns_201(http, base_url, admin_headers):
    fw_id = _get_fw_id(http, base_url, admin_headers)
    suffix = _uid()
    r = http.post(f"{base_url}/api/frameworks/{fw_id}/node-types", headers=admin_headers, json={
        "name": f"TestNT_{suffix}", "label": f"Test Node Type {suffix}",
        "sort_order": 99, "is_assessable_default": False,
    })
    assert r.status_code == 201
    data = r.json()
    assert data["name"] == f"TestNT_{suffix}"
    # Cleanup
    http.delete(f"{base_url}/api/frameworks/{fw_id}/node-types/{data['id']}", headers=admin_headers)


def test_update_node_type(http, base_url, admin_headers):
    fw_id = _get_fw_id(http, base_url, admin_headers)
    suffix = _uid()
    r = http.post(f"{base_url}/api/frameworks/{fw_id}/node-types", headers=admin_headers, json={
        "name": f"UpdNT_{suffix}", "label": f"Update Me {suffix}",
        "sort_order": 50, "is_assessable_default": False,
    })
    assert r.status_code == 201
    nt_id = r.json()["id"]
    r2 = http.put(f"{base_url}/api/frameworks/{fw_id}/node-types/{nt_id}", headers=admin_headers, json={
        "name": f"UpdNT_{suffix}", "label": f"Updated {suffix}",
        "sort_order": 51, "is_assessable_default": True,
    })
    assert r2.status_code == 200
    assert r2.json()["label"] == f"Updated {suffix}"
    assert r2.json()["is_assessable_default"] is True
    # Cleanup
    http.delete(f"{base_url}/api/frameworks/{fw_id}/node-types/{nt_id}", headers=admin_headers)


def test_delete_node_type_returns_204(http, base_url, admin_headers):
    fw_id = _get_fw_id(http, base_url, admin_headers)
    suffix = _uid()
    r = http.post(f"{base_url}/api/frameworks/{fw_id}/node-types", headers=admin_headers, json={
        "name": f"DelNT_{suffix}", "label": f"Delete Me {suffix}",
        "sort_order": 99, "is_assessable_default": False,
    })
    assert r.status_code == 201
    nt_id = r.json()["id"]
    r2 = http.delete(f"{base_url}/api/frameworks/{fw_id}/node-types/{nt_id}", headers=admin_headers)
    assert r2.status_code == 204


def test_get_node_types_empty_framework(http, base_url, admin_headers):
    """Node types for a nonexistent framework returns empty list or 200."""
    fake_fw_id = str(uuid.uuid4())
    r = http.get(f"{base_url}/api/frameworks/{fake_fw_id}/node-types", headers=admin_headers)
    # The endpoint returns 200 with an empty list for unknown fw_id
    assert r.status_code == 200
    assert r.json() == []


# ---------------------------------------------------------------------------
# Nodes
# ---------------------------------------------------------------------------

def test_list_nodes_returns_list(http, base_url, admin_headers):
    fw_id = _get_fw_id(http, base_url, admin_headers)
    r = http.get(f"{base_url}/api/frameworks/{fw_id}/nodes", headers=admin_headers)
    assert r.status_code == 200
    data = r.json()
    assert isinstance(data, list)
    assert len(data) >= 1


def test_create_root_node_returns_201(http, base_url, admin_headers):
    fw_id = _get_fw_id(http, base_url, admin_headers)
    node_type = _get_first_node_type_name(http, base_url, admin_headers, fw_id)
    suffix = _uid()
    r = http.post(f"{base_url}/api/frameworks/{fw_id}/nodes", headers=admin_headers, json={
        "node_type": node_type,
        "name": f"Root Node {suffix}",
        "reference_code": f"RN-{suffix}",
    })
    assert r.status_code == 201
    data = r.json()
    assert data["name"] == f"Root Node {suffix}"
    assert data["depth"] == 0
    assert data["parent_id"] is None
    # Soft-delete cleanup
    http.delete(f"{base_url}/api/frameworks/{fw_id}/nodes/{data['id']}", headers=admin_headers)


def test_create_child_node(http, base_url, admin_headers):
    fw_id = _get_fw_id(http, base_url, admin_headers)
    node_type = _get_first_node_type_name(http, base_url, admin_headers, fw_id)
    suffix = _uid()
    # Create parent
    r_parent = http.post(f"{base_url}/api/frameworks/{fw_id}/nodes", headers=admin_headers, json={
        "node_type": node_type,
        "name": f"Parent {suffix}",
        "reference_code": f"PAR-{suffix}",
    })
    assert r_parent.status_code == 201
    parent_id = r_parent.json()["id"]
    # Create child
    r_child = http.post(f"{base_url}/api/frameworks/{fw_id}/nodes", headers=admin_headers, json={
        "node_type": node_type,
        "name": f"Child {suffix}",
        "reference_code": f"CHD-{suffix}",
        "parent_id": parent_id,
    })
    assert r_child.status_code == 201
    child = r_child.json()
    assert child["parent_id"] == parent_id
    assert child["depth"] == 1
    # Cleanup
    http.delete(f"{base_url}/api/frameworks/{fw_id}/nodes/{child['id']}", headers=admin_headers)
    http.delete(f"{base_url}/api/frameworks/{fw_id}/nodes/{parent_id}", headers=admin_headers)


def test_update_node(http, base_url, admin_headers):
    fw_id = _get_fw_id(http, base_url, admin_headers)
    node_type = _get_first_node_type_name(http, base_url, admin_headers, fw_id)
    suffix = _uid()
    r = http.post(f"{base_url}/api/frameworks/{fw_id}/nodes", headers=admin_headers, json={
        "node_type": node_type,
        "name": f"UpdNode {suffix}",
        "reference_code": f"UND-{suffix}",
    })
    assert r.status_code == 201
    node_id = r.json()["id"]
    new_name = f"Updated Node {suffix}"
    r2 = http.put(f"{base_url}/api/frameworks/{fw_id}/nodes/{node_id}", headers=admin_headers, json={
        "name": new_name,
        "description": "updated description",
    })
    assert r2.status_code == 200
    assert r2.json()["name"] == new_name
    assert r2.json()["description"] == "updated description"
    # Cleanup
    http.delete(f"{base_url}/api/frameworks/{fw_id}/nodes/{node_id}", headers=admin_headers)


def test_deactivate_node_soft_deletes(http, base_url, admin_headers):
    fw_id = _get_fw_id(http, base_url, admin_headers)
    node_type = _get_first_node_type_name(http, base_url, admin_headers, fw_id)
    suffix = _uid()
    r = http.post(f"{base_url}/api/frameworks/{fw_id}/nodes", headers=admin_headers, json={
        "node_type": node_type,
        "name": f"DeactNode {suffix}",
        "reference_code": f"DND-{suffix}",
    })
    assert r.status_code == 201
    node_id = r.json()["id"]
    # Soft-delete
    r2 = http.delete(f"{base_url}/api/frameworks/{fw_id}/nodes/{node_id}", headers=admin_headers)
    assert r2.status_code == 204
    # Default list should not show it
    r3 = http.get(f"{base_url}/api/frameworks/{fw_id}/nodes", headers=admin_headers)
    node_ids = [n["id"] for n in r3.json()]
    assert node_id not in node_ids


def test_show_inactive_nodes_with_query_param(http, base_url, admin_headers):
    fw_id = _get_fw_id(http, base_url, admin_headers)
    node_type = _get_first_node_type_name(http, base_url, admin_headers, fw_id)
    suffix = _uid()
    r = http.post(f"{base_url}/api/frameworks/{fw_id}/nodes", headers=admin_headers, json={
        "node_type": node_type,
        "name": f"InactiveNode {suffix}",
        "reference_code": f"IND-{suffix}",
    })
    assert r.status_code == 201
    node_id = r.json()["id"]
    # Deactivate
    http.delete(f"{base_url}/api/frameworks/{fw_id}/nodes/{node_id}", headers=admin_headers)
    # include_inactive=true should show it
    r2 = http.get(f"{base_url}/api/frameworks/{fw_id}/nodes?include_inactive=true", headers=admin_headers)
    assert r2.status_code == 200
    node_ids = [n["id"] for n in r2.json()]
    assert node_id in node_ids


def test_create_node_requires_admin(http, base_url):
    """POST without auth token returns 401 or 403."""
    fake_fw_id = str(uuid.uuid4())
    r = http.post(f"{base_url}/api/frameworks/{fake_fw_id}/nodes", json={
        "node_type": "Domain", "name": "No Auth Node", "reference_code": "NA-001",
    })
    assert r.status_code in (401, 403)


def test_duplicate_reference_code_rejected(http, base_url, admin_headers):
    fw_id = _get_fw_id(http, base_url, admin_headers)
    node_type = _get_first_node_type_name(http, base_url, admin_headers, fw_id)
    suffix = _uid()
    ref_code = f"DUP-{suffix}"
    r1 = http.post(f"{base_url}/api/frameworks/{fw_id}/nodes", headers=admin_headers, json={
        "node_type": node_type, "name": f"Dup1 {suffix}", "reference_code": ref_code,
    })
    assert r1.status_code == 201
    r2 = http.post(f"{base_url}/api/frameworks/{fw_id}/nodes", headers=admin_headers, json={
        "node_type": node_type, "name": f"Dup2 {suffix}", "reference_code": ref_code,
    })
    assert r2.status_code == 409
    # Cleanup
    http.delete(f"{base_url}/api/frameworks/{fw_id}/nodes/{r1.json()['id']}", headers=admin_headers)

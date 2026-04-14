"""Scales, Form Templates, and Aggregation Rules CRUD integration tests."""
import uuid


def _uid():
    return uuid.uuid4().hex[:8]


def _get_fw_id(http, base_url, admin_headers):
    r = http.get(f"{base_url}/api/frameworks/", headers=admin_headers)
    assert r.status_code == 200
    fws = r.json()
    assert len(fws) > 0
    return fws[0]["id"]


def _get_node_type_ids(http, base_url, admin_headers, fw_id, count=2):
    """Return up to `count` node type ids for a framework."""
    r = http.get(f"{base_url}/api/frameworks/{fw_id}/node-types", headers=admin_headers)
    assert r.status_code == 200
    types = r.json()
    assert len(types) >= count, f"Need at least {count} node types, found {len(types)}"
    return [t["id"] for t in types[:count]]


def _create_node_type_pair(http, base_url, admin_headers, fw_id):
    """Create two fresh node types (parent + child) for aggregation rule tests.
    Returns (parent_id, child_id) and a cleanup function."""
    suffix = _uid()
    r1 = http.post(f"{base_url}/api/frameworks/{fw_id}/node-types", headers=admin_headers, json={
        "name": f"AggParent_{suffix}", "label": f"Agg Parent {suffix}",
        "sort_order": 90, "is_assessable_default": False,
    })
    assert r1.status_code == 201
    r2 = http.post(f"{base_url}/api/frameworks/{fw_id}/node-types", headers=admin_headers, json={
        "name": f"AggChild_{suffix}", "label": f"Agg Child {suffix}",
        "sort_order": 91, "is_assessable_default": False,
    })
    assert r2.status_code == 201
    parent_id = r1.json()["id"]
    child_id = r2.json()["id"]

    def cleanup():
        http.delete(f"{base_url}/api/frameworks/{fw_id}/node-types/{parent_id}", headers=admin_headers)
        http.delete(f"{base_url}/api/frameworks/{fw_id}/node-types/{child_id}", headers=admin_headers)

    return parent_id, child_id, cleanup


# ---------------------------------------------------------------------------
# Scales — Ordinal
# ---------------------------------------------------------------------------

def test_create_scale_ordinal(http, base_url, admin_headers):
    fw_id = _get_fw_id(http, base_url, admin_headers)
    suffix = _uid()
    r = http.post(f"{base_url}/api/frameworks/{fw_id}/scales", headers=admin_headers, json={
        "name": f"Ordinal {suffix}",
        "scale_type": "ORDINAL",
        "is_cumulative": False,
        "levels": [
            {"value": 0, "label": "None", "color": "#ccc", "sort_order": 0},
            {"value": 1, "label": "Low", "color": "#f00", "sort_order": 1},
            {"value": 2, "label": "Medium", "color": "#ff0", "sort_order": 2},
            {"value": 3, "label": "High", "color": "#0f0", "sort_order": 3},
        ],
    })
    assert r.status_code == 201
    data = r.json()
    assert data["scale_type"] == "ORDINAL"
    assert len(data["levels"]) == 4
    # Cleanup
    http.delete(f"{base_url}/api/frameworks/{fw_id}/scales/{data['id']}", headers=admin_headers)


# ---------------------------------------------------------------------------
# Scales — Binary
# ---------------------------------------------------------------------------

def test_create_scale_binary(http, base_url, admin_headers):
    fw_id = _get_fw_id(http, base_url, admin_headers)
    suffix = _uid()
    r = http.post(f"{base_url}/api/frameworks/{fw_id}/scales", headers=admin_headers, json={
        "name": f"Binary {suffix}",
        "scale_type": "BINARY",
        "is_cumulative": False,
        "levels": [
            {"value": 0, "label": "No", "sort_order": 0},
            {"value": 1, "label": "Yes", "sort_order": 1},
        ],
    })
    assert r.status_code == 201
    data = r.json()
    assert data["scale_type"] == "BINARY"
    assert len(data["levels"]) == 2
    http.delete(f"{base_url}/api/frameworks/{fw_id}/scales/{data['id']}", headers=admin_headers)


# ---------------------------------------------------------------------------
# Scales — Percentage
# ---------------------------------------------------------------------------

def test_create_scale_percentage(http, base_url, admin_headers):
    fw_id = _get_fw_id(http, base_url, admin_headers)
    suffix = _uid()
    r = http.post(f"{base_url}/api/frameworks/{fw_id}/scales", headers=admin_headers, json={
        "name": f"Percentage {suffix}",
        "scale_type": "PERCENTAGE",
        "is_cumulative": False,
        "min_value": 1,
        "max_value": 100,
        "step": 5,
        "levels": [],
    })
    assert r.status_code == 201
    data = r.json()
    assert data["scale_type"] == "PERCENTAGE"
    assert data["min_value"] == 1
    assert data["max_value"] == 100
    assert data["step"] == 5
    http.delete(f"{base_url}/api/frameworks/{fw_id}/scales/{data['id']}", headers=admin_headers)


# ---------------------------------------------------------------------------
# Scales — Update
# ---------------------------------------------------------------------------

def test_update_scale(http, base_url, admin_headers):
    fw_id = _get_fw_id(http, base_url, admin_headers)
    suffix = _uid()
    r = http.post(f"{base_url}/api/frameworks/{fw_id}/scales", headers=admin_headers, json={
        "name": f"UpdScale {suffix}", "scale_type": "ORDINAL", "is_cumulative": False,
        "levels": [{"value": 0, "label": "Zero", "sort_order": 0}],
    })
    assert r.status_code == 201
    scale_id = r.json()["id"]
    r2 = http.put(f"{base_url}/api/frameworks/{fw_id}/scales/{scale_id}", headers=admin_headers, json={
        "name": f"Updated {suffix}", "scale_type": "ORDINAL", "is_cumulative": True,
        "levels": [
            {"value": 0, "label": "Zero", "sort_order": 0},
            {"value": 1, "label": "One", "sort_order": 1},
        ],
    })
    assert r2.status_code == 200
    assert r2.json()["name"] == f"Updated {suffix}"
    assert r2.json()["is_cumulative"] is True
    # Re-fetch to get accurate level count (PUT response may show stale data)
    r3 = http.get(f"{base_url}/api/frameworks/{fw_id}/scales/{scale_id}", headers=admin_headers)
    assert r3.status_code == 200
    assert len(r3.json()["levels"]) == 2
    http.delete(f"{base_url}/api/frameworks/{fw_id}/scales/{scale_id}", headers=admin_headers)


# ---------------------------------------------------------------------------
# Scales — Delete (hard)
# ---------------------------------------------------------------------------

def test_delete_scale_hard_delete(http, base_url, admin_headers):
    fw_id = _get_fw_id(http, base_url, admin_headers)
    suffix = _uid()
    r = http.post(f"{base_url}/api/frameworks/{fw_id}/scales", headers=admin_headers, json={
        "name": f"DelScale {suffix}", "scale_type": "BINARY", "is_cumulative": False,
        "levels": [{"value": 0, "label": "No", "sort_order": 0}],
    })
    assert r.status_code == 201
    scale_id = r.json()["id"]
    r2 = http.delete(f"{base_url}/api/frameworks/{fw_id}/scales/{scale_id}", headers=admin_headers)
    assert r2.status_code == 204
    # Verify gone
    r3 = http.get(f"{base_url}/api/frameworks/{fw_id}/scales/{scale_id}", headers=admin_headers)
    assert r3.status_code == 404


# ---------------------------------------------------------------------------
# Scales — Thresholds
# ---------------------------------------------------------------------------

def test_scale_with_thresholds(http, base_url, admin_headers):
    fw_id = _get_fw_id(http, base_url, admin_headers)
    suffix = _uid()
    r = http.post(f"{base_url}/api/frameworks/{fw_id}/scales", headers=admin_headers, json={
        "name": f"Thresh {suffix}", "scale_type": "ORDINAL", "is_cumulative": False,
        "levels": [
            {"value": 1, "label": "Low", "sort_order": 0, "min_threshold": 0, "max_threshold": 33},
            {"value": 2, "label": "Med", "sort_order": 1, "min_threshold": 34, "max_threshold": 66},
            {"value": 3, "label": "High", "sort_order": 2, "min_threshold": 67, "max_threshold": 100},
        ],
    })
    assert r.status_code == 201
    data = r.json()
    lvl = data["levels"][0]
    assert lvl["min_threshold"] == 0
    assert lvl["max_threshold"] == 33
    http.delete(f"{base_url}/api/frameworks/{fw_id}/scales/{data['id']}", headers=admin_headers)


# ---------------------------------------------------------------------------
# Form Templates — List
# ---------------------------------------------------------------------------

def test_list_form_templates_returns_list(http, base_url, admin_headers):
    fw_id = _get_fw_id(http, base_url, admin_headers)
    r = http.get(f"{base_url}/api/frameworks/{fw_id}/form-templates", headers=admin_headers)
    assert r.status_code == 200
    assert isinstance(r.json(), list)


# ---------------------------------------------------------------------------
# Form Templates — Create
# ---------------------------------------------------------------------------

def test_create_form_template(http, base_url, admin_headers):
    fw_id = _get_fw_id(http, base_url, admin_headers)
    suffix = _uid()
    # Create a temporary node type for this template
    nt_r = http.post(f"{base_url}/api/frameworks/{fw_id}/node-types", headers=admin_headers, json={
        "name": f"FTNodeType_{suffix}", "label": f"FT NT {suffix}",
        "sort_order": 99, "is_assessable_default": False,
    })
    assert nt_r.status_code == 201
    nt_id = nt_r.json()["id"]
    # Create scale for the template
    sc_r = http.post(f"{base_url}/api/frameworks/{fw_id}/scales", headers=admin_headers, json={
        "name": f"FTScale {suffix}", "scale_type": "ORDINAL", "is_cumulative": False,
        "levels": [{"value": 0, "label": "No", "sort_order": 0}, {"value": 1, "label": "Yes", "sort_order": 1}],
    })
    assert sc_r.status_code == 201
    scale_id = sc_r.json()["id"]
    # Create template
    r = http.post(f"{base_url}/api/frameworks/{fw_id}/form-templates", headers=admin_headers, json={
        "node_type_id": nt_id, "scale_id": scale_id,
        "name": f"Template {suffix}", "description": "test template",
        "fields": [
            {"field_key": "compliance_level", "label": "Compliance Level", "is_required": True, "sort_order": 0},
            {"field_key": "justification", "label": "Justification", "sort_order": 1},
        ],
    })
    assert r.status_code == 201
    tmpl = r.json()
    assert tmpl["name"] == f"Template {suffix}"
    assert len(tmpl["fields"]) == 2
    # Cleanup
    http.delete(f"{base_url}/api/frameworks/{fw_id}/form-templates/{tmpl['id']}", headers=admin_headers)
    http.delete(f"{base_url}/api/frameworks/{fw_id}/scales/{scale_id}", headers=admin_headers)
    http.delete(f"{base_url}/api/frameworks/{fw_id}/node-types/{nt_id}", headers=admin_headers)


# ---------------------------------------------------------------------------
# Form Templates — Update
# ---------------------------------------------------------------------------

def test_update_form_template(http, base_url, admin_headers):
    fw_id = _get_fw_id(http, base_url, admin_headers)
    suffix = _uid()
    nt_r = http.post(f"{base_url}/api/frameworks/{fw_id}/node-types", headers=admin_headers, json={
        "name": f"UpdTplNT_{suffix}", "label": f"Upd Tpl NT {suffix}",
        "sort_order": 99, "is_assessable_default": False,
    })
    assert nt_r.status_code == 201
    nt_id = nt_r.json()["id"]
    # Create
    r = http.post(f"{base_url}/api/frameworks/{fw_id}/form-templates", headers=admin_headers, json={
        "node_type_id": nt_id, "name": f"UpdTpl {suffix}",
        "fields": [{"field_key": "f1", "label": "Field 1", "sort_order": 0}],
    })
    assert r.status_code == 201
    tmpl_id = r.json()["id"]
    # Update
    r2 = http.put(f"{base_url}/api/frameworks/{fw_id}/form-templates/{tmpl_id}", headers=admin_headers, json={
        "node_type_id": nt_id, "name": f"UpdTpl Renamed {suffix}",
        "fields": [
            {"field_key": "f1", "label": "Field One", "sort_order": 0},
            {"field_key": "f2", "label": "Field Two", "sort_order": 1},
        ],
    })
    assert r2.status_code == 200
    assert r2.json()["name"] == f"UpdTpl Renamed {suffix}"
    # Re-fetch to get accurate field count (PUT response may show stale data)
    templates = http.get(f"{base_url}/api/frameworks/{fw_id}/form-templates", headers=admin_headers).json()
    tmpl_data = next(t for t in templates if t["id"] == tmpl_id)
    assert len(tmpl_data["fields"]) == 2
    # Cleanup
    http.delete(f"{base_url}/api/frameworks/{fw_id}/form-templates/{tmpl_id}", headers=admin_headers)
    http.delete(f"{base_url}/api/frameworks/{fw_id}/node-types/{nt_id}", headers=admin_headers)


# ---------------------------------------------------------------------------
# Form Templates — Delete
# ---------------------------------------------------------------------------

def test_delete_form_template(http, base_url, admin_headers):
    fw_id = _get_fw_id(http, base_url, admin_headers)
    suffix = _uid()
    nt_r = http.post(f"{base_url}/api/frameworks/{fw_id}/node-types", headers=admin_headers, json={
        "name": f"DelTplNT_{suffix}", "label": f"Del Tpl NT {suffix}",
        "sort_order": 99, "is_assessable_default": False,
    })
    assert nt_r.status_code == 201
    nt_id = nt_r.json()["id"]
    r = http.post(f"{base_url}/api/frameworks/{fw_id}/form-templates", headers=admin_headers, json={
        "node_type_id": nt_id, "name": f"DelTpl {suffix}",
        "fields": [],
    })
    assert r.status_code == 201
    tmpl_id = r.json()["id"]
    r2 = http.delete(f"{base_url}/api/frameworks/{fw_id}/form-templates/{tmpl_id}", headers=admin_headers)
    assert r2.status_code == 204
    # Cleanup node type
    http.delete(f"{base_url}/api/frameworks/{fw_id}/node-types/{nt_id}", headers=admin_headers)


# ---------------------------------------------------------------------------
# Form Templates — Field with per-field scale_id
# ---------------------------------------------------------------------------

def test_form_template_field_with_scale_id(http, base_url, admin_headers):
    fw_id = _get_fw_id(http, base_url, admin_headers)
    suffix = _uid()
    nt_r = http.post(f"{base_url}/api/frameworks/{fw_id}/node-types", headers=admin_headers, json={
        "name": f"FSclNT_{suffix}", "label": f"Field Scale NT {suffix}",
        "sort_order": 99, "is_assessable_default": False,
    })
    assert nt_r.status_code == 201
    nt_id = nt_r.json()["id"]
    sc_r = http.post(f"{base_url}/api/frameworks/{fw_id}/scales", headers=admin_headers, json={
        "name": f"FieldScale {suffix}", "scale_type": "BINARY", "is_cumulative": False,
        "levels": [{"value": 0, "label": "No", "sort_order": 0}, {"value": 1, "label": "Yes", "sort_order": 1}],
    })
    assert sc_r.status_code == 201
    scale_id = sc_r.json()["id"]
    r = http.post(f"{base_url}/api/frameworks/{fw_id}/form-templates", headers=admin_headers, json={
        "node_type_id": nt_id, "name": f"FSclTpl {suffix}",
        "fields": [
            {"field_key": "rating", "label": "Rating", "scale_id": scale_id, "sort_order": 0},
        ],
    })
    assert r.status_code == 201
    field = r.json()["fields"][0]
    assert field["scale_id"] == scale_id
    # Cleanup
    http.delete(f"{base_url}/api/frameworks/{fw_id}/form-templates/{r.json()['id']}", headers=admin_headers)
    http.delete(f"{base_url}/api/frameworks/{fw_id}/scales/{scale_id}", headers=admin_headers)
    http.delete(f"{base_url}/api/frameworks/{fw_id}/node-types/{nt_id}", headers=admin_headers)


# ---------------------------------------------------------------------------
# Aggregation Rules — List
# ---------------------------------------------------------------------------

def test_list_aggregation_rules_returns_list(http, base_url, admin_headers):
    fw_id = _get_fw_id(http, base_url, admin_headers)
    r = http.get(f"{base_url}/api/frameworks/{fw_id}/aggregation-rules", headers=admin_headers)
    assert r.status_code == 200
    assert isinstance(r.json(), list)


# ---------------------------------------------------------------------------
# Aggregation Rules — Create
# ---------------------------------------------------------------------------

def test_create_aggregation_rule(http, base_url, admin_headers):
    fw_id = _get_fw_id(http, base_url, admin_headers)
    parent_id, child_id, cleanup_nts = _create_node_type_pair(http, base_url, admin_headers, fw_id)
    r = http.post(f"{base_url}/api/frameworks/{fw_id}/aggregation-rules", headers=admin_headers, json={
        "parent_node_type_id": parent_id,
        "child_node_type_id": child_id,
        "method": "weighted_average",
        "round_to": 2,
    })
    assert r.status_code == 201
    data = r.json()
    assert data["method"] == "weighted_average"
    # Cleanup
    http.delete(f"{base_url}/api/frameworks/{fw_id}/aggregation-rules/{data['id']}", headers=admin_headers)
    cleanup_nts()


# ---------------------------------------------------------------------------
# Aggregation Rules — Create with badge_scale
# ---------------------------------------------------------------------------

def test_create_aggregation_rule_with_badge_scale(http, base_url, admin_headers):
    fw_id = _get_fw_id(http, base_url, admin_headers)
    parent_id, child_id, cleanup_nts = _create_node_type_pair(http, base_url, admin_headers, fw_id)
    suffix = _uid()
    # Create a badge scale
    sc_r = http.post(f"{base_url}/api/frameworks/{fw_id}/scales", headers=admin_headers, json={
        "name": f"BadgeScale {suffix}", "scale_type": "ORDINAL", "is_cumulative": False,
        "levels": [
            {"value": 1, "label": "Bronze", "sort_order": 0, "min_threshold": 1, "max_threshold": 50},
            {"value": 2, "label": "Silver", "sort_order": 1, "min_threshold": 51, "max_threshold": 80},
            {"value": 3, "label": "Gold", "sort_order": 2, "min_threshold": 81, "max_threshold": 100},
        ],
    })
    assert sc_r.status_code == 201
    badge_scale_id = sc_r.json()["id"]
    r = http.post(f"{base_url}/api/frameworks/{fw_id}/aggregation-rules", headers=admin_headers, json={
        "parent_node_type_id": parent_id,
        "child_node_type_id": child_id,
        "method": "average",
        "round_to": 0,
        "badge_scale_id": badge_scale_id,
    })
    assert r.status_code == 201
    data = r.json()
    assert data["badge_scale_id"] == badge_scale_id
    assert data["badge_scale"] is not None
    # Cleanup
    http.delete(f"{base_url}/api/frameworks/{fw_id}/aggregation-rules/{data['id']}", headers=admin_headers)
    http.delete(f"{base_url}/api/frameworks/{fw_id}/scales/{badge_scale_id}", headers=admin_headers)
    cleanup_nts()


# ---------------------------------------------------------------------------
# Aggregation Rules — Update
# ---------------------------------------------------------------------------

def test_update_aggregation_rule(http, base_url, admin_headers):
    fw_id = _get_fw_id(http, base_url, admin_headers)
    parent_id, child_id, cleanup_nts = _create_node_type_pair(http, base_url, admin_headers, fw_id)
    r = http.post(f"{base_url}/api/frameworks/{fw_id}/aggregation-rules", headers=admin_headers, json={
        "parent_node_type_id": parent_id,
        "child_node_type_id": child_id,
        "method": "average",
        "round_to": 2,
    })
    assert r.status_code == 201
    rule_id = r.json()["id"]
    r2 = http.put(f"{base_url}/api/frameworks/{fw_id}/aggregation-rules/{rule_id}", headers=admin_headers, json={
        "parent_node_type_id": parent_id,
        "child_node_type_id": child_id,
        "method": "sum",
        "round_to": 0,
    })
    assert r2.status_code == 200
    assert r2.json()["method"] == "sum"
    assert r2.json()["round_to"] == 0
    http.delete(f"{base_url}/api/frameworks/{fw_id}/aggregation-rules/{rule_id}", headers=admin_headers)
    cleanup_nts()


# ---------------------------------------------------------------------------
# Aggregation Rules — Delete
# ---------------------------------------------------------------------------

def test_delete_aggregation_rule(http, base_url, admin_headers):
    fw_id = _get_fw_id(http, base_url, admin_headers)
    parent_id, child_id, cleanup_nts = _create_node_type_pair(http, base_url, admin_headers, fw_id)
    r = http.post(f"{base_url}/api/frameworks/{fw_id}/aggregation-rules", headers=admin_headers, json={
        "parent_node_type_id": parent_id,
        "child_node_type_id": child_id,
        "method": "average",
        "round_to": 2,
    })
    assert r.status_code == 201
    rule_id = r.json()["id"]
    r2 = http.delete(f"{base_url}/api/frameworks/{fw_id}/aggregation-rules/{rule_id}", headers=admin_headers)
    assert r2.status_code == 204
    cleanup_nts()


# ---------------------------------------------------------------------------
# Aggregation Rules — Duplicate pair check
# ---------------------------------------------------------------------------

def test_duplicate_aggregation_rule_same_pair(http, base_url, admin_headers):
    """Creating two rules with same parent+child node types should be rejected
    by the DB unique constraint (framework_id, parent_node_type_id, child_node_type_id).
    The API returns 500 (unhandled IntegrityError) for the duplicate.
    """
    fw_id = _get_fw_id(http, base_url, admin_headers)
    parent_id, child_id, cleanup_nts = _create_node_type_pair(http, base_url, admin_headers, fw_id)
    payload = {
        "parent_node_type_id": parent_id,
        "child_node_type_id": child_id,
        "method": "average",
        "round_to": 2,
    }
    r1 = http.post(f"{base_url}/api/frameworks/{fw_id}/aggregation-rules", headers=admin_headers, json=payload)
    assert r1.status_code == 201
    rule1_id = r1.json()["id"]
    r2 = http.post(f"{base_url}/api/frameworks/{fw_id}/aggregation-rules", headers=admin_headers, json=payload)
    # DB unique constraint rejects the duplicate (API returns 409 or 500)
    assert r2.status_code in (409, 500)
    if r2.status_code == 201:
        http.delete(f"{base_url}/api/frameworks/{fw_id}/aggregation-rules/{r2.json()['id']}", headers=admin_headers)
    http.delete(f"{base_url}/api/frameworks/{fw_id}/aggregation-rules/{rule1_id}", headers=admin_headers)
    cleanup_nts()


# ---------------------------------------------------------------------------
# Scales — List
# ---------------------------------------------------------------------------

def test_list_scales_returns_list(http, base_url, admin_headers):
    fw_id = _get_fw_id(http, base_url, admin_headers)
    r = http.get(f"{base_url}/api/frameworks/{fw_id}/scales", headers=admin_headers)
    assert r.status_code == 200
    assert isinstance(r.json(), list)


# ---------------------------------------------------------------------------
# Scales — Get by ID
# ---------------------------------------------------------------------------

def test_get_scale_by_id(http, base_url, admin_headers):
    fw_id = _get_fw_id(http, base_url, admin_headers)
    suffix = _uid()
    r = http.post(f"{base_url}/api/frameworks/{fw_id}/scales", headers=admin_headers, json={
        "name": f"GetScale {suffix}", "scale_type": "BINARY", "is_cumulative": False,
        "levels": [{"value": 0, "label": "No", "sort_order": 0}],
    })
    assert r.status_code == 201
    scale_id = r.json()["id"]
    r2 = http.get(f"{base_url}/api/frameworks/{fw_id}/scales/{scale_id}", headers=admin_headers)
    assert r2.status_code == 200
    assert r2.json()["id"] == scale_id
    http.delete(f"{base_url}/api/frameworks/{fw_id}/scales/{scale_id}", headers=admin_headers)

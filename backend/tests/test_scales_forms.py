"""Module 6: Assessment Scales & Forms tests."""


def _get_fw_id(http, base_url, admin_headers):
    return http.get(f"{base_url}/api/frameworks", headers=admin_headers).json()[0]["id"]


def test_list_scales(http, base_url, admin_headers):
    fw_id = _get_fw_id(http, base_url, admin_headers)
    r = http.get(f"{base_url}/api/frameworks/{fw_id}/scales", headers=admin_headers)
    assert r.status_code == 200
    assert isinstance(r.json(), list)


def test_list_form_templates(http, base_url, admin_headers):
    fw_id = _get_fw_id(http, base_url, admin_headers)
    r = http.get(f"{base_url}/api/frameworks/{fw_id}/form-templates", headers=admin_headers)
    assert r.status_code == 200
    assert isinstance(r.json(), list)


def test_create_and_delete_scale(http, base_url, admin_headers):
    fw_id = _get_fw_id(http, base_url, admin_headers)
    r = http.post(f"{base_url}/api/frameworks/{fw_id}/scales", headers=admin_headers, json={
        "name": "Test Scale UT " + str(__import__('uuid').uuid4())[:8], "scale_type": "ORDINAL", "is_cumulative": False,
        "levels": [
            {"value": 0, "label": "Low", "color": "#FF0000", "sort_order": 0},
            {"value": 1, "label": "High", "color": "#00FF00", "sort_order": 1},
        ],
    })
    assert r.status_code == 201
    assert "Test Scale UT" in r.json()["name"]
    assert len(r.json()["levels"]) == 2
    sid = r.json()["id"]
    r2 = http.delete(f"{base_url}/api/frameworks/{fw_id}/scales/{sid}", headers=admin_headers)
    assert r2.status_code == 204


def test_list_aggregation_rules(http, base_url, admin_headers):
    fw_id = _get_fw_id(http, base_url, admin_headers)
    r = http.get(f"{base_url}/api/frameworks/{fw_id}/aggregation-rules", headers=admin_headers)
    assert r.status_code == 200
    assert isinstance(r.json(), list)

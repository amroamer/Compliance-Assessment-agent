"""Module 10: Reports & Export tests."""


def _get_instance_id(http, base_url, admin_headers):
    instances = http.get(f"{base_url}/api/assessments", headers=admin_headers).json()
    return instances[0]["id"] if instances else None


def test_export_excel_report(http, base_url, admin_headers):
    iid = _get_instance_id(http, base_url, admin_headers)
    if not iid:
        return
    r = http.get(f"{base_url}/api/assessments/{iid}/export/report", headers=admin_headers)
    assert r.status_code == 200
    assert "spreadsheet" in r.headers.get("content-type", "")


def test_export_pdf_report(http, base_url, admin_headers):
    iid = _get_instance_id(http, base_url, admin_headers)
    if not iid:
        return
    r = http.get(f"{base_url}/api/assessments/{iid}/export/pdf", headers=admin_headers, timeout=30)
    assert r.status_code == 200
    assert "pdf" in r.headers.get("content-type", "")


def test_bulk_entities_export(http, base_url, admin_headers):
    r = http.get(f"{base_url}/api/bulk-entities/export-excel", headers=admin_headers)
    assert r.status_code == 200
    assert "spreadsheet" in r.headers.get("content-type", "")


def test_bulk_regulatory_entities_export(http, base_url, admin_headers):
    r = http.get(f"{base_url}/api/bulk-regulatory-entities/export-excel", headers=admin_headers)
    assert r.status_code == 200
    assert "spreadsheet" in r.headers.get("content-type", "")

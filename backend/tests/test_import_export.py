"""Import/Export integration tests for all bulk modules.

Pattern: export to Excel, then re-import with preview=true to validate
the round-trip without mutating data.
"""
import io


# ── Helpers ──


def _get_fw_id(http, base_url, admin_headers):
    """Return the first active framework ID, or None."""
    fws = http.get(f"{base_url}/api/frameworks", headers=admin_headers).json()
    active = [fw for fw in fws if fw.get("status") not in ("Archived",)]
    return active[0]["id"] if active else None


def _export_and_preview_import(http, base_url, admin_headers, export_url, import_url):
    """Download an Excel export, then POST it back with preview=true.

    Returns (export_response, import_response) for further assertions.
    """
    r_export = http.get(f"{base_url}{export_url}", headers=admin_headers)
    assert r_export.status_code == 200, f"Export failed ({export_url}): {r_export.status_code} {r_export.text}"
    content_type = r_export.headers.get("content-type", "")
    assert "spreadsheet" in content_type or "excel" in content_type, f"Unexpected content-type: {content_type}"

    # Re-import with preview=true
    file_bytes = r_export.content
    separator = "?" if "?" not in import_url else "&"
    r_import = http.post(
        f"{base_url}{import_url}{separator}preview=true",
        headers=admin_headers,
        files={"file": ("export.xlsx", io.BytesIO(file_bytes), "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")},
    )
    return r_export, r_import


# ── Entities ──


def test_export_entities_excel(http, base_url, admin_headers):
    """GET /api/bulk-entities/export-excel returns Excel."""
    r = http.get(f"{base_url}/api/bulk-entities/export-excel", headers=admin_headers)
    assert r.status_code == 200
    assert "spreadsheet" in r.headers.get("content-type", "")


def test_import_entities_preview(http, base_url, admin_headers):
    """POST /api/bulk-entities/import-excel?preview=true returns preview data."""
    r_exp, r_imp = _export_and_preview_import(
        http, base_url, admin_headers,
        "/api/bulk-entities/export-excel",
        "/api/bulk-entities/import-excel",
    )
    assert r_imp.status_code == 200, f"Import preview failed: {r_imp.text}"
    data = r_imp.json()
    assert isinstance(data, (list, dict))


# ── Users ──


def test_export_users_excel(http, base_url, admin_headers):
    """GET /api/bulk-users/export-excel returns Excel."""
    r = http.get(f"{base_url}/api/bulk-users/export-excel", headers=admin_headers)
    assert r.status_code == 200
    assert "spreadsheet" in r.headers.get("content-type", "")


def test_import_users_preview(http, base_url, admin_headers):
    """POST /api/bulk-users/import-excel?preview=true returns preview."""
    r_exp, r_imp = _export_and_preview_import(
        http, base_url, admin_headers,
        "/api/bulk-users/export-excel",
        "/api/bulk-users/import-excel",
    )
    assert r_imp.status_code == 200, f"Import preview failed: {r_imp.text}"


# ── Regulatory Entities ──


def test_export_regulatory_entities_excel(http, base_url, admin_headers):
    """GET /api/bulk-regulatory-entities/export-excel returns Excel."""
    r = http.get(f"{base_url}/api/bulk-regulatory-entities/export-excel", headers=admin_headers)
    assert r.status_code == 200
    assert "spreadsheet" in r.headers.get("content-type", "")


def test_import_regulatory_entities_preview(http, base_url, admin_headers):
    """POST /api/bulk-regulatory-entities/import-excel?preview=true returns preview."""
    r_exp, r_imp = _export_and_preview_import(
        http, base_url, admin_headers,
        "/api/bulk-regulatory-entities/export-excel",
        "/api/bulk-regulatory-entities/import-excel",
    )
    assert r_imp.status_code == 200, f"Import preview failed: {r_imp.text}"


# ── Cycles ──


def test_export_cycles_excel(http, base_url, admin_headers):
    """GET /api/bulk-cycles/export-excel returns Excel."""
    r = http.get(f"{base_url}/api/bulk-cycles/export-excel", headers=admin_headers)
    assert r.status_code == 200
    assert "spreadsheet" in r.headers.get("content-type", "")


def test_import_cycles_preview(http, base_url, admin_headers):
    """POST /api/bulk-cycles/import-excel?preview=true returns preview."""
    r_exp, r_imp = _export_and_preview_import(
        http, base_url, admin_headers,
        "/api/bulk-cycles/export-excel",
        "/api/bulk-cycles/import-excel",
    )
    assert r_imp.status_code == 200, f"Import preview failed: {r_imp.text}"


# ── Frameworks ──


def test_export_frameworks_excel(http, base_url, admin_headers):
    """GET /api/bulk-frameworks/export-excel returns Excel."""
    r = http.get(f"{base_url}/api/bulk-frameworks/export-excel", headers=admin_headers)
    assert r.status_code == 200
    assert "spreadsheet" in r.headers.get("content-type", "")


def test_import_frameworks_preview(http, base_url, admin_headers):
    """POST /api/bulk-frameworks/import-excel?preview=true returns preview."""
    r_exp, r_imp = _export_and_preview_import(
        http, base_url, admin_headers,
        "/api/bulk-frameworks/export-excel",
        "/api/bulk-frameworks/import-excel",
    )
    assert r_imp.status_code == 200, f"Import preview failed: {r_imp.text}"


# ── Hierarchy (per-framework) ──


def test_export_hierarchy_excel(http, base_url, admin_headers):
    """GET /api/frameworks/{fw_id}/hierarchy/export-excel returns Excel."""
    fw_id = _get_fw_id(http, base_url, admin_headers)
    if not fw_id:
        return
    r = http.get(f"{base_url}/api/frameworks/{fw_id}/hierarchy/export-excel", headers=admin_headers)
    assert r.status_code == 200
    assert "spreadsheet" in r.headers.get("content-type", "")


def test_import_hierarchy_preview(http, base_url, admin_headers):
    """POST /api/frameworks/{fw_id}/hierarchy/import-excel?preview=true round-trips."""
    fw_id = _get_fw_id(http, base_url, admin_headers)
    if not fw_id:
        return
    r_exp, r_imp = _export_and_preview_import(
        http, base_url, admin_headers,
        f"/api/frameworks/{fw_id}/hierarchy/export-excel",
        f"/api/frameworks/{fw_id}/hierarchy/import-excel",
    )
    assert r_imp.status_code == 200, f"Import preview failed: {r_imp.text}"


# ── Scales (per-framework) ──


def test_export_scales_excel(http, base_url, admin_headers):
    """GET /api/frameworks/{fw_id}/bulk-scales/export-excel returns Excel."""
    fw_id = _get_fw_id(http, base_url, admin_headers)
    if not fw_id:
        return
    r = http.get(f"{base_url}/api/frameworks/{fw_id}/bulk-scales/export-excel", headers=admin_headers)
    assert r.status_code == 200
    assert "spreadsheet" in r.headers.get("content-type", "")


def test_import_scales_preview(http, base_url, admin_headers):
    """POST /api/frameworks/{fw_id}/bulk-scales/import-excel?preview=true round-trips."""
    fw_id = _get_fw_id(http, base_url, admin_headers)
    if not fw_id:
        return
    r_exp, r_imp = _export_and_preview_import(
        http, base_url, admin_headers,
        f"/api/frameworks/{fw_id}/bulk-scales/export-excel",
        f"/api/frameworks/{fw_id}/bulk-scales/import-excel",
    )
    assert r_imp.status_code == 200, f"Import preview failed: {r_imp.text}"


# ── Scoring Rules (per-framework) ──


def test_export_scoring_rules_excel(http, base_url, admin_headers):
    """GET /api/frameworks/{fw_id}/bulk-scoring/export-excel returns Excel."""
    fw_id = _get_fw_id(http, base_url, admin_headers)
    if not fw_id:
        return
    r = http.get(f"{base_url}/api/frameworks/{fw_id}/bulk-scoring/export-excel", headers=admin_headers)
    assert r.status_code == 200
    assert "spreadsheet" in r.headers.get("content-type", "")


def test_import_scoring_rules_preview(http, base_url, admin_headers):
    """POST /api/frameworks/{fw_id}/bulk-scoring/import-excel?preview=true round-trips."""
    fw_id = _get_fw_id(http, base_url, admin_headers)
    if not fw_id:
        return
    r_exp, r_imp = _export_and_preview_import(
        http, base_url, admin_headers,
        f"/api/frameworks/{fw_id}/bulk-scoring/export-excel",
        f"/api/frameworks/{fw_id}/bulk-scoring/import-excel",
    )
    assert r_imp.status_code == 200, f"Import preview failed: {r_imp.text}"


# ── LLM Models ──


def test_export_llm_models_excel(http, base_url, admin_headers):
    """GET /api/settings/llm-models/export-excel returns Excel."""
    r = http.get(f"{base_url}/api/settings/llm-models/export-excel", headers=admin_headers)
    assert r.status_code == 200
    assert "spreadsheet" in r.headers.get("content-type", "")


def test_import_llm_models_preview(http, base_url, admin_headers):
    """POST /api/settings/llm-models/import-excel?preview=true round-trips."""
    r_exp, r_imp = _export_and_preview_import(
        http, base_url, admin_headers,
        "/api/settings/llm-models/export-excel",
        "/api/settings/llm-models/import-excel",
    )
    assert r_imp.status_code == 200, f"Import preview failed: {r_imp.text}"

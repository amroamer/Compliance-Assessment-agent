"""Framework Documents bulk-delete + single delete tests."""
import uuid as _uuid
import io


def _get_fw_id(http, base_url, admin_headers):
    return http.get(f"{base_url}/api/frameworks", headers=admin_headers).json()[0]["id"]


def _upload_doc(http, base_url, admin_headers, fw_id=None, filename=None):
    """Helper: upload a tiny test document and return (fw_id, doc_id)."""
    if fw_id is None:
        fw_id = _get_fw_id(http, base_url, admin_headers)
    if filename is None:
        filename = f"test_{_uuid.uuid4().hex[:8]}.txt"
    content = b"test document content"
    r = http.post(
        f"{base_url}/api/frameworks/{fw_id}/documents",
        headers=admin_headers,
        files={"file": (filename, io.BytesIO(content), "text/plain")},
    )
    # The API might reject .txt if not in allowed types — use .pdf which is always allowed
    if r.status_code != 201:
        filename = filename.replace(".txt", ".pdf")
        r = http.post(
            f"{base_url}/api/frameworks/{fw_id}/documents",
            headers=admin_headers,
            files={"file": (filename, io.BytesIO(b"%PDF-1.4 test"), "application/pdf")},
        )
    assert r.status_code == 201, f"Upload failed: {r.text}"
    return fw_id, r.json()["id"]


# ── Single delete ──

def test_delete_single_document_success(http, base_url, admin_headers):
    """DELETE single document returns 204 and it no longer appears in list."""
    fw_id, doc_id = _upload_doc(http, base_url, admin_headers)
    r = http.delete(f"{base_url}/api/frameworks/documents/{doc_id}", headers=admin_headers)
    assert r.status_code == 204
    docs = http.get(f"{base_url}/api/frameworks/{fw_id}/documents", headers=admin_headers).json()
    assert all(d["id"] != doc_id for d in docs)


def test_delete_single_document_not_found(http, base_url, admin_headers):
    """DELETE non-existent document returns 404."""
    r = http.delete(f"{base_url}/api/frameworks/documents/00000000-0000-0000-0000-000000000000", headers=admin_headers)
    assert r.status_code == 404


def test_delete_single_document_requires_admin(http, base_url):
    """Unauthenticated single document delete is rejected."""
    r = http.delete(f"{base_url}/api/frameworks/documents/00000000-0000-0000-0000-000000000001")
    assert r.status_code in (401, 403)


# ── Bulk delete ──

def test_bulk_delete_single_document(http, base_url, admin_headers):
    """Bulk delete with one ID works and returns correct counts."""
    fw_id, doc_id = _upload_doc(http, base_url, admin_headers)
    r = http.post(f"{base_url}/api/frameworks/{fw_id}/documents/bulk-delete", headers=admin_headers, json={"ids": [doc_id]})
    assert r.status_code == 200
    data = r.json()
    assert data["deleted"] == 1
    assert data["requested"] == 1
    assert data["not_found"] == 0
    # Confirm gone
    docs = http.get(f"{base_url}/api/frameworks/{fw_id}/documents", headers=admin_headers).json()
    assert all(d["id"] != doc_id for d in docs)


def test_bulk_delete_multiple_documents(http, base_url, admin_headers):
    """Bulk delete removes all specified documents."""
    fw_id = _get_fw_id(http, base_url, admin_headers)
    ids = [_upload_doc(http, base_url, admin_headers, fw_id=fw_id)[1] for _ in range(3)]
    r = http.post(f"{base_url}/api/frameworks/{fw_id}/documents/bulk-delete", headers=admin_headers, json={"ids": ids})
    assert r.status_code == 200
    data = r.json()
    assert data["deleted"] == 3
    assert data["requested"] == 3
    # Confirm all gone
    docs = http.get(f"{base_url}/api/frameworks/{fw_id}/documents", headers=admin_headers).json()
    for doc_id in ids:
        assert all(d["id"] != doc_id for d in docs)


def test_bulk_delete_partial_nonexistent_documents(http, base_url, admin_headers):
    """Bulk delete with some valid, some fake IDs deletes only the valid ones."""
    fw_id, doc_id = _upload_doc(http, base_url, admin_headers)
    fake_id = "00000000-0000-0000-0000-000000000099"
    r = http.post(f"{base_url}/api/frameworks/{fw_id}/documents/bulk-delete", headers=admin_headers, json={"ids": [doc_id, fake_id]})
    assert r.status_code == 200
    data = r.json()
    assert data["deleted"] == 1
    assert data["requested"] == 2
    assert data["not_found"] == 1


def test_bulk_delete_empty_ids_documents(http, base_url, admin_headers):
    """Empty IDs list returns 400."""
    fw_id = _get_fw_id(http, base_url, admin_headers)
    r = http.post(f"{base_url}/api/frameworks/{fw_id}/documents/bulk-delete", headers=admin_headers, json={"ids": []})
    assert r.status_code == 400


def test_bulk_delete_all_nonexistent_documents(http, base_url, admin_headers):
    """All-nonexistent document IDs return 404."""
    fw_id = _get_fw_id(http, base_url, admin_headers)
    r = http.post(f"{base_url}/api/frameworks/{fw_id}/documents/bulk-delete", headers=admin_headers, json={
        "ids": ["00000000-0000-0000-0000-000000000001", "00000000-0000-0000-0000-000000000002"]
    })
    assert r.status_code == 404


def test_bulk_delete_documents_requires_admin(http, base_url):
    """Unauthenticated bulk document delete is rejected."""
    r = http.post(f"{base_url}/api/frameworks/00000000-0000-0000-0000-000000000001/documents/bulk-delete", json={
        "ids": ["00000000-0000-0000-0000-000000000001"]
    })
    assert r.status_code in (401, 403)

"""Module 1: Auth & Security tests."""
from app.core.security import get_password_hash, verify_password, create_access_token


# ── Unit tests for security utilities ──

def test_password_hashing():
    hashed = get_password_hash("MySecret123")
    assert hashed != "MySecret123"
    assert verify_password("MySecret123", hashed)


def test_password_verify_wrong():
    hashed = get_password_hash("Correct")
    assert not verify_password("Wrong", hashed)


def test_jwt_token_creation():
    token = create_access_token(data={"sub": "test-user-id"})
    assert isinstance(token, str)
    assert len(token) > 20


def test_jwt_token_decode():
    from jose import jwt
    from app.config import settings
    token = create_access_token(data={"sub": "abc-123"})
    payload = jwt.decode(token, settings.JWT_SECRET_KEY, algorithms=[settings.JWT_ALGORITHM])
    assert payload["sub"] == "abc-123"
    assert "exp" in payload


# ── Integration tests for auth endpoints ──

def test_login_success(http, base_url):
    r = http.post(f"{base_url}/api/auth/login", json={"email": "admin@kpmg.com", "password": "Admin123!"})
    assert r.status_code == 200
    assert "access_token" in r.json()


def test_login_wrong_password(http, base_url):
    r = http.post(f"{base_url}/api/auth/login", json={"email": "admin@kpmg.com", "password": "WrongPass"})
    assert r.status_code == 401


def test_login_nonexistent_user(http, base_url):
    r = http.post(f"{base_url}/api/auth/login", json={"email": "nobody@test.com", "password": "x"})
    assert r.status_code == 401


def test_get_me_authenticated(http, base_url, admin_headers):
    r = http.get(f"{base_url}/api/auth/me", headers=admin_headers)
    assert r.status_code == 200
    data = r.json()
    assert data["email"] == "admin@kpmg.com"
    assert data["role"] == "admin"


def test_get_me_no_token(http, base_url):
    r = http.get(f"{base_url}/api/auth/me")
    assert r.status_code in (401, 403)


def test_list_users_admin(http, base_url, admin_headers):
    r = http.get(f"{base_url}/api/users/", headers=admin_headers)
    assert r.status_code == 200
    assert isinstance(r.json(), list)
    assert len(r.json()) >= 1


# ── Single user deactivate tests ──

def _create_temp_user(http, base_url, admin_headers, suffix=""):
    """Helper: create a throwaway user and return its id."""
    import uuid
    email = f"tmp_{uuid.uuid4().hex[:8]}{suffix}@test.com"
    r = http.post(f"{base_url}/api/auth/register", headers=admin_headers, json={
        "email": email, "name": "Temp User", "password": "TempPass123!", "role": "kpmg_user"
    })
    assert r.status_code == 201
    return r.json()["id"], email


def test_deactivate_user_success(http, base_url, admin_headers):
    """Admin can deactivate another user."""
    uid, _ = _create_temp_user(http, base_url, admin_headers, "_deact")
    r = http.delete(f"{base_url}/api/users/{uid}", headers=admin_headers)
    assert r.status_code == 204
    # Confirm status
    users = http.get(f"{base_url}/api/users/", headers=admin_headers).json()
    match = next((u for u in users if u["id"] == uid), None)
    assert match is not None
    assert match["is_active"] is False


def test_deactivate_user_not_found(http, base_url, admin_headers):
    """Deactivating a non-existent user returns 404."""
    r = http.delete(f"{base_url}/api/users/00000000-0000-0000-0000-000000000099", headers=admin_headers)
    assert r.status_code == 404
    assert "not found" in r.json()["detail"].lower()


def test_cannot_deactivate_self(http, base_url, admin_headers):
    """Admin cannot deactivate their own account."""
    me = http.get(f"{base_url}/api/auth/me", headers=admin_headers).json()
    r = http.delete(f"{base_url}/api/users/{me['id']}", headers=admin_headers)
    assert r.status_code == 400
    assert "own account" in r.json()["detail"].lower()


def test_deactivate_user_requires_admin(http, base_url):
    """Unauthenticated requests are rejected."""
    r = http.delete(f"{base_url}/api/users/00000000-0000-0000-0000-000000000099")
    assert r.status_code in (401, 403)


# ── Bulk deactivate user tests ──

def test_bulk_deactivate_users_single(http, base_url, admin_headers):
    """Bulk deactivating one user works correctly."""
    uid, _ = _create_temp_user(http, base_url, admin_headers, "_bulk1")
    r = http.post(f"{base_url}/api/users/bulk-deactivate", headers=admin_headers, json={"ids": [uid]})
    assert r.status_code == 200
    data = r.json()
    assert data["deactivated"] == 1
    assert data["requested"] == 1


def test_bulk_deactivate_users_multiple(http, base_url, admin_headers):
    """Bulk deactivating multiple users works."""
    ids = [_create_temp_user(http, base_url, admin_headers, f"_bulkm{i}")[0] for i in range(3)]
    r = http.post(f"{base_url}/api/users/bulk-deactivate", headers=admin_headers, json={"ids": ids})
    assert r.status_code == 200
    data = r.json()
    assert data["deactivated"] == 3
    assert data["requested"] == 3
    # Confirm all inactive
    users = http.get(f"{base_url}/api/users/", headers=admin_headers).json()
    for uid in ids:
        match = next((u for u in users if u["id"] == uid), None)
        assert match and match["is_active"] is False


def test_bulk_deactivate_already_inactive_counted(http, base_url, admin_headers):
    """Re-deactivating an already-inactive user reports it in already_inactive."""
    uid, _ = _create_temp_user(http, base_url, admin_headers, "_bulkai")
    # Deactivate once
    http.post(f"{base_url}/api/users/bulk-deactivate", headers=admin_headers, json={"ids": [uid]})
    # Deactivate again
    r = http.post(f"{base_url}/api/users/bulk-deactivate", headers=admin_headers, json={"ids": [uid]})
    assert r.status_code == 200
    data = r.json()
    assert data["deactivated"] == 0
    assert data["already_inactive"] == 1


def test_bulk_deactivate_empty_ids(http, base_url, admin_headers):
    """Empty IDs list returns 400."""
    r = http.post(f"{base_url}/api/users/bulk-deactivate", headers=admin_headers, json={"ids": []})
    assert r.status_code == 400


def test_bulk_deactivate_nonexistent_ids(http, base_url, admin_headers):
    """All-nonexistent IDs returns 404."""
    r = http.post(f"{base_url}/api/users/bulk-deactivate", headers=admin_headers, json={
        "ids": ["00000000-0000-0000-0000-000000000001", "00000000-0000-0000-0000-000000000002"]
    })
    assert r.status_code == 404


def test_bulk_deactivate_cannot_include_self(http, base_url, admin_headers):
    """Including your own ID in the bulk list returns 400."""
    me = http.get(f"{base_url}/api/auth/me", headers=admin_headers).json()
    r = http.post(f"{base_url}/api/users/bulk-deactivate", headers=admin_headers, json={"ids": [me["id"]]})
    assert r.status_code == 400
    assert "own account" in r.json()["detail"].lower()


def test_bulk_deactivate_requires_admin(http, base_url):
    """Unauthenticated bulk deactivate is rejected."""
    r = http.post(f"{base_url}/api/users/bulk-deactivate", json={"ids": ["00000000-0000-0000-0000-000000000001"]})
    assert r.status_code in (401, 403)


# ── Forgot password & reset password tests ──

def test_forgot_password_existing_user(http, base_url):
    """Valid email returns a reset token."""
    r = http.post(f"{base_url}/api/auth/forgot-password", json={"email": "admin@kpmg.com"})
    assert r.status_code == 200
    data = r.json()
    assert data["reset_token"] is not None
    assert len(data["reset_token"]) > 10
    assert data["expires_in_minutes"] == 15


def test_forgot_password_nonexistent_user(http, base_url):
    """Unknown email returns success but with null token (no enumeration)."""
    r = http.post(f"{base_url}/api/auth/forgot-password", json={"email": "ghost@nowhere.com"})
    assert r.status_code == 200
    data = r.json()
    assert data["reset_token"] is None


def test_reset_password_success(http, base_url):
    """Full happy path: request token then reset password, then log in with new password."""
    # Create a temporary test user
    import uuid
    tmp_email = f"reset_test_{uuid.uuid4().hex[:8]}@test.com"
    from app.core.security import get_password_hash

    # Register test user via admin
    r_login = http.post(f"{base_url}/api/auth/login", json={"email": "admin@kpmg.com", "password": "Admin123!"})
    token = r_login.json()["access_token"]
    headers = {"Authorization": f"Bearer {token}"}

    r_reg = http.post(f"{base_url}/api/auth/register", headers=headers, json={
        "email": tmp_email, "name": "Reset Test User", "password": "OldPass123!", "role": "kpmg_user"
    })
    assert r_reg.status_code == 201
    user_id = r_reg.json()["id"]

    try:
        # Request reset token
        r_forgot = http.post(f"{base_url}/api/auth/forgot-password", json={"email": tmp_email})
        assert r_forgot.status_code == 200
        reset_token = r_forgot.json()["reset_token"]
        assert reset_token is not None

        # Reset the password
        r_reset = http.post(f"{base_url}/api/auth/reset-password", json={
            "token": reset_token, "new_password": "NewPass456!"
        })
        assert r_reset.status_code == 200
        assert "successfully" in r_reset.json()["message"]

        # Login with new password works
        r_new_login = http.post(f"{base_url}/api/auth/login", json={"email": tmp_email, "password": "NewPass456!"})
        assert r_new_login.status_code == 200

        # Login with old password fails
        r_old_login = http.post(f"{base_url}/api/auth/login", json={"email": tmp_email, "password": "OldPass123!"})
        assert r_old_login.status_code == 401

    finally:
        # Cleanup: delete test user via DB (deactivate via patch)
        http.patch(f"{base_url}/api/users/{user_id}", headers=headers, json={"is_active": False})


def test_reset_password_invalid_token(http, base_url):
    """Bogus token returns 400."""
    r = http.post(f"{base_url}/api/auth/reset-password", json={
        "token": "totally-invalid-token-xyz", "new_password": "NewPass456!"
    })
    assert r.status_code == 400
    assert "Invalid" in r.json()["detail"] or "expired" in r.json()["detail"].lower()


def test_reset_password_token_consumed_once(http, base_url):
    """A reset token can only be used once."""
    r_forgot = http.post(f"{base_url}/api/auth/forgot-password", json={"email": "admin@kpmg.com"})
    reset_token = r_forgot.json()["reset_token"]

    # First use — succeeds (but we'll use a temp password we'll restore)
    r1 = http.post(f"{base_url}/api/auth/reset-password", json={
        "token": reset_token, "new_password": "TempPass999!"
    })
    assert r1.status_code == 200

    # Restore admin password
    r_forgot2 = http.post(f"{base_url}/api/auth/forgot-password", json={"email": "admin@kpmg.com"})
    restore_token = r_forgot2.json()["reset_token"]
    http.post(f"{base_url}/api/auth/reset-password", json={
        "token": restore_token, "new_password": "Admin123!"
    })

    # Second use of first token — must fail
    r2 = http.post(f"{base_url}/api/auth/reset-password", json={
        "token": reset_token, "new_password": "AnotherPass999!"
    })
    assert r2.status_code == 400


def test_reset_password_too_short(http, base_url):
    """Password shorter than 8 characters is rejected."""
    r_forgot = http.post(f"{base_url}/api/auth/forgot-password", json={"email": "admin@kpmg.com"})
    reset_token = r_forgot.json()["reset_token"]

    r = http.post(f"{base_url}/api/auth/reset-password", json={
        "token": reset_token, "new_password": "short"
    })
    assert r.status_code == 400
    assert "8 characters" in r.json()["detail"]

    # Token is still valid — clean up by using it with a valid password
    http.post(f"{base_url}/api/auth/reset-password", json={
        "token": reset_token, "new_password": "Admin123!"
    })

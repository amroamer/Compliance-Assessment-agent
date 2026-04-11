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

"""Shared test fixtures — tests against the running app via HTTP."""
import os

import pytest
import httpx

# Tests run against the live running application inside Docker container.
APP_URL = os.environ.get("TEST_BASE_URL", "http://localhost:8000")


@pytest.fixture(scope="session")
def base_url():
    return APP_URL


@pytest.fixture(scope="session")
def http():
    """HTTP client with redirect following enabled."""
    return httpx.Client(follow_redirects=True, timeout=30)


@pytest.fixture(scope="session")
def admin_token(base_url, http):
    """Login as admin and return JWT token."""
    r = http.post(f"{base_url}/api/auth/login", json={"email": "admin@kpmg.com", "password": "Admin123!"})
    assert r.status_code == 200, f"Admin login failed: {r.text}"
    return r.json()["access_token"]


@pytest.fixture(scope="session")
def admin_headers(admin_token):
    return {"Authorization": f"Bearer {admin_token}"}


def auth_header(token: str) -> dict:
    return {"Authorization": f"Bearer {token}"}

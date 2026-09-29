import os

os.environ.setdefault(
    "DATABASE_URL",
    "postgresql+asyncpg://appuser:apppassword@localhost:5432/appdb",
)
os.environ.setdefault(
    "SECRET_KEY",
    "test-secret-key",
)

from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)


def test_health():
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json() == {"status": "ok"}

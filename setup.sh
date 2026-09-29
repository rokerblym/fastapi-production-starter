#!/bin/zsh
set -e

echo "==> FastAPI Production Starter setup"

if ! command -v python3 >/dev/null 2>&1; then
  echo "Python 3 is not installed."
  exit 1
fi

if ! command -v docker >/dev/null 2>&1; then
  echo "Docker is not installed or not running."
  exit 1
fi

echo "==> Creating virtual environment"
python3 -m venv .venv
source .venv/bin/activate

echo "==> Installing dependencies"
python -m pip install --upgrade pip
pip install -r requirements.txt

if [ ! -f .env ]; then
  SECRET=$(python -c "import secrets; print(secrets.token_urlsafe(64))")
  cat > .env <<EOF
DATABASE_URL=postgresql+asyncpg://appuser:apppassword@localhost:5432/appdb
SECRET_KEY=$SECRET
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=60
EOF
  echo "==> Created .env with a random secret"
else
  echo "==> Existing .env kept"
fi

echo "==> Starting PostgreSQL"
docker compose up -d db

echo "==> Waiting for PostgreSQL"
for i in {1..30}; do
  if docker exec fastapi_starter_db pg_isready -U appuser -d appdb >/dev/null 2>&1; then
    break
  fi
  sleep 1
done

if ! docker exec fastapi_starter_db pg_isready -U appuser -d appdb >/dev/null 2>&1; then
  echo "PostgreSQL did not become ready."
  exit 1
fi

if [ -z "$(find alembic/versions -type f -name '*.py' -print -quit)" ]; then
  echo "==> Creating initial Alembic migration"
  alembic revision --autogenerate -m "create users table"
fi

echo "==> Applying migrations"
alembic upgrade head

echo "==> Running tests"
pytest -q

echo ""
echo "SETUP COMPLETE"
echo "Run the API with:"
echo "  source .venv/bin/activate"
echo "  uvicorn app.main:app --reload"
echo ""
echo "Swagger:"
echo "  http://127.0.0.1:8000/docs"

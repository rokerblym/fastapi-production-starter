# FastAPI Production Starter

A clean backend starter built with **FastAPI, PostgreSQL, SQLAlchemy 2, JWT authentication, Alembic, Docker Compose, and pytest**.

## Features

- FastAPI REST API
- Async PostgreSQL with `asyncpg`
- SQLAlchemy 2 async ORM
- User registration
- Password hashing with bcrypt
- JWT login
- Protected `/users/me` endpoint
- Alembic database migrations
- Docker + Docker Compose
- Swagger/OpenAPI docs
- Basic pytest health check

## Stack

Python 3.13 · FastAPI · PostgreSQL · SQLAlchemy · Alembic · Pydantic · JWT · Docker · pytest

## Local setup

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
cp .env.example .env
```

Generate a secure secret and place it into `.env`:

```bash
python -c "import secrets; print(secrets.token_urlsafe(64))"
```

Start PostgreSQL:

```bash
docker compose up -d db
```

Create the first migration:

```bash
alembic revision --autogenerate -m "create users table"
alembic upgrade head
```

Run the API:

```bash
uvicorn app.main:app --reload
```

Open:

- Swagger: http://127.0.0.1:8000/docs
- Health: http://127.0.0.1:8000/health

## Authentication flow

1. `POST /auth/register`
2. `POST /auth/login`
3. Copy the returned access token
4. Use `Authorize` in Swagger
5. Call `GET /users/me`

## Docker

Run the full stack:

```bash
docker compose up --build
```

Then run migrations inside the API container:

```bash
docker compose exec api alembic revision --autogenerate -m "create users table"
docker compose exec api alembic upgrade head
```

## Tests

```bash
pytest
```

## Security notes

- Passwords are hashed and never stored in plaintext.
- JWT secret is read from environment variables.
- `.env` is excluded from Git.
- SQLAlchemy parameterization protects normal ORM queries from SQL injection.
- Input validation is handled through Pydantic.

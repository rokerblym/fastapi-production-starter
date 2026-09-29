from fastapi import FastAPI

from app.routers.auth import router as auth_router
from app.routers.users import router as users_router

app = FastAPI(
    title="FastAPI Production Starter",
    description="Production-ready FastAPI starter with PostgreSQL, JWT auth, Docker and tests.",
    version="1.0.0",
)

app.include_router(auth_router)
app.include_router(users_router)


@app.get("/", tags=["system"])
async def root():
    return {"message": "FastAPI Production Starter is running"}


@app.get("/health", tags=["system"])
async def health_check():
    return {"status": "ok"}

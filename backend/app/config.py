from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    POSTGRES_USER: str = "aibadges"
    POSTGRES_PASSWORD: str = "aibadges_secret_2024"
    POSTGRES_DB: str = "aibadges"
    DATABASE_URL: str = "postgresql+asyncpg://aibadges:aibadges_secret_2024@db:5432/aibadges"

    JWT_SECRET_KEY: str = "super-secret-jwt-key-change-in-production-2024"
    JWT_ALGORITHM: str = "HS256"
    JWT_ACCESS_TOKEN_EXPIRE_MINUTES: int = 480

    UPLOAD_DIR: str = "/app/uploads"
    BACKEND_CORS_ORIGINS: list[str] = ["http://localhost:3000", "http://localhost:80", "http://localhost"]

    class Config:
        env_file = ".env"


settings = Settings()

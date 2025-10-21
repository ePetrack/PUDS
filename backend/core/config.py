"""
Application configuration - MVP version without Pydantic
"""

from typing import List
import os
from dotenv import load_dotenv

# Load .env file if it exists
load_dotenv()


class Settings:
    """Application settings"""

    # Application
    APP_NAME: str = "PUDS"
    ENV: str = os.getenv("ENV", "development")
    DEBUG: bool = os.getenv("DEBUG", "true").lower() == "true"

    # Database
    DATABASE_URL: str = os.getenv("DATABASE_URL", "sqlite+aiosqlite:///./puds.db")

    # CORS
    CORS_ORIGINS: List[str] = [
        "http://localhost:5173",
        "http://localhost:3000",
        "http://127.0.0.1:5173",
        "http://127.0.0.1:3000"
    ]

    # ISO 50001 Settings
    ENERGY_BASELINE_PERIOD_MONTHS: int = 12
    ENPI_CALCULATION_FREQUENCY: str = "monthly"


settings = Settings()

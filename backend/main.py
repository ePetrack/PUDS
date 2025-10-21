"""
PUDS Backend - FastAPI Application
Professional Utility Data System
"""

from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from contextlib import asynccontextmanager
import uvicorn

from api.routes import dashboard, bills, analytics, buildings, financial
from core.config import settings
from db.session import engine, Base

# Import all models to ensure they're registered with SQLAlchemy
from models import user, organization, utility, building, meter


@asynccontextmanager
async def lifespan(app: FastAPI):
    """Application lifespan events"""
    # Startup
    print("🚀 Starting PUDS Backend...")
    print(f"📊 Database: {settings.DATABASE_URL.split('@')[-1] if settings.DATABASE_URL else 'Not configured'}")

    # Create tables
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)

    yield

    # Shutdown
    print("👋 Shutting down PUDS Backend...")
    await engine.dispose()


# Initialize FastAPI app
app = FastAPI(
    title="PUDS API",
    description="Professional Utility Data System - Enterprise utility management following APPA and ISO 50001 standards",
    version="0.1.0",
    lifespan=lifespan,
    docs_url="/api/docs",
    redoc_url="/api/redoc",
    openapi_url="/api/openapi.json"
)

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.CORS_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Health check endpoint
@app.get("/health")
async def health_check():
    """Health check endpoint with database status"""
    import os

    # Check database file exists
    db_path = settings.DATABASE_URL.replace("sqlite+aiosqlite:///", "")
    db_exists = os.path.exists(db_path) if db_path.endswith('.db') else True

    return {
        "status": "healthy",
        "service": "PUDS Backend",
        "version": "0.1.0-MVP",
        "database": {
            "type": "SQLite",
            "path": "./puds.db"
        }
    }

# Include routers
app.include_router(dashboard.router, prefix="/api/dashboard", tags=["Dashboard"])
app.include_router(bills.router, prefix="/api/bills", tags=["Bills Management"])
app.include_router(analytics.router, prefix="/api/analytics", tags=["Analytics"])
app.include_router(buildings.router, prefix="/api/buildings", tags=["Buildings"])
app.include_router(financial.router, prefix="/api/financial", tags=["Financial"])


if __name__ == "__main__":
    uvicorn.run(
        "main:app",
        host="0.0.0.0",
        port=8000,
        reload=True
    )

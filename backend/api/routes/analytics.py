"""Analytics API endpoints"""
from fastapi import APIRouter

router = APIRouter()

@router.get("/")
async def get_analytics():
    """Get analytics - placeholder"""
    return {"message": "Analytics endpoint - to be implemented"}

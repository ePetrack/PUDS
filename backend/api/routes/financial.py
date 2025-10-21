"""Financial Performance API endpoints"""
from fastapi import APIRouter

router = APIRouter()

@router.get("/")
async def get_financial():
    """Get financial data - placeholder"""
    return {"message": "Financial endpoint - to be implemented"}

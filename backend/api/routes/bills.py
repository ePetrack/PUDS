"""Bills Management API endpoints"""
from fastapi import APIRouter

router = APIRouter()

@router.get("/")
async def get_bills():
    """Get utility bills - placeholder"""
    return {"message": "Bills endpoint - to be implemented"}

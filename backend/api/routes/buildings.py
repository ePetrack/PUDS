"""Buildings API endpoints"""
from fastapi import APIRouter

router = APIRouter()

@router.get("/")
async def get_buildings():
    """Get buildings - placeholder"""
    return {"message": "Buildings endpoint - to be implemented"}

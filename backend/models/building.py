"""
Building and facility models
"""

from sqlalchemy import Column, Integer, String, Float, DateTime, ForeignKey, Text
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from db.session import Base


class Building(Base):
    __tablename__ = "buildings"

    id = Column(Integer, primary_key=True, index=True)
    organization_id = Column(Integer, ForeignKey("organizations.id"), nullable=False)

    name = Column(String, index=True, nullable=False)
    building_code = Column(String, unique=True, index=True)
    building_type = Column(String)  # Office, Lab, Residence, Industrial, etc.

    # Physical characteristics
    address = Column(Text)
    square_footage = Column(Float)
    floors = Column(Integer)
    year_built = Column(Integer)
    occupancy = Column(Integer)

    # Energy characteristics
    climate_zone = Column(String)
    heating_degree_days = Column(Float)
    cooling_degree_days = Column(Float)

    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())

    # Relationships
    organization = relationship("Organization", back_populates="buildings")
    meters = relationship("Meter", back_populates="building")

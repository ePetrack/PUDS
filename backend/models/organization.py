"""
Organization and multi-tenancy models
"""

from sqlalchemy import Column, Integer, String, DateTime, Text
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from db.session import Base


class Organization(Base):
    __tablename__ = "organizations"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, unique=True, index=True, nullable=False)
    display_name = Column(String)
    description = Column(Text)
    contact_email = Column(String)
    contact_phone = Column(String)
    address = Column(Text)

    # ISO 50001 specific
    energy_policy = Column(Text)
    scope_boundaries = Column(Text)

    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())

    # Relationships
    users = relationship("User", back_populates="organization")
    buildings = relationship("Building", back_populates="organization")
    utilities = relationship("Utility", back_populates="organization")

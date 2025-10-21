"""
Meter and time-series data models
"""

from sqlalchemy import Column, Integer, String, Float, DateTime, ForeignKey, Index
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from db.session import Base


class Meter(Base):
    __tablename__ = "meters"

    id = Column(Integer, primary_key=True, index=True)
    building_id = Column(Integer, ForeignKey("buildings.id"), nullable=False)

    meter_id = Column(String, unique=True, index=True, nullable=False)
    meter_type = Column(String, nullable=False)  # electricity, gas, water, steam
    meter_name = Column(String)
    location = Column(String)

    # Meter characteristics
    manufacturer = Column(String)
    model = Column(String)
    install_date = Column(DateTime(timezone=True))
    last_calibration = Column(DateTime(timezone=True))

    is_active = Column(Integer, default=1)

    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())

    # Relationships
    building = relationship("Building", back_populates="meters")
    readings = relationship("MeterReading", back_populates="meter")


class MeterReading(Base):
    """
    Time-series meter readings
    This table should use TimescaleDB hypertable for optimal performance
    """
    __tablename__ = "meter_readings"

    id = Column(Integer, primary_key=True, index=True)
    meter_id = Column(Integer, ForeignKey("meters.id"), nullable=False, index=True)

    timestamp = Column(DateTime(timezone=True), nullable=False, index=True)
    value = Column(Float, nullable=False)
    unit = Column(String, nullable=False)

    # Quality indicators
    quality = Column(String)  # good, estimated, missing
    is_estimated = Column(Integer, default=0)

    created_at = Column(DateTime(timezone=True), server_default=func.now())

    # Relationships
    meter = relationship("Meter", back_populates="readings")

    # Create composite index for time-series queries
    __table_args__ = (
        Index('ix_meter_timestamp', 'meter_id', 'timestamp'),
    )

"""
Utility and bill models
"""

from sqlalchemy import Column, Integer, String, Float, DateTime, ForeignKey, Date, Numeric
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from db.session import Base


class Utility(Base):
    __tablename__ = "utilities"

    id = Column(Integer, primary_key=True, index=True)
    organization_id = Column(Integer, ForeignKey("organizations.id"), nullable=False)

    name = Column(String, nullable=False)  # Electric, Natural Gas, Water, Steam, etc.
    utility_type = Column(String, index=True, nullable=False)  # electricity, gas, water, steam
    provider = Column(String)  # Utility company name
    account_number = Column(String)

    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())

    # Relationships
    organization = relationship("Organization", back_populates="utilities")
    bills = relationship("UtilityBill", back_populates="utility")


class UtilityBill(Base):
    __tablename__ = "utility_bills"

    id = Column(Integer, primary_key=True, index=True)
    utility_id = Column(Integer, ForeignKey("utilities.id"), nullable=False)
    building_id = Column(Integer, ForeignKey("buildings.id"))

    bill_date = Column(Date, nullable=False, index=True)
    billing_period_start = Column(Date, nullable=False)
    billing_period_end = Column(Date, nullable=False)

    # Consumption
    consumption = Column(Float, nullable=False)  # kWh, therms, gallons, etc.
    consumption_unit = Column(String, nullable=False)  # kWh, therms, gal, etc.

    # Costs
    total_cost = Column(Numeric(10, 2), nullable=False)
    energy_charge = Column(Numeric(10, 2))
    demand_charge = Column(Numeric(10, 2))
    fixed_charge = Column(Numeric(10, 2))
    taxes = Column(Numeric(10, 2))

    # Demand (for electricity)
    peak_demand = Column(Float)  # kW
    demand_unit = Column(String)

    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())

    # Relationships
    utility = relationship("Utility", back_populates="bills")

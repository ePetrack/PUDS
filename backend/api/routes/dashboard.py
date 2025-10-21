"""
Dashboard API endpoints with dummy data
Provides real-time overview of utility system performance
"""

from fastapi import APIRouter, HTTPException
from datetime import datetime, timedelta
from typing import List, Dict, Any
import random

router = APIRouter()


def generate_time_series(days: int = 30, interval_hours: int = 1) -> List[Dict[str, Any]]:
    """Generate dummy time-series data"""
    data = []
    start_date = datetime.now() - timedelta(days=days)

    for i in range(days * (24 // interval_hours)):
        timestamp = start_date + timedelta(hours=i * interval_hours)
        # Simulate realistic energy consumption pattern
        hour = timestamp.hour
        base_load = 500  # kW base load
        time_factor = 1.2 if 6 <= hour <= 22 else 0.7  # Higher during day
        random_variation = random.uniform(0.9, 1.1)

        data.append({
            "timestamp": timestamp.isoformat(),
            "value": round(base_load * time_factor * random_variation, 2)
        })

    return data


@router.get("/overview")
async def get_dashboard_overview():
    """
    Get dashboard overview with key performance indicators
    Following ISO 50001 EnPI metrics and APPA best practices
    """

    # Current period vs previous period
    current_consumption = random.uniform(450000, 550000)  # kWh
    previous_consumption = random.uniform(480000, 580000)
    savings = ((previous_consumption - current_consumption) / previous_consumption) * 100

    return {
        "timestamp": datetime.now().isoformat(),
        "period": "current_month",

        # Key Performance Indicators (ISO 50001)
        "kpis": {
            "total_energy_consumption": {
                "value": round(current_consumption, 2),
                "unit": "kWh",
                "change_percent": round(savings, 2),
                "status": "improving" if savings > 0 else "degrading"
            },
            "energy_intensity": {
                "value": round(current_consumption / 850000, 4),  # kWh per sq ft
                "unit": "kWh/sqft",
                "change_percent": round(random.uniform(-5, 5), 2),
                "status": "stable"
            },
            "cost_savings": {
                "value": round(savings * current_consumption * 0.12 / 100, 2),  # $0.12/kWh
                "unit": "USD",
                "change_percent": round(savings, 2),
                "status": "improving" if savings > 0 else "degrading"
            },
            "carbon_emissions": {
                "value": round(current_consumption * 0.000709, 2),  # metric tons CO2e
                "unit": "metric tons CO2e",
                "change_percent": round(savings, 2),
                "status": "improving" if savings > 0 else "degrading"
            },
            "peak_demand": {
                "value": round(random.uniform(850, 1200), 2),
                "unit": "kW",
                "change_percent": round(random.uniform(-8, 8), 2),
                "timestamp": (datetime.now() - timedelta(days=random.randint(1, 7))).isoformat()
            }
        },

        # Energy distribution by utility type
        "energy_by_type": [
            {"type": "Electricity", "consumption": round(current_consumption * 0.65, 2), "cost": round(current_consumption * 0.65 * 0.12, 2), "unit": "kWh"},
            {"type": "Natural Gas", "consumption": round(random.uniform(15000, 25000), 2), "cost": round(random.uniform(15000, 25000) * 0.95, 2), "unit": "therms"},
            {"type": "Water", "consumption": round(random.uniform(800000, 1200000), 2), "cost": round(random.uniform(3500, 5500), 2), "unit": "gallons"},
            {"type": "Steam", "consumption": round(random.uniform(5000, 8000), 2), "cost": round(random.uniform(8000, 12000), 2), "unit": "mlbs"}
        ],

        # Building performance summary
        "building_summary": {
            "total_buildings": 15,
            "total_sqft": 850000,
            "average_eui": round(random.uniform(55, 75), 2),  # kBtu/sqft/year
            "top_performers": [
                {"name": "Science Building A", "eui": 48.2, "savings_percent": 15.3},
                {"name": "Admin Building", "eui": 52.1, "savings_percent": 12.7},
                {"name": "Library", "eui": 54.8, "savings_percent": 10.5}
            ],
            "needs_attention": [
                {"name": "Old Dormitory C", "eui": 95.3, "increase_percent": -8.2},
                {"name": "Lab Building 2", "eui": 88.7, "increase_percent": -5.4}
            ]
        },

        # Active alerts
        "alerts": [
            {
                "id": 1,
                "severity": "warning",
                "type": "high_consumption",
                "building": "Lab Building 2",
                "message": "Electricity consumption 15% above baseline",
                "timestamp": (datetime.now() - timedelta(hours=2)).isoformat()
            },
            {
                "id": 2,
                "severity": "info",
                "type": "meter_offline",
                "building": "Dormitory A",
                "message": "Steam meter offline for 6 hours",
                "timestamp": (datetime.now() - timedelta(hours=6)).isoformat()
            }
        ],

        # ISO 50001 Action Plans
        "action_plans": {
            "total": 12,
            "in_progress": 5,
            "completed_this_month": 2,
            "projected_annual_savings": 125000  # USD
        }
    }


@router.get("/energy-trends")
async def get_energy_trends(days: int = 30):
    """
    Get energy consumption trends over time
    """
    return {
        "period_days": days,
        "electricity": generate_time_series(days, interval_hours=1),
        "natural_gas": generate_time_series(days, interval_hours=24),
        "baseline": {
            "value": 520,
            "unit": "kW",
            "description": "12-month rolling baseline per ISO 50001"
        }
    }


@router.get("/utility-costs")
async def get_utility_costs(months: int = 12):
    """
    Get utility costs breakdown by month
    """
    costs = []
    start_date = datetime.now() - timedelta(days=months * 30)

    for i in range(months):
        month_date = start_date + timedelta(days=i * 30)
        costs.append({
            "month": month_date.strftime("%Y-%m"),
            "electricity": round(random.uniform(35000, 55000), 2),
            "natural_gas": round(random.uniform(15000, 25000), 2),
            "water": round(random.uniform(3000, 5000), 2),
            "steam": round(random.uniform(8000, 12000), 2),
            "total": round(random.uniform(65000, 95000), 2)
        })

    return {
        "period_months": months,
        "costs": costs,
        "total_annual": round(sum(c["total"] for c in costs), 2),
        "average_monthly": round(sum(c["total"] for c in costs) / len(costs), 2)
    }


@router.get("/weather-correlation")
async def get_weather_correlation(days: int = 30):
    """
    Get energy consumption correlated with weather data
    Important for ISO 50001 baseline adjustments
    """
    data = []
    start_date = datetime.now() - timedelta(days=days)

    for i in range(days):
        date = start_date + timedelta(days=i)
        temp = round(random.uniform(35, 85), 1)  # Fahrenheit
        consumption = 500 + (abs(temp - 65) * 15)  # More consumption at temperature extremes

        data.append({
            "date": date.strftime("%Y-%m-%d"),
            "avg_temperature": temp,
            "heating_degree_days": max(0, 65 - temp),
            "cooling_degree_days": max(0, temp - 65),
            "energy_consumption": round(consumption * random.uniform(0.9, 1.1), 2)
        })

    return {
        "period_days": days,
        "data": data,
        "correlation_coefficient": round(random.uniform(0.65, 0.85), 3)
    }


@router.get("/enpi-metrics")
async def get_enpi_metrics():
    """
    Get Energy Performance Indicators (EnPIs) per ISO 50001
    """
    return {
        "reporting_period": "2024-10",
        "baseline_period": "2023-01 to 2023-12",

        "primary_enpi": {
            "name": "Site Energy Use Intensity",
            "value": 65.3,
            "unit": "kBtu/sqft/year",
            "baseline_value": 72.1,
            "target_value": 68.0,
            "improvement_percent": 9.4,
            "status": "exceeding_target"
        },

        "secondary_enpis": [
            {
                "name": "Energy Cost per Square Foot",
                "value": 2.15,
                "unit": "USD/sqft/year",
                "baseline_value": 2.38,
                "improvement_percent": 9.7
            },
            {
                "name": "Carbon Intensity",
                "value": 0.0142,
                "unit": "metric tons CO2e/sqft/year",
                "baseline_value": 0.0157,
                "improvement_percent": 9.6
            },
            {
                "name": "Weather-Normalized EUI",
                "value": 67.2,
                "unit": "kBtu/sqft/year",
                "baseline_value": 73.5,
                "improvement_percent": 8.6
            }
        ],

        "target_achievement": {
            "on_track": True,
            "projected_annual_improvement": 10.2,
            "target_improvement": 5.0,
            "performance_vs_target": "205%"
        }
    }

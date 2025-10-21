"""
Advanced Analytics API endpoints using DuckDB

These endpoints demonstrate DuckDB's analytical capabilities:
- Complex aggregations
- Time-series analysis
- Statistical calculations
- ISO 50001 EnPI computations
"""

from fastapi import APIRouter, HTTPException
from datetime import datetime, timedelta
from typing import Optional
from services.analytics import get_analytics

router = APIRouter()


@router.get("/energy-baseline")
async def get_energy_baseline(
    months: int = 12,
    building_id: Optional[int] = None
):
    """
    Calculate energy baseline using DuckDB analytics

    Uses statistical functions to compute baseline statistics
    per ISO 50001 requirements.
    """
    analytics = get_analytics()

    try:
        baseline = analytics.calculate_energy_baseline(
            months=months,
            building_id=building_id
        )

        return {
            "baseline_period_months": months,
            "building_id": building_id,
            "statistics": baseline,
            "calculated_at": datetime.now().isoformat(),
            "methodology": "12-month rolling average per ISO 50001"
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Analytics error: {str(e)}")


@router.get("/enpi-trends")
async def get_enpi_trends(months: int = 12):
    """
    Get Energy Performance Indicator trends using DuckDB

    Uses window functions for month-over-month analysis
    """
    analytics = get_analytics()

    try:
        trends = analytics.calculate_enpi_trend(months=months)

        return {
            "period_months": months,
            "trends": trends,
            "calculated_at": datetime.now().isoformat()
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Analytics error: {str(e)}")


@router.get("/time-series-aggregation")
async def get_time_series_aggregation(
    table: str = "meter_readings",
    interval: str = "1 hour",
    aggregation: str = "AVG",
    value_column: str = "value"
):
    """
    Perform time-series aggregation using DuckDB

    Demonstrates DuckDB's time-series capabilities
    """
    analytics = get_analytics()

    try:
        result = analytics.calculate_time_series_aggregation(
            table=table,
            value_column=value_column,
            timestamp_column="timestamp",
            interval=interval,
            aggregation=aggregation
        )

        return {
            "table": table,
            "interval": interval,
            "aggregation": aggregation,
            "data_points": len(result),
            "data": result
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Analytics error: {str(e)}")


@router.get("/custom-query")
async def execute_custom_query(sql: str):
    """
    Execute a custom analytical SQL query using DuckDB

    WARNING: This is for development/testing only.
    In production, this should be restricted or removed.

    Example query:
    SELECT
        DATE_TRUNC('month', billing_period_start) as month,
        SUM(consumption) as total_consumption
    FROM utility_bills
    GROUP BY month
    ORDER BY month DESC
    LIMIT 12
    """
    analytics = get_analytics()

    try:
        result = analytics.execute_analytical_query(sql)

        return {
            "query": sql,
            "row_count": len(result),
            "data": result
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Query error: {str(e)}")


@router.get("/database-info")
async def get_database_info():
    """
    Get information about the dual-database architecture
    """
    return {
        "architecture": "Dual Database",
        "databases": {
            "sqlite": {
                "purpose": "Transactional data (OLTP)",
                "use_cases": [
                    "User accounts and authentication",
                    "Buildings and organizations",
                    "Utility accounts",
                    "Bill uploads and updates",
                    "Real-time data entry"
                ],
                "strengths": [
                    "Fast writes/updates/deletes",
                    "ACID transactions",
                    "Row-based storage",
                    "Mature and stable"
                ]
            },
            "duckdb": {
                "purpose": "Analytical queries (OLAP)",
                "use_cases": [
                    "ISO 50001 EnPI calculations",
                    "Time-series analysis",
                    "Energy baseline computations",
                    "Complex aggregations",
                    "Performance reports"
                ],
                "strengths": [
                    "Column-based storage",
                    "Blazing fast aggregations",
                    "Statistical functions",
                    "Window functions",
                    "Reads directly from SQLite (no duplication)"
                ]
            }
        },
        "data_flow": {
            "writes": "All data writes go to SQLite",
            "analytics": "DuckDB reads from SQLite using sqlite_scan()",
            "benefit": "No data duplication, best tool for each job"
        }
    }

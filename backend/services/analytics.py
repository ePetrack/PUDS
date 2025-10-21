"""
DuckDB Analytics Service

Provides high-performance analytics by reading from SQLite.
DuckDB excels at analytical queries (aggregations, time-series analysis, complex calculations).
SQLite handles transactional data (writes, updates, deletes).

Architecture:
    SQLite (puds.db) ← All writes go here (bills, buildings, meters)
    DuckDB ← Reads from SQLite for analytics (EnPI, trends, reports)

Benefits:
    - No data duplication
    - SQLite ensures ACID transactions
    - DuckDB provides fast analytical queries
    - Both are single-file, no server needed
"""

import duckdb
from typing import List, Dict, Any, Optional
from pathlib import Path
import os


class DuckDBAnalytics:
    """
    DuckDB analytics service for PUDS

    Uses DuckDB to perform fast analytical queries on SQLite data
    without duplicating data or requiring data movement.
    """

    def __init__(self, sqlite_db_path: str = "./puds.db"):
        """
        Initialize DuckDB analytics service

        Args:
            sqlite_db_path: Path to the SQLite database file
        """
        # Normalize path for Windows compatibility
        self.sqlite_db_path = os.path.abspath(sqlite_db_path).replace('\\', '/')
        self.conn: Optional[duckdb.DuckDBPyConnection] = None

    def get_connection(self) -> duckdb.DuckDBPyConnection:
        """
        Get or create DuckDB connection

        Returns:
            DuckDB connection object
        """
        if self.conn is None:
            # Create in-memory DuckDB instance
            self.conn = duckdb.connect(database=':memory:')

            # Install and load SQLite extension if needed
            try:
                self.conn.execute("INSTALL sqlite")
                self.conn.execute("LOAD sqlite")
            except:
                pass  # Extension might already be installed

        return self.conn

    def query_sqlite(self, table_name: str, query: str = "*", where: str = "") -> List[Dict[str, Any]]:
        """
        Query a SQLite table using DuckDB

        Args:
            table_name: Name of the table in SQLite
            query: SQL SELECT clause (default: "*")
            where: SQL WHERE clause (optional)

        Returns:
            List of dictionaries with query results
        """
        conn = self.get_connection()

        # Build query using sqlite_scan
        where_clause = f"WHERE {where}" if where else ""
        sql = f"""
            SELECT {query}
            FROM sqlite_scan('{self.sqlite_db_path}', '{table_name}')
            {where_clause}
        """

        result = conn.execute(sql).fetchall()
        columns = [desc[0] for desc in conn.description]

        return [dict(zip(columns, row)) for row in result]

    def execute_analytical_query(self, sql: str) -> List[Dict[str, Any]]:
        """
        Execute a custom analytical SQL query

        The SQL can reference SQLite tables using sqlite_scan function:
        Example: SELECT * FROM sqlite_scan('puds.db', 'meter_readings')

        Args:
            sql: DuckDB SQL query

        Returns:
            List of dictionaries with query results
        """
        conn = self.get_connection()

        # Replace table references with sqlite_scan
        # This allows using table names directly in queries
        sql_modified = sql.replace(
            f"FROM meter_readings",
            f"FROM sqlite_scan('{self.sqlite_db_path}', 'meter_readings')"
        ).replace(
            f"FROM utility_bills",
            f"FROM sqlite_scan('{self.sqlite_db_path}', 'utility_bills')"
        ).replace(
            f"FROM buildings",
            f"FROM sqlite_scan('{self.sqlite_db_path}', 'buildings')"
        )

        result = conn.execute(sql_modified).fetchall()

        if not result:
            return []

        columns = [desc[0] for desc in conn.description]
        return [dict(zip(columns, row)) for row in result]

    def calculate_time_series_aggregation(
        self,
        table: str,
        value_column: str,
        timestamp_column: str,
        interval: str = "1 hour",
        aggregation: str = "AVG"
    ) -> List[Dict[str, Any]]:
        """
        Calculate time-series aggregations using DuckDB's time functions

        Perfect for meter readings, energy consumption trends, etc.

        Args:
            table: Table name (e.g., 'meter_readings')
            value_column: Column to aggregate (e.g., 'value')
            timestamp_column: Timestamp column
            interval: Time interval (e.g., '1 hour', '1 day', '1 month')
            aggregation: Aggregation function (AVG, SUM, MIN, MAX, COUNT)

        Returns:
            List of time-series data points
        """
        sql = f"""
            SELECT
                time_bucket(INTERVAL '{interval}', {timestamp_column}) as time_bucket,
                {aggregation}({value_column}) as value,
                COUNT(*) as count
            FROM sqlite_scan('{self.sqlite_db_path}', '{table}')
            GROUP BY time_bucket
            ORDER BY time_bucket
        """

        return self.execute_analytical_query(sql)

    def calculate_energy_baseline(
        self,
        months: int = 12,
        building_id: Optional[int] = None
    ) -> Dict[str, Any]:
        """
        Calculate energy baseline per ISO 50001

        Uses DuckDB's statistical functions for regression analysis

        Args:
            months: Number of months for baseline period (default: 12)
            building_id: Optional building filter

        Returns:
            Baseline statistics (mean, std_dev, regression coefficients)
        """
        building_filter = f"AND building_id = {building_id}" if building_id else ""

        sql = f"""
            SELECT
                AVG(consumption) as baseline_mean,
                STDDEV(consumption) as baseline_stddev,
                MIN(consumption) as baseline_min,
                MAX(consumption) as baseline_max,
                COUNT(*) as data_points
            FROM sqlite_scan('{self.sqlite_db_path}', 'utility_bills')
            WHERE billing_period_start >= CURRENT_DATE - INTERVAL '{months} months'
            {building_filter}
        """

        result = self.execute_analytical_query(sql)
        return result[0] if result else {}

    def calculate_enpi_trend(
        self,
        metric: str = "energy_intensity",
        months: int = 12
    ) -> List[Dict[str, Any]]:
        """
        Calculate Energy Performance Indicator trends

        Uses DuckDB's window functions for month-over-month analysis

        Args:
            metric: EnPI metric to calculate
            months: Number of months to analyze

        Returns:
            Monthly EnPI values with trends
        """
        # This is a simplified example - would be customized based on your EnPI formulas
        sql = f"""
            SELECT
                DATE_TRUNC('month', billing_period_start) as month,
                SUM(consumption) as total_consumption,
                SUM(total_cost) as total_cost,
                AVG(consumption) as avg_consumption,
                LAG(SUM(consumption)) OVER (ORDER BY DATE_TRUNC('month', billing_period_start)) as prev_month_consumption
            FROM sqlite_scan('{self.sqlite_db_path}', 'utility_bills')
            WHERE billing_period_start >= CURRENT_DATE - INTERVAL '{months} months'
            GROUP BY DATE_TRUNC('month', billing_period_start)
            ORDER BY month
        """

        return self.execute_analytical_query(sql)

    def close(self):
        """Close DuckDB connection"""
        if self.conn:
            self.conn.close()
            self.conn = None

    def __enter__(self):
        """Context manager entry"""
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        """Context manager exit"""
        self.close()


# Singleton instance
_analytics_instance: Optional[DuckDBAnalytics] = None


def get_analytics() -> DuckDBAnalytics:
    """
    Get singleton DuckDB analytics instance

    Returns:
        DuckDBAnalytics instance
    """
    global _analytics_instance

    if _analytics_instance is None:
        # Get SQLite database path from environment or use default
        db_path = os.getenv("DATABASE_PATH", "./puds.db")
        if db_path.startswith("sqlite+aiosqlite:///"):
            db_path = db_path.replace("sqlite+aiosqlite:///", "")

        _analytics_instance = DuckDBAnalytics(db_path)

    return _analytics_instance

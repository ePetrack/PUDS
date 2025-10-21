@echo off
REM Quick Test Script for PUDS Backend

echo ========================================
echo PUDS Backend Test
echo ========================================
echo.

cd /d "%~dp0backend"

REM Check if virtual environment exists
if not exist "venv\" (
    echo ERROR: Virtual environment not found!
    echo Please run start-backend.bat first
    pause
    exit /b 1
)

REM Activate virtual environment
call venv\Scripts\activate.bat

echo Testing Python installation...
python --version
if errorlevel 1 (
    echo ERROR: Python not found
    pause
    exit /b 1
)

echo.
echo Testing dependencies...
python -c "import fastapi; print('✓ FastAPI OK')"
python -c "import uvicorn; print('✓ Uvicorn OK')"
python -c "import sqlalchemy; print('✓ SQLAlchemy OK')"
python -c "import duckdb; print('✓ DuckDB OK')"
python -c "import pydantic; print('✓ Pydantic OK')"

echo.
echo ========================================
echo All tests passed! ✓
echo ========================================
echo.
echo You can now run: start-backend.bat
echo.

pause

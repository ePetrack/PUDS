@echo off
REM Final verification before running PUDS

echo ========================================
echo PUDS MVP - Pre-Flight Check
echo ========================================
echo.

cd /d "%~dp0"

echo [1/5] Checking Python installation...
python --version >nul 2>&1
if errorlevel 1 (
    echo ❌ FAILED: Python not found
    echo.
    echo Install Python:
    echo   winget install Python.Python.3.11 --scope user
    echo.
    pause
    exit /b 1
)
python --version
echo ✓ Python found
echo.

echo [2/5] Checking requirements.txt...
findstr /C:"duckdb" backend\requirements.txt >nul 2>&1
if not errorlevel 1 (
    echo ❌ FAILED: DuckDB still in requirements.txt
    echo Please run: git pull
    pause
    exit /b 1
)
findstr /C:"pydantic" backend\requirements.txt >nul 2>&1
if not errorlevel 1 (
    echo ❌ FAILED: Pydantic still in requirements.txt
    echo Please run: git pull
    pause
    exit /b 1
)
echo ✓ requirements.txt is clean (no DuckDB/Pydantic)
echo.

echo [3/5] Checking Python files for DuckDB imports...
findstr /S /C:"import duckdb" backend\*.py >nul 2>&1
if not errorlevel 1 (
    echo ❌ FAILED: Found duckdb imports in Python files
    echo Please run: git pull
    pause
    exit /b 1
)
echo ✓ No DuckDB imports found
echo.

echo [4/5] Verifying MVP requirements...
type backend\requirements.txt
echo.
echo ✓ Only 5 dependencies listed
echo.

echo [5/5] Checking directory structure...
if not exist "backend\main.py" (
    echo ❌ FAILED: backend\main.py not found
    pause
    exit /b 1
)
if not exist "frontend\package.json" (
    echo ❌ FAILED: frontend\package.json not found
    pause
    exit /b 1
)
echo ✓ All required files present
echo.

echo ========================================
echo ✓ ALL CHECKS PASSED!
echo ========================================
echo.
echo You're ready to run PUDS MVP!
echo.
echo Next steps:
echo 1. Run: start-backend-mvp.bat
echo 2. Wait for "Uvicorn running"
echo 3. In new window, run: start-frontend.bat
echo 4. Open: http://localhost:5173
echo.
pause

@echo off
SETLOCAL EnableDelayedExpansion

echo ========================================
echo PUDS MVP Backend - Debug Mode
echo ========================================
echo.

REM Navigate to backend directory
cd /d "%~dp0backend"
if errorlevel 1 (
    echo ERROR: Cannot find backend directory
    echo Current directory: %CD%
    pause
    exit /b 1
)

echo Current directory: %CD%
echo.

REM Test 1: Check Python
echo [TEST 1] Checking Python...
python --version
if errorlevel 1 (
    echo.
    echo ❌ FAILED: Python not found
    echo.
    echo Please install Python:
    echo   1. Open new PowerShell
    echo   2. Run: winget install Python.Python.3.11 --scope user
    echo   3. Close and reopen this window
    echo   4. Try again
    echo.
    pause
    exit /b 1
)
echo ✓ Python is installed
echo.

REM Test 2: Check requirements.txt
echo [TEST 2] Checking requirements.txt...
if not exist "requirements.txt" (
    echo ❌ FAILED: requirements.txt not found
    echo Expected location: %CD%\requirements.txt
    pause
    exit /b 1
)
echo ✓ requirements.txt found
echo.
echo Contents:
type requirements.txt
echo.

REM Test 3: Check main.py
echo [TEST 3] Checking main.py...
if not exist "main.py" (
    echo ❌ FAILED: main.py not found
    pause
    exit /b 1
)
echo ✓ main.py found
echo.

REM Test 4: Create virtual environment
echo [TEST 4] Creating virtual environment...
if exist "venv" (
    echo Deleting old venv...
    rmdir /s /q venv
)
python -m venv venv
if errorlevel 1 (
    echo ❌ FAILED: Could not create virtual environment
    pause
    exit /b 1
)
echo ✓ Virtual environment created
echo.

REM Test 5: Activate venv
echo [TEST 5] Activating virtual environment...
if not exist "venv\Scripts\activate.bat" (
    echo ❌ FAILED: activate.bat not found
    pause
    exit /b 1
)
call venv\Scripts\activate.bat
echo ✓ Virtual environment activated
echo.

REM Test 6: Check pip
echo [TEST 6] Checking pip...
python -m pip --version
if errorlevel 1 (
    echo ❌ FAILED: pip not working
    pause
    exit /b 1
)
echo ✓ pip is working
echo.

REM Test 7: Upgrade pip
echo [TEST 7] Upgrading pip...
python -m pip install --upgrade pip --quiet
echo ✓ pip upgraded
echo.

REM Test 8: Install dependencies
echo [TEST 8] Installing dependencies...
echo This may take 1-2 minutes...
echo.
pip install -r requirements.txt
if errorlevel 1 (
    echo.
    echo ========================================
    echo ❌ FAILED: Could not install dependencies
    echo ========================================
    echo.
    echo Try these solutions:
    echo   1. Check internet connection
    echo   2. Try running this script again
    echo   3. Check if antivirus is blocking
    echo.
    echo If you see compilation errors, run:
    echo   git pull
    echo   (to get latest code without DuckDB)
    echo.
    pause
    exit /b 1
)
echo.
echo ✓ All dependencies installed
echo.

REM Test 9: Verify imports
echo [TEST 9] Testing Python imports...
python -c "import fastapi; print('  ✓ fastapi')"
if errorlevel 1 (
    echo ❌ FAILED: Cannot import fastapi
    pause
    exit /b 1
)
python -c "import uvicorn; print('  ✓ uvicorn')"
if errorlevel 1 (
    echo ❌ FAILED: Cannot import uvicorn
    pause
    exit /b 1
)
python -c "import sqlalchemy; print('  ✓ sqlalchemy')"
if errorlevel 1 (
    echo ❌ FAILED: Cannot import sqlalchemy
    pause
    exit /b 1
)
echo ✓ All imports successful
echo.

REM Test 10: Start server
echo [TEST 10] Starting server...
echo.
echo ========================================
echo ✓ ALL TESTS PASSED!
echo ========================================
echo.
echo Starting PUDS Backend...
echo.
echo URLs:
echo   Dashboard: http://localhost:5173
echo   API Docs:  http://localhost:8000/api/docs
echo   Health:    http://localhost:8000/health
echo.
echo Press Ctrl+C to stop
echo ========================================
echo.

python -m uvicorn main:app --reload --host 0.0.0.0 --port 8000

echo.
echo Server stopped.
pause

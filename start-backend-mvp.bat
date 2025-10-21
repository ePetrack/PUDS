@echo off
REM MVP Startup Script - Simplified for Python 3.13

echo ========================================
echo PUDS MVP - Backend Startup
echo ========================================
echo.

cd /d "%~dp0backend"

REM Check Python is available
python --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Python not found!
    echo.
    echo Please install Python:
    echo   winget install Python.Python.3.11 --scope user
    echo.
    echo Then close and reopen this terminal.
    pause
    exit /b 1
)

echo Python found:
python --version
echo.

REM Delete old venv if it exists
if exist "venv\" (
    echo Removing old virtual environment...
    rmdir /s /q venv
)

REM Create fresh virtual environment
echo Creating virtual environment...
python -m venv venv
if errorlevel 1 (
    echo ERROR: Failed to create virtual environment
    pause
    exit /b 1
)

REM Activate virtual environment
echo Activating virtual environment...
call venv\Scripts\activate.bat

REM Upgrade pip
echo Upgrading pip...
python -m pip install --upgrade pip --quiet

REM Install dependencies
echo.
echo Installing dependencies...
echo This should only take 30-60 seconds...
echo.

pip install -r requirements.txt
if errorlevel 1 (
    echo.
    echo ========================================
    echo ERROR: Failed to install dependencies
    echo ========================================
    echo.
    echo Try these solutions:
    echo 1. Make sure you have internet connection
    echo 2. Try running as administrator
    echo 3. Check if antivirus is blocking
    echo.
    pause
    exit /b 1
)

echo.
echo ========================================
echo Installation complete!
echo ========================================
echo.
echo Starting PUDS Backend...
echo.
echo Dashboard API: http://localhost:8000
echo API Docs: http://localhost:8000/api/docs
echo Health Check: http://localhost:8000/health
echo.
echo Press Ctrl+C to stop
echo ========================================
echo.

uvicorn main:app --reload --host 0.0.0.0 --port 8000

pause

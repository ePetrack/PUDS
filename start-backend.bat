@echo off
REM Start PUDS Backend (Windows)

echo ========================================
echo Starting PUDS Backend...
echo ========================================
echo.

cd /d "%~dp0backend"

REM Check if virtual environment exists
if not exist "venv\" (
    echo Creating Python virtual environment...
    python -m venv venv
    if errorlevel 1 (
        echo ERROR: Failed to create virtual environment
        echo Make sure Python is installed and in your PATH
        pause
        exit /b 1
    )
    echo Virtual environment created successfully!
    echo.
)

REM Activate virtual environment
echo Activating virtual environment...
call venv\Scripts\activate.bat
if errorlevel 1 (
    echo ERROR: Failed to activate virtual environment
    pause
    exit /b 1
)

REM Upgrade pip first
echo Upgrading pip...
python -m pip install --upgrade pip --quiet

REM Install/update dependencies
echo Installing dependencies (this may take a minute on first run)...
echo.
pip install -r requirements.txt
if errorlevel 1 (
    echo.
    echo ERROR: Failed to install dependencies
    echo.
    echo This might be due to:
    echo - Missing Python installation
    echo - Network connectivity issues
    echo - Python version incompatibility
    echo.
    echo Please ensure Python 3.11+ is installed
    pause
    exit /b 1
)

echo.
echo ========================================
echo Backend installation complete!
echo ========================================
echo.
echo Starting FastAPI server...
echo Dashboard API: http://localhost:8000
echo API Documentation: http://localhost:8000/api/docs
echo.
echo Press Ctrl+C to stop the server
echo ========================================
echo.

uvicorn main:app --reload --host 0.0.0.0 --port 8000

pause

@echo off
REM Start PUDS Frontend (Windows)

echo ========================================
echo Starting PUDS Frontend...
echo ========================================
echo.

cd /d "%~dp0frontend"

REM Check if node_modules exists
if not exist "node_modules\" (
    echo Installing Node.js dependencies...
    echo This will take a few minutes on first run...
    echo.
    npm install
    if errorlevel 1 (
        echo.
        echo ERROR: Failed to install Node.js dependencies
        echo.
        echo This might be due to:
        echo - Missing Node.js installation
        echo - Network connectivity issues
        echo.
        echo Please ensure Node.js 18+ is installed
        pause
        exit /b 1
    )
    echo.
    echo Frontend dependencies installed successfully!
    echo.
)

echo ========================================
echo Frontend installation complete!
echo ========================================
echo.
echo Starting SvelteKit development server...
echo Dashboard: http://localhost:5173
echo.
echo Press Ctrl+C to stop the server
echo ========================================
echo.

npm run dev

pause

@echo off
REM Test if MVP is working properly

echo ========================================
echo PUDS MVP - System Check
echo ========================================
echo.

echo Testing Backend API...
echo.

REM Test 1: Health Check
echo [1/4] Health Check...
curl -s http://localhost:8000/health
if errorlevel 1 (
    echo ❌ Backend not responding
    echo Make sure start-backend-debug.bat is running
    pause
    exit /b 1
)
echo.
echo ✓ Backend is healthy
echo.

REM Test 2: Dashboard Overview
echo [2/4] Dashboard Overview API...
curl -s http://localhost:8000/api/dashboard/overview > temp_response.json
if errorlevel 1 (
    echo ❌ Dashboard API not responding
    pause
    exit /b 1
)
type temp_response.json
del temp_response.json
echo.
echo ✓ Dashboard API working
echo.

REM Test 3: Frontend
echo [3/4] Frontend Check...
curl -s http://localhost:5173 > nul
if errorlevel 1 (
    echo ❌ Frontend not responding
    echo Make sure start-frontend.bat is running
    pause
    exit /b 1
)
echo ✓ Frontend is running
echo.

REM Test 4: Browser Check
echo [4/4] Opening dashboard in browser...
start http://localhost:5173
echo.

echo ========================================
echo ✓ MVP System Check Complete!
echo ========================================
echo.
echo Your browser should open automatically.
echo If you see a blank page, press F12 and check the Console tab.
echo.
pause

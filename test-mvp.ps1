# MVP Verification Script
# Run this in PowerShell to check if everything is working

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "PUDS MVP - System Check" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Test 1: Backend Health
Write-Host "[1/5] Testing Backend Health..." -ForegroundColor Yellow
try {
    $health = Invoke-RestMethod -Uri "http://localhost:8000/health" -TimeoutSec 5
    Write-Host "✓ Backend is healthy" -ForegroundColor Green
    Write-Host "  Version: $($health.version)" -ForegroundColor Gray
    Write-Host "  Database: $($health.database.type)" -ForegroundColor Gray
} catch {
    Write-Host "❌ Backend not responding" -ForegroundColor Red
    Write-Host "  Make sure start-backend-debug.bat is running" -ForegroundColor Yellow
    exit 1
}
Write-Host ""

# Test 2: Dashboard API
Write-Host "[2/5] Testing Dashboard API..." -ForegroundColor Yellow
try {
    $dashboard = Invoke-RestMethod -Uri "http://localhost:8000/api/dashboard/overview" -TimeoutSec 5
    Write-Host "✓ Dashboard API working" -ForegroundColor Green
    Write-Host "  KPIs available: $($dashboard.kpis.PSObject.Properties.Count)" -ForegroundColor Gray
    Write-Host "  Buildings: $($dashboard.building_summary.total_buildings)" -ForegroundColor Gray
} catch {
    Write-Host "❌ Dashboard API failed" -ForegroundColor Red
    Write-Host "  Error: $($_.Exception.Message)" -ForegroundColor Yellow
    exit 1
}
Write-Host ""

# Test 3: Energy Trends API
Write-Host "[3/5] Testing Energy Trends API..." -ForegroundColor Yellow
try {
    $trends = Invoke-RestMethod -Uri "http://localhost:8000/api/dashboard/energy-trends" -TimeoutSec 5
    Write-Host "✓ Energy Trends API working" -ForegroundColor Green
    Write-Host "  Data points: $($trends.electricity.Count)" -ForegroundColor Gray
} catch {
    Write-Host "❌ Energy Trends API failed" -ForegroundColor Red
    exit 1
}
Write-Host ""

# Test 4: EnPI Metrics API
Write-Host "[4/5] Testing EnPI Metrics API..." -ForegroundColor Yellow
try {
    $enpi = Invoke-RestMethod -Uri "http://localhost:8000/api/dashboard/enpi-metrics" -TimeoutSec 5
    Write-Host "✓ EnPI Metrics API working" -ForegroundColor Green
    Write-Host "  Primary EnPI: $($enpi.primary_enpi.name)" -ForegroundColor Gray
} catch {
    Write-Host "❌ EnPI Metrics API failed" -ForegroundColor Red
    exit 1
}
Write-Host ""

# Test 5: Frontend
Write-Host "[5/5] Testing Frontend..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:5173" -TimeoutSec 5 -UseBasicParsing
    Write-Host "✓ Frontend is running" -ForegroundColor Green
} catch {
    Write-Host "❌ Frontend not responding" -ForegroundColor Red
    Write-Host "  Make sure start-frontend.bat is running" -ForegroundColor Yellow
    exit 1
}
Write-Host ""

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "✓ ALL TESTS PASSED!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Opening dashboard in browser..." -ForegroundColor Yellow
Start-Process "http://localhost:5173"
Write-Host ""
Write-Host "If you see a blank page:" -ForegroundColor Yellow
Write-Host "1. Press F12 in your browser" -ForegroundColor Gray
Write-Host "2. Click the 'Console' tab" -ForegroundColor Gray
Write-Host "3. Look for any red error messages" -ForegroundColor Gray
Write-Host "4. Send me a screenshot!" -ForegroundColor Gray
Write-Host ""

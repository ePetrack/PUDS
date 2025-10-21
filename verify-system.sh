#!/bin/bash
# MVP Verification Script - Tests if everything is working

echo "========================================="
echo "PUDS MVP - Complete System Check"
echo "========================================="
echo ""

# Test 1: Backend Health
echo "[1/6] Testing Backend Health..."
HEALTH=$(curl -s http://localhost:8000/health 2>&1)
if [ $? -ne 0 ]; then
    echo "❌ FAILED: Backend not responding on port 8000"
    echo "   Make sure backend is running: ./start-backend-codespaces.sh"
    exit 1
fi
echo "✓ Backend is responding"
echo "   Response: $HEALTH"
echo ""

# Test 2: Dashboard Overview Endpoint
echo "[2/6] Testing Dashboard Data..."
DASHBOARD=$(curl -s http://localhost:8000/api/dashboard/overview 2>&1)
if [ $? -ne 0 ]; then
    echo "❌ FAILED: Dashboard API not responding"
    exit 1
fi
echo "✓ Dashboard API responding"
echo "   First 200 chars: ${DASHBOARD:0:200}..."
echo ""

# Test 3: Check if data has KPIs
echo "[3/6] Checking for KPI data..."
if echo "$DASHBOARD" | grep -q "kpis"; then
    echo "✓ KPI data found in response"
else
    echo "❌ FAILED: No KPI data in response"
    echo "   Full response: $DASHBOARD"
    exit 1
fi
echo ""

# Test 4: Energy Trends Endpoint
echo "[4/6] Testing Energy Trends..."
TRENDS=$(curl -s http://localhost:8000/api/dashboard/energy-trends 2>&1)
if [ $? -ne 0 ]; then
    echo "❌ FAILED: Energy trends API not responding"
    exit 1
fi
echo "✓ Energy trends API responding"
echo ""

# Test 5: Frontend
echo "[5/6] Testing Frontend..."
FRONTEND=$(curl -s http://localhost:5173 2>&1)
if [ $? -ne 0 ]; then
    echo "❌ FAILED: Frontend not responding on port 5173"
    echo "   Make sure frontend is running: ./start-frontend-codespaces.sh"
    exit 1
fi
echo "✓ Frontend is responding"
echo ""

# Test 6: Check for API proxy
echo "[6/6] Testing API Proxy..."
PROXY=$(curl -s http://localhost:5173/api/dashboard/overview 2>&1)
if echo "$PROXY" | grep -q "kpis"; then
    echo "✓ API proxy working (frontend can reach backend)"
else
    echo "⚠️  WARNING: API proxy might not be working"
    echo "   This could cause empty dashboard"
    echo "   Frontend response: ${PROXY:0:200}..."
fi
echo ""

echo "========================================="
echo "System Check Complete!"
echo "========================================="
echo ""
echo "If dashboard is still empty:"
echo "1. Open browser Developer Tools (F12)"
echo "2. Go to Console tab"
echo "3. Look for red errors"
echo "4. Look for 'Failed to fetch' messages"
echo ""
echo "Check these URLs in your browser:"
echo "  http://localhost:8000/api/dashboard/overview"
echo "  http://localhost:5173"
echo ""

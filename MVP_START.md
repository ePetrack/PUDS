# MVP QUICK START - Get Running in 5 Minutes!

This is a simplified version that works with Python 3.13 without any compilation.

## What's Different in MVP

**Removed (to avoid compilation):**
- ❌ DuckDB (advanced analytics) - We'll add back later
- ❌ Pydantic validation - Using simple Python classes
- ❌ Authentication libraries - Not needed for dashboard yet

**What Still Works:**
- ✅ Dashboard with sample energy data
- ✅ All charts and visualizations
- ✅ SQLite database
- ✅ FastAPI backend
- ✅ SvelteKit frontend
- ✅ ISO 50001 metrics

## Installation (Windows)

### Step 1: Install Python

```powershell
# Any Python 3.11+ works
winget install Python.Python.3.11 --scope user

# Close and reopen PowerShell!
```

### Step 2: Clone PUDS

```powershell
# Navigate to D drive
cd D:\PROJECTS

# Clone the repo
git clone https://github.com/ePetrack/PUDS.git PUDS
cd PUDS

# Switch to the feature branch
git checkout claude/utility-management-system-011CULczmjWU9SeDqSQbLmBe

# Pull latest MVP code
git pull
```

### Step 3: Start Backend

```powershell
# Use the MVP startup script
.\start-backend-mvp.bat
```

**What happens:**
- Creates fresh virtual environment
- Installs only 5 packages (30-60 seconds)
- Starts the server

**Success looks like:**
```
INFO:     Uvicorn running on http://0.0.0.0:8000
INFO:     Application startup complete.
```

**Keep this window open!**

### Step 4: Start Frontend

Open a **NEW** PowerShell window:

```powershell
cd D:\PROJECTS\PUDS
.\start-frontend.bat
```

**Success looks like:**
```
Local:   http://localhost:5173/
```

### Step 5: Open Dashboard

Go to: **http://localhost:5173**

You should see the full PUDS dashboard!

## Verification

Check these URLs work:

- ✅ http://localhost:8000/health - Backend health check
- ✅ http://localhost:8000/api/docs - API documentation
- ✅ http://localhost:5173 - Dashboard

## If Something Goes Wrong

### "Python not found"

```powershell
# Check it's installed
python --version

# If not found, close and reopen PowerShell after installing
```

### Dependencies fail to install

```powershell
# Delete and retry
Remove-Item -Recurse -Force backend\venv
.\start-backend-mvp.bat
```

### Port already in use

```powershell
# Kill the process
netstat -ano | findstr :8000
taskkill /PID <number> /F

# Or just restart your computer
```

### Frontend won't start

```powershell
# Install Node.js if you haven't
winget install OpenJS.NodeJS --scope user

# Close and reopen PowerShell

# Delete and retry
Remove-Item -Recurse -Force frontend\node_modules
.\start-frontend.bat
```

## What You're Getting

### Dashboard Features
- ✅ Real-time energy consumption KPIs
- ✅ Energy trend charts (ECharts)
- ✅ Utility cost breakdown (pie chart)
- ✅ ISO 50001 EnPI metrics with gauge
- ✅ Building performance rankings
- ✅ Active alerts monitoring
- ✅ Action plans tracking

### API Endpoints
- `GET /api/dashboard/overview` - Main KPIs
- `GET /api/dashboard/energy-trends` - Time-series data
- `GET /api/dashboard/utility-costs` - Cost breakdown
- `GET /api/dashboard/enpi-metrics` - ISO 50001 metrics
- `GET /health` - System health check

### Sample Data
All endpoints return realistic dummy data so you can see the dashboard in action immediately.

## Files Created

```
D:\PROJECTS\PUDS\
├── backend\
│   ├── venv\          # Python virtual environment
│   ├── puds.db        # SQLite database (auto-created)
│   └── .env           # Configuration
└── frontend\
    └── node_modules\  # Node dependencies
```

## Next Steps

Once this MVP is working:

1. **Add Real Data** - Replace dummy data with actual utility bills
2. **Add DuckDB Back** - For advanced analytics (when wheels available)
3. **Build Other Modules** - Bills Management, Analytics, etc.
4. **Deploy to Production** - Move to cloud or server

## Differences from Full Version

| Feature | MVP | Full Version |
|---------|-----|--------------|
| Dashboard | ✅ Full | ✅ Full |
| SQLite DB | ✅ Yes | ✅ Yes |
| DuckDB Analytics | ❌ Not yet | ✅ Yes |
| Data Validation | ⚠️ Basic | ✅ Pydantic |
| Authentication | ❌ Not yet | ✅ JWT |
| All 11 Modules | ❌ Dashboard only | ⚠️ In progress |

## Troubleshooting

**Still stuck?**

1. Make sure you're in the right directory:
   ```powershell
   pwd
   # Should show: D:\PROJECTS\PUDS
   ```

2. Verify Python works:
   ```powershell
   python --version
   # Should show: Python 3.11.x or 3.13.x
   ```

3. Check you pulled latest code:
   ```powershell
   git pull
   git log --oneline -1
   # Should show recent commit about MVP
   ```

4. Try deleting everything and starting fresh:
   ```powershell
   Remove-Item -Recurse -Force backend\venv
   Remove-Item -Recurse -Force frontend\node_modules
   Remove-Item backend\puds.db -ErrorAction SilentlyContinue

   .\start-backend-mvp.bat
   # Wait for success, then in new window:
   .\start-frontend.bat
   ```

## Support

- **Backend not starting?** Check `backend/venv/Scripts/python.exe` exists
- **Frontend not starting?** Check `frontend/node_modules` exists
- **Database errors?** Delete `backend/puds.db` and restart

## Success Indicators

✅ **You're good to go if:**
- Backend shows "Uvicorn running on http://0.0.0.0:8000"
- Frontend shows "Local: http://localhost:5173/"
- Browser shows PUDS dashboard with charts
- No errors in either terminal

## Time Estimate

- **First time:** 5-10 minutes
- **Subsequent startups:** 10 seconds

That's it! You now have a working utility management dashboard! 🎉

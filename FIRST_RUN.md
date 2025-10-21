# Windows First-Time Startup Guide

## Before You Start

Make sure you have:
- ✅ Python 3.11 or 3.13 installed
- ✅ Node.js 18+ installed
- ✅ Closed and reopened your terminal after installing

## Quick Installation Check

```powershell
# Check Python
python --version

# Check Node
node --version

# Check npm
npm --version
```

If any command fails, install the missing software and **restart your terminal**.

## Step 1: Navigate to PUDS

```powershell
cd D:\PROJECTS\PUDS
```

## Step 2: Test Installation (Optional but Recommended)

```powershell
# Run the test script
.\test-installation.bat
```

This will verify all dependencies can be installed without errors.

## Step 3: Start Backend

```powershell
.\start-backend.bat
```

**What to expect:**
```
========================================
Starting PUDS Backend...
========================================

Creating Python virtual environment...
Virtual environment created successfully!

Activating virtual environment...
Upgrading pip...
Installing dependencies (this may take a minute on first run)...

Collecting fastapi==0.109.0
...
Successfully installed [all packages]

========================================
Backend installation complete!
========================================

Starting FastAPI server...
Dashboard API: http://localhost:8000
API Documentation: http://localhost:8000/api/docs

INFO:     Uvicorn running on http://0.0.0.0:8000
INFO:     Application startup complete.
```

**If you see this → Success!** ✅

Keep this window open and continue to Step 4.

## Step 4: Verify Backend is Running

Open another PowerShell window and test:

```powershell
# Quick health check
curl http://localhost:8000/health
```

Should return:
```json
{
  "status": "healthy",
  "service": "PUDS Backend",
  "version": "0.1.0",
  "database": {
    "type": "SQLite",
    "connected": true
  }
}
```

## Step 5: Start Frontend

In the **NEW** PowerShell window:

```powershell
cd D:\PROJECTS\PUDS
.\start-frontend.bat
```

**What to expect:**
```
========================================
Starting PUDS Frontend...
========================================

Installing Node.js dependencies...
This will take a few minutes on first run...

added 300 packages in 45s

Frontend dependencies installed successfully!

========================================
Frontend installation complete!
========================================

Starting SvelteKit development server...
Dashboard: http://localhost:5173

VITE v5.x.x  ready in 500 ms

➜  Local:   http://localhost:5173/
```

**If you see this → Success!** ✅

## Step 6: Open Dashboard

Open your browser: **http://localhost:5173**

You should see:
- ✅ PUDS dashboard with navigation sidebar
- ✅ Energy consumption KPIs
- ✅ Charts with sample data
- ✅ ISO 50001 metrics
- ✅ Building performance data

## Troubleshooting

### Problem: "Python not found"

**Solution:**
1. Verify installation: `winget list Python`
2. Close and reopen PowerShell
3. Try: `py --version` instead of `python --version`
4. If still fails, reinstall: `winget install Python.Python.3.11 --scope user`

### Problem: "Node not found"

**Solution:**
1. Verify installation: `winget list Node`
2. Close and reopen PowerShell
3. If still fails, reinstall: `winget install OpenJS.NodeJS --scope user`

### Problem: Backend installation fails

**Common causes:**

1. **Network error** - Check internet connection
2. **Antivirus blocking** - Temporarily disable or add exception
3. **Disk space** - Need ~500MB free

**Solution:**
```powershell
# Delete and retry
Remove-Item -Recurse -Force backend\venv
.\start-backend.bat
```

### Problem: "Port 8000 already in use"

**Solution:**
```powershell
# Find and kill the process
netstat -ano | findstr :8000
taskkill /PID <number> /F

# Then restart
.\start-backend.bat
```

### Problem: Frontend installation fails

**Solution:**
```powershell
# Delete and retry
Remove-Item -Recurse -Force frontend\node_modules
.\start-frontend.bat
```

### Problem: Dashboard loads but no data

**Check backend is running:**
1. Make sure backend terminal is still open
2. Check: http://localhost:8000/health
3. If not running, restart: `.\start-backend.bat`

### Problem: "Cannot read file" errors

**Solution:**
Make sure you're in the PUDS directory:
```powershell
# Check where you are
pwd

# Should show: D:\PROJECTS\PUDS (or wherever you put it)
# If not, navigate there:
cd D:\PROJECTS\PUDS
```

## Success Checklist

After successful startup, verify:

- [ ] Backend running: http://localhost:8000/health shows "healthy"
- [ ] Frontend running: http://localhost:5173 shows dashboard
- [ ] API docs accessible: http://localhost:8000/api/docs
- [ ] Dashboard shows sample data (charts, KPIs, tables)
- [ ] No error messages in either terminal

## What's Running

**Terminal 1 - Backend:**
- FastAPI web server
- SQLite database (creates puds.db automatically)
- DuckDB analytics engine
- REST API endpoints

**Terminal 2 - Frontend:**
- Vite development server
- SvelteKit application
- Hot module reloading (changes update automatically)

## Stopping PUDS

Press `Ctrl+C` in each terminal window, or just close the windows.

## Next Time You Start

It's much faster! Just:

```powershell
# Terminal 1
cd D:\PROJECTS\PUDS
.\start-backend.bat

# Terminal 2
cd D:\PROJECTS\PUDS
.\start-frontend.bat
```

Dependencies are already installed, so it starts in ~10 seconds.

## Files Created

After first run, you'll have:

```
D:\PROJECTS\PUDS\
├── backend\
│   ├── venv\              # Python virtual environment
│   ├── puds.db            # Your database (SQLite file)
│   └── .env               # Configuration
└── frontend\
    └── node_modules\      # Node.js dependencies
```

## Getting Help

If you're still stuck:

1. Check **WINDOWS_INSTALL.md** for detailed troubleshooting
2. Make sure Python 3.11+ and Node.js 18+ are installed
3. Verify you closed and reopened terminal after installing
4. Try the test script: `.\test-installation.bat`

## You're Ready! 🚀

Once both servers are running and the dashboard loads, you're all set to:
- Explore the dashboard
- Try the API endpoints
- Start customizing for your campus
- Build the next module!

Happy energy managing! ⚡

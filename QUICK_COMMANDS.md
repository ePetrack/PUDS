# QUICK START - Take This With You!

## Setup Commands (Copy & Paste)

### 1. Navigate to PUDS
```powershell
cd D:\PROJECTS\PUDS
```

### 2. Pull Latest Code
```powershell
git pull
```

### 3. Start Backend (Terminal 1)
```powershell
.\start-backend.bat
```
Wait for: `INFO: Uvicorn running on http://0.0.0.0:8000`

### 4. Start Frontend (Terminal 2)
```powershell
cd D:\PROJECTS\PUDS
.\start-frontend.bat
```
Wait for: `Local: http://localhost:5173/`

### 5. Open Dashboard
```
http://localhost:5173
```

## If It Fails - Quick Fixes

### "Python not found"
```powershell
winget install Python.Python.3.11 --scope user
# Then close and reopen terminal
```

### "Node not found"
```powershell
winget install OpenJS.NodeJS --scope user
# Then close and reopen terminal
```

### Installation errors
```powershell
# Delete old virtual environment
Remove-Item -Recurse -Force backend\venv

# Try again
.\start-backend.bat
```

### Port already in use
```powershell
# Kill port 8000
netstat -ano | findstr :8000
taskkill /PID <number> /F

# Or just restart your computer
```

## Verification

After both scripts run, check:
- ✅ Backend: http://localhost:8000/health
- ✅ Frontend: http://localhost:5173
- ✅ API Docs: http://localhost:8000/api/docs

## What You're Getting

✅ **Dashboard** with sample energy data
✅ **SQLite database** (no server needed)
✅ **DuckDB analytics** (10-100x faster calculations)
✅ **ISO 50001** compliant metrics
✅ **APPA** best practices built-in

## Files Created

```
D:\PROJECTS\PUDS\
├── backend\venv\      # Python environment
├── backend\puds.db    # Your database
└── frontend\node_modules\  # Node dependencies
```

## For Detailed Help

- **First Run Guide:** `FIRST_RUN.md`
- **Windows Setup:** `WINDOWS_INSTALL.md`
- **Quick Start:** `QUICKSTART_WINDOWS.md`

## Support URLs

- Dashboard: http://localhost:5173
- API Docs: http://localhost:8000/api/docs
- Health Check: http://localhost:8000/health

---

**Remember:** You need TWO terminal windows running!
- Window 1: Backend (port 8000)
- Window 2: Frontend (port 5173)

Good luck! 🚀

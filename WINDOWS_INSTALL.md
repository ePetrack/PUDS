# Windows Installation Guide (No Admin Required)

## The Error You Got

The error happens because numpy tries to compile from source and needs Visual Studio Build Tools (requires admin). **We've removed numpy** - it wasn't needed anyway!

## Fixed! Here's the Solution

### Step 1: Delete Old Virtual Environment

```powershell
# Navigate to PUDS folder
cd D:\PROJECTS\PUDS\PUDS-claude__v2025-10-21

# Delete the old virtual environment
Remove-Item -Recurse -Force backend\venv
```

### Step 2: Install Prerequisites

```powershell
# Install Python (if not already installed)
winget install Python.Python.3.11 --scope user

# Install Node.js (if not already installed)
winget install OpenJS.NodeJS --scope user
```

**Close and reopen PowerShell/Command Prompt after installation!**

### Step 3: Verify Installation

```powershell
# Check Python
python --version
# Should show: Python 3.11.x or 3.12.x

# Check Node.js
node --version
# Should show: v18.x or higher
```

### Step 4: Start PUDS

Open **two separate** Command Prompt or PowerShell windows:

**Window 1 - Backend:**
```powershell
cd D:\PROJECTS\PUDS\PUDS-claude__v2025-10-21
.\start-backend.bat
```

**Window 2 - Frontend:**
```powershell
cd D:\PROJECTS\PUDS\PUDS-claude__v2025-10-21
.\start-frontend.bat
```

### Step 5: Open Dashboard

Go to: http://localhost:5173

## What We Changed

✅ **Removed heavy dependencies:**
- ❌ numpy (required C compiler)
- ❌ pandas (depends on numpy)
- ❌ duckdb (not needed for dashboard)
- ❌ pytest (dev dependency)
- ❌ alembic (not needed yet)

✅ **Kept essential dependencies:**
- ✅ FastAPI (web framework)
- ✅ uvicorn (web server)
- ✅ SQLAlchemy (database)
- ✅ aiosqlite (SQLite driver)
- ✅ pydantic (data validation)

## Troubleshooting

### Problem: "python: command not found"

**Solution:**
1. Close and reopen your terminal after installing Python
2. Or manually add to PATH:
   - Search "Environment Variables" in Windows
   - Edit "Path" for your user (no admin needed)
   - Click "New" and add: `C:\Users\YOUR_USERNAME\AppData\Local\Programs\Python\Python311`
   - Click "New" again and add: `C:\Users\YOUR_USERNAME\AppData\Local\Programs\Python\Python311\Scripts`

### Problem: "node: command not found"

**Solution:**
Same as above, but add Node.js path (usually `C:\Program Files\nodejs`)

### Problem: Port 8000 or 5173 already in use

**Solution:**
```powershell
# Kill process on port 8000
netstat -ano | findstr :8000
taskkill /PID <number> /F

# Kill process on port 5173
netstat -ano | findstr :5173
taskkill /PID <number> /F
```

### Problem: Installation fails with network error

**Solution:**
```powershell
# Try with different pip index
pip install -r requirements.txt --index-url https://pypi.org/simple
```

### Problem: "uvicorn not found" after installation

**Solution:**
```powershell
# Make sure virtual environment is activated
cd backend
.\venv\Scripts\activate

# Reinstall uvicorn specifically
pip install uvicorn[standard]
```

## Success Indicators

**Backend started successfully:**
```
INFO:     Uvicorn running on http://0.0.0.0:8000
INFO:     Application startup complete.
```

**Frontend started successfully:**
```
VITE v5.x.x  ready in xxx ms
➜  Local:   http://localhost:5173/
```

## Database File

Your SQLite database will be created at:
```
D:\PROJECTS\PUDS\PUDS-claude__v2025-10-21\backend\puds.db
```

To backup your data, just copy this file!

## Next Steps

1. ✅ Open http://localhost:5173
2. ✅ Explore the dashboard
3. ✅ See dummy data in action
4. 📊 Start customizing for your needs!

## If All Else Fails

Try this manual approach:

```powershell
# Backend
cd backend
python -m venv venv
.\venv\Scripts\activate
python -m pip install --upgrade pip
pip install fastapi uvicorn[standard] sqlalchemy aiosqlite pydantic pydantic-settings python-dotenv
uvicorn main:app --reload

# In new window - Frontend
cd frontend
npm install
npm run dev
```

## Getting Help

If you're still stuck:
1. Copy the full error message
2. Note which step failed
3. Check that Python 3.11+ and Node.js 18+ are installed
4. Make sure you closed/reopened terminal after installing

You got this! 🚀

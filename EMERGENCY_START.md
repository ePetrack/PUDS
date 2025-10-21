# Emergency MVP Startup - Copy & Paste This!

## If Backend Won't Start

### Option 1: Debug Script

```powershell
cd D:\PROJECTS\PUDS
.\start-backend-debug.bat
```

This will show you exactly where it fails.

### Option 2: Manual Step-by-Step

Copy and paste ONE command at a time:

```powershell
# 1. Go to backend folder
cd D:\PROJECTS\PUDS\backend

# 2. Check Python works
python --version

# 3. Delete old venv
Remove-Item -Recurse -Force venv -ErrorAction SilentlyContinue

# 4. Create fresh venv
python -m venv venv

# 5. Activate it
.\venv\Scripts\activate

# 6. Upgrade pip
python -m pip install --upgrade pip

# 7. Show what we're installing
type requirements.txt

# 8. Install (should show 5 packages)
pip install -r requirements.txt

# 9. Test imports
python -c "import fastapi; print('OK')"
python -c "import uvicorn; print('OK')"

# 10. Start server
python -m uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

## What to Look For

**Good output from step 8:**
```
Successfully installed fastapi-0.115.0 uvicorn-0.31.0 sqlalchemy-2.0.35 aiosqlite-0.20.0 python-dotenv-1.0.1
```

**Good output from step 10:**
```
INFO:     Uvicorn running on http://0.0.0.0:8000
INFO:     Application startup complete.
```

## If You See Errors

### "Python not found"
```powershell
winget install Python.Python.3.11 --scope user
# Close and reopen PowerShell
```

### "Cannot create venv"
```powershell
# Try with py launcher
cd D:\PROJECTS\PUDS\backend
py -3.11 -m venv venv
```

### Still compiling DuckDB/Pydantic
```powershell
cd D:\PROJECTS\PUDS
git pull
# Then start over
```

### "Module not found" when starting
```powershell
# Make sure you're in venv
cd D:\PROJECTS\PUDS\backend
.\venv\Scripts\activate
# You should see (venv) in your prompt
pip list
# Should show fastapi, uvicorn, etc.
```

## Send Me This Info

If it still doesn't work, copy and paste the output from:

```powershell
cd D:\PROJECTS\PUDS\backend
python --version
type requirements.txt
```

And tell me what error you see!

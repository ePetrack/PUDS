# PUDS Windows Setup Guide (No Admin Required)

Complete setup guide for running PUDS on Windows without administrator privileges.

## Prerequisites

You'll need to install these using winget (no admin required):

```powershell
# Install Python 3.11+ (user scope)
winget install Python.Python.3.11 --scope user

# Install Node.js (user scope)
winget install OpenJS.NodeJS --scope user
```

**Important**: After installation, close and reopen your terminal (PowerShell or Command Prompt) to refresh the PATH.

## Verify Installation

```powershell
# Check Python
python --version
# Should show: Python 3.11.x or higher

# Check pip
pip --version

# Check Node.js
node --version
# Should show: v18.x.x or higher

# Check npm
npm --version
```

## Quick Start (3 Simple Steps)

### Step 1: Get the Code

```powershell
# Navigate to where you want the project
cd C:\Users\YourUsername\Projects

# Clone the repository (or download and extract ZIP)
git clone <repository-url>
cd PUDS
```

### Step 2: Start Backend

Open PowerShell or Command Prompt in the PUDS folder:

```powershell
# Run the backend startup script
.\start-backend.bat
```

This will:
- ✅ Create a Python virtual environment
- ✅ Install all dependencies
- ✅ Create SQLite database automatically
- ✅ Start the API server

You should see:
```
INFO:     Uvicorn running on http://0.0.0.0:8000
```

**Keep this window open!**

### Step 3: Start Frontend

Open a **NEW** PowerShell or Command Prompt window:

```powershell
# Navigate to PUDS folder
cd C:\Users\YourUsername\Projects\PUDS

# Run the frontend startup script
.\start-frontend.bat
```

This will:
- ✅ Install Node.js dependencies
- ✅ Start the development server

You should see:
```
VITE ready in xxx ms
Local: http://localhost:5173/
```

### Step 4: Open the Dashboard

Open your browser and go to:
- **Dashboard**: http://localhost:5173
- **API Docs**: http://localhost:8000/api/docs

🎉 **You're done!** The dashboard should load with sample data.

## Database: SQLite vs PostgreSQL

### SQLite (Default - No Admin Needed) ✅

**Pros:**
- ✅ No installation required
- ✅ Single file database (puds.db)
- ✅ Perfect for development and testing
- ✅ Works without admin rights
- ✅ Easy to backup (just copy puds.db file)

**Cons:**
- ⚠️ Less efficient for very large datasets
- ⚠️ No TimescaleDB time-series optimizations

**Current Setup:** The system is pre-configured to use SQLite. Just run the scripts!

### PostgreSQL + TimescaleDB (Optional - Better for Production)

If you later get admin rights or want to use a cloud database:

**Option 1: Cloud Database (No Admin Required)**
- Use [Supabase](https://supabase.com) (Free tier available)
- Use [Neon](https://neon.tech) (Free PostgreSQL)
- Use [Railway](https://railway.app) (Free tier)

**Option 2: Portable PostgreSQL**
- Download [portable PostgreSQL](https://sourceforge.net/projects/pgsqlportable/)
- Extract to a folder (no installation needed)
- Update `backend/.env` with connection string

To switch to PostgreSQL, just edit `backend/.env`:
```env
# Comment out SQLite:
# DATABASE_URL=sqlite+aiosqlite:///./puds.db

# Enable PostgreSQL:
DATABASE_URL=postgresql+asyncpg://username:password@host:5432/database
```

## Manual Setup (If Scripts Don't Work)

### Backend Setup

```powershell
# Navigate to backend folder
cd backend

# Create virtual environment
python -m venv venv

# Activate virtual environment
.\venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Start the server
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

### Frontend Setup

Open a NEW terminal:

```powershell
# Navigate to frontend folder
cd frontend

# Install dependencies
npm install

# Start development server
npm run dev
```

## File Locations

Your PUDS installation will create these files:

```
C:\Users\YourUsername\Projects\PUDS\
├── backend/
│   ├── venv/              # Python virtual environment
│   ├── puds.db            # SQLite database (auto-created)
│   └── .env               # Configuration file
├── frontend/
│   └── node_modules/      # Node.js dependencies
└── ...
```

## Troubleshooting

### Issue: "Python not found"

After installing Python, you may need to:
1. Close and reopen your terminal
2. Or add Python to PATH manually:
   - Search for "Environment Variables" in Windows
   - Edit "Path" for current user (doesn't need admin)
   - Add: `C:\Users\YourUsername\AppData\Local\Programs\Python\Python311`

### Issue: "Port already in use"

**Backend (port 8000):**
```powershell
# Find what's using port 8000
netstat -ano | findstr :8000

# Kill the process (note the PID from above command)
taskkill /PID <PID> /F
```

**Frontend (port 5173):**
```powershell
# Find what's using port 5173
netstat -ano | findstr :5173

# Kill the process
taskkill /PID <PID> /F
```

### Issue: "pip install fails"

Some packages may need Visual C++ build tools. If you get errors:

```powershell
# Try installing without binary packages
pip install --no-binary :all: <package-name>

# Or use pre-built wheels
pip install --only-binary :all: <package-name>
```

### Issue: "Cannot activate virtual environment"

If you get execution policy errors:

```powershell
# Run PowerShell with this command first:
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned

# Then try activating again
.\venv\Scripts\activate
```

Or use Command Prompt instead of PowerShell:
```cmd
venv\Scripts\activate.bat
```

### Issue: "Module not found"

Make sure you're in the virtual environment:

```powershell
# You should see (venv) in your prompt
(venv) PS C:\Users\...\PUDS\backend>

# If not, activate it:
.\venv\Scripts\activate

# Then install dependencies again:
pip install -r requirements.txt
```

### Issue: Database errors

Delete and recreate the database:

```powershell
# Stop the backend server (Ctrl+C)

# Delete the database file
del backend\puds.db

# Restart the backend
.\start-backend.bat
```

The database will be recreated automatically.

## Performance Tips

### Faster Startup

After first installation, startups will be faster because dependencies are cached.

### Database Backup

Your data is stored in `backend/puds.db`. To backup:

```powershell
# Simple copy
copy backend\puds.db backend\puds_backup.db

# Or with date
copy backend\puds.db backend\puds_backup_%date:~-4,4%%date:~-10,2%%date:~-7,2%.db
```

## Next Steps

1. ✅ Start the backend: `.\start-backend.bat`
2. ✅ Start the frontend: `.\start-frontend.bat`
3. ✅ Open dashboard: http://localhost:5173
4. 📊 Explore the dashboard with sample data
5. 🔧 Start building other modules!

## Development Workflow

### Daily Development

```powershell
# Terminal 1 - Backend
cd C:\Users\YourUsername\Projects\PUDS
.\start-backend.bat

# Terminal 2 - Frontend
cd C:\Users\YourUsername\Projects\PUDS
.\start-frontend.bat
```

### Stopping the Servers

- Press `Ctrl+C` in each terminal window
- Or close the terminal windows

### Updating Dependencies

**Backend:**
```powershell
cd backend
.\venv\Scripts\activate
pip install --upgrade -r requirements.txt
```

**Frontend:**
```powershell
cd frontend
npm update
```

## Using Different Database

### SQLite (Default)
```env
DATABASE_URL=sqlite+aiosqlite:///./puds.db
```

### Cloud PostgreSQL (Supabase example)
```env
DATABASE_URL=postgresql+asyncpg://user:pass@db.xxxxx.supabase.co:5432/postgres
```

## Support

If you encounter issues:
1. Check this troubleshooting guide
2. Check `SETUP.md` for general setup info
3. Review error messages in the terminal
4. Create an issue on GitHub with error details

## Summary

✅ No admin rights needed
✅ SQLite database (no server required)
✅ Simple two-command startup
✅ All data in portable files
✅ Easy to backup and move

You're ready to develop! 🚀

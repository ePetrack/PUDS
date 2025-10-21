# Install PUDS from Scratch (Windows)

If you don't have git or haven't cloned the repository yet, follow these steps.

## Option 1: Download from GitHub

1. Go to: https://github.com/ePetrack/PUDS
2. Click the green "Code" button
3. Click "Download ZIP"
4. Extract the ZIP file to `D:\PROJECTS\PUDS`
5. Open PowerShell and continue to "Running PUDS" below

## Option 2: Clone with Git

If you have git installed:

```powershell
# Navigate to your projects folder
cd D:\PROJECTS

# Clone the repository
git clone https://github.com/ePetrack/PUDS.git PUDS
cd PUDS

# Switch to the feature branch with all the latest fixes
git checkout claude/utility-management-system-011CULczmjWU9SeDqSQbLmBe
```

## Install Prerequisites

```powershell
# Install Python 3.11+ (no admin needed)
winget install Python.Python.3.11 --scope user

# Install Node.js 18+ (no admin needed)
winget install OpenJS.NodeJS --scope user
```

**Important:** Close and reopen PowerShell after installing!

## Verify Installation

```powershell
# Check Python
python --version
# Should show: Python 3.11.x or 3.12.x

# Check Node
node --version
# Should show: v18.x.x or higher

# Check npm
npm --version
```

## Running PUDS

Open **two separate** PowerShell windows:

### Window 1 - Backend
```powershell
cd D:\PROJECTS\PUDS
.\start-backend.bat
```

Wait for:
```
INFO: Uvicorn running on http://0.0.0.0:8000
INFO: Application startup complete.
```

### Window 2 - Frontend
```powershell
cd D:\PROJECTS\PUDS
.\start-frontend.bat
```

Wait for:
```
VITE ready in xxx ms
Local: http://localhost:5173/
```

## Open the Dashboard

Go to: **http://localhost:5173**

You should see the PUDS dashboard with sample data!

## File Structure

After installation, you'll have:

```
D:\PROJECTS\PUDS\
├── backend\
│   ├── venv\              # Python virtual environment (auto-created)
│   ├── puds.db            # SQLite database (auto-created)
│   ├── .env               # Configuration (copy from .env.example)
│   └── ...
├── frontend\
│   ├── node_modules\      # Node dependencies (auto-created)
│   └── ...
├── start-backend.bat      # Run this first
├── start-frontend.bat     # Run this second
└── ...
```

## First Run Setup

The startup scripts will automatically:
1. ✅ Create Python virtual environment
2. ✅ Install all Python dependencies
3. ✅ Install all Node.js dependencies
4. ✅ Create SQLite database
5. ✅ Load sample data
6. ✅ Start the servers

**First run takes 2-5 minutes. Subsequent runs take 10 seconds.**

## Troubleshooting

### "Python not found"
- Make sure you closed/reopened PowerShell after installing Python
- Check: `python --version`

### "Node not found"
- Make sure you closed/reopened PowerShell after installing Node.js
- Check: `node --version`

### Port already in use
```powershell
# Kill process on port 8000
netstat -ano | findstr :8000
taskkill /PID <number> /F

# Kill process on port 5173
netstat -ano | findstr :5173
taskkill /PID <number> /F
```

### Installation fails
See **WINDOWS_INSTALL.md** for detailed troubleshooting

## What You're Getting

✅ **Dashboard Module** - Real-time energy monitoring
✅ **ISO 50001 Compliance** - Energy Performance Indicators
✅ **APPA Standards** - Utility management best practices
✅ **Sample Data** - Ready to explore
✅ **11 Module Framework** - Ready to build more

## Next Steps

1. Explore the dashboard
2. Review `docs/ISO50001_COMPLIANCE.md`
3. Check `docs/ARCHITECTURE.md` to understand the system
4. Start building the next module!

## Need Help?

- **Quick Start:** QUICKSTART_WINDOWS.md
- **Detailed Setup:** SETUP_WINDOWS.md
- **Windows Issues:** WINDOWS_INSTALL.md
- **General Setup:** SETUP.md
- **Architecture:** docs/ARCHITECTURE.md

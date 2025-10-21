# Windows Quick Start (2 Minutes)

The fastest way to get PUDS running on Windows without admin rights.

## Install Prerequisites

```powershell
# Install Python (user scope - no admin needed)
winget install Python.Python.3.11 --scope user

# Install Node.js (user scope - no admin needed)
winget install OpenJS.NodeJS --scope user
```

**Close and reopen your terminal after installation!**

## Start PUDS

### Terminal 1 - Backend
```powershell
cd path\to\PUDS
.\start-backend.bat
```

### Terminal 2 - Frontend
```powershell
cd path\to\PUDS
.\start-frontend.bat
```

## Open Dashboard

http://localhost:5173

That's it! 🎉

---

## What Just Happened?

- ✅ SQLite database created (no server needed)
- ✅ Python dependencies installed
- ✅ Node.js dependencies installed
- ✅ Backend API running on port 8000
- ✅ Frontend dashboard running on port 5173
- ✅ Sample data loaded

## Common Issues

**"Python not found"** → Close and reopen terminal after installation

**"Port already in use"** → Kill the process or restart your computer

**Need help?** → See `SETUP_WINDOWS.md` for detailed troubleshooting

## Next Steps

1. Explore the Dashboard with sample data
2. Review `docs/ISO50001_COMPLIANCE.md` to understand features
3. Start building the next module!

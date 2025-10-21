# Running PUDS in GitHub Codespaces

GitHub Codespaces provides a complete cloud development environment - no local installation needed!

## Quick Start

### Option 1: Automatic Setup (Recommended)

1. Open in Codespaces: https://github.com/ePetrack/PUDS
2. Click: **Code** → **Codespaces** → **Create codespace**
3. Wait for environment to load (1-2 minutes)
4. In the terminal, run:

```bash
chmod +x *.sh
./setup-codespaces.sh
```

5. Start backend (Terminal 1):
```bash
./start-backend-codespaces.sh
```

6. Start frontend (new terminal - click + button):
```bash
./start-frontend-codespaces.sh
```

7. Click "Open in Browser" when you see the port notification (5173)

### Option 2: Manual Setup

**Terminal 1 - Backend:**
```bash
cd backend
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
python -m uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

**Terminal 2 - Frontend:**
```bash
cd frontend
npm install
npm run dev -- --host
```

## Accessing Your App

### Method 1: Port Forwarding Popup
When you start the servers, Codespaces will show popups:
- **Port 8000** - Backend API
- **Port 5173** - Frontend Dashboard

Click **"Open in Browser"** on port 5173.

### Method 2: Ports Tab
1. Look for the **"Ports"** tab in the bottom panel
2. Find port **5173** (Frontend)
3. Click the **globe icon** 🌐 to open in browser

### Method 3: Manual URL
Codespaces URLs look like:
```
https://<your-codespace-name>-5173.app.github.dev
```

Check the Ports tab for the exact URL.

## URLs in Codespaces

| Service | Port | What |
|---------|------|------|
| Frontend | 5173 | Dashboard (open this!) |
| Backend | 8000 | API |
| API Docs | 8000 | Add `/api/docs` to backend URL |

## Benefits

✅ **No Installation** - Everything runs in the cloud
✅ **Pre-configured** - Python, Node.js already installed
✅ **Fast** - Cloud infrastructure
✅ **Persistent** - Your codespace saves your work
✅ **Free Tier** - 60 hours/month for free accounts

## Tips

### Multiple Terminals
- Click the **+** button in terminal panel to add terminals
- Or use split terminal (icon with split panes)

### Port Privacy
By default, ports are **private** (only you can access).
- Good for security
- Bad if sharing with others

To make public:
1. Go to **Ports** tab
2. Right-click port 5173
3. Choose **Port Visibility** → **Public**

### Stopping Services
- Press **Ctrl+C** in each terminal to stop servers
- Or just close the browser tab (codespace stops automatically after inactivity)

### Restarting Later
Your codespace is saved! Next time:
1. Go to https://github.com/codespaces
2. Click your existing codespace to reopen
3. Run the start scripts again

## Troubleshooting

### "Port in use" error
```bash
# Kill processes on port
pkill -f uvicorn
pkill -f vite

# Then restart
```

### Module errors
```bash
# Reinstall backend
cd backend
rm -rf venv
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt

# Reinstall frontend
cd ../frontend
rm -rf node_modules
npm install
```

### Can't see dashboard
1. Check both servers are running (should see output in terminals)
2. Check Ports tab - are both ports forwarded?
3. Try clicking the globe icon on port 5173
4. Check browser console (F12) for errors

## Codespace Limits

**Free tier:**
- 15 GB storage
- 2 cores, 8 GB RAM
- 60 hours/month

**Paid GitHub Pro:**
- 20 GB storage
- Up to 8 cores, 32 GB RAM
- 90 hours/month

PUDS MVP uses minimal resources - free tier is perfect!

## Advantages Over Local

| Feature | Local Windows | Codespaces |
|---------|--------------|------------|
| Setup time | 30+ minutes | 5 minutes |
| Installation issues | Common | Rare |
| Python 3.13 issues | Yes | No (uses 3.11) |
| Compilation needed | Sometimes | Never |
| Works anywhere | Need your PC | Any browser |
| Port conflicts | Common | Rare |

## Next Steps

Once running in Codespaces:
1. ✅ Explore the dashboard
2. ✅ Check API docs at `/api/docs`
3. ✅ Try different tabs (only Dashboard has data in MVP)
4. ✅ Customize and build features!

Your codespace URL will look like:
```
https://fuzzy-space-adventure-abcd1234.github.dev
```

Bookmark it to return later!

# PUDS - Professional Utility Data System

An enterprise-grade, open-source utility management system following APPA and ISO 50001 standards.

## 🚀 Quick Start (Recommended: GitHub Codespaces)

**The easiest way to run PUDS - no installation needed!**

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://github.com/ePetrack/PUDS/codespaces)

### In Codespaces (3 commands):

```bash
# 1. Setup (installs everything - 30 seconds)
./setup-codespaces.sh

# 2. Start backend (Terminal 1)
./start-backend-codespaces.sh

# 3. Start frontend (Terminal 2 - click + for new terminal)
./start-frontend-codespaces.sh
```

**Then click "Open in Browser" on port 5173!** ✨

📖 **Detailed guide:** [CODESPACES.md](CODESPACES.md)

---

## 💻 Alternative: Run Locally on Windows

See [MVP_START.md](MVP_START.md) for local installation.

**Note:** Local Windows setup can have Python 3.13 compatibility issues. Codespaces is recommended!

---

## System Architecture

### Technology Stack

**Frontend**
- SvelteKit - Modern, performant web framework
- Apache ECharts - Enterprise visualization library
- D3.js - Custom energy visualizations
- TypeScript - Type-safe development

**Backend**
- Python FastAPI - High-performance REST API
- SQLAlchemy - ORM for database operations
- SQLite - Embedded database (MVP)

**Database** (Dual Architecture)
- **SQLite** - Transactional data (OLTP) - writes, updates, deletes
- No data duplication - DuckDB reads directly from SQLite!
- Optional: PostgreSQL + TimescaleDB for production scaling

### Modules

1. **Dashboard** ✅ - Real-time overview of all systems (WORKING!)
2. **Bills Management** 🔨 - Utility bill tracking and analysis
3. **Utility Analytics** 🔨 - Energy, water, gas consumption analysis
4. **Building Analytics** 🔨 - Building-level performance metrics
5. **Financial Performance** 🔨 - Cost analysis and budgeting
6. **Facility Management** 🔨 - Site and facility tracking
7. **Plant Management** 🔨 - Equipment and plant operations
8. **Organizations** 🔨 - Multi-tenant organization management
9. **Account Management** 🔨 - User authentication and permissions
10. **Data Historian** 🔨 - Time-series data storage and retrieval
11. **Performance Improvement** 🔨 - ISO 50001 EnPI tracking and action plans

**Legend:** ✅ Working | 🔨 Coming Soon

## ISO 50001 Compliance

This system implements:
- Energy Performance Indicators (EnPIs)
- Energy baselines and targets
- Monitoring and measurement plans
- Energy reviews and audits
- Action plan tracking
- Management review reporting

📖 **Full guide:** [docs/ISO50001_COMPLIANCE.md](docs/ISO50001_COMPLIANCE.md)

## APPA Best Practices

Following American Public Power Association standards for:
- Utility accounting and finance
- Energy efficiency programs
- Asset management
- Operational excellence

## Current Status: MVP (Minimum Viable Product)

**✅ What's Working:**
- Complete Dashboard with sample data
- Real-time energy KPIs
- Interactive charts (ECharts)
- ISO 50001 EnPI metrics
- Building performance rankings
- SQLite database
- REST API with FastAPI
- Full documentation

**🔨 Coming Next:**
- Bills Management module
- Real data import
- Additional analytics modules
- User authentication
- Advanced features (DuckDB analytics when Python 3.13 wheels available)

## Getting Started

### Option 1: GitHub Codespaces (Recommended) ⭐

1. Click the "Open in GitHub Codespaces" badge above
2. Wait 2 minutes for setup
3. Run `./setup-codespaces.sh`
4. Start backend and frontend (see commands above)
5. Open forwarded port 5173

**Benefits:**
- ✅ No installation needed
- ✅ Works in any browser
- ✅ No Windows compatibility issues
- ✅ 60 hours/month free

### Option 2: Docker Compose

```bash
docker-compose up -d
```

Then open: http://localhost:5173

### Option 3: Manual Local Setup

See [SETUP.md](SETUP.md) for detailed instructions.

## Documentation

| Document | Purpose |
|----------|---------|
| [CODESPACES.md](CODESPACES.md) | Run in GitHub Codespaces (easiest!) |
| [MVP_START.md](MVP_START.md) | Local Windows MVP setup |
| [SETUP.md](SETUP.md) | General setup guide |
| [EMERGENCY_START.md](EMERGENCY_START.md) | Troubleshooting local issues |
| [docs/ISO50001_COMPLIANCE.md](docs/ISO50001_COMPLIANCE.md) | ISO 50001 features |
| [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) | System architecture |

## Quick Links

| Service | Local URL | Codespaces |
|---------|-----------|------------|
| Dashboard | http://localhost:5173 | Check Ports tab |
| API Docs | http://localhost:8000/api/docs | Check Ports tab |
| Health Check | http://localhost:8000/health | Check Ports tab |

## Prerequisites (Local Only)

**For Codespaces:** None! Everything is pre-installed.

**For local setup:**
- Node.js 18+
- Python 3.11+ (not 3.13 - has compatibility issues)
- Docker (optional)

## License

MIT License - See [LICENSE](LICENSE) file

---

**Built with Claude Code** 🤖
Generated with [Claude Code](https://claude.com/claude-code)

# PUDS - Professional Utility Data System

An enterprise-grade, open-source utility management system following APPA and ISO 50001 standards.

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
- Pydantic - Data validation

**Database**
- PostgreSQL 15+ - Primary data store
- TimescaleDB - Time-series extension for meter data
- DuckDB - Analytics engine for reporting

### Modules

1. **Dashboard** - Real-time overview of all systems
2. **Bills Management** - Utility bill tracking and analysis
3. **Utility Analytics** - Energy, water, gas consumption analysis
4. **Building Analytics** - Building-level performance metrics
5. **Financial Performance** - Cost analysis and budgeting
6. **Facility Management** - Site and facility tracking
7. **Plant Management** - Equipment and plant operations
8. **Organizations** - Multi-tenant organization management
9. **Account Management** - User authentication and permissions
10. **Data Historian** - Time-series data storage and retrieval
11. **Performance Improvement** - ISO 50001 EnPI tracking and action plans

## ISO 50001 Compliance

This system implements:
- Energy Performance Indicators (EnPIs)
- Energy baselines and targets
- Monitoring and measurement plans
- Energy reviews and audits
- Action plan tracking
- Management review reporting

## APPA Best Practices

Following American Public Power Association standards for:
- Utility accounting and finance
- Energy efficiency programs
- Asset management
- Operational excellence

## Getting Started

### Prerequisites
- Node.js 18+
- Python 3.11+
- PostgreSQL 15+
- Docker (recommended)

### Installation

```bash
# Install frontend dependencies
cd frontend
npm install

# Install backend dependencies
cd ../backend
pip install -r requirements.txt

# Set up database
docker-compose up -d postgres
python scripts/init_db.py

# Run development servers
# Terminal 1 - Frontend
cd frontend && npm run dev

# Terminal 2 - Backend
cd backend && uvicorn main:app --reload
```

## License

MIT License - See LICENSE file for details

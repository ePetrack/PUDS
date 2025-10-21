# PUDS Setup Guide

Complete installation and setup instructions for the Professional Utility Data System.

## Prerequisites

Before you begin, ensure you have the following installed:

- **Docker & Docker Compose** (recommended) OR
- **Node.js 18+** (for frontend)
- **Python 3.11+** (for backend)
- **PostgreSQL 15+** with TimescaleDB extension

## Quick Start with Docker (Recommended)

The fastest way to get PUDS running is with Docker Compose:

```bash
# Clone the repository
git clone <repository-url>
cd PUDS

# Start all services
docker-compose up -d

# Check service status
docker-compose ps
```

The application will be available at:
- **Frontend**: http://localhost:5173
- **Backend API**: http://localhost:8000
- **API Documentation**: http://localhost:8000/api/docs

## Manual Setup

If you prefer to run services individually without Docker:

### 1. Database Setup

#### Install PostgreSQL with TimescaleDB

**macOS (Homebrew):**
```bash
brew install postgresql@15
brew install timescaledb

# Initialize TimescaleDB
timescaledb-tune --quiet --yes
```

**Ubuntu/Debian:**
```bash
sudo apt-get install postgresql-15 postgresql-server-dev-15

# Add TimescaleDB repository
echo "deb https://packagecloud.io/timescale/timescaledb/ubuntu/ $(lsb_release -c -s) main" | sudo tee /etc/apt/sources.list.d/timescaledb.list
wget --quiet -O - https://packagecloud.io/timescale/timescaledb/gpgkey | sudo apt-key add -
sudo apt-get update
sudo apt-get install timescaledb-2-postgresql-15
```

#### Create Database

```bash
# Create user and database
sudo -u postgres psql

postgres=# CREATE USER puds_user WITH PASSWORD 'your_secure_password';
postgres=# CREATE DATABASE puds OWNER puds_user;
postgres=# \c puds
puds=# CREATE EXTENSION timescaledb;
puds=# \q
```

### 2. Backend Setup

```bash
cd backend

# Create virtual environment
python3 -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Create .env file
cp .env.example .env

# Edit .env with your database credentials
# DATABASE_URL=postgresql+asyncpg://puds_user:your_secure_password@localhost:5432/puds

# Run database migrations
# (Tables will be created automatically on first run)

# Start the backend server
uvicorn main:app --reload
```

The API will be available at http://localhost:8000

### 3. Frontend Setup

```bash
cd frontend

# Install dependencies
npm install

# Start development server
npm run dev
```

The frontend will be available at http://localhost:5173

## Configuration

### Environment Variables

#### Backend (.env)

```env
# Application
ENV=development
DEBUG=true

# Database
DATABASE_URL=postgresql+asyncpg://puds_user:password@localhost:5432/puds

# Security
SECRET_KEY=your-secret-key-here-change-in-production
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=30

# CORS
CORS_ORIGINS=http://localhost:5173,http://localhost:3000

# ISO 50001 Settings
ENERGY_BASELINE_PERIOD_MONTHS=12
ENPI_CALCULATION_FREQUENCY=monthly
```

### Database Optimization

For optimal TimescaleDB performance:

```sql
-- Connect to database
\c puds

-- Create hypertable (if not already created)
SELECT create_hypertable('meter_readings', 'timestamp',
    chunk_time_interval => INTERVAL '1 week');

-- Enable compression
ALTER TABLE meter_readings SET (
    timescaledb.compress,
    timescaledb.compress_segmentby = 'meter_id'
);

-- Add compression policy
SELECT add_compression_policy('meter_readings', INTERVAL '30 days');

-- Add retention policy (optional - keeps data for 5 years)
SELECT add_retention_policy('meter_readings', INTERVAL '5 years');
```

## Verification

### Check Backend

```bash
curl http://localhost:8000/health
# Should return: {"status":"healthy","service":"PUDS Backend","version":"0.1.0"}

curl http://localhost:8000/api/dashboard/overview
# Should return dashboard data
```

### Check Frontend

Open http://localhost:5173 in your browser. You should see the PUDS Dashboard with sample data.

## Troubleshooting

### Database Connection Issues

**Error: `asyncpg.exceptions.InvalidPasswordError`**
- Verify your database credentials in `.env`
- Ensure PostgreSQL is running: `sudo systemctl status postgresql`

**Error: `Extension "timescaledb" not found`**
- Install TimescaleDB extension
- Run: `CREATE EXTENSION timescaledb;` in your database

### Port Already in Use

**Backend (port 8000):**
```bash
# Find process using port 8000
lsof -i :8000
# Kill the process
kill -9 <PID>
```

**Frontend (port 5173):**
```bash
# Find process using port 5173
lsof -i :5173
# Kill the process
kill -9 <PID>
```

### Docker Issues

**Containers won't start:**
```bash
# Check logs
docker-compose logs backend
docker-compose logs frontend
docker-compose logs postgres

# Rebuild containers
docker-compose down
docker-compose build --no-cache
docker-compose up -d
```

## Next Steps

1. **Import Real Data**: Replace dummy data with actual utility bills and meter readings
2. **Configure Users**: Set up authentication and user accounts
3. **Add Buildings**: Create your building inventory
4. **Set Baselines**: Establish energy baselines per ISO 50001
5. **Configure Alerts**: Set up monitoring thresholds and notifications

## Development

### Running Tests

```bash
# Backend tests
cd backend
pytest

# Frontend tests
cd frontend
npm test
```

### Code Quality

```bash
# Backend
cd backend
black .  # Format code
flake8 .  # Lint

# Frontend
cd frontend
npm run check  # Type checking
npm run lint  # ESLint
```

## Production Deployment

For production deployment, see `DEPLOYMENT.md` for:
- Security hardening
- SSL/TLS configuration
- Performance optimization
- Backup strategies
- High availability setup

## Support

- Documentation: See `README.md` and `/docs`
- Issues: Submit issues on GitHub
- ISO 50001 Compliance: See `docs/ISO50001_COMPLIANCE.md`

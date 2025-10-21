# PUDS Architecture Documentation

## System Overview

PUDS (Professional Utility Data System) is a modern, microservices-based utility management platform built with enterprise scalability and ISO 50001 compliance in mind.

```
┌─────────────────────────────────────────────────────────────┐
│                        Frontend Layer                        │
│  ┌───────────────────────────────────────────────────────┐  │
│  │  SvelteKit Application (Port 5173)                    │  │
│  │  - Dashboard, Analytics, Management Modules            │  │
│  │  - ECharts & D3.js Visualizations                     │  │
│  │  - Responsive UI Components                           │  │
│  └───────────────────────────────────────────────────────┘  │
└──────────────────────────┬──────────────────────────────────┘
                           │ HTTP/REST
                           │
┌──────────────────────────▼──────────────────────────────────┐
│                      Backend Layer                           │
│  ┌───────────────────────────────────────────────────────┐  │
│  │  FastAPI Application (Port 8000)                      │  │
│  │  - REST API Endpoints                                 │  │
│  │  - Business Logic & ISO 50001 Calculations            │  │
│  │  - Data Validation & Processing                       │  │
│  │  - Authentication & Authorization                     │  │
│  └───────────────────────────────────────────────────────┘  │
└──────────────────────────┬──────────────────────────────────┘
                           │ SQLAlchemy ORM
                           │
┌──────────────────────────▼──────────────────────────────────┐
│                       Data Layer                             │
│  ┌────────────────────────┐  ┌──────────────────────────┐  │
│  │  PostgreSQL 15         │  │  DuckDB                  │  │
│  │  + TimescaleDB         │  │  Analytics Engine        │  │
│  │  (Port 5432)           │  │  (Embedded)              │  │
│  │                        │  │                          │  │
│  │  - Transactional Data  │  │  - Heavy Aggregations    │  │
│  │  - User Data           │  │  - Report Generation     │  │
│  │  - Time-series Meters  │  │  - Complex Queries       │  │
│  └────────────────────────┘  └──────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

## Technology Stack

### Frontend

**Framework: SvelteKit**
- **Why**: Lightweight, excellent performance, minimal boilerplate
- **Version**: 2.x
- **Key Features**:
  - Server-side rendering (SSR)
  - File-based routing
  - Built-in API routes
  - TypeScript support

**Visualization Libraries**:
1. **Apache ECharts 5.4+**
   - Primary charting library
   - Enterprise-grade performance
   - Extensive chart types
   - Mobile responsive

2. **D3.js 7.8+**
   - Custom energy flow diagrams
   - Sankey diagrams
   - Network graphs
   - Advanced data transformations

**State Management**:
- Svelte stores for global state
- @tanstack/svelte-query for server state
- Local component state where appropriate

### Backend

**Framework: FastAPI**
- **Why**: High performance, automatic API docs, async support, Python ecosystem
- **Version**: 0.109+
- **Key Features**:
  - Automatic OpenAPI/Swagger documentation
  - Type safety with Pydantic
  - Async/await support
  - Dependency injection

**ORM: SQLAlchemy 2.0**
- Async engine support
- Declarative models
- Migration support with Alembic

**Key Libraries**:
```python
pandas      # Data manipulation and analysis
numpy       # Numerical computations
duckdb      # Embedded analytics database
pydantic    # Data validation
python-jose # JWT tokens
passlib     # Password hashing
```

### Database

#### Primary: PostgreSQL 15 + TimescaleDB

**PostgreSQL**:
- Industry-standard RDBMS
- ACID compliance
- Rich ecosystem
- JSON support for flexible schemas

**TimescaleDB Extension**:
- Optimized for time-series data
- Automatic data partitioning (chunks)
- Data compression
- Continuous aggregates
- Retention policies

**Key Tables**:
- `organizations` - Multi-tenant org data
- `users` - User accounts
- `buildings` - Facility inventory
- `utilities` - Utility accounts
- `utility_bills` - Monthly bill data
- `meters` - Meter registry
- `meter_readings` - Time-series data (hypertable)

#### Analytics: DuckDB

**Purpose**:
- Heavy analytical queries
- Report generation
- Data exports
- OLAP workloads

**Integration**:
- Reads from PostgreSQL via foreign data wrapper
- In-memory processing for speed
- Columnar storage for analytics

## Module Architecture

### 1. Dashboard Module

**Purpose**: Real-time overview and KPI monitoring

**Components**:
- KPI Cards (4 primary metrics)
- Energy Trend Chart (ECharts line chart)
- Utility Distribution (ECharts pie chart)
- EnPI Metrics (gauge charts)
- Building Performance (tables/rankings)
- Alerts List

**Data Flow**:
```
User → Dashboard Page → API Call → FastAPI Endpoint →
Database Query → Data Processing → JSON Response →
Chart Rendering
```

**API Endpoints**:
- `GET /api/dashboard/overview` - Main KPIs
- `GET /api/dashboard/energy-trends` - Time-series data
- `GET /api/dashboard/utility-costs` - Cost breakdown
- `GET /api/dashboard/enpi-metrics` - ISO 50001 metrics

### 2. Bills Management Module

**Purpose**: Utility bill tracking and analysis

**Features**:
- Bill upload (manual entry, CSV import)
- Bill validation and verification
- Historical bill comparison
- Cost allocation by building
- Anomaly detection

**Workflow**:
```
Bill Upload → Validation → Parsing → Database Storage →
Calculation of Metrics → Dashboard Update
```

### 3. Utility Analytics Module

**Purpose**: Deep dive into energy consumption patterns

**Features**:
- Consumption trends over time
- Weather normalization
- Peak demand analysis
- Load profiling
- Utility cost forecasting

**Analysis Types**:
- Time-series decomposition
- Regression analysis
- Clustering (building segmentation)
- Anomaly detection

### 4. Building Analytics Module

**Purpose**: Building-level performance tracking

**Features**:
- Energy Use Intensity (EUI) by building
- Building comparisons
- Space utilization vs energy use
- Building benchmarking
- Equipment-level metering

### 5. Financial Performance Module

**Purpose**: Cost management and budgeting

**Features**:
- Budget vs actual tracking
- Cost allocation
- Rate tariff management
- ROI calculations for projects
- Financial forecasting

### 6-11. Additional Modules

See module-specific documentation for:
- Facility Management
- Plant Management
- Organizations
- Account Management
- Data Historian
- Performance Improvement

## Data Models

### Entity Relationship Diagram

```
┌─────────────────┐
│  Organization   │
└────────┬────────┘
         │ 1:N
         │
    ┌────┴──────────────────┬────────────────┐
    │                       │                │
    ▼                       ▼                ▼
┌────────┐           ┌──────────┐      ┌─────────┐
│ User   │           │ Building │      │ Utility │
└────────┘           └─────┬────┘      └────┬────┘
                           │ 1:N            │ 1:N
                           │                │
                           ▼                ▼
                     ┌──────────┐    ┌──────────────┐
                     │  Meter   │    │ UtilityBill  │
                     └─────┬────┘    └──────────────┘
                           │ 1:N
                           │
                           ▼
                   ┌─────────────────┐
                   │  MeterReading   │
                   │  (Hypertable)   │
                   └─────────────────┘
```

### Key Relationships

- **Organization** → Buildings (1:N)
- **Organization** → Users (1:N)
- **Organization** → Utilities (1:N)
- **Building** → Meters (1:N)
- **Meter** → MeterReadings (1:N, time-series)
- **Utility** → UtilityBills (1:N)

## API Design

### RESTful Principles

**Resource-based URLs**:
```
GET    /api/buildings          # List all buildings
GET    /api/buildings/{id}     # Get specific building
POST   /api/buildings          # Create building
PUT    /api/buildings/{id}     # Update building
DELETE /api/buildings/{id}     # Delete building
```

**Standard Response Format**:
```json
{
  "status": "success",
  "data": { ... },
  "meta": {
    "timestamp": "2024-10-21T12:00:00Z",
    "version": "0.1.0"
  }
}
```

**Error Format**:
```json
{
  "status": "error",
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid input data",
    "details": { ... }
  }
}
```

### Authentication

**JWT-based Authentication**:
```
POST /api/auth/login
  → Returns: { "access_token": "...", "token_type": "bearer" }

GET /api/protected-route
  Headers: { "Authorization": "Bearer <token>" }
```

### API Versioning

- URL versioning: `/api/v1/...`, `/api/v2/...`
- Current version: v1 (implicit in `/api/...`)

## Security

### Authentication & Authorization

**Technologies**:
- JWT tokens for stateless authentication
- Bcrypt for password hashing
- Role-based access control (RBAC)

**Security Measures**:
- Password complexity requirements
- Token expiration (30 minutes default)
- Refresh token rotation
- Rate limiting on endpoints
- CORS configuration
- SQL injection prevention (parameterized queries)
- XSS protection

### Data Privacy

- Multi-tenant data isolation at database level
- Organization-scoped queries
- Audit logging for data access
- GDPR compliance features (data export, deletion)

## Performance Optimization

### Database Level

**TimescaleDB Optimizations**:
- Hypertables for time-series data
- Chunk-based partitioning (1-week chunks)
- Compression for old data (>30 days)
- Continuous aggregates for common queries
- Retention policies

**Indexes**:
- B-tree indexes on foreign keys
- Composite indexes for common query patterns
- GiST indexes for time-range queries
- Partial indexes for filtered queries

### Application Level

**Caching Strategy**:
- Response caching for dashboard KPIs (5-minute TTL)
- Query result caching
- Static asset caching
- CDN for frontend assets

**Database Connection Pooling**:
- Pool size: 10 connections
- Max overflow: 20 connections
- Connection recycling

### Frontend Performance

**Code Splitting**:
- Route-based code splitting
- Dynamic imports for charts
- Lazy loading of components

**Asset Optimization**:
- Minification and bundling
- Image optimization
- Tree shaking
- Gzip compression

## Scalability

### Horizontal Scaling

**Stateless Design**:
- No server-side sessions
- JWT for authentication
- All state in database or client

**Load Balancing**:
- Multiple FastAPI instances behind load balancer
- Database read replicas for queries
- Write operations to primary database

### Vertical Scaling

**Database Scaling**:
- Increase PostgreSQL resources
- Tune shared_buffers, work_mem
- Optimize query performance

**Application Scaling**:
- Increase worker processes
- Tune async worker count
- Optimize memory usage

## Monitoring & Observability

### Logging

**Structured Logging**:
```python
{
  "timestamp": "2024-10-21T12:00:00Z",
  "level": "INFO",
  "service": "puds-backend",
  "message": "Dashboard data requested",
  "user_id": 123,
  "request_id": "abc-123",
  "duration_ms": 45
}
```

**Log Levels**:
- ERROR: Application errors
- WARNING: Anomalies, deprecated usage
- INFO: Important events
- DEBUG: Detailed information

### Metrics

**Key Metrics to Track**:
- Request rate (req/sec)
- Response time (p50, p95, p99)
- Error rate
- Database query time
- Active users
- Data ingestion rate

**Tools**:
- Prometheus for metrics collection
- Grafana for visualization
- Custom dashboards for energy metrics

### Health Checks

**Endpoints**:
- `/health` - Basic health check
- `/health/db` - Database connectivity
- `/health/ready` - Application ready to serve traffic

## Deployment

### Container Strategy

**Docker Images**:
- `puds-frontend`: SvelteKit application
- `puds-backend`: FastAPI application
- `puds-postgres`: PostgreSQL + TimescaleDB

**Orchestration**:
- Docker Compose for development
- Kubernetes for production (optional)

### CI/CD Pipeline

**Stages**:
1. Code checkout
2. Linting and formatting
3. Unit tests
4. Integration tests
5. Build Docker images
6. Push to registry
7. Deploy to staging
8. Deploy to production (manual approval)

### Environment Strategy

- **Development**: Local Docker Compose
- **Staging**: Cloud environment mirroring production
- **Production**: High-availability cloud deployment

## Future Enhancements

### Phase 2 Features

- Machine learning for consumption forecasting
- Automated anomaly detection
- Mobile applications (iOS/Android)
- Advanced data analytics with AI
- Integration with building automation systems
- ENERGY STAR Portfolio Manager sync

### Scalability Improvements

- Microservices architecture
- Event-driven architecture with message queues
- Caching layer (Redis)
- Search engine integration (Elasticsearch)
- GraphQL API option

### Data Science Integration

- Predictive modeling for energy consumption
- Equipment failure prediction
- Optimal control recommendations
- Automated report generation with NLP

## Development Guidelines

### Code Style

**Backend (Python)**:
- Follow PEP 8
- Use Black for formatting
- Use type hints
- Maximum line length: 100 characters

**Frontend (TypeScript)**:
- Follow Airbnb style guide
- Use Prettier for formatting
- Strict TypeScript mode
- Component naming: PascalCase

### Git Workflow

**Branch Strategy**:
- `main` - Production-ready code
- `develop` - Integration branch
- `feature/*` - Feature branches
- `bugfix/*` - Bug fix branches
- `hotfix/*` - Production hotfixes

**Commit Messages**:
```
<type>(<scope>): <subject>

<body>

<footer>
```

Types: feat, fix, docs, style, refactor, test, chore

### Testing

**Backend Testing**:
- Unit tests with pytest
- Integration tests for API endpoints
- Database tests with test fixtures
- Target coverage: >80%

**Frontend Testing**:
- Component tests with Svelte Testing Library
- E2E tests with Playwright
- Visual regression tests

## Contributing

See `CONTRIBUTING.md` for detailed guidelines on:
- Setting up development environment
- Code review process
- Documentation requirements
- Release process

## License

MIT License - See LICENSE file

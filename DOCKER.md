# Docker Deployment

## Quick Start

Run the Awana Club Management System with one command:

```bash
docker run -d --name awana-club -p 8080:8080 \
  -v ./awana_storage:/app/storage \
  -v ./awana_data:/app/data \
  ghcr.io/joshjetson/awana:latest
```

The application will be available at http://localhost:8080

## Manual Build from GitHub

```bash
# Build from GitHub repo
docker build -t awana-app https://github.com/joshjetson/awana.git

# Run the application
docker run -d --name awana-club -p 8080:8080 \
  -v ./awana_storage:/app/storage \
  -v ./awana_data:/app/data \
  awana-app
```

## Build Locally

```bash
# Clone the repo
git clone https://github.com/joshjetson/awana.git
cd awana

# Build the Docker image
docker build -t awana-app .

# Run the container
docker run -p 8080:8080 awana-app
```

## Environment Variables

- `JAVA_OPTS`: JVM options (default: "-Xmx512m -Xms256m")
- `GRAILS_ENV`: Environment (default: "production")
- `DATABASE_URL`: PostgreSQL connection URL (e.g., "jdbc:postgresql://postgres:5432/awana_db")
- `DATABASE_USERNAME`: PostgreSQL username (e.g., "awana_user")
- `DATABASE_PASSWORD`: PostgreSQL password

**Note:** Without PostgreSQL environment variables, the application will use H2 in-memory database and data will be lost on restart.

## Data Persistence

To persist data between container restarts:

```bash
docker run -p 8080:8080 -v awana-data:/app/data awana-app
```

## Health Check

The container includes a health check that monitors the application:

```bash
docker ps  # Shows health status
```

## Production Deployment with PostgreSQL

For production deployment with persistent database:

### Option 1: PostgreSQL + Application Containers

```bash
# 1. Start PostgreSQL first
docker run -d --name awana-postgres \
    -e POSTGRES_DB=awana_db \
    -e POSTGRES_USER=awana_user \
    -e POSTGRES_PASSWORD=your_production_password_here \
    -v postgres_data:/var/lib/postgresql/data \
    -p 5432:5432 \
    postgres:15-alpine

# 2. Then start your app (linking to postgres container)
docker run -d --name awana-club -p 8083:8080 \
    --link awana-postgres:postgres \
    -v ./awana_storage:/app/storage \
    -v ./awana_data:/app/data \
    -e GRAILS_ENV=production \
    -e DATABASE_URL="jdbc:postgresql://postgres:5432/awana_db" \
    -e DATABASE_USERNAME="awana_user" \
    -e DATABASE_PASSWORD="your_production_password_here" \
    ghcr.io/joshjetson/awana:latest
```

### Option 2: Docker Compose (Alternative)

```yaml
version: '3.8'
services:
  postgres:
    image: postgres:15-alpine
    environment:
      POSTGRES_DB: awana_db
      POSTGRES_USER: awana_user
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
    volumes:
      - postgres_data:/var/lib/postgresql/data
    ports:
      - "5432:5432"

  awana:
    image: ghcr.io/joshjetson/awana:latest
    depends_on:
      - postgres
    ports:
      - "8083:8080"
    volumes:
      - ./awana_storage:/app/storage
      - ./awana_data:/app/data
    environment:
      - GRAILS_ENV=production
      - DATABASE_URL=jdbc:postgresql://postgres:5432/awana_db
      - DATABASE_USERNAME=awana_user
      - DATABASE_PASSWORD=${POSTGRES_PASSWORD}

volumes:
  postgres_data:
```

Save as `docker-compose.yml` and run:

```bash
docker-compose up -d
```

### Database Schema Management

**Important:** The application is currently configured with `dbCreate: create-drop` which recreates the database schema on each startup. For production:

1. **First deployment:** Use `dbCreate: create-drop` to create initial schema
2. **Subsequent deployments:** Change to `dbCreate: update` in `application.yml` to preserve data

### Deployment Updates

For CI/CD deployments:

```bash
# Stop current container
docker stop awana-club && docker rm awana-club

# Pull latest image
docker pull ghcr.io/joshjetson/awana:latest

# Restart with same command (PostgreSQL container stays running)
docker run -d --name awana-club -p 8083:8080 \
    --link awana-postgres:postgres \
    -v ./awana_storage:/app/storage \
    -v ./awana_data:/app/data \
    -e GRAILS_ENV=production \
    -e DATABASE_URL="jdbc:postgresql://postgres:5432/awana_db" \
    -e DATABASE_USERNAME="awana_user" \
    -e DATABASE_PASSWORD="your_production_password_here" \
    ghcr.io/joshjetson/awana:latest
```
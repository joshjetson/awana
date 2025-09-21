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

## Production Deployment

For production, consider using docker-compose:

```yaml
version: '3.8'
services:
  awana:
    build: https://github.com/joshjetson/awana.git
    ports:
      - "8080:8080"
    volumes:
      - awana-data:/app/data
    environment:
      - JAVA_OPTS=-Xmx1g -Xms512m
    restart: unless-stopped

volumes:
  awana-data:
```

Save as `docker-compose.yml` and run:

```bash
docker-compose up -d
```
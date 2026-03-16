# Daily Challenge

A daily programming challenge platform where users solve trivia questions and predict code output. Built with a Rust backend and React frontend, deployed as a single static binary from a scratch Docker image.

## Features

- **Trivia challenges** -- daily programming knowledge questions with multiple attempts and hints
- **Code output challenges** -- read a code snippet and predict what it prints
- **Streak tracking** -- current and longest streaks calculated per game
- **Leaderboard** -- ranked by streak and total solves
- **Challenge archive** -- browse and attempt past challenges
- **Auth** -- registration, login, JWT access tokens with refresh token rotation, password reset flow

## Tech stack

**Backend** -- Rust (Axum, SQLx, Argon2, jsonwebtoken, tower-governor)

- Workspace with four crates: `api`, `db`, `auth`, `shared`
- Compile-time checked SQL queries via SQLx
- Per-IP rate limiting (global + stricter on auth endpoints)
- Security headers (CSP, HSTS, X-Frame-Options, etc.)
- Structured JSON logging for production, pretty output for local dev

**Frontend** -- React 19, TypeScript, Vite, Tailwind CSS, shadcn/ui, React Router

**Database** -- PostgreSQL

**Deployment** -- Multi-stage Dockerfile producing a `scratch`-based image with a static musl binary, bundled frontend assets, and zero runtime dependencies.

## Getting started

### Prerequisites

- Rust (stable)
- Node.js 22+
- PostgreSQL 18 (or use the provided Docker Compose)
- [SQLx CLI](https://github.com/launchbadge/sqlx/blob/main/sqlx-cli/README.md) (`cargo install sqlx-cli`)

### Setup

```bash
# Clone and enter the project
git clone <repo-url>
cd daily-challenge

# Start PostgreSQL
docker compose up -d

# Configure environment
cp .env.example .env
# Edit .env with your database credentials and JWT secret

# Run migrations
sqlx migrate run

# Seed sample challenges
./scripts/seed.sh
```

### Development

Run the backend and frontend in separate terminals:

```bash
# Backend (watches for changes with cargo-watch if installed)
cargo run -p api

# Frontend
cd frontend
npm install
npm run dev
```

The API serves on `http://localhost:8080` and the frontend dev server on `http://localhost:3000`.

### Production build

```bash
docker build -t daily-challenge .
docker run -p 8080:8080 --env-file .env daily-challenge
```

The final image is built from `scratch` -- it contains only the static binary, frontend assets, CA certificates, and migrations. Runs as a non-root user.

## Project structure

```
crates/
  api/       HTTP server, handlers, middleware, routes
  auth/      JWT, Argon2 password hashing, refresh tokens
  db/        Connection pool, models, query functions
  shared/    AppError, Config
frontend/    React SPA
migrations/  SQL migration files
scripts/     Database seed and reset helpers
```

## License

[MIT](LICENSE)

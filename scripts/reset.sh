#!/bin/bash

echo "Dropping and recreating schema..."
docker compose exec -T db psql -U user -d daily_challenge -c "DROP SCHEMA public CASCADE; CREATE SCHEMA public;"
echo "Running migrations..."
sqlx migrate run
echo "Seeding database..."
cat scripts/seed.sql | docker compose exec -T db psql -U user -d daily_challenge
echo "Done. Fresh database ready."
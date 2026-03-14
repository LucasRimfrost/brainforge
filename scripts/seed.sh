#!/bin/bash

cat scripts/seed.sql | docker compose exec -T db psql -U user -d daily_challenge
echo "Database seeded successfully."
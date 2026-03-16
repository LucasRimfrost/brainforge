#!/bin/bash
cat scripts/seed_trivia.sql | docker compose exec -T db psql -U user -d brainforge
cat scripts/seed_code_output.sql | docker compose exec -T db psql -U user -d brainforge
echo "Database seeded successfully."
#!/bin/bash

# Start services
docker-compose -f docker-compose.render-test.yml up -d

# Wait for services
echo "Waiting for PostgreSQL to be ready..."
while ! docker-compose -f docker-compose.render-test.yml exec postgres pg_isready -U postgres; do
  sleep 2
done

echo "Waiting for pgAdmin to be ready..."
while ! curl -s http://localhost:5050 >/dev/null; do
  sleep 2
done

# Run application with local profile
./gradlew bootRun --args='--spring.profiles.active=local'

# Cleanup (manual after CTRL+C)
# docker-compose -f docker-compose.render-test.yml down
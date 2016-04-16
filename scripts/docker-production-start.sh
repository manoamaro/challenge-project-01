#!/bin/bash

# Simple script to run the docker containers. This could be done with docker-compose,
# but the docker-compose is not yet recommended for production environments.

# Runs the postgresql database
docker run --name helpjuice-challenge-db -d postgres
# Runs the redis database
docker run --name helpjuice-challenge-redis -d redis
# Runs the NGINX database
docker run --name helpjuice-challenge-nginx-proxy -v /var/run/docker.sock:/tmp/docker.sock -p 80:80 -d jwilder/nginx-proxy

# Build the app image.
# The image is the same for the Web server and the Sidekiq worker
docker build -t helpjuice-challenge-app -f Dockerfile.production .

# Run the Sidekiq worker.
# If you want to scale and run more workers,
# just execute the same command, changing the name
docker run -d --name helpjuice-challenge_sidekiq_1 \
  --link helpjuice-challenge-db \
  --link helpjuice-challenge-redis \
  -e "SECRET_KEY_BASE=secret-key-base" \
  -e "RAILS_ENV=production" \
  -e "REDIS_URL=redis://helpjuice-challenge-redis:6379" \
  -e "DATABASE_URL=postgresql://helpjuice-challenge-db/postgres?user=postgres&password=postgres" \
  helpjuice-challenge-app \
  bundle exec sidekiq -C config/sidekiq.yml -e production

  # Run the Sidekiq worker.
  # If you want to scale and run more workers,
  # just execute the same command, changing the name
docker run -d --name helpjuice-challenge_web_1 \
  --link helpjuice-challenge-db \
  --link helpjuice-challenge-redis \
  -e "VIRTUAL_HOST=~." \
  -e "VIRTUAL_PORT=3000" \
  -e "SECRET_KEY_BASE=secret-key-base" \
  -e "RAILS_ENV=production" \
  -e "REDIS_URL=redis://helpjuice-challenge-redis:6379" \
  -e "DATABASE_URL=postgresql://helpjuice-challenge-db/postgres?user=postgres&password=postgres" \
  -e "RAILS_SERVE_STATIC_FILES=1" \
  helpjuice-challenge-app \
  bundle exec puma -C config/puma.rb -e production

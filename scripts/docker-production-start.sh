#!/bin/bash

docker run --name helpjuice-challenge-db -d postgres
docker run --name helpjuice-challenge-redis -d redis
docker run --name helpjuice-challenge-nginx-proxy -v /var/run/docker.sock:/tmp/docker.sock -p 80:80 -d jwilder/nginx-proxy

docker build -t helpjuice-challenge-app .

docker run -d --name helpjuice-challenge_sidekiq_1 \
  --link helpjuice-challenge-db \
  --link helpjuice-challenge-redis \
  -e "SECRET_KEY_BASE=secret-key-base" \
  -e "RAILS_ENV=production" \
  -e "REDIS_URL=redis://helpjuice-challenge-redis:6379" \
  -e "DATABASE_URL=postgresql://helpjuice-challenge-db/postgres?user=postgres&password=postgres" \
  helpjuice-challenge-app \
  bundle exec sidekiq -C config/sidekiq.yml -e production

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

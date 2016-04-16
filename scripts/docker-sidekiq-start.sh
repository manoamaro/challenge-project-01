#!/bin/bash

# Init script for the development env with docker-compose. It checks and install the
# dependencies inside a data volume container.

bundle check || bundle install
bundle exec sidekiq -C config/sidekiq.yml

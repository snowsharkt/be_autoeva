#!/bin/bash
set -e

rm -f /app/tmp/pids/server.pid

until mysql -h $DATABASE_HOST -u $DATABASE_USERNAME -p$DATABASE_PASSWORD -e "SELECT 1"; do
  echo "Waiting for MySQL to be ready..."
  sleep 2
done

bundle check || bundle install

bundle exec rails db:prepare

if [ "$RAILS_ENV" = "production" ]; then
  echo "Clearing cache..."
  rm -rf public/assets tmp/cache
  echo "Precompiling assets..."
  bundle exec rails assets:precompile
fi

exec "$@"

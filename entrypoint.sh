#!/bin/bash
set -e

rm -f /app/tmp/pids/server.pid

until mysql -h $DATABASE_HOST -u $DATABASE_USERNAME -p$DATABASE_PASSWORD -e "SELECT 1"; do
  echo "Waiting for MySQL to be ready..."
  sleep 2
done

bundle check || bundle install

if [ "$RAILS_ENV" = "development" ]; then
  bundle exec rails db:prepare
fi

if [ "$RAILS_ENV" = "production" ]; then
  echo "migrate db"
  bundle exec rails db:migrate
  echo "Clearing cache..."
  rm -rf public/assets tmp/cache
  echo "Precompiling assets..."
  bundle exec rails assets:precompile
fi

exec "$@"

#!/bin/sh
set -e

echo "==> Installing gems..."
bundle install

echo "==> Configuring git hooks..."
git config core.hooksPath .githooks

echo "==> Initialising PostgreSQL..."
pg-setup

echo "==> Setting up database..."
PGDATA="$(pwd)/pgdata" rails db:create db:migrate db:seed

echo "==> Done. Run 'bin/dev' to start the app."

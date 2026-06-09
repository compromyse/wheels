# Dev Environment

Nix flakes — always pre-configured when Claude runs here. No need to run `direnv allow` or `nix develop`.

## PostgreSQL

Runs locally inside the project at `pgdata/`. Connect via Unix socket, not TCP. Always set `PGDATA=$(pwd)/pgdata` when running Rails commands outside the `dev` wrapper.

```
pg-setup   # initialise pgdata/ (first time only)
pg-start   # start postgres
pg-stop    # stop postgres
dev        # pg-start + tmux session "wheels" + pg-stop on exit
```

## Starting the app

```bash
bin/dev    # Rails server + Tailwind watcher via foreman
```

## Common commands

```bash
PGDATA=$(pwd)/pgdata rails db:migrate
PGDATA=$(pwd)/pgdata rails db:seed
PGDATA=$(pwd)/pgdata rails db:migrate:status
PGDATA=$(pwd)/pgdata rails routes
PGDATA=$(pwd)/pgdata rails runner '<ruby>'
bundle exec brakeman
bundle exec rubocop
bundle exec bundler-audit
```

No tests yet. Test database is `wheels` (separate from dev by Rails env).

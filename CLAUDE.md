# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Dev environment

The project uses Nix flakes. The environment is always pre-configured when Claude runs here — no need to run `direnv allow` or `nix develop`.

PostgreSQL runs locally inside the project directory (`pgdata/`). The nix shell exposes these commands:

```
pg-setup   # initialise pgdata/ (first time only)
pg-start   # start postgres
pg-stop    # stop postgres
dev        # pg-start + tmux session named "wheels" + pg-stop on exit
```

`PGDATA` must be set to `$(pwd)/pgdata` when running rails commands outside of the `dev` wrapper. The database config connects via Unix socket at `pgdata/`, not TCP.

Start the app (Rails server + Tailwind watcher):
```
bin/dev
```

## Common commands

```bash
rails db:migrate          # run pending migrations
rails db:seed             # seed superadmin + sample factory + distribution center
rails db:migrate:status   # check migration state
rails routes              # list all routes
rails runner '<ruby>'     # run arbitrary Ruby in app context
bundle exec brakeman      # static security analysis
bundle exec rubocop       # linting
bundle exec bundler-audit # gem vulnerability check
```

There are no tests yet. The test database is `wheels` (same name as dev, separate by Rails env).

## Architecture

### Authentication

Custom session-based auth using `has_secure_password` (bcrypt). No Devise.

- `SessionsController` — login/logout, lives at `/login` and `/logout`
- `ApplicationController` — sets `current_user` from `session[:user_id]`; `require_authentication` is a default `before_action` on all controllers
- `SessionsController` skips `require_authentication` via `skip_before_action`

### Authorization model

A user's access is determined entirely by their location assignments, not a single global role.

```
User
 ├── has_many :user_factories         (join: user_id, factory_id, role)
 ├── has_many :factories, through: :user_factories
 ├── has_many :user_distribution_centers  (join: user_id, distribution_center_id, role)
 ├── has_many :distribution_centers, through: :user_distribution_centers
 └── superadmin: boolean              (controls admin panel access only)
```

`role` on each join record is `"admin"` or `"volunteer"` and is scoped to that specific location. One user can be `admin` at one factory and `volunteer` at a distribution center simultaneously.

`superadmin: true` is the only way to access `/admin`. It is independent of location assignments.

### Access control helpers (ApplicationController)

| Helper | Enforces |
|---|---|
| `require_authentication` | user is logged in |
| `require_superadmin` | `current_user.superadmin?` |
| `require_factory_access(factory)` | user has this factory assigned |
| `require_distribution_center_access(dc)` | user has this dc assigned |

All return `403 Access denied` on failure (plain text for now).

### Post-login routing (HomeController)

`HomeController#index` is the root. Its logic:

1. Superadmin with **no** location assignments → redirect to `/admin`
2. Exactly **one** location total (factory or DC) → redirect directly to that dashboard (no picker)
3. Otherwise → render the home page showing up to three boxes: Factories, Distribution Centers, Admin Panel (if superadmin)

### Admin namespace

All admin controllers inherit from `Admin::BaseController < ApplicationController`, which applies `require_superadmin`. The admin panel manages `Factory`, `DistributionCenter`, and `User` records (index/new/create/destroy only — no edit).

When creating a user in the admin panel, location assignments are submitted as indexed param arrays (`factory_assignments[i][factory_id]`, `[enabled]`, `[role]`). The controller skips rows where `enabled != "1"`.

### Views

All views are HAML. Tailwind CSS v4 is used for styling — compiled by `tailwindcss-rails` to `app/assets/builds/tailwind.css` and referenced in the layout as `stylesheet_link_tag "tailwind"`. The layout (`application.html.haml`) renders the nav bar (name + logout) for any logged-in user and injects flash messages.

Design constraint: the UI targets users aged 25–70 including people uncomfortable with computers. Keep tap targets large, language plain, and interactions minimal.

### Locations

Currently two location types exist:

- **Factory** — one factory currently (`Main Factory`), but the model supports multiple
- **DistributionCenter** — multiple supported from the start

Each type has its own dashboard controller (`FactoriesController#show`, `DistributionCentersController#show`) and its own join table. Adding a new location type requires a new model, join table migration, join model, controller, route, and home-page box.

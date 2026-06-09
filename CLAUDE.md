# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Quick reference

- Dev environment & commands: `docs/dev-environment.md`
- Auth & authorization: `docs/architecture/auth.md`
- Locations & bike requests: `docs/architecture/locations.md`
- Admin panel: `docs/architecture/admin.md`
- Views, design system, partials: `docs/architecture/views.md`
- UI design rules: `DESIGN.md`
- Updating docs: see Documentation section below

## Documentation

When making changes, update the relevant `docs/` file(s) before committing. Keep docs current — stale docs are worse than none.

## Stack

Rails 8.1 · PostgreSQL (local Unix socket at `pgdata/`) · HAML · Tailwind CSS v4 · Pagy · Nix flakes

Always set `PGDATA=$(pwd)/pgdata` when running Rails commands. Run the app with `bin/dev`.

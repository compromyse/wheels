# Views

All views are HAML. Tailwind CSS v4 compiled by `tailwindcss-rails` to `app/assets/builds/tailwind.css`.

The layout (`application.html.haml`) renders the nav bar (app name + current user + logout) for logged-in users and injects flash messages.

## Design

Full design system: `DESIGN.md` at the project root. Summary:

- Target audience: ages 25–70, including people uncomfortable with computers
- Flat, minimal — no shadows, no rounded corners, no colored backgrounds
- Black/white/gray palette only; color only for errors (red) and flash (green/red)
- Minimum font size on interactive elements: `text-lg`
- Borders: `border-2 border-gray-900` as the only visual separator
- One primary action per page

## Shared partials

- `app/views/bike_requests/_list.html.haml` — tab bar + request cards + pagination, used by both Production and Distribution dashboards. Accepts: `active_tab`, `bike_requests`, `pagy`, `production_view` (bool — shows action buttons and hides DC name when true)

## Pagination

Pagy gem. `Pagy::Backend` included in `ApplicationController`, `Pagy::Frontend` in `ApplicationHelper`. Use `pagy(scope, limit: 20)` in controllers. Render with plain prev/next links (not `pagy_nav`).

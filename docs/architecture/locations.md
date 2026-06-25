# Locations

Two location types: **Production** and **Distribution**.

Each type has its own dashboard controller, join table, and join model. Adding a new location type requires: model, migration, join model, join migration, controller, route, and a home-page box.

## Production

- Model: `Production` — `app/models/production.rb`
- Join: `UserProduction` (`user_id`, `production_id`, `role`) — roles defined in `UserProduction::ROLES`
- Controller: `ProductionsController` — actions: `show` (redirects to tickets), `tickets`, `users`
- Routes:
  - `GET /productions/:id` — redirects to tickets
  - `GET /productions/:id/tickets` — bike ticket dashboard
  - `GET /productions/:id/users` — member management (admin only)
- Currently one record (`Main Production`)

## Distribution

- Model: `Distribution` — `app/models/distribution.rb`; has `name` and `address`
- Join: `UserDistribution` (`user_id`, `distribution_id`, `role`) — roles defined in `UserDistribution::ROLES`
- Controller: `DistributionsController` — actions: `show` (redirects to tickets), `tickets`, `users`
- Routes:
  - `GET /distributions/:id` — redirects to tickets
  - `GET /distributions/:id/tickets` — bike ticket dashboard
  - `GET /distributions/:id/users` — member management (admin only)

## Member Management

Both productions and distributions have a `/users` route for managing members. Only location admins (and superadmins) can access it. Members can be searched by name or email (fuzzy, ILIKE), added with a role, have their role changed, or be removed.

Nested routes:
- `POST /productions/:id/user_productions` — add member
- `PATCH /productions/:id/user_productions/:id` — update role
- `DELETE /productions/:id/user_productions/:id` — remove member
- Same pattern for distributions with `user_distributions`

## Bike Requests

Distributions submit bike requests to a production. One request = one person with one or more bikes.

Model: `BikeRequest` — fields: `phone` (10 digits exactly, no formatting), `requestor_name`, `due_date`, `status` (enum)

Each request `has_many :bikes`. `Bike` fields: `name` (optional), `bike_type` (enum: any/male/female/kid, default any), `age`, `height`, `notes` (all optional), `completed` (boolean).

Status flow: `pending (1)` → production approves → `requested (0)` → `completed (2)` → `delivered (3)` → `distributed (4)`. Production can also deny: `pending` → `denied (5)` → distribution edits and resubmits → `pending`.

- New requests default to `pending`; production must approve before they enter the work queue
- Denied cards show a red outline in the distribution's pending tab
- Each bike row has Done/Undo buttons (production view); all bikes completed auto-advances the card to `completed`; uncompleting a bike on a completed card reverts it to `requested`
- Back-transitions allowed at each step (completed ↔ delivered ↔ distributed)

Routes:
- `GET /distributions/:distribution_id/bike_requests/new` — new request form (distribution access)
- `POST /distributions/:distribution_id/bike_requests` — create (distribution access)
- `GET /bike_requests/:id/edit` — edit pending/denied request (distribution access)
- `PATCH /bike_requests/:id` — approve/deny/status update (production) or resubmit (distribution)

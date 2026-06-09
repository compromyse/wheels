# Locations

Two location types: **Production** and **Distribution**.

Each type has its own dashboard controller, join table, and join model. Adding a new location type requires: model, migration, join model, join migration, controller, route, and a home-page box.

## Production

- Model: `Production` — `app/models/production.rb`
- Join: `UserProduction` (`user_id`, `production_id`, `role`)
- Controller: `ProductionsController#show`
- Route: `GET /productions/:id`
- Currently one record (`Main Production`)

## Distribution

- Model: `Distribution` — `app/models/distribution.rb`; has `name` and `address`
- Join: `UserDistribution` (`user_id`, `distribution_id`, `role`)
- Controller: `DistributionsController#show`
- Route: `GET /distributions/:id`

## Bike Requests

Distributions submit bike requests to a production. One request = one person.

Model: `BikeRequest` — fields: `phone`, `requestor_name`, `due_date`, `recipient_name`, `bike_type` (enum: male/female/kid), `age`, `height`, `notes`, `status` (enum), `assignee_id`

Status flow: `requested` → `pending` → `completed` → `delivered` → `distributed`

- `pending`: sets `assignee` to the factory worker who claimed it
- Back-transitions are allowed at each step

Routes:
- `POST /distributions/:distribution_id/bike_requests` — create (distribution access)
- `PATCH /bike_requests/:id` — update status (production access)

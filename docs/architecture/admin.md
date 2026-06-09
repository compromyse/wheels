# Admin Panel

All admin controllers inherit from `Admin::BaseController < ApplicationController`, which applies `require_superadmin`. Only accessible to users with `superadmin: true`.

## Managed resources

| Resource | Actions |
|---|---|
| `Production` | index, new, create, destroy |
| `Distribution` | index, new, create, edit, update, destroy |
| `User` | index, new, create, destroy |

No edit for Productions or Users currently.

## Creating users

Location assignments are submitted as indexed param arrays:

```
production_assignments[i][production_id]
production_assignments[i][enabled]       # "1" = include
production_assignments[i][role]          # "admin" or "volunteer"

distribution_assignments[i][distribution_id]
distribution_assignments[i][enabled]
distribution_assignments[i][role]
```

The controller skips rows where `enabled != "1"`.

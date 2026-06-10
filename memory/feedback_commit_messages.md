---
name: Commit message style
description: Commit messages should have a descriptive body, not just a one-line subject
type: feedback
---

Write commit messages with a subject line and a body that explains what changed and why. Look at the existing git log for the style — commits like "enforce one pending request per user at a time" include a paragraph or two explaining the approach, what files changed, and what tests cover.

**Why:** Short one-liners are too terse for this project. The user noticed and asked why messages were short.

**How to apply:** Always include a body paragraph (or two) in commit messages describing the implementation details and test coverage, not just the subject line.

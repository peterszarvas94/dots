---
description: Write/rewrite MR file
---

Based on the current branch, get the ticket number that starts with `GEMSU-`.

Update or create `MR/<number>.md` using the exact section structure from `MR/example.md`.

Fill the file in one go (do not leave template comments/placeholders):

1. Write a concrete `## Description` with 1-5 bullet points.
2. Include 1-2 example affected routes using placeholders (for example `:id`).
3. Add `## Related Issue` with the full ticket key (for example `GEMSU-1234`).
4. In `## Type of Changes`, mark the applicable row(s) with `✓`.
5. End with `Closes GEMSU-<number>`.

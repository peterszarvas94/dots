---
description: End-to-end ticket workflow (branch, code, MR file)
---

Handle this ticket end-to-end using: `$ARGUMENTS`.

Workflow:

1. Parse ticket key (`GEMSU-<number>`) and short title from input.
2. Switch to `development` branch, pull. Create/switch branch in format: `fix/GEMSU-<number>-<kebab-slug>`, based/rebased to development. This should be a fresh branch, same commits as latest `development`. English branch name.
3. Implement the ticket with minimal, scoped changes following repo conventions.
4. Dont commit anything, keep it unstaged.
5. Create or update `MR/<number>.md`, using `MR/example.md` as a template. Don't commit this folder.
6. Return:
   - branch name
   - changed files
   - MR file path
   - short problem and solution description

Rules:

- If branch already exists, switch to it and continue.
- Do not include unrelated refactors.
- Keep MR text short and concrete.
- If ticket key is missing, ask one concise question.
- Always use english, but with german object names.

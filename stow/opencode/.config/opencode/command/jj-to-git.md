---
description: Safely migrate the current repository from Jujutsu to Git
---

Migrate the current repository from Jujutsu to Git while preserving commit history. Use this optional commit message when supplied: `$ARGUMENTS`.

Workflow:

1. Inspect `git status`, `git diff`, `git log --oneline --decorate -10`, `jj status`, and `jj log`. Do not reset, checkout-discard, amend, force-push, or overwrite unrelated work.
2. Identify the current Git branch and determine whether all current changes are intended for this migration. If unrelated or ambiguous changes are present, ask one concise question before staging anything.
3. Run the relevant repository checks before committing. Fix failures caused by the migration; report unrelated failures.
4. Create the first real commit with Jujutsu using the supplied message or a concise migration-appropriate message. Use non-interactive commands such as `jj describe -m` and `jj commit -m`.
5. Move the current Git branch/bookmark to the new Jujutsu commit using a fast-forward-safe operation. Verify with `git log --oneline --decorate` that the new commit is a child of the previous branch tip and that prior history is unchanged.
6. Update repository documentation, scripts, and configuration to use Git only. Remove Jujutsu instructions and runtime fallbacks, update broken links, and add `.jj/` to `.gitignore` if appropriate.
7. Remove only the repository-local `.jj` metadata after confirming the Git commit is reachable from the branch. Never remove `.git`.
8. Re-run relevant checks, `git diff --check`, and searches for `jj`, `Jujutsu`, and `jujutsu`. The only acceptable remaining match is an intentional `.gitignore` entry.
9. Review `git status`, `git diff --cached`, and `git log --oneline --decorate -5`. Stage only the migration files and create a second normal Git commit with a concise message.
10. Verify the final branch is clean, the two new commits are ordered after the original branch tip, and no remote branch was changed. Return the commit hashes, branch status, checks run, and any residual warnings.

Rules:

- Preserve all existing Git commits and commit order.
- Never use `git reset --hard`, destructive checkout/restore commands, amend, force-push, or interactive editors.
- Do not commit secrets or unrelated work.
- If Jujutsu is unavailable, stop and report that the first-stage commit cannot be performed safely.

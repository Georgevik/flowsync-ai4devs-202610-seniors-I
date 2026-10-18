---
name: commit
description: Create a git commit from the current changes with a conventional message `tipo(scope): descripción` in Spanish. Use when the user types /commit or asks to commit the proposed changes.
---

# /commit

Commit the current changes with a single-line conventional message.

## 1. Inspect the changes

Run in parallel:

- `git status --short`
- `git diff --staged` and `git diff` (unstaged)
- `git log --oneline -10` to match the style of recent commits
- `git branch --show-current`

If there is nothing to commit, say so and stop. If the current branch is `main`, ask before committing (suggest creating a branch first).

## 2. Decide what goes in

- If there are staged changes, commit **only** what is staged.
- If nothing is staged, stage the files related to the proposed changes by name (`git add <files>`), never `git add -A` / `git add .`.
- Never stage secrets or local files: `.env`, `*.sqlite3`, `tmp/`, `node_modules/`, `.claude/settings.local.json`. Warn if any of them shows up.
- If the changes cover unrelated concerns, propose splitting them into several commits and ask.
- `$ARGUMENTS`, if given, is a hint for the type, scope or description: honor it.

## 3. Write the message

Format: `tipo(scope): descripción`

- **tipo**: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, `revert`.
- **scope** (optional but preferred): the area touched, short and lowercase, e.g. `frontend`, `backend`, `auth`, `ui`, `s1`. Reuse scopes already seen in `git log`. Omit the parentheses if no scope fits.
- **descripción**: in Spanish, lowercase start, no final period, present tense describing what the commit does (e.g. `añade formulario de signup`), max ~72 characters for the whole line.
- Breaking change: `tipo(scope)!: descripción`.

Rules (from the user's global instructions, mandatory):

- One line only: no body, no bullet points.
- No `Co-Authored-By` trailer or any other attribution.

## 4. Commit

```bash
git commit -m "tipo(scope): descripción"
```

Do not use `--no-verify` and do not amend unless the user asks. If a hook fails, fix the issue, re-stage and create a **new** commit. Do not push.

Finish by showing the resulting `git log --oneline -1`.

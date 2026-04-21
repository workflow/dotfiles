---
name: pr-review
description: Summarize and adversarially review a GitHub pull request.
argument-hint: <pr-number-or-url>
allowed-tools:
  - Bash(gh pr view:*)
  - Bash(gh pr diff:*)
  - Bash(gh pr checks:*)
  - Bash(jj git fetch:*)
  - Bash(jj new:*)
  - Bash(jj log:*)
  - Bash(jj abandon:*)
  - Read
  - Grep
  - Glob
  - Agent
---

Review pull request `$ARGUMENTS`.

1. Fetch the PR metadata and diff via `gh pr view` and `gh pr diff`.
2. If the PR branch isn't already checked out locally, run `jj git fetch` and `jj new <branch>` to get it.
3. Summarize what the PR does and why.
4. Perform an adversarial review: actively try to break the code. Look for logic errors, incorrect assumptions, edge cases, silent failures, security holes, race conditions, and performance traps. Only report real, substantiated issues with file:line references — not hypotheticals or linter-level nitpicks.

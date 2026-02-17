- Use asserts in code liberally. Better to fail fast on an unexpected path than to continue in an unknown state. (More good reading on this in https://github.com/tigerbeetle/tigerbeetle/blob/main/docs/TIGER_STYLE.md#safety)
- Comment code sparsely, and only where it adds true novel context to the code being executed. This is an example of superfluous commenting:
```rust
                // Set current carrier in the database to track it in the logic module
                CurrentCarrierRepository::set(ctx.tx(), carrier_number)
                    .await
                    .context("Failed to set current carrier")?;
```
A comment like this would be a sign that the function naming (CurrentCarrierRepository::set) is not clear enough in the context and should be refactored instead.
Extensive File and function headers are still useful to give context.
- Apply the "Small Functions" practice: functions should be small, stay at a single level of abstraction and extract helper functions with intention-revealing names so the code reads clearly without needing comments.
- Apply the "step-down" rule: Top level reads like a story, details pushed into well-named helpers. Helpers should live below their main functions/tests wherever possible, reading like a newspaper (headlines first, details later).
* When good tests exists, prefer TDD.
- Make a `jj commit` at the end of your changes: Don't include the "Created with Claude Code" and "Co-Authored-by" lines. Also keep commits short and to the point. Use conventional-commits (such as perf, feat...etc) for commit headings. Put the subject in parentheses, i.e. `feat(logic-module): add X operation` or `chore(clippy): add a lint`
- `jj commit` does not have an `--amend` option - instead try `jj absorb` and if that doesn't find the right target then use `jj squash` to squash changes into the latest commit and then re-describe that commit as needed.
- Use `jj` instead of `git` for all version control operations
- For opening PRs on github, since jj does not map directly to git branches, first push the new bookmark with jj and then use `gh pr create --head <new bookmark name> --base main ...`
- When offering to open Github PRs, do not include a "Generated with Claude" line, nor a `## Test Plan` section unless the Test Plan is core to this specific PR.

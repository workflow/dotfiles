- Comment code sparsely, and only where it adds true novel context to the code being executed. This is an example of superfluous commenting:
```rust
                // Set current carrier in the database to track it in the logic module
                CurrentCarrierRepository::set(ctx.tx(), carrier_number)
                    .await
                    .context("Failed to set current carrier")?;
```
A comment like this would be a sign that the function naming (CurrentCarrierRepository::set) is not clear enough in the context and should be refactored instead.
Extensive File and function headers are still useful to give context.
- Instead of long functions with lots of comments, prefer to refactor these by adding short helper methods/functions that are self-explanatory in name.
* When good tests exists, prefer TDD.
- Make a `jj commit` at the end of your changes: Don't include the "Created with Claude Code" and "Co-Authored-by" lines. Also keep commits short and to the point. Use conventional-commits (such as perf, feat...etc) for commit headings. Put the subject in parentheses, i.e. `feat(logic-module): add X operation` or `chore(clippy): add a lint`
- `jj commit` does not have an `--amend` option - instead try `jj absorb` and if that doesn't find the right target then use `jj squash` to squash changes into the latest commit and then re-describe that commit as needed.
- Use `jj` instead of `git` for all version control operations

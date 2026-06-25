Post-merge local repo cleanup. Do this without asking for confirmation, and never push or `fetch --prune`.

1. Capture the current branch name. If it is already `main`, just run `git pull` and stop.
2. Switch to `main` and `git pull`.
3. Delete the old local branch, squash-merge-aware:
   - Try `git branch -d <branch>` first. If it succeeds, done.
   - If it fails with "not fully merged", that's expected for squash/rebase merges (the merged commit has a new SHA, so the branch tip is never an ancestor of main). Before force-deleting, **confirm the branch was actually merged**:
     - Authoritative check (preferred): `gh pr view <branch> --json state --jq .state` — if it returns `MERGED`, the branch is safe to delete with `git branch -D <branch>`.
     - Fallback if `gh` is unavailable: squash-aware git check — `git cherry main $(git commit-tree "$(git rev-parse '<branch>^{tree}')" -p "$(git merge-base main <branch>)" -m _)`. Empty output means the branch's content is already in `main`; delete with `git branch -D <branch>`.
   - If neither check confirms the branch is merged, do **not** delete it — warn that it may have unmerged work.

Note: the repo has "automatically delete head branches" enabled on GitHub, so the remote branch is already gone after merge; this skill only cleans up the local branch.

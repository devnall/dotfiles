Post-merge local repo cleanup. Do this without asking for confirmation, and never push or `fetch --prune`.

**First, figure out where you are:**

- Current branch: `git rev-parse --abbrev-ref HEAD`. If it's already `main`, just `git pull` and stop.
- **Supacode worktree?** Check whether this working tree is a supacode-managed worktree: `git rev-parse --show-toplevel` contains `/.supacode/repos/`. Supacode also locks these — they show `locked` in `git worktree list`. If it is, follow the **supacode path**; otherwise the **normal path**. Not every branch lives in a supacode worktree, so this check decides which path to take each time.

## Normal path

`main` is checked out in this same working tree — the classic single-worktree repo.

1. Switch to `main` and `git pull`.
2. Delete the old local branch, squash-merge-aware:
   - Try `git branch -d <branch>` first. If it succeeds, done.
   - If it fails with "not fully merged", that's expected for squash/rebase merges (the merged commit has a new SHA, so the branch tip is never an ancestor of main). Before force-deleting, **confirm the branch was actually merged**:
     - Authoritative check (preferred): `gh pr view <branch> --json state --jq .state` — if it returns `MERGED`, the branch is safe to delete with `git branch -D <branch>`.
     - Fallback if `gh` is unavailable: squash-aware git check — `git cherry main $(git commit-tree "$(git rev-parse '<branch>^{tree}')" -p "$(git merge-base main <branch>)" -m _)`. Empty output means the branch's content is already in `main`; delete with `git branch -D <branch>`.
   - If neither check confirms the branch is merged, do **not** delete it — warn that it may have unmerged work.

## Supacode path

You're working inside a `*/.supacode/repos/*` worktree. **Supacode owns the worktree's lifecycle — it is the boundary.** Clean up everything *up to* the worktree, but never touch the worktree or its branch: the owner archives and deletes those in supacode when ready.

1. Do **not** `git checkout main` here (main lives in its own worktree and this branch is checked out and locked), do **not** delete the branch, and do **not** run `git worktree remove`/`unlock`/`prune`.
2. Update `main` in its own worktree instead: find its path from `git worktree list` (the entry tagged `[main]`), then `git -C <main-worktree-path> pull`.
3. Confirm the branch's merge status so the owner knows it's safe to archive:
   - `gh pr view <branch> --json state --jq .state` → `MERGED` means merged.
   - Fallback if `gh` is unavailable: `git cherry main $(git commit-tree "$(git rev-parse '<branch>^{tree}')" -p "$(git merge-base main <branch>)" -m _)` — empty (or a `-`-prefixed line) means the content is already in `main`.
   - If neither confirms it merged, **warn** that it may have unmerged work.
4. Report: `main` updated, the branch's merge status, and that the worktree + local branch are intentionally left for the owner to archive and delete in supacode. Then stop.

Note: the repo has "automatically delete head branches" enabled on GitHub, so the remote branch is already gone after merge; this command only cleans up locally.

# Dotfiles Project Spec

> **Version:** 6.0
> **Purpose:** Architecture reference and task plan for the `~/.dotfiles` repo. Part A documents design decisions and constraints. Part B holds the **latest** project's task plan — in progress, or the most recently completed. It is overwritten by the next project's first commit, never reset to an idle state on its own (completed plans stay recoverable from this file's git history).
>
> **Repo:** `~/.dotfiles` (Dotbot-managed, macOS/zsh-centric, with Linux remote support)
>
> **Previous:** v5.0 Remote bat version upgrade helper — completed. `bin/linux-bat-install` swaps apt's stale bat for the latest upstream `.deb` on minimal `.remote` servers.

---

## Part A: Architecture Reference

See [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) for directory structure,
design decisions, and strict directives.

### Acceptance Criteria

After all cleanup work is complete, these must all be true:

1. `install.config.yaml` successfully symlinks `~/.zshrc`, `~/.bashrc`, `~/.config/nvim`, and all tool configs to their correct locations.
2. Shell starts without errors on macOS with zsh.
3. Non-interactive subshells do not emit prompt escape codes or extraneous output.
4. `brew bundle --file=packages/Brewfile.universal` installs cleanly; work/personal Brewfiles install conditionally based on marker file.
5. Neovim opens without blocking errors even when LSPs are absent.
6. `~/.env.local` and `~/.secrets.local` are sourced silently if present, silently skipped if absent.
7. Marker file controls which env config loads correctly for all four marker types; if none exists, only universal config loads.
8. No stale symlinks, no orphaned `install.config.yaml` entries, no references to removed files/directories in documentation.
9. README.md and docs/RUNBOOK.md are accurate and complete reflections of the repo's actual state.
10. Shell startup time is reasonable (benchmark documented).

---

## Part B: Task Plan

### Project: Claude Code settings — install-time layered merge

**Problem**

`~/.claude/settings.json` is an **orphan symlink** into the public repo
(`config/claude/settings.json`). Four issues, priority order:

1. **Churn (biggest):** Claude Code rewrites the live file at runtime (`theme`,
   `effortLevel`, `model`, `skipAutoPermissionPrompt`, …). Because it's symlinked
   into the repo, `git status` is perpetually dirty and `git pull` autostash has
   conflicted twice. Confirmed live: the working-tree drift on
   `config/claude/settings.json` is exactly these runtime writes.
2. **Secrets risk:** the file lives in a **public** repo. `settings.json` can carry
   `env`, `apiKeyHelper`, `hooks`, and internal hostnames in `permissions` rules.
   (Audit result below: the *current* file has none — but the exposure is real.)
3. **Work vs personal:** different settings wanted per machine type, driven by the
   existing marker files (`~/.work`, `~/.personal`, `~/.remote`, `~/.remote-full`),
   the same way Brewfiles and `env/*.zsh` already layer.
4. **Curated shared baseline:** still want permissions / statusline / plugins /
   marketplaces version-controlled and applied on every machine — committed safely.

**Verified before designing** (current Claude Code docs + live inspection; supersedes
training memory and the old ARCHITECTURE §3.5 claim):

- **Precedence (high→low):** managed-settings → CLI `--settings` → project
  `.claude/settings.local.json` → project `.claude/settings.json` → user
  `~/.claude/settings.json`. User/project/local **deep-merge**; managed is
  enterprise/root-scope (macOS `/Library/Application Support/ClaudeCode/`, Linux
  `/etc/claude-code/`) and pops a security dialog — wrong tool for personal dotfiles.
- **`~/.claude/settings.local.json` is NOT merged at user scope** — only project-scoped
  `.claude/settings.local.json` merges. Confirmed live: `~/.claude/settings.local.json`
  contains `{"model":"opus"}` and is being **ignored**. → ARCHITECTURE §3.5 and
  `bootstrap.sh` are **wrong** and must be corrected.
- **No native include/compose** for user settings. `CLAUDE_CONFIG_DIR` relocates the
  whole `.claude` dir (incl. credentials) — heavier than needed. ⇒ work/personal
  differentiation must be done **at install time via marker files**.
- **MCP servers live in `~/.claude.json`, not `settings.json`** — that whole "work MCP"
  leak worry is off the table for this file. Onboarding/tips/oauth/caches also live in
  `~/.claude.json`; credentials in `~/.claude/.credentials.json`.
- **Volatile keys** confirmed auto-written to `settings.json`: `theme`, `effortLevel`,
  `skipAutoPermissionPrompt` (live drift), plus `model`/`outputStyle` via slash commands.
- **Known bug (independent reason to drop the symlink):** Claude Code issue **#3575** —
  symlinked `settings.json` causes permission failures and perf degradation; Nix users
  hit read-only-symlink write errors (#55485, #52525). Consensus fix: **copy/generate a
  real file, never symlink it.**
- **Community consensus:** robust setups generate/merge `settings.json` from a tracked
  base (e.g. ryoppippi's jq deep-merge with an OS conditional — our marker approach);
  secrets stay out entirely, in a gitignored local layer or resolved at runtime via a
  secret manager (1Password `op://` + `apiKeyHelper`).

**Audit of current `config/claude/settings.json`:** no secrets. Curated keys
(`permissions` allow-list of generic git/gh/standard tools, `statusLine`,
`enabledPlugins`, `extraKnownMarketplaces`) are all safe to commit. Volatile keys
(`theme`, `effortLevel`, `skipAutoPermissionPrompt`) are runtime drift, not curated.

**Design**

Stop tracking a single `settings.json`. Keep **layered source files** in the repo and
generate the **real, untracked** `~/.claude/settings.json` at install time by
deep-merging the layers on top of the live file. Churn lands in an untracked file (zero
git noise); the curated baseline is re-applied every `./install`; marker files select
the work/personal layer.

- **Layers in `config/claude/` (low→high precedence):**
  - `settings.shared.json` — **committed**. Universal curated baseline: `permissions`,
    `statusLine`, `enabledPlugins`, `extraKnownMarketplaces`. No secrets, no volatile keys.
  - `settings.<marker>.json` — `settings.personal.json` / `settings.work.json`
    **committed** (safe, non-sensitive); `settings.remote*.json` optional/future.
    Generator picks the one matching the active marker.
  - `settings.local.json` — **gitignored** (matches existing `*.local.*`; explicit entry
    added for clarity). Per-machine secrets/overrides: internal hostnames in permission
    rules, `hooks`, `apiKeyHelper` (real creds via 1Password `op://`). Mirrors
    `~/.env.local` / `~/.secrets.local`. Bootstrap creates a `{}` stub.
- **Work-layer decision:** commit a safe `settings.work.json`; route any sensitive bits
  to the gitignored `settings.local.json`. Mirrors `env/work.zsh` (tracked) +
  `~/.secrets.local` (untracked), and the runbook's existing rule that work OTEL secrets
  go in `~/.secrets.local`, not settings.json.
- **Merge semantics (`bin/claude-settings-build`, jq):** recursive deep-merge —
  objects recurse, arrays union + dedup, scalars right-wins, canonical sorted-key output.
  **Permissions are repo-authoritative**: the live file's permissions are dropped before
  merging, so the allow/deny lists are exactly shared ∪ marker ∪ local (curated removals
  propagate; runtime "always allow" grants don't accumulate). Keys only in the live file
  (`theme`/`model`/`effort`) are preserved untouched → no reset surprise.
- **Volatile keys** are deliberately *absent* from all committed layers, so the merge
  never overwrites them → the churn fix. (`model`: stays machine-local per the earlier
  `🔧 Remove model key from shared Claude settings` decision; this machine's `opus`
  preference is rescued from the legacy `~/.claude/settings.local.json` during migration.
  To default a new machine to opus, set it once via `/model` or in `settings.local.json`.)
- **Why not just commit-and-churn / git-wrapper / per-key strip:** committing the whole
  file keeps the public-repo secret exposure and the dirty tree; a git auto-sync wrapper
  still pushes every model/theme flip; per-key `assume-unchanged` is unshipped in the
  wild and brittle. Install-time generate is the robust, repo-idiomatic fit.

**Decisions (made 2026-06-13)**

- Work layer: **commit safe + gitignored local for secrets** (not whole-file-ignored).
- Pre-existing drift: **subsume** the `config/claude/settings.json` working-tree drift
  (it's removed by the redesign; curated keys extracted into `settings.shared.json`
  first), and **remove** the redundant untracked `config/git/.gitconfig-darwin`
  (`credential.helper = osxkeychain` is already set directly in `config/git/config`;
  the file is referenced nowhere).
- `jq` already in `Brewfile.universal`; generator self-guards and no-ops where absent
  (e.g. minimal `.remote`).

**Tasks**

- [x] **Source layers** (`config/claude/`):
  - [x] Create `settings.shared.json` from the current HEAD curated keys (permissions,
        statusLine, enabledPlugins, extraKnownMarketplaces) — no volatile keys, no secrets.
  - [x] Create `settings.personal.json` and `settings.work.json` (safe, minimal to start).
  - [x] `git rm` the tracked `config/claude/settings.json` (drift subsumed).
- [x] **`bin/claude-settings-build`** (bash, shellcheck-clean, bootstrap.sh output style):
  - [x] `jq` guard → warn + exit 0 if absent. `mkdir -p ~/.claude`. trap-clean temp.
  - [x] Detect active marker; missing marker → empty marker layer.
  - [x] Deep-merge (objects recurse / arrays union+dedup / scalars right-wins), inputs
        low→high: legacy `~/.claude/settings.local.json` (rescue) → live
        `~/.claude/settings.json` → `settings.shared.json` → `settings.<marker>.json` →
        `config/claude/settings.local.json`.
  - [x] **Symlink migration:** if `~/.claude/settings.json` is a symlink, read its
        content (or `{}` if dangling) as the live input, then atomically replace it with
        the generated real file.
  - [x] Write only when content changes (avoid needless rewrites). Validate JSON before `mv`.
  - [x] Idempotent on re-run; note when it rescues/should-delete legacy local file.
- [x] **`install.config.yaml`:** add a shell step (after the bat-cache step) running
      `command -v jq > /dev/null && bash bin/claude-settings-build || true`. (No symlink
      entry to remove — already gone in `68f0532`.)
- [x] **`bootstrap.sh`:** repoint the stub from `~/.claude/settings.local.json` to
      `config/claude/settings.local.json` (`{}`); fix any summary/TODO text referencing
      the old path.
- [x] **`.gitignore`:** add explicit `config/claude/settings.local.json` under a Claude
      comment (confirm committed layers are not caught by `*.local.*`).
- [x] **`config/git/.gitconfig-darwin`:** remove (redundant/orphaned).
- [x] **Docs:**
  - [x] ARCHITECTURE §3.5 — correct the false "settings.local.json deep-merged at
        runtime" claim; describe the layered generate. §3.4 — list Claude layers as
        marker-driven. §2 tree — add `config/claude/*` layers + `bin/claude-settings-build`.
  - [x] RUNBOOK — new "Claude Code settings" section (layering, how to add a permission,
        work vs personal, migration); fix the local-files / backup tables.
  - [x] README — check for and fix any settings references.
- [x] **Migration (this machine):** run the generator; confirm `~/.claude/settings.json`
      is now a real file with the curated baseline + preserved `theme`/`effort`/`model`;
      advise deleting the legacy `~/.claude/settings.local.json`.

**Status:** Implemented on branch `feat/claude-settings-layering`. Generator
unit-tested in a sandbox (permission union, volatile-key preservation, precedence,
legacy rescue, marker selection, symlink migration, idempotency — all pass) and run
live on this `.personal` machine: the orphan `~/.claude/settings.json` symlink is now a
real file carrying the curated baseline + preserved `theme`/`effort`/`skipAutoPermissionPrompt`
+ rescued `model: opus`; re-run is a clean no-op; `git status` shows no settings churn.
`pre-commit run --all-files` green (shellcheck included). `.gitconfig-darwin` removed and
the legacy `~/.claude/settings.local.json` retired. Not yet exercised on a `.work` or `.remote` box (no access from here; logic verified via
sandbox marker tests).

**Follow-up — permission audit (2026-06-13):** trimmed the shared allow-list to a
least-privilege baseline (dropped 14 redundant read-only builtins; removed the
escape-hatch/outward/secret entries `python3 -c`, `command`, `gh`, `git push`, `env`,
`printenv`; tightened `git config` to read-only). Moved `git push` + a narrow `gh` read
subset to `settings.personal.json`. Added a `deny` block to `settings.shared.json`
(`rm -rf`, `gh repo delete`, `gh auth token`, `gh secret`). Made the generator treat
**permissions as repo-authoritative** (drops the live file's permissions before merging) so
curated removals propagate and runtime grants don't accumulate; output is now sorted-key
for stable idempotency. Live file regenerated: 35 allow + 5 deny, volatile keys preserved.

**Verification plan**

- `shellcheck` + `bash -n` clean on `bin/claude-settings-build`; `pre-commit run
  --all-files` green.
- Generate → `~/.claude/settings.json` is a regular file (not a symlink), valid JSON,
  contains the shared baseline; `theme`/`effortLevel`/`model` preserved. Re-run is a
  no-op (idempotent).
- Merge logic tested against sample layer inputs in a temp dir for each marker
  (permissions union; marker override; local override) — without touching real markers.
- `git status` shows no `settings.json` (file untracked + removed from repo); a Claude
  session that flips theme/model produces **no** repo diff.
- `./install` end-to-end idempotent.

**Acceptance**

- `git status` no longer shows settings.json churn on any machine after normal Claude use.
- The shared baseline (permissions/statusline/plugins/marketplaces) applies on all machines.
- Work machines get the work layer; personal machines get the personal layer — via markers.
- No sensitive data in the public repo; volatile model/theme/effort stay machine-local.
- `./install` stays idempotent; migration converts the orphan symlink with no data loss.
- ARCHITECTURE / RUNBOOK / bootstrap.sh corrected (esp. the settings.local.json claim).

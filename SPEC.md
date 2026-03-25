# Dotfiles Project Spec

> **Version:** 5.0
> **Purpose:** Architecture reference and task plan for the `~/.dotfiles` repo. Part A documents design decisions and constraints. Part B holds the current project's task plan (rotates per project).
>
> **Repo:** `~/.dotfiles` (Dotbot-managed, macOS/zsh-centric, with Linux remote support)
>
> **Previous:** v4.0 Dotbot deep audit & optimization — completed. Install pipeline cleaned, config reorganized, RUNBOOK docs added.

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

_No active project. Replace this section with the next task plan._

> **Previous:** v4.0 Dotbot deep audit & optimization — completed. Install pipeline cleaned, config reorganized, RUNBOOK docs added.

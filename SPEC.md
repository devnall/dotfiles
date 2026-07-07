# Dotfiles Project Spec

> **Version:** 7.0
> **Purpose:** Architecture reference and task plan for the `~/.dotfiles` repo. Part A documents design decisions and constraints. Part B holds the **latest** project's task plan — in progress, or the most recently completed. It is overwritten by the next project's first commit, never reset to an idle state on its own (completed plans stay recoverable from this file's git history).
>
> **Repo:** `~/.dotfiles` (Dotbot-managed, macOS/zsh-centric, with Linux remote support)
>
> **Previous:** v7.0 NordicPine dark-mode readability — completed. Fixed unreadable `bat` comments (Brewfile.* syntax mapping + custom `nordicpine.tmTheme`), split the near-duplicate blue/cyan palette slots (ΔE 5 → 23), and aligned Neovim treesitter groups onto the NordicPine palette with a lossless dark↔light toggle.

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

### Project: Raycast v2 beta coexistence — protect scripts + Brewfile

**Problem**

Migrating to the [Raycast v2 beta](https://www.raycast.com/new) raised two fears: (1) that
`brew bundle` would clobber the beta and reinstall v1, and (2) that the dotfiles-managed
`config/raycast/scripts/*` script commands would break. Investigation showed both fears are
largely unfounded given how Raycast actually ships v2 — the work is to document that and add
a guardrail so a future cleanup doesn't reintroduce the risk.

Findings (verified on a live machine):

1. **v1 and v2 are separate apps.** v1 = `/Applications/Raycast.app` (`com.raycast.macos`);
   v2 beta = `/Applications/Raycast Beta.app` (`com.raycast-x.macos`), separate settings
   stores. They coexist by design; neither bundle can clobber the other.
2. **The Brewfile can't clobber the beta.** No `raycast@beta` cask exists (checked the
   Homebrew API — `raycast@beta`/`raycast-beta`/`raycast-x` all 404), so the beta is a manual
   install. `bin/brew-bundle-install` runs `brew bundle --no-upgrade` (a no-op for the
   already-installed v1), and nothing in the install path runs `brew bundle cleanup`/`zap`.
3. **Script commands are compatible.** Plain shell + `@raycast.*` metadata; v2 supports the
   same format. `~/.config/raycast/scripts` is app-agnostic.
4. **Registration carries over on migration.** v2's separate settings store would in
   principle need the script directory re-registered — but its "Migrate from Raycast v1"
   onboarding does this automatically (verified: no manual action needed). Only relevant if
   migration is skipped. The registration is NOT in NSUserDefaults, so it can be reminded
   about but not verified programmatically.

**Decisions**

- **Keep `cask "raycast"` (v1)** during the beta (Raycast recommends coexistence; the beta
  still lacks some features). Add a comment so it isn't "cleaned up."
- **Beta stays a manual install** — no cask to add yet. Revisit if/when `raycast@beta` lands.
- **Guardrail = a read-only doctor**, not an install-time gate, since the one unverifiable
  step (script-dir registration) can only be reminded, not enforced. Model it on
  `bin/brew-audit.sh` (colored, read-only, exit 0).

**Tasks**

- [x] **`bin/raycast-doctor`** — detects installed v1/v2 apps, checks the
      `~/.config/raycast/scripts` symlink, lists tracked script commands, prints the
      per-app manual-registration reminder. Read-only, exit 0, macOS-guarded. Auto-symlinked
      into `~/bin` via the existing `bin/*` glob (no `install.config.yaml` change).
- [x] **`packages/Brewfile.universal`** — comment on `cask "raycast"` explaining v1 is kept
      intentionally, no beta cask exists, and brew won't clobber the beta.
- [x] **`docs/RUNBOOK.md`** — new "Raycast v1 vs v2 beta" subsection (comparison table +
      key points) and a v2 note on the one-time setup step; reference `raycast-doctor`.
- [x] **`docs/ARCHITECTURE.md`** — note the scripts dir is shared by v1 and the separate v2
      app.
- [x] **`SPEC.md`** — rotate Part B to this project.

**Status:** Implemented on branch `feat/raycast-v2-beta-coexistence`. `raycast-doctor` runs
clean on a live machine with both apps installed (v1 + v2 beta detected, symlink healthy,
`quick-capture-obsidian.sh` listed). Applies across work and personal machines via the
universal Brewfile + `bin/*` glob symlink.

**Acceptance**

- `raycast-doctor` reports installed apps, symlink health, and tracked scripts; exits 0; is
  a no-op on non-macOS.
- `cask "raycast"` carries a comment documenting the intentional v1/v2 coexistence.
- RUNBOOK + ARCHITECTURE accurately describe the separate-app model and the per-app
  script-directory registration.
- No install-path change auto-removes or downgrades the beta (no `cleanup`/`zap`;
  `--no-upgrade` retained).

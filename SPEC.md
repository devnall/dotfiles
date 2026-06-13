# Dotfiles Project Spec

> **Version:** 5.0
> **Purpose:** Architecture reference and task plan for the `~/.dotfiles` repo. Part A documents design decisions and constraints. Part B holds the **latest** project's task plan — in progress, or the most recently completed. It is overwritten by the next project's first commit, never reset to an idle state on its own (completed plans stay recoverable from this file's git history).
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

### Project: Remote bat version upgrade helper

**Problem**

`config/bat/config` uses options introduced in bat **0.25.0** that hard-error on
older versions:

- `--theme="auto:system"`, `--theme-light`, `--theme-dark` (light/dark auto-switching)
- `--squeeze-limit`
- `--set-terminal-title`

The config is symlinked universally by dotbot. On `.remote` (minimal, no Homebrew)
Debian/Ubuntu servers, apt ships bat **0.24.0**, so every `bat` invocation fails on
unknown flags. Manual fix to date: `apt remove` bat, then install the current
release `.deb` from `sharkdp/bat` via `dpkg`.

**Scope / context**

- Only `.remote` machines are affected. `.remote-full` (Homebrew) and macOS already
  run a current bat (0.26.1+).
- On Debian/Ubuntu the apt package installs the binary as **`batcat`**, not `bat`
  (conflict with `bacula-console-bat`). The repo's aliases and fzf previews all call
  `bat`, so the apt package is doubly wrong. The sharkdp `.deb` installs as `bat`,
  fixing both the version and the naming gap.

**Decisions (made 2026-06-13)**

- **Delivery:** standalone idempotent `bin/linux-bat-install` (auto-symlinked to
  `~/bin` via the existing `bin/*` glob) + RUNBOOK docs. Not wired into `./install`
  (avoids sudo prompts mid-install) or relied on via `bootstrap.sh` (the documented
  remote flow doesn't run bootstrap).
- **Version:** resolve the **latest** `sharkdp/bat` release at run time; only act
  when installed bat is below a 0.25.0 floor.

**Tasks**

- [x] Create `bin/linux-bat-install`:
  - [x] No-op (exit 0) unless on Linux with `dpkg` available.
  - [x] No-op if `bat --version` is already ≥ 0.25.0 (leaves brew bat alone;
        idempotent re-runs). Checks the `bat`-named binary specifically so an apt
        `batcat` still triggers the upstream install (fixes the naming gap too).
  - [x] Detect arch via `dpkg --print-architecture` (amd64 / arm64 / armhf; warn +
        exit on anything else).
  - [x] Resolve the latest release tag from the
        `https://github.com/sharkdp/bat/releases/latest` redirect (`curl -fsSLI`,
        no jq).
  - [x] Download `bat_<ver>_<arch>.deb` to a temp dir (trap-cleaned).
  - [x] If the apt package is present (`dpkg -s bat`), `sudo apt-get remove -y bat`.
  - [x] `sudo dpkg -i` the `.deb` (falls back to `apt-get -f install -y` for deps);
        temp dir cleaned on exit.
  - [x] Use the info/success/warn output style from `bin/bootstrap.sh`.
  - [x] Keep shellcheck-clean (bin/ is in the pre-commit shellcheck scope).
- [x] Document in `docs/RUNBOOK.md` → Remote/Server Setup: note apt's bat is too old
      for the shared config and point to `linux-bat-install` in the "Optional
      nice-to-haves" area; added a row to the "What you get" table.
- [x] Mention `bin/linux-bat-install` in `docs/ARCHITECTURE.md` (§3.2
      optional-tool-guards note).

**Status:** Implemented on branch `feat/remote-bat-upgrade`. Verified on macOS:
shellcheck + `bash -n` clean, platform guard no-ops, `version_ge` correct across
cases, latest-release resolution returns v0.26.1 with a live 200 on the amd64 asset.
Not yet run on a real Debian/Ubuntu `.remote` box (no access from here).

**Acceptance**

- On a `.remote` Debian/Ubuntu box, `linux-bat-install` upgrades bat to the current
  release, `bat` (not `batcat`) resolves, and `config/bat/config` loads with no
  errors.
- Re-running the script is a clean no-op.
- macOS and `.remote-full` machines are unaffected (version floor short-circuits).

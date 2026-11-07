# Dotfiles Project Spec

> **Version:** 7.0
> **Purpose:** Architecture reference and task plan for the `~/.dotfiles` repo. Part A documents design decisions and constraints. Part B holds the **latest** project's task plan — in progress, or the most recently completed. It is overwritten by the next project's first commit, never reset to an idle state on its own (completed plans stay recoverable from this file's git history).
>
> **Repo:** `~/.dotfiles` (Dotbot-managed, macOS/zsh-centric, with Linux remote support)
>
> **Previous:** Raycast v2 beta coexistence — completed. Added the read-only `bin/raycast-doctor`, documented that v1 and the v2 beta are separate apps the Brewfile can't clobber, and kept `cask "raycast"` intentionally.

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

### Project: Rex hosts in dotfiles — one host list for every machine

**Problem**

The [Rex](https://www.superlogical.com/rex/docs/customize/config) beta multiplexer runs a server per machine, each on its own built-in Tailscale node. The laptop listed the Mac Studio as a host, but the Mac Studio listed nothing. Host lists live on each device's *home* server, and every device is its own home by default, so a `rex hosts add` on one machine never reaches the others. Neither of the laptop's two Mac Studio entries worked either: one used the machine's regular Tailscale name (Rex isn't listening there, so the connection is refused) and the other used a name that doesn't resolve.

**Decisions**

- **Declare hosts in `init.lua`** (`rex.host{...}`), the config file the Rex server reads, instead of relying on `rex home` syncing. Every machine gets the same list from git, and nothing depends on one machine being online.
- **Endpoints are the Rex server's own Tailscale node** (`<machine>-rex`), not the machine's Tailscale name.
- **Stable `id` per host** so a rename keeps the host's identity.
- **Reload, never start.** `bin/rex-config-reload` reloads a running server and is a no-op without `rex` or a running server, modeled on `bin/dark-notify-load`.
- **Turning on Tailscale stays manual.** Sign-in is interactive and per machine. It is documented in the RUNBOOK, not automated.

**Tasks**

- [x] **`config/rex/init.lua`**: declares `rum` (laptop) and `studio` (Mac Studio).
- [x] **`install.config.yaml`**: links `~/.config/rex/init.lua` (`force: true`) and runs `bin/rex-config-reload`.
- [x] **`bin/rex-config-reload`**: reloads a running server and exits 0 everywhere. Auto-linked into `~/bin` by the `bin/*` glob.
- [x] **`docs/RUNBOOK.md`**: new "Rex terminal multiplexer" section (host table, adding a machine, pitfalls) and a directory-tree entry.
- [x] **`docs/ARCHITECTURE.md`**: directory-tree entry.
- [x] **`SPEC.md`**: Part B moved to this project.

**Acceptance**

- After `./install`, `rex hosts list` on each machine shows `rum` and `studio` with `init.lua` as the source, and `rex hosts check` reports both reachable.
- `./install` succeeds on machines without Rex or without a running server.

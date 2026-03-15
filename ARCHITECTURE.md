# Dotfiles Architecture

> **What this file is:** A human-maintained reference document capturing the design decisions, constraints, and conventions for this dotfiles repo. It is the source of truth for how the repo is structured and why.
>
> **How to use it:** When starting a new project or task plan (SPEC.md), copy the relevant sections from this file into the spec's context/architecture section so that Claude Code (or any other tool) gets the full picture in a single file. This avoids relying on cross-file references during execution.
>
> **This file is not a task plan.** It contains no actionable work items. For current tasks, see SPEC.md. For future ideas, see TODO.md.
>
> **When to update this file:** Whenever a design decision changes — new marker types, new directory conventions, new directives, updated acceptance criteria, etc. Keep it in sync with the actual repo state after each project.

---

## 1. Overview

This repo consolidates shell and tool configurations into a single, idempotent dotfiles repository managed by [Dotbot](https://github.com/anishathalye/dotbot). It is macOS/zsh-centric. Linux bash support is a minimal remote-server baseline only.

---

## 2. Directory Structure

```text
dotfiles/
├── .git/
├── .gitignore
├── ARCHITECTURE.md           # This file — design reference (not consumed by tooling)
├── SPEC.md                   # Current project task plan
├── TODO.md                   # Future ideas and deferred work
├── README.md                 # Quick-start guide
├── RUNBOOK.md                # Detailed usage and maintenance reference
├── dotbot/                   # Git submodule
├── install.config.yaml       # Dotbot symlink + shell command config
├── install                   # Dotbot bootstrap script
├── bin/                      # Global shell scripts (all symlinked to ~/bin)
├── docs/                     # Cheatsheets (fzf, tmux, git, shell, kubernetes)
├── zsh/
│   ├── zshrc.zsh             # Entrypoint (symlinked to ~/.zshrc)
│   ├── lib/                  # Modular zsh config files (auto-sourced alphabetically)
│   └── zfunctions/           # Autoloaded zsh functions
├── env/
│   ├── work.zsh              # Sourced when ~/.work exists
│   ├── personal.zsh          # Sourced when ~/.personal exists
│   ├── remote.zsh            # Sourced when ~/.remote exists
│   └── remote-full.zsh       # Sourced when ~/.remote-full exists
├── packages/
│   ├── Brewfile.universal    # Installed on all machines
│   ├── Brewfile.work         # Installed on work machines only
│   └── Brewfile.personal     # Installed on personal machines only
└── config/                   # XDG-style tool configs
    ├── bash/bashrc           # Minimal bash (remote server baseline only)
    ├── bat/
    ├── btop/
    ├── ghostty/
    ├── git/
    ├── macos/                # macOS setup/defaults scripts
    ├── nvim/                 # Neovim config (lazy.nvim)
    ├── ripgrep/
    ├── sheldon/              # Zsh plugin manager config
    ├── ssh/                  # SSH config template (private hosts in ~/.ssh/config.local)
    ├── starship/
    ├── tmux/
    └── vim/vimrc             # Minimal vim fallback (no plugins, remote-safe)
```

> **Note:** Update this tree after each cleanup or restructuring project to keep it accurate.

---

## 3. Core Design Decisions

### 3.1 Configuration Management (Dotbot)

- `dotbot` handles all symlinking and bootstrapping via `install.config.yaml`.
- The `install` script must be 100% idempotent — safe to re-run at any time without errors or duplications.
- `install.config.yaml` symlinks at minimum: `~/.zshrc`, `~/.bashrc`, `~/.config/nvim`, and all tool configs under `config/` to their correct XDG locations.

### 3.2 Shell Environment

- **Primary:** macOS with zsh. Only fully-supported interactive shell environment.
- **Remote baseline:** `config/bash/bashrc` provides a minimal `.bashrc` for remote servers — PATH, essential aliases only. No visual elements, does not mirror the full zsh setup.
- **Entrypoint:** `zsh/zshrc.zsh` is the sole zsh entrypoint. It sources `zsh/lib/*.zsh` directly — no `shell/`, `os/`, or `env/` module tree.
- **Plugin manager:** Sheldon (`config/sheldon/`) manages zsh plugins. Homebrew dependency. Initialization guarded with `command -v sheldon > /dev/null`.

### 3.3 Machine-Specific PATH

- **Universal toolchain paths** (Homebrew, Cargo, Go, Ruby gems): defined in `zsh/lib/path.zsh`, guarded with `[[ -d /path ]]` checks.
- **Machine-specific tools** (e.g., LM Studio, Claude Code): go in `~/.env.local`, NOT committed to the repo.

### 3.4 Environment Separation (Marker Files)

- **Detection:** Marker file approach — one of `~/.work`, `~/.personal`, `~/.remote-full`, or `~/.remote` is touched during machine setup. No hostname detection.
- **Shell loader:** Sources the corresponding `env/*.zsh` file. If no marker exists, only universal config loads.
- **Dotbot install:** Runs `brew bundle` for the appropriate Brewfile(s) based on marker.
- **Marker definitions:**
  - `~/.work` — work machine (full macOS setup)
  - `~/.personal` — personal machine (full macOS setup)
  - `~/.remote-full` — Linux server with Homebrew and full tool suite
  - `~/.remote` — minimal Linux server (no Homebrew; skips Brewfiles entirely)

### 3.5 Secrets Management

- Passwords, API keys, and tokens MUST NOT be committed to version control.
- `.gitignore` must explicitly exclude `*.local`, `.env*`, `*secrets*`, and `*.key`.
- **Local override files** (both gitignored, sourced silently, skipped without error if absent):
  - `~/.env.local` — machine-specific exports, PATH additions, non-secret config
  - `~/.secrets.local` — credentials, API keys, tokens
- **Sourcing order:** `~/.env.local` first, then `~/.secrets.local` at the very end of `zshrc.zsh`.

### 3.6 Editor Configuration

- **Neovim** (`config/nvim/`): lazy.nvim-based. Intended for desktop machines. Must open without blocking errors when an LSP or external tool is missing.
- **Vim** (`config/vim/vimrc`): Must work on any remote server with stock vim and zero external dependencies. Sensible defaults only.

---

## 4. Strict Directives

These directives apply to all work on this repo:

### Directive 1: Interactive Shell Guards

Guard only prompt/theme initialization behind `[[ $- == *i* ]]`. Specifically: `eval "$(starship init zsh)"` and custom prompt fallbacks MUST be wrapped. Aliases, exports, and PATH additions do NOT need wrapping (inert in non-interactive contexts).

**Rationale:** Prevents Starship escape codes from leaking into piped output from non-interactive subshells (e.g., vim `:terminal`, tmux job control, `ssh user@host 'cmd'`).

### Directive 2: POSIX Alias Safety

Do NOT alias standard POSIX commands (`ls`, `cat`, `grep`) in ways that alter their default machine-readable output. Use new alias names instead (e.g., `ll` for `eza -l`, not `ls`).

### Directive 3: Git Config Simplicity

Do not implement exotic Git hooks or `core.editor` behaviors that interrupt standard automated commit workflows.

---

## 5. Acceptance Criteria

These should be true at the end of any project that modifies the repo:

1. `install.config.yaml` successfully symlinks `~/.zshrc`, `~/.bashrc`, `~/.config/nvim`, and all tool configs to their correct locations.
2. Shell starts without errors on macOS with zsh.
3. Non-interactive subshells do not emit prompt escape codes or extraneous output.
4. `brew bundle --file=packages/Brewfile.universal` installs cleanly; work/personal Brewfiles install conditionally based on marker file.
5. Neovim opens without blocking errors even when LSPs are absent.
6. `~/.env.local` and `~/.secrets.local` are sourced silently if present, silently skipped if absent.
7. Marker file controls which env config loads correctly for all four marker types; if none exists, only universal config loads.
8. No stale symlinks, no orphaned `install.config.yaml` entries, no references to removed files/directories in documentation.
9. README.md and RUNBOOK.md are accurate and complete reflections of the repo's actual state.
10. Shell startup time is reasonable (benchmark documented in RUNBOOK).

---

## 6. Key Files Reference

| File | Purpose |
|------|---------|
| `install` | Dotbot bootstrap script — run with `./install` |
| `install.config.yaml` | Dotbot config — symlinks and shell commands |
| `zsh/zshrc.zsh` | Zsh entrypoint, symlinked to `~/.zshrc` |
| `config/bash/bashrc` | Minimal bash for remote servers |
| `~/.env.local` | Machine-specific exports (gitignored, not in repo) |
| `~/.secrets.local` | API keys and tokens (gitignored, not in repo) |
| `config/git/.gitconfig-user` | Git identity (gitignored, copy from `.gitconfig-user.example`) |
| `README.md` | Quick-start installation guide |
| `RUNBOOK.md` | Detailed usage, maintenance, and troubleshooting |
| `SPEC.md` | Current project task plan (rotates per project) |
| `TODO.md` | Deferred ideas and future work |

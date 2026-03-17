# Dotfiles Project Spec

> **Version:** 4.0
> **Purpose:** Architecture reference and task plan for the `~/.dotfiles` repo. Part A documents design decisions and constraints. Part B holds the current project's task plan (rotates per project).
>
> **Repo:** `~/.dotfiles` (Dotbot-managed, macOS/zsh-centric, with Linux remote support)
>
> **Previous:** v3.0 cleanup & improvement project — completed. All phases, tasks, and human review items resolved.

---

## Part A: Architecture Reference

This section documents the repo's design decisions, constraints, and acceptance criteria. It is context for the task plan in Part B — Claude Code should understand and respect these decisions when executing tasks.

### A.1 Directory Structure

```text
dotfiles/
├── .git/
├── .gitignore
├── README.md                 # Quick-start guide
├── SPEC.md                   # Current project task plan
├── dotbot/                   # Git submodule
├── install.config.yaml       # Dotbot config
├── install                   # Dotbot bootstrap script
├── bin/                      # Global shell scripts (all symlinked to ~/bin)
├── docs/                     # Documentation (architecture, runbook, TODO, cheatsheets)
│   ├── ARCHITECTURE.md       # Design reference (authoritative)
│   ├── RUNBOOK.md            # Detailed usage and maintenance reference
│   ├── TODO.md               # Deferred ideas and future work
│   └── *.cheatsheet.md       # Tool cheatsheets (fzf, tmux, git, shell, kubernetes)
├── zsh/
│   ├── zshrc.zsh             # Entrypoint (symlinked to ~/.zshrc)
│   ├── lib/                  # Modular zsh config files (auto-sourced alphabetically)
│   │   ├── aliases.zsh
│   │   ├── brew.zsh
│   │   ├── completions.zsh
│   │   ├── directory_nav.zsh
│   │   ├── fzf.zsh
│   │   ├── git.zsh
│   │   ├── keybindings.zsh
│   │   ├── local.zsh.template  # Template — copy to local.zsh for per-machine shortcuts
│   │   ├── path.zsh
│   │   ├── ssh.zsh
│   │   └── theme.zsh           # fast-syntax-highlighting styles
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
    ├── claude/               # Claude Code settings and statusline
    ├── macos/                # macOS setup scripts
    ├── mise/                 # Runtime version manager config
    ├── nvim/                 # Neovim config (lazy.nvim)
    ├── ripgrep/
    ├── sheldon/              # Zsh plugin manager config
    ├── ssh/                  # SSH config template (private hosts in ~/.ssh/config.local)
    ├── starship/
    ├── tmux/
    └── vim/vimrc             # Minimal vim fallback (no plugins, remote-safe)
```

### A.2 Core Design Decisions

#### Configuration Management (Dotbot)
- `dotbot` handles all symlinking and bootstrapping via `install.config.yaml`.
- The `install` script must be 100% idempotent — safe to re-run at any time without errors or duplications.
- `install.config.yaml` symlinks at minimum: `~/.zshrc`, `~/.bashrc`, `~/.config/nvim`, and all tool configs under `config/` to their correct XDG locations.

#### Shell Environment
- **Primary:** macOS with zsh. Only fully-supported interactive shell environment.
- **Remote baseline:** `config/bash/bashrc` provides a minimal `.bashrc` for remote servers — PATH, essential aliases only. No visual elements, does not mirror the full zsh setup.
- **Entrypoint:** `zsh/zshrc.zsh` is the sole zsh entrypoint. It sources `zsh/lib/*.zsh` directly — no `shell/`, `os/`, or `env/` module tree.
- **Plugin manager:** Sheldon (`config/sheldon/`) manages zsh plugins. Homebrew dependency. Initialization guarded with `command -v sheldon > /dev/null`.

#### Machine-Specific PATH
- **Universal toolchain paths** (Homebrew, Cargo, Go, Ruby gems): defined in `zsh/lib/path.zsh`, guarded with `[[ -d /path ]]` checks.
- **Machine-specific tools** (e.g., LM Studio, Claude Code): go in `~/.env.local`, NOT committed to the repo.

#### Environment Separation (Marker Files)
- **Detection:** Marker file approach — one of `~/.work`, `~/.personal`, `~/.remote-full`, or `~/.remote` is touched during machine setup. No hostname detection.
- **Shell loader:** Sources the corresponding `env/*.zsh` file. If no marker exists, only universal config loads.
- **Dotbot install:** Runs `brew bundle` for the appropriate Brewfile(s) based on marker.
- **Marker definitions:**
  - `~/.work` — work machine (full macOS setup)
  - `~/.personal` — personal machine (full macOS setup)
  - `~/.remote-full` — Linux server with Homebrew and full tool suite
  - `~/.remote` — minimal Linux server (no Homebrew; skips Brewfiles entirely)

#### Secrets Management
- Passwords, API keys, and tokens MUST NOT be committed to version control.
- `.gitignore` must explicitly exclude `*.local`, `.env*`, `*secrets*`, and `*.key`.
- **Local override files** (both gitignored, sourced silently, skipped without error if absent):
  - `~/.env.local` — machine-specific exports, PATH additions, non-secret config
  - `~/.secrets.local` — credentials, API keys, tokens
- **Sourcing order:** `~/.env.local` first, then `~/.secrets.local` at the very end of `zshrc.zsh`.

#### Editor Configuration
- **Neovim** (`config/nvim/`): lazy.nvim-based. Intended for desktop machines. Must open without blocking errors when an LSP or external tool is missing. Full overhaul is a **separate project** — current cleanup is light-touch only.
- **Vim** (`config/vim/vimrc`): Must work on any remote server with stock vim and zero external dependencies. Sensible defaults only.

### A.3 Strict Directives

These directives must be respected during all cleanup and audit work:

1. **Interactive Shell Guards** — Guard only prompt/theme initialization behind `[[ $- == *i* ]]`. Specifically: `eval "$(starship init zsh)"` and custom prompt fallbacks MUST be wrapped. Aliases, exports, and PATH additions do NOT need wrapping (inert in non-interactive contexts). Rationale: prevents Starship escape codes from leaking into piped output from non-interactive subshells.

2. **POSIX Alias Safety** — Do NOT alias standard POSIX commands (`ls`, `cat`, `grep`) in ways that alter their default machine-readable output. Use new alias names instead (e.g., `ll` for `eza -l`, not `ls`).

3. **Git Config Simplicity** — Do not implement exotic Git hooks or `core.editor` behaviors that interrupt standard automated commit workflows.

### A.4 Acceptance Criteria

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

_No active project. This section will be populated when a new project begins._

<!--
Template for new projects:

### Phase N: Phase Name

#### N.1 — Task title
**Type:** Claude Code | Human | Collaborative

Task description.
-->

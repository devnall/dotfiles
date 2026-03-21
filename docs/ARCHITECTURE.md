# Dotfiles Architecture

> **What this file is:** A human-maintained reference document capturing the design decisions, constraints, and conventions for this dotfiles repo. It is the source of truth for how the repo is structured and why.
>
> **How to use it:** When starting a new project or task plan (SPEC.md), copy the relevant sections from this file into the spec's context/architecture section so that Claude Code (or any other tool) gets the full picture in a single file. This avoids relying on cross-file references during execution.
>
> **This file is not a task plan.** It contains no actionable work items. For current tasks, see SPEC.md. For future ideas, see docs/TODO.md.
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
├── .github/
│   └── workflows/
│       └── lint.yml          # GitHub Actions CI (pre-commit on PRs)
├── .gitignore
├── .pre-commit-config.yaml   # Pre-commit hook definitions
├── .shellcheckrc             # ShellCheck defaults (shell=bash)
├── README.md                 # Quick-start guide
├── SPEC.md                   # Current project task plan
├── dotbot/                   # Git submodule
├── install.config.yaml       # Dotbot symlink + shell command config
├── install                   # Dotbot bootstrap script
├── bin/                      # Global shell scripts (all symlinked to ~/bin)
├── docs/                     # Documentation (architecture, runbook, TODO, cheatsheets)
│   ├── ARCHITECTURE.md       # This file — design reference (not consumed by tooling)
│   ├── RUNBOOK.md            # Detailed usage and maintenance reference
│   ├── TODO.md               # Future ideas and deferred work
│   ├── *.cheatsheet.md       # Tool cheatsheets (fzf, tmux, git, shell, vim, kubernetes)
│   └── tldr/                 # Custom tealdeer pages (symlinked to ~/Library/Application Support/tealdeer/pages)
│       └── my-*.page.md     # Custom pages: my-git, my-shell, my-tmux, my-fzf, my-vim
├── zsh/
│   ├── zshrc.zsh             # Entrypoint (symlinked to ~/.zshrc)
│   ├── lib/                  # Modular zsh config files (auto-sourced alphabetically)
│   └── zfunctions/           # Autoloaded zsh functions
├── env/
│   ├── work.zsh              # Sourced when ~/.work exists
│   ├── personal.zsh          # Sourced when ~/.personal exists
│   ├── remote.zsh            # Sourced when ~/.remote exists
│   └── remote-full.zsh       # Sourced when ~/.remote-full exists
├── wallpapers/              # Default dark/light wallpapers (symlinked to ~/.local/share/wallpapers)
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
    │   ├── config            # Git config (symlinked to ~/.gitconfig)
    │   ├── ignore            # Global gitignore
    │   ├── .gitconfig-user.example  # Template for git identity (copy to .gitconfig-user)
    │   ├── .gitconfig-user   # Local git identity (gitignored)
    │   ├── .gitconfig-work.example  # Template for work identity (copy to .gitconfig-work)
    │   └── .gitconfig-work   # Work git identity (gitignored, work machines only)
    ├── macos/                # macOS setup/defaults scripts
    ├── mise/                 # Runtime version manager config
    ├── nvim/                 # Neovim config (lazy.nvim)
    │   ├── init.lua           # Bootstrap, leader, module loading
    │   ├── lazy-lock.json     # Committed plugin lockfile
    │   └── lua/
    │       ├── config/        # options, keymaps, autocmds, appearance
    │       └── plugins/       # One lazy.nvim spec per plugin concern
    ├── ripgrep/
    ├── sheldon/              # Zsh plugin manager config
    ├── ssh/                  # SSH config template (private hosts in ~/.ssh/config.local)
    ├── starship/
    ├── tmux/
    └── vim/                  # Minimal vim config (symlinked as ~/.vim)
        ├── vimrc              # Remote-safe, no plugins
        └── colors/
            └── nordicpine.vim # Dual-mode colorscheme (dark/light)
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
- **Plugin manager:** Sheldon (`config/sheldon/`) manages zsh plugins. Homebrew dependency. Initialization guarded with `command -v sheldon > /dev/null && [[ -t 1 ]]`.
- **Terminal font:** `SauceCodePro Nerd Font Mono` is installed via `Brewfile.universal` (`font-sauce-code-pro-nerd-font` cask). Required by Ghostty config and Starship prompt glyphs. Remote machines don't need it — the local terminal renders all glyphs.
- **Optional tool guards:** Tools that may not be installed on all machines (zoxide, thefuck, terraform, bat) are guarded with `command -v` checks. The installer's `bat cache --build` step is similarly guarded.

### 3.3 Machine-Specific PATH

- **Universal toolchain paths** (Homebrew, Cargo, Go user binaries): defined in `zsh/lib/path.zsh`, guarded with `[[ -d /path ]]` checks. Ruby, Node, and language runtime paths are handled by mise, not manually.
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

### 3.7 Runtime Management (mise)

- [mise](https://mise.jdx.dev/) is the single runtime manager for language toolchains: go, lua, node, python, ruby, terraform.
- Global config lives in `config/mise/config.toml`, symlinked to `~/.config/mise/config.toml` via dotbot.
- Activated in `zshrc.zsh` via `eval "$(mise activate zsh)"`, guarded with `command -v mise`.
- Per-project overrides: drop a `.mise.toml` in the project root to pin specific versions.
- **Rust** is managed by rustup, not mise (standard practice for the Rust ecosystem).
- Legacy managers (nvm, rbenv, tfenv) are quarantined in Brewfiles — mise replaces all of them.

### 3.5 Secrets Management

- Passwords, API keys, and tokens MUST NOT be committed to version control.
- `.gitignore` must explicitly exclude `*.local`, `.env*`, `*secrets*`, and `*.key`.
- **Local override files** (both gitignored, sourced silently, skipped without error if absent):
  - `~/.env.local` — machine-specific exports, PATH additions, non-secret config
  - `~/.secrets.local` — credentials, API keys, tokens
- **Sourcing order:** `~/.env.local` first, then `~/.secrets.local` at the very end of `zshrc.zsh`.

### 3.6 Editor Configuration

- **Neovim** (`config/nvim/`): Modular lazy.nvim-based config for quick-edits workflow. Structure: `lua/config/` (options, keymaps, autocmds, appearance) + `lua/plugins/` (one spec per concern). Rose Pine Dawn light colorscheme with custom NordicPine dark colorscheme with live theme switching via `ThemeSwitch` command and remote socket. Mason-managed LSP servers, blink.cmp completion, conform.nvim formatting (format on save), Telescope file finding, neo-tree explorer, gitsigns + fugitive, treesitter, which-key, mini.surround + autopairs, vim-tmux-navigator. Must open without blocking errors when an LSP, formatter, or external tool is missing.
- **Vim** (`config/vim/`): Symlinked as `~/.vim` → `config/vim/`. Must work on any remote server with stock vim and zero external dependencies. Includes `nordicpine` colorscheme (dark/light auto-detection).

### 3.8 Git Identity & Commit Signing

- **Single GitHub account:** One GitHub account for both work and personal. Employer doesn't require separation, and `includeIf`-based identity switching gives correct attribution per repo. Revisit only if employer policy changes.
- **Identity switching:** `config/git/config` uses `[includeIf "gitdir:~/code/work/"]` to load `.gitconfig-work` (work name, email, signingkey). All other repos use the default `.gitconfig-user` (personal identity). Directory convention: `~/code/work/` for work repos, `~/code/personal/` for personal repos.
- **Commit signing:** `commit.gpgsign = true` is shared config (in `config/git/config`). `user.signingkey` is per-machine, set in `.gitconfig-user` and `.gitconfig-work`. `gpg.format = ssh` — all machines target 1Password-managed SSH keys for signing.
- **`allowed_signers`:** Intentionally skipped. GitHub handles signature verification via uploaded signing keys — local verification isn't needed for this workflow.

### 3.9 CI and Linting

- **Pre-commit** (`.pre-commit-config.yaml`) runs all lint checks both locally and in CI. Single source of truth — CI calls `pre-commit run --all-files` via `pre-commit/action`.
- **Hooks:** trailing-whitespace, end-of-file-fixer, check-yaml, check-added-large-files, shellcheck (scoped to `bin/`, excluding `tunes.js` and `brew-repair`), zsh syntax check (`zsh -n` on all `.zsh` files).
- **GitHub Actions** (`.github/workflows/lint.yml`) runs on PRs targeting `main`. Uses `ubuntu-latest` (installs zsh via apt).
- **ShellCheck** (`.shellcheckrc`) defaults to `shell=bash`. No global suppressions — fix or inline-suppress case-by-case.
- **Dotbot integration:** `./install` runs `pre-commit install` (guarded with `command -v`) to set up local git hooks automatically.
- **Brewfile:** `pre-commit` is in `Brewfile.universal`.

---

## 4. Strict Directives

These directives apply to all work on this repo:

### Directive 1: Interactive Shell Guards

Two levels of guarding apply, depending on what is being loaded:

**`[[ $- == *i* ]]` — interactive shell guard**
Use for prompt/theme initialization only. Specifically: `eval "$(starship init zsh)"` and custom prompt fallbacks MUST be wrapped. Aliases, exports, and PATH additions do NOT need wrapping (inert in non-interactive contexts).

**`[[ -t 1 ]]` — real TTY guard**
Use for anything that requires ZLE (the zsh line editor) to be active: plugin loading (sheldon), fzf key-bindings and shell integration, and bashcompinit/completion setup. `zsh -i` sets the `interactive` flag but does NOT activate ZLE without a real terminal — these blocks must be guarded with `[[ -t 1 ]]` (stdout is a terminal) to avoid "can't change option: zle" warnings in non-TTY interactive contexts (e.g., test runners, vim `:terminal`, `ssh user@host 'cmd'`).

**Rationale:** Prevents escape codes and ZLE errors from leaking into piped or non-TTY subshell output.

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
9. README.md and docs/RUNBOOK.md are accurate and complete reflections of the repo's actual state.
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
| `config/git/.gitconfig-work` | Work git identity (gitignored, copy from `.gitconfig-work.example`, work machines only) |
| `README.md` | Quick-start installation guide |
| `docs/RUNBOOK.md` | Detailed usage, maintenance, and troubleshooting |
| `SPEC.md` | Current project task plan (rotates per project) |
| `docs/TODO.md` | Deferred ideas and future work |

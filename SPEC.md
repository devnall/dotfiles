# Dotfiles Architecture Specification
**File:** `SPEC.md`
**Version:** 2.0
**Context:** This project consolidates shell and tool configurations into a single, idempotent dotfiles repository managed by Dotbot. It is macOS/zsh-centric. Linux bash support is a minimal remote-server baseline only.

---

## 1. System Architecture & Directory Structure

```text
dotfiles/
├── .git/
├── .gitignore
├── SPEC.md
├── dotbot/                   # Git submodule
├── install.config.yaml       # Dotbot config
├── install                   # Dotbot bootstrap script
├── bin/                      # Global shell scripts (all symlinked to ~/bin)
├── archive/                  # Deprecated configs — to be reviewed/culled
├── docs/                     # Documentation
├── zsh/
│   ├── zshrc.zsh             # Entrypoint (symlinked to ~/.zshrc)
│   ├── lib/                  # Modular zsh config files
│   │   ├── aliases.zsh
│   │   ├── brew.zsh
│   │   ├── completions.zsh
│   │   ├── directory_nav.zsh
│   │   ├── fzf.zsh
│   │   ├── git.zsh
│   │   ├── history.zsh
│   │   ├── path.zsh
│   │   ├── ssh.zsh
│   │   └── work.zsh          # Work-specific config (sourced on work machines only)
│   └── zfunctions/           # Autoloaded zsh functions
├── env/
│   ├── work.zsh              # Work-specific shell overrides
│   ├── personal.zsh          # Personal-specific shell overrides
│   ├── remote.zsh            # Remote server baseline overrides
│   └── remote-full.zsh       # Remote servers with Homebrew + full tool suite
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
    ├── macos/                # macOS setup scripts
    ├── nvim/                 # Neovim config (lazy.nvim, full IDE)
    ├── sheldon/              # Zsh plugin manager config
    ├── starship/
    ├── tmux/
    └── vim/vimrc             # Minimal vim fallback (no plugins, remote-safe)
```

---

## 2. Core Requirements

### 2.1 Configuration Management (Dotbot)

- **Tool:** Use `dotbot` for symlinking and bootstrapping.
- **Idempotency:** The `install` script and `install.config.yaml` execution must be 100% idempotent. Running the install script multiple times must yield the exact same system state without errors or duplications.
- **Symlink targets:** `install.config.yaml` must symlink at minimum: `~/.zshrc`, `~/.bashrc`, `~/.config/nvim`, and all tool configs under `config/` to their correct XDG locations.

### 2.2 Shell Environment

- **Primary:** macOS with zsh. This is the only fully-supported interactive shell environment.
- **Remote baseline:** `config/bash/bashrc` provides a minimal `.bashrc` for remote servers — PATH, essential aliases only. It does NOT mirror the full zsh setup and has no visual elements.
- **Entrypoint:** `zsh/zshrc.zsh` is the sole zsh entrypoint. It sources `zsh/lib/*.zsh` directly — there is no `shell/`, `os/`, or `env/` module tree.
- **Plugin manager:** Sheldon (`config/sheldon/`) manages zsh plugins. It is a Homebrew dependency. `zshrc.zsh` guards its initialization with `command -v sheldon > /dev/null`.

#### Machine-Specific PATH

- **Universal toolchain paths** (Homebrew, Cargo, Go, Ruby gems): defined in `zsh/lib/path.zsh`, guarded with `[[ -d /path ]]` checks.
- **Machine-specific tools** (e.g., LM Studio `~/.cache/lm-studio/bin`, Claude Code `~/.local/bin`): go in `~/.env.local`, NOT committed to the repo.

### 2.3 Environment Separation (Work vs. Personal)

- **Detection:** A marker file approach — one of `~/.work`, `~/.personal`, `~/.remote-full`, or `~/.remote` is touched during machine setup. No hostname detection or `.env.local` inspection for environment type.
- **Shell loader:** Sources the corresponding `env/*.zsh` file based on marker file existence. If no marker exists, only universal config loads.
- **Dotbot install:** Runs `brew bundle --file=packages/Brewfile.work` or `Brewfile.personal` based on the same marker file.
- **Brewfiles:**
  - `Brewfile.universal` — always installed
  - `Brewfile.work` — installed when `~/.work` exists
  - `Brewfile.personal` — installed when `~/.personal` exists
- **Marker files:**
  - `~/.work` — work machine (full macOS setup)
  - `~/.personal` — personal machine (full macOS setup)
  - `~/.remote-full` — Linux server with Homebrew and full tool suite installed
  - `~/.remote` — minimal Linux server (no Homebrew; skips Brewfiles entirely)

### 2.4 Secrets Management

- **Strict Exclusion:** Passwords, API keys, and tokens MUST NOT be committed to version control.
- **`.gitignore`:** Must explicitly exclude `*.local`, `.env*`, `*secrets*`, and `*.key`. (The previous exclusion of only `secrets.txt` and `local.zsh` is insufficient.)
- **Local override files** (both gitignored):
  - `~/.env.local` — machine-specific exports, PATH additions, non-secret config
  - `~/.secrets.local` — credentials, API keys, tokens
- **Sourcing order:** `~/.env.local` first, then `~/.secrets.local` at the very end of `zshrc.zsh`. Both must be sourced silently — skipped without error if absent.

### 2.5 Editor Configuration

#### Neovim (Full IDE)
- Config lives in `config/nvim/`, using lazy.nvim as the plugin manager.
- Intended for desktop machines. Includes LSPs, Telescope, AI plugins, rose-pine theme.
- **Graceful degradation:** Must open without blocking errors when an LSP or external tool is missing.

#### Vim (Remote Fallback)
- Config lives in `config/vim/vimrc`.
- Must work on any remote server with stock vim and zero external dependencies — no vim-plug, no NERDTree, no airline, no syntastic.
- Keep: sensible defaults, formatting settings, split/visual settings, no-backup/no-swap.

---

## 3. Strict Directives

### Directive 3.1: Interactive Shell Guards

- **Scope:** Guard only prompt/theme initialization behind `[[ $- == *i* ]]`.
- **Specifically:** `eval "$(starship init zsh)"` and any custom prompt fallback MUST be wrapped in an interactive check.
- **Not required:** Aliases, exports, and PATH additions — these are inert in non-interactive contexts and do not need to be wrapped.
- **Rationale:** Prevents Starship escape codes from leaking into piped output from non-interactive subshells (e.g., vim `:terminal`, tmux job control, `ssh user@host 'cmd'`).

### Directive 3.2: POSIX Alias Safety

- Do NOT alias standard POSIX commands (`ls`, `cat`, `grep`) in ways that alter their default machine-readable output. Use new alias names instead (e.g., `ll` for `eza -l`, not `ls`).

### Directive 3.3: Git Config Simplicity

- Do not implement exotic Git hooks or `core.editor` behaviors that interrupt standard automated commit workflows.

---

## 4. Acceptance Criteria

1. `install.config.yaml` successfully symlinks `~/.zshrc`, `~/.bashrc`, `~/.config/nvim`, and all tool configs to their correct locations.
2. Shell starts without errors on macOS with zsh.
3. Non-interactive subshells do not emit prompt escape codes or extraneous output.
4. `brew bundle --file=packages/Brewfile.universal` installs cleanly; work/personal Brewfiles install conditionally based on marker file (`~/.work` or `~/.personal`).
5. Neovim opens without blocking errors even when LSPs are absent.
6. `~/.env.local` and `~/.secrets.local` are sourced silently if present, silently skipped if absent.
7. Marker file controls which env config loads: `~/.work` → `env/work.zsh`, `~/.personal` → `env/personal.zsh`, `~/.remote-full` → `env/remote-full.zsh`, `~/.remote` → `env/remote.zsh`; if none exists, only universal config loads.

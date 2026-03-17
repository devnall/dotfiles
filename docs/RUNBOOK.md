# Dotfiles Runbook

Detailed reference for setting up, using, and maintaining these dotfiles.

---

## New Machine Setup

### 1. Install Homebrew

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Add brew to your shell (follow the post-install instructions, or use the appropriate line below):

```sh
# Apple Silicon
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile

# Intel
echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zprofile
```

### 2. Clone the repo

```sh
git clone git@github.com:devnall/dotfiles.git --recursive ~/.dotfiles
```

### 3. Set machine type

Touch a marker file before running the installer — this controls which env config and Brewfile load:

```sh
touch ~/.work         # work machine (full macOS setup)
# or
touch ~/.personal     # personal machine (full macOS setup)
# or
touch ~/.remote-full  # Linux server with Homebrew + full tool suite
# or
touch ~/.remote       # minimal Linux server (skips Homebrew; see Remote/Server Setup below)
```

If none exists, only the universal config loads. You can switch at any time and re-run `./install`.

### 4. Run the installer

```sh
cd ~/.dotfiles && ./install
```

This will:
- Create all symlinks (zshrc, nvim, tmux, ghostty, starship, bat, btop, etc.)
- Run `brew bundle` for `Brewfile.universal`, plus `Brewfile.work` or `Brewfile.personal` based on the marker file

### 5. Set up git identity

Git config includes `config/git/.gitconfig-user` for your personal identity. That file is
gitignored — copy the template and fill it in:

```sh
cp ~/.dotfiles/config/git/.gitconfig-user.example ~/.dotfiles/config/git/.gitconfig-user
```

Then edit `~/.dotfiles/config/git/.gitconfig-user`:

```ini
[user]
  name = Your Name
  email = you@example.com
  signingkey = YOUR_SSH_KEY_PATH_OR_GPG_ID
```

This file is excluded from git tracking. The template (`.gitconfig-user.example`) is what's committed to the repo.

### 6. Install runtimes (mise)

After the installer runs, mise is activated but runtimes aren't installed yet:

```sh
mise install
```

This installs all tools defined in `~/.config/mise/config.toml` (go, lua, node, python, ruby, terraform). Verify with `mise ls`.

### 7. Set up local overrides

Create these files — both are gitignored and sourced at the end of every shell session:

| File | Purpose |
|------|---------|
| `~/.env.local` | Machine-specific exports, PATH additions, non-secret config |
| `~/.secrets.local` | API keys, tokens, credentials — never commit these |

Example `~/.env.local`:
```sh
export PATH="$PATH:$HOME/.cache/lm-studio/bin"
export AWS_DEFAULT_REGION=us-east-1
```

---

## How Things Work

### Environment separation

```
~/.work exists         → sources env/work.zsh + installs packages/Brewfile.work
~/.personal exists     → sources env/personal.zsh + installs packages/Brewfile.personal
~/.remote-full exists  → sources env/remote-full.zsh + installs packages/Brewfile.universal
~/.remote exists       → sources env/remote.zsh + skips Homebrew/Brewfiles entirely
none exists            → only universal config loads
```

The marker file is checked at shell startup (for env sourcing) and at install time (for Brewfiles). To switch machine type: remove the old marker, touch the new one, re-run `./install`.

### zsh lib loading

All files in `zsh/lib/` are sourced automatically by `zshrc.zsh` in alphabetical order. If you add a new `zsh/lib/*.zsh` file it will be picked up automatically. Machine-type-specific config goes in `env/*.zsh` instead.

### SSH config

`config/ssh/config` is symlinked to `~/.ssh/config`. It contains the universal `Host *` block (1Password SSH agent) and an `Include ~/.ssh/config.local` directive.

Machine-specific hosts (private IPs, internal hostnames, jump hosts) go in `~/.ssh/config.local` on each machine — this file is not tracked by dotfiles.

```
# ~/.ssh/config.local — machine-specific, not committed
Host myalias
  HostName example.internal
  User myuser
  ForwardAgent yes
```

### Editors

- **Neovim** (`config/nvim/`) — lazy.nvim-based IDE setup, used on desktop machines
- **Vim** (`config/vim/vimrc`) — minimal, no plugins, safe to use on any remote server with stock vim

---

## Remote/Server Setup

For Linux servers accessed via SSH — same muscle memory, no Homebrew required.

### 1. Clone the repo

```sh
git clone git@github.com:devnall/dotfiles.git --recursive ~/.dotfiles
```

### 2. Set the remote marker

```sh
touch ~/.remote
```

Do this **before** running `./install`. The marker causes Homebrew setup and all Brewfile installs to be skipped entirely.

### 3. Run the installer

```sh
cd ~/.dotfiles && ./install
```

This creates all symlinks. Homebrew and Brewfile steps are skipped.

**Prerequisites:** `git`, `zsh`, and `python3` must be installed (python3 is required by dotbot).

### What you get

| Feature | Behavior |
|---------|----------|
| zsh history, dirstack, setopt | all portable |
| `zsh/lib/aliases.zsh` | Darwin-specific blocks skip via `uname` checks |
| `zsh/lib/git.zsh` | git aliases work everywhere |
| `zsh/lib/fzf.zsh` | skips silently if fzf not installed |
| starship prompt | skips if not installed; falls back to system prompt |
| zoxide, thefuck, terraform completions | skip if not installed (guarded with `command -v`) |
| bat theme cache | skips if bat not installed |
| Homebrew PATH | harmless on Linux (`/usr/local` typically exists) |
| Brewfile installs | skipped via `~/.remote` guard |

### Optional nice-to-haves (single-binary installs)

```sh
# starship — cross-platform prompt
curl -sS https://starship.rs/install.sh | sh

# fzf — fuzzy finder
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install

# zoxide — smarter cd
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
```

---

## Re-running the Installer

The installer is idempotent — safe to run at any time:

```sh
cd ~/.dotfiles && ./install
```

Run it after:
- Pulling new changes from the repo
- Adding new entries to `install.config.yaml`
- Switching machine type (touching a different marker file)

---

## Directory Structure

```
dotfiles/
├── install                   # Dotbot bootstrap script
├── install.config.yaml       # Dotbot symlink + shell command config
├── bin/                      # Scripts symlinked to ~/bin
├── docs/                     # Cheatsheets (fzf, tmux, git, shell, kubernetes)
├── env/
│   ├── work.zsh              # Sourced when ~/.work exists
│   ├── personal.zsh          # Sourced when ~/.personal exists
│   ├── remote-full.zsh       # Sourced when ~/.remote-full exists (Linux + Homebrew)
│   └── remote.zsh            # Sourced when ~/.remote exists (minimal Linux servers)
├── packages/
│   ├── Brewfile.universal    # Installed on every machine
│   ├── Brewfile.work         # Installed when ~/.work exists
│   └── Brewfile.personal     # Installed when ~/.personal exists
├── zsh/
│   ├── zshrc.zsh             # Symlinked to ~/.zshrc
│   ├── lib/                  # Auto-sourced by zshrc (alphabetical order)
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
│   │   └── theme.zsh           # fast-syntax-highlighting styles + color config
│   └── zfunctions/           # Autoloaded zsh functions
└── config/
    ├── bash/bashrc           # Minimal bash (remote server baseline)
    ├── bat/
    ├── btop/
    ├── ghostty/
    ├── git/                  # Git config + identity template (.gitconfig-user.example)
    ├── macos/                # macOS setup scripts
    ├── mise/                 # Runtime version manager config
    ├── nvim/                 # Neovim config (lazy.nvim)
    ├── ripgrep/
    ├── sheldon/              # Zsh plugin manager config
    ├── ssh/                  # SSH config template (private hosts in ~/.ssh/config.local)
    ├── starship/
    ├── tmux/
    └── vim/vimrc             # Minimal vim fallback
```

---

## Maintenance

### Update Homebrew packages

```sh
bubu  # brew update && brew upgrade
brew bundle --file=~/.dotfiles/packages/Brewfile.universal
# plus Brewfile.work or Brewfile.personal as appropriate
```

### Check for Brewfile drift

Packages accumulate outside the Brewfile over time. Audit with:

```sh
brew bundle check --file=~/.dotfiles/packages/Brewfile.universal
brew bundle cleanup --file=~/.dotfiles/packages/Brewfile.universal  # shows what would be removed
brew bundle cleanup --force --file=~/.dotfiles/packages/Brewfile.universal  # actually removes them
```

### Update tmux plugins

Tmux plugins are managed as git submodules under `config/tmux/plugins/`. To update a single plugin:

```sh
cd ~/.dotfiles
git submodule update --remote config/tmux/plugins/<plugin-name>
git add config/tmux/plugins/<plugin-name>
git commit -m "⬆️ Update <plugin-name>"
```

To update all tmux plugins at once:

```sh
cd ~/.dotfiles
git submodule update --remote config/tmux/plugins/
git add config/tmux/plugins/
git commit -m "⬆️ Update tmux plugins"
```

### Update dotbot submodule

```sh
cd ~/.dotfiles
git submodule update --remote dotbot
git add dotbot
git commit -m "update dotbot submodule"
```

### Sync Neovim plugins

```sh
nvim --headless "+Lazy sync" +qa
```

### Update mise runtimes

```sh
mise upgrade        # upgrade all installed runtimes to latest
mise ls             # show currently installed versions
mise doctor         # health check
```

### Pin a runtime version per-project

Drop a `.mise.toml` in the project root:

```toml
[tools]
node = "20"
python = "3.12"
```

Then run `mise install` in that directory. mise activates the correct versions automatically when you `cd` into the project.

### Update sheldon plugins

```sh
sheldon lock --update
```

### Benchmark shell startup time

```sh
for i in 1 2 3 4 5; do /usr/bin/time -p script -q /dev/null zsh -i -c exit 2>&1 | grep real; done
```

Use `script` to allocate a real PTY — sheldon and fzf key-bindings are guarded behind `[[ -t 1 ]]` and won't load in a plain `zsh -i -c exit` without a terminal, making that command an undercount. Discard the first run (cold cache). A clean startup should be under ~500ms.

**Baseline (March 2026, M-series Mac):** ~320ms (warm cache). Main contributors are sheldon plugin initialization (fast-syntax-highlighting, forgit, zsh-autosuggestions) and thefuck. Revisit if it climbs above ~500ms.

---

## Adding New Things

### New Homebrew package

Add to the appropriate Brewfile and run `./install` (or `brew bundle` directly):

- `packages/Brewfile.universal` — install everywhere
- `packages/Brewfile.work` — work machines only
- `packages/Brewfile.personal` — personal machines only

### New zsh config

Drop a file in `zsh/lib/yourfile.zsh` — it will be sourced automatically next shell start. No changes to `zshrc.zsh` needed. For work-only config, add to `env/work.zsh` instead.

### New tool config

1. Add config files under `config/toolname/`
2. Add a symlink entry to `install.config.yaml`
3. Run `./install`

### New bin script

Drop it in `bin/` — Dotbot glob-symlinks the whole directory to `~/bin`, so it's in PATH after `./install`.

---

## Secrets Hygiene

- **Never commit secrets.** Tokens, passwords, and keys go in `~/.secrets.local`.
- **Non-secret machine config** (tool paths, env vars, region defaults) goes in `~/.env.local`.
- Both are covered by the `*.local` gitignore pattern and sourced silently at shell startup.
- If you accidentally commit a secret: rotate it immediately, then scrub it from git history.
- **Git identity** (`name`, `email`, `signingkey`) lives in `config/git/.gitconfig-user` — gitignored, never tracked. Copy from `config/git/.gitconfig-user.example` on each new machine.

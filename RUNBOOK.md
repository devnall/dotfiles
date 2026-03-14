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

### 6. Set up local overrides

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
~/.remote-full exists  → sources env/remote-full.zsh (Linux server with Homebrew + full tool suite)
~/.remote exists       → sources env/remote.zsh + skips Homebrew/Brewfiles entirely
none exists            → only universal config loads
```

The marker file is checked at shell startup (for env sourcing) and at install time (for Brewfiles). To switch machine type: remove the old marker, touch the new one, re-run `./install`.

### zsh lib loading

All files in `zsh/lib/` are sourced automatically by `zshrc.zsh` in alphabetical order, **except** `work.zsh` — that one loads only when `~/.work` exists. If you add a new `zsh/lib/*.zsh` file it will be picked up automatically.

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

### What you get

| Feature | Behavior |
|---------|----------|
| zsh history, dirstack, setopt | all portable |
| `zsh/lib/aliases.zsh` | Darwin-specific blocks skip via `uname` checks |
| `zsh/lib/git.zsh` | git aliases work everywhere |
| `zsh/lib/fzf.zsh` | skips silently if fzf not installed |
| starship prompt | skips if not installed; falls back to system prompt |
| zoxide, thefuck | skip if not installed (guarded with `command -v`) |
| ssh-agent | works; `-K` Keychain flag is Darwin-only |
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
├── archive/                  # Deprecated scripts — review and cull periodically
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
│   ├── lib/                  # Auto-sourced by zshrc
│   │   ├── aliases.zsh
│   │   ├── brew.zsh
│   │   ├── completions.zsh
│   │   ├── directory_nav.zsh
│   │   ├── fzf.zsh
│   │   ├── git.zsh
│   │   ├── history.zsh
│   │   ├── path.zsh
│   │   ├── ssh.zsh
│   │   └── work.zsh          # Not auto-sourced; loaded via marker file
│   └── zfunctions/           # Autoloaded zsh functions
└── config/
    ├── bash/bashrc           # Minimal bash (remote server baseline)
    ├── bat/
    ├── btop/
    ├── ghostty/
    ├── git/
    ├── macos/                # macOS setup scripts
    ├── nvim/                 # Neovim config (lazy.nvim)
    ├── sheldon/              # Zsh plugin manager config
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

### Audit archive/

Scripts in `archive/` are no longer on the active path. Review occasionally and delete anything you're confident is dead:

```sh
ls ~/.dotfiles/archive/
```

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

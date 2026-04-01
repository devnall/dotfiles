# Dotfiles Runbook

Detailed reference for setting up, using, and maintaining these dotfiles.

---

## New Machine Setup

### 1. Clone the repo

```sh
git clone git@github.com:devnall/dotfiles.git --recursive ~/.dotfiles
```

### 2. Run bootstrap

```sh
cd ~/.dotfiles && ./bin/bootstrap.sh
```

The bootstrap wizard is interactive and idempotent — it skips anything already done. It handles:

- **Xcode CLT check** (macOS) — warns if missing, prints the install command
- **Submodules** — initializes `dotbot/` if empty
- **Machine type** — prompts you to choose work / personal / remote-full / remote and creates the marker file (`~/.work`, etc.). Controls which env config and Brewfile load at install time
- **Homebrew** — offers to install on macOS / remote-full machines
- **Git identity** — copies `config/git/.gitconfig-user.example` → `.gitconfig-user` if missing. Edit this file with your name, email, and signingkey
- **Code directories** — creates `~/code/personal/` on all machines, `~/code/work/` on work machines only
- **Work git identity** (work machines only) — copies `config/git/.gitconfig-work.example` → `.gitconfig-work` if missing. Edit with your work name, email, and signingkey
- **Stub files** — creates `~/.env.local`, `~/.secrets.local`, `~/.ssh/config.local`, `~/.claude/settings.local.json`, and `packages/Brewfile.local` with commented templates if they don't exist
- **Display type detection** (macOS) — detects ultrawide vs widescreen displays, stores fallback at `~/.local/state/display-type`
- **Wallpapers repo** (macOS) — prompts to clone the wallpapers repo to `~/Pictures/wallpapers/` for folder-based rotation. Validates existing clones (correct remote, has images)
- **Mise runtimes** — offers to run `mise install` to provision language toolchains

### 3. Run the installer

```sh
./install
```

This will:
- Create all symlinks (zshrc, nvim, tmux, ghostty, starship, bat, btop, etc.)
- Run `brew bundle` for `Brewfile.universal`, plus `Brewfile.work` or `Brewfile.personal` based on the marker file, plus `Brewfile.local` if it exists

### 4. Install runtimes

```sh
mise install
```

Installs all tools defined in `~/.config/mise/config.toml` (go, lua, node, python, ruby, terraform). Bootstrap offers to run this for you if mise is already available. Verify with `mise ls`.

### 5. Apply macOS defaults (optional)

```sh
bash config/macos/defaults.sh
```

Applies preferred system preferences: Dock (auto-hide, small icons, no recents), Finder (list view, show hidden files, extensions), keyboard repeat rate, tap-to-click, three-finger drag, screenshot location (`~/Pictures/Screenshots`), Mission Control (no hot corners, stable Spaces), and menu bar clock (24-hour, no date).

The script is idempotent and prompts before applying. It is **not** called by `./install` — run it manually on new machines. Most settings take effect immediately; input settings (key repeat, trackpad) may require logout or restart.

**After macOS upgrades:** Re-run the script after major upgrades (e.g. Sequoia). Major upgrades occasionally reset Dock, trackpad, and input settings. Minor updates almost never touch them. If a setting doesn't take effect after re-running, Apple likely changed or dropped the key — check `defaults read <domain>` to find the new key name.

**Backup/restore:** Before running, you can snapshot current values:

```sh
defaults export com.apple.dock /tmp/dock-backup.plist       # backup
defaults import com.apple.dock /tmp/dock-backup.plist        # restore
killall Dock                                                  # apply
```

### Quick reference

| File | Purpose |
|------|---------|
| `~/.work` / `~/.personal` / `~/.remote-full` / `~/.remote` | Machine type marker (created by bootstrap) |
| `config/git/.gitconfig-user` | Git identity — name, email, signingkey (gitignored) |
| `config/git/.gitconfig-work` | Work git identity — work machines only (gitignored) |
| `~/.env.local` | Machine-specific exports, PATH additions, non-secret config |
| `~/.secrets.local` | API keys, tokens, credentials — never commit |
| `~/.ssh/config.local` | Per-machine SSH host entries (not tracked) |
| `~/.claude/settings.local.json` | Machine-specific Claude Code config (deep-merged with settings.json) |

### Local files: backup & migration

These untracked files contain machine-specific config that won't survive a wipe or new-machine setup. Back them up to 1Password (or your vault of choice) periodically and before migrating.

| File | What to back up | Sensitive? |
|------|----------------|-----------|
| `~/.work` / `~/.personal` / `~/.remote*` | Just remember which marker to `touch` | No |
| `~/.env.local` | Full file contents | Maybe |
| `~/.secrets.local` | Full file contents | **Yes** — store in 1Password |
| `~/.ssh/config.local` | Full file contents | Maybe |
| `config/git/.gitconfig-user` | name, email, signingkey values | No |
| `config/git/.gitconfig-work` | name, email, signingkey values (work machines) | No |
| `packages/Brewfile.local` | Full file contents | No |
| `~/.claude/settings.local.json` | Full file contents | Maybe |
| `~/.local/state/display-type` | Single word (`widescreen` / `ultrawide`) — auto-detected, low priority | No |

**Recommended workflow:** Create a secure note in 1Password called "dotfiles local config — \<machine name\>" and paste the contents of each file. Update it when you make significant changes to any local file. On a new machine, run `bootstrap.sh` first (creates stubs), then paste saved contents into each file.

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

The `IdentityAgent` path uses `~/.1p-agent.sock` — a no-space symlink created by `./install` pointing to the real 1Password socket at `~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock`. The symlink is needed because the space in that path breaks `SSH_AUTH_SOCK` sourcing in some env files.

Machine-specific hosts (private IPs, internal hostnames, jump hosts) go in `~/.ssh/config.local` on each machine — this file is not tracked by dotfiles.

```
# ~/.ssh/config.local — machine-specific, not committed
Host myalias
  HostName example.internal
  User myuser
  ForwardAgent yes
```

### 1Password CLI (`op`)

The `op` CLI is installed via Homebrew and shell completions are wired in `zsh/lib/completions.zsh`.

**Common commands:**

```sh
op vault list                          # list available vaults
op item list                           # list all items
op item list --vault Private           # list items in a specific vault
op item get "Item Name"                # show full item details
op read "op://VaultName/Item/field"    # read a single secret value (scriptable)
```

**SSH agent integration:** The 1Password SSH agent is configured in `config/ssh/config` via `IdentityAgent` — see the [SSH config](#ssh-config) section above. Keys are managed in 1Password and served to SSH transparently.

**Touch ID / biometric prompts:** The `op` CLI and SSH agent trigger macOS biometric prompts (Touch ID or password) when accessing secrets. This is expected 1Password security behavior, not a bug or misconfiguration.

**`gh` auth in non-TTY shells:** The `op` plugin wrapper for `gh` is guarded behind a TTY check (`[[ -t 1 ]]`) to prevent biometric popups in IDE/editor subshells. This means `gh` in non-interactive contexts uses its own stored token. Run `gh auth login` once per machine to set this up.

### Commit Signing with 1Password SSH Keys

All commits are signed (`commit.gpgsign = true` in shared git config, `gpg.format = ssh`). Each machine needs its `user.signingkey` set to the SSH public key string from 1Password.

**Setup (per machine):**

1. Open 1Password → find your SSH key item → copy the public key (starts with `ssh-ed25519 AAAA...`)
2. Paste it as the `signingkey` value in `config/git/.gitconfig-user`:
   ```ini
   [user]
     name = Your Name
     email = you@example.com
     signingkey = ssh-ed25519 AAAA...your-key-here
   ```
3. On work machines, do the same in `config/git/.gitconfig-work` with your work email and key
4. Upload the signing key to GitHub: Settings → SSH and GPG keys → New SSH key → select **Signing Key** as the key type
5. Verify signing works:
   ```sh
   echo "test" | git commit-tree HEAD^{tree}   # should not error
   git log --show-signature -1                   # or check GitHub for "Verified" badge
   ```

**Note:** `allowed_signers` is intentionally not configured. GitHub handles signature verification via uploaded signing keys — local `git log --show-signature` won't show "Good signature" without it, but GitHub's Verified badge works.

### Directory Convention (Work / Personal)

Repos are organized by identity under `~/code/`:

```
~/code/
├── work/       # Work repos — git uses work identity (name, email, signingkey)
└── personal/   # Personal repos — git uses personal identity (default)
```

The `~/code/work/` directory triggers `includeIf` in git config, loading `.gitconfig-work` which overrides `user.name`, `user.email`, and `user.signingkey` for all repos cloned there. Repos anywhere else use the default personal identity from `.gitconfig-user`.

Bootstrap creates these directories automatically (`~/code/work/` only on work machines).

### Editors

- **Neovim** (`config/nvim/`) — modular lazy.nvim-based config (see `docs/nvim.cheatsheet.md` for keymaps)
- **Vim** (`config/vim/`) — minimal, no plugins, safe to use on any remote server with stock vim. Symlinked as `~/.vim` → `config/vim/` (vim auto-finds `~/.vim/vimrc`)
  - **Colorscheme:** `nordicpine` — dual-mode (NordicPine dark / AlpineDawn light), auto-detects macOS appearance, defaults to dark on Linux/remote
  - **Colors directory:** `config/vim/colors/nordicpine.vim` — available automatically via the `~/.vim` symlink
- **Aliases:** `vim` and `e` are aliased to `nvim` on machines where neovim is installed (interactive shells only; `$EDITOR` remains `vim`)

---

## Theme Switching (Dark/Light)

Automatic dark/light theme switching is driven by `dark-notify`, which listens for macOS appearance changes and calls `bin/theme-switch`.

### How it works

```
macOS appearance change
  → dark-notify (LaunchAgent: com.dnall.dark-notify)
    → bin/theme-switch "dark"|"light"
      ├─ writes ~/.local/state/appearance
      ├─ tmux: sources tmux-nordic.conf or tmux-alpine.conf (immediate)
      ├─ neovim: sends ThemeSwitch to all running instances via socket (immediate)
      ├─ btop: seds color_theme in btop.conf (next launch)
      └─ starship: seds palette line in starship.toml (next prompt)

Existing shell sessions:
  → precmd hook in theme.zsh reads ~/.local/state/appearance
  → re-applies syntax highlighting + autosuggestion colors if changed

Desktop wallpaper (macOS):
  → desktoppr sets wallpaper from tier 2 folder or tier 1 single image
```

### Tools and their response time

| Tool | Switches when |
|------|---------------|
| Ghostty | Immediately (native macOS support) |
| bat | Immediately (`--theme=auto:system`) |
| tmux | Immediately (theme-switch sources conf) |
| starship | Next prompt |
| Neovim | Immediately (theme-switch sends ThemeSwitch via socket) |
| Desktop wallpaper | Immediately (desktoppr) |
| zsh syntax highlighting | Next prompt |
| btop | Next launch |

### Troubleshooting

**LaunchAgent not running:**
```sh
launchctl list | grep dark-notify
# If missing:
launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/com.dnall.dark-notify.plist
```

**Manual trigger:**
```sh
~/.dotfiles/bin/theme-switch dark   # or light
```

### Wallpapers

**Tier 1 (default):** Default dark + light wallpapers (`dark.jpg`, `light.jpg`) are committed to `wallpapers/`, which is symlinked to `~/.local/share/wallpapers/` by dotbot. `theme-switch` picks `dark.jpg` or `light.jpg` based on current mode. To replace defaults, swap with your preferred images (`.jpg` or `.png`).

**Tier 2 (folder rotation):** Clone the wallpapers repo for multi-wallpaper rotation. `bootstrap.sh` prompts for this, or run manually:

```sh
bin/wallpaper-setup
```

This clones `https://github.com/devnall/wallpapers.git` to `~/Pictures/wallpapers/` and validates the folder structure. When a tier 2 folder exists with images, `theme-switch` passes the folder to `desktoppr` for rotation.

**Display type:** Auto-detected per display at runtime (ultrawide = aspect ratio >= 2:1). Mixed setups (ultrawide + widescreen) are handled automatically. Fallback stored at `~/.local/state/display-type` (defaults to `widescreen`).


**Manual set:**
```sh
desktoppr ~/.local/share/wallpapers/dark.jpg
```

**Check state file:**
```sh
cat ~/.local/state/appearance
```

**Logs:**
```sh
cat /tmp/dark-notify.log
```

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

## Troubleshooting `./install`

The installer is a thin wrapper around dotbot. Most failures are environmental.

**Debug output:**
```sh
./install --verbose
```

**Common failures:**

| Symptom | Cause | Fix |
|---------|-------|-----|
| `python3: command not found` | dotbot requires Python 3 | Install Python 3 (`brew install python3` or distro package manager) |
| `fatal: no submodule mapping found` | stale or uninitialized dotbot submodule | `git submodule update --init --recursive` |
| `Error: <target> already exists and is not a link` | real file at symlink target (and `force` not set) | Back up the file, remove it, re-run `./install` |
| Link succeeds but points to nothing | config file was moved or deleted in repo | Check `git status` for missing tracked files |

**Safe to re-run:** The installer is idempotent by design — re-running it won't duplicate symlinks, re-install already-installed Homebrew packages, or overwrite user-customizable configs (starship, ripgrep, bat, btop).

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
├── bin/                      # Scripts symlinked to ~/bin (includes bootstrap wizard)
├── docs/                     # Cheatsheets, tldr custom pages, architecture docs
├── env/
│   ├── work.zsh              # Sourced when ~/.work exists
│   ├── personal.zsh          # Sourced when ~/.personal exists
│   ├── remote-full.zsh       # Sourced when ~/.remote-full exists (Linux + Homebrew)
│   └── remote.zsh            # Sourced when ~/.remote exists (minimal Linux servers)
├── wallpapers/              # Default dark/light wallpapers (symlinked to ~/.local/share/wallpapers)
├── packages/
│   ├── Brewfile.universal    # Installed on every machine
│   ├── Brewfile.work         # Installed when ~/.work exists
│   ├── Brewfile.personal     # Installed when ~/.personal exists
│   └── Brewfile.local        # Machine-specific (gitignored, create per machine)
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
    ├── mise/                 # Runtime version manager config
    ├── nvim/                 # Neovim config (lazy.nvim)
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

---

## Maintenance

### Symlink modes (`force` vs `relink`)

Dotbot's `relink: true` (the default in this repo) removes stale symlinks and recreates them, but will not overwrite a real file at the target path. `force: true` removes whatever is at the target — file, directory, or symlink — and replaces it with the managed symlink.

**Convention:** Use `force: true` for repo-authoritative configs (shell, editors, git, ssh, tmux) where the repo is always the source of truth. Use the default (no `force`) for user-customizable configs (starship, ripgrep, bat, btop) that are initialized from defaults but may be edited locally.

### Update Homebrew packages

```sh
bubu  # brew update && brew upgrade
brew bundle --file=~/.dotfiles/packages/Brewfile.universal
# plus Brewfile.work or Brewfile.personal as appropriate
```

### Check for Brewfile drift

Run the audit script to get a full drift report:

```sh
brew-audit
```

This compares `brew leaves`, `brew list --cask`, and `mas list` against all applicable Brewfiles (auto-detected from marker file). Output is grouped into:

1. Installed formulae not in any Brewfile
2. Installed casks not in any Brewfile
3. Installed MAS apps not in any Brewfile
4. Brewfile entries not installed on this machine
5. Apps in /Applications not managed by Homebrew or MAS

**When to run:** After major Brewfile changes, when setting up a new machine, or periodically (quarterly).

**Decision framework for each finding:**
- **Add to Brewfile** — if you want it tracked and installed on new machines
- **Quarantine** — if unsure; comment it out with a datestamp (delete after 6 months if still unused)
- **Uninstall** — `brew uninstall <name>` for packages you no longer need
- **Leave as manual** — for vendor-installed apps (audio production, drivers) that aren't in Homebrew

For targeted drift checks, `brew bundle` commands are also available:

```sh
brew bundle check --file=~/.dotfiles/packages/Brewfile.universal
brew bundle cleanup --file=~/.dotfiles/packages/Brewfile.universal  # shows what would be removed
brew bundle cleanup --force --file=~/.dotfiles/packages/Brewfile.universal  # actually removes them
```

### Mac App Store apps

MAS apps are tracked in Brewfiles using `mas "App Name", id: 123456` syntax. The `mas` CLI is installed via `Brewfile.universal`.

```sh
mas list                    # list installed MAS apps with IDs
mas search "App Name"       # find an app's ID
```

`brew bundle` handles `mas` entries automatically alongside formulae and casks. Requirements:
- Must be signed into the Mac App Store
- Paid apps must have been purchased previously (mas cannot buy apps)
- `mas install` may fail silently for apps with no compatible version; `brew bundle` skips failures without blocking

### Manual applications (personal machines)

Some apps are not available via Homebrew or the Mac App Store, or have stunted features if installed via those routes, and must be installed manually from vendor websites. These are documented as `# Download:` comments in `Brewfile.personal`:

- **Tailscale** - the "Standalone Variant" has features unavailable in the MAS version, and gets updates more frequently. Download and install it from https://pkgs.tailscale.com/stable/#macos
- **Audio production platform managers** — install these first, then use them to install individual plugins (Native Access, IK Product Manager, Spitfire Audio, etc.)
- **Standalone audio apps** — synth tutorials, amp sims, etc.
- **Non-audio apps** — apps whose Homebrew cask is deprecated or was never available (Affinity Photo 2, Aqua Voice, etc.)

Machine-specific manual apps (audio interfaces, hardware utilities) go as `# Download:` comments in `Brewfile.local` on each machine.

On a new personal machine, check `Brewfile.personal` and `Brewfile.local` for the full list of download links after running `./install`.

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

### Neovim maintenance

```sh
nvim --headless "+Lazy sync" +qa    # install/clean/update plugins
nvim --headless "+MasonUpdate" +qa  # update Mason registries
nvim --headless "+TSUpdate" +qa     # update treesitter parsers
```

After updating plugins, commit the lockfile:

```sh
cd ~/.dotfiles
git add config/nvim/lazy-lock.json
git commit -m "⬆️ Update nvim plugin lockfile"
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

### Pre-commit hooks

Run all checks (same as CI):

```sh
pre-commit run --all-files
```

Run a specific hook:

```sh
pre-commit run shellcheck --all-files
pre-commit run trailing-whitespace --all-files
```

Update hook versions:

```sh
pre-commit autoupdate
```

Re-install hooks (after clone or if `.git/hooks/pre-commit` is missing):

```sh
pre-commit install
```

Bypass hooks for a single commit (use sparingly):

```sh
git commit --no-verify -m "message"
```

### Benchmark shell startup time

```sh
for i in 1 2 3 4 5; do /usr/bin/time -p script -q /dev/null zsh -i -c exit 2>&1 | grep real; done
```

Use `script` to allocate a real PTY — sheldon and fzf key-bindings are guarded behind `[[ -t 1 ]]` and won't load in a plain `zsh -i -c exit` without a terminal, making that command an undercount. Discard the first run (cold cache). A clean startup should be under ~500ms.

**Baseline (March 2026, M-series Mac):** ~315ms (warm cache). Main contributors are sheldon plugin initialization (fast-syntax-highlighting, forgit, zsh-autosuggestions), mise activate, and starship init. thefuck is lazy-loaded and does not contribute to startup. Revisit if it climbs above ~500ms.

---

## Adding New Things

### New Homebrew package

Add to the appropriate Brewfile and run `./install` (or `brew bundle` directly):

- `packages/Brewfile.universal` — install everywhere
- `packages/Brewfile.work` — work machines only
- `packages/Brewfile.personal` — personal machines only
- `packages/Brewfile.local` — this machine only (gitignored)

### New zsh config

Drop a file in `zsh/lib/yourfile.zsh` — it will be sourced automatically next shell start. No changes to `zshrc.zsh` needed. For work-only config, add to `env/work.zsh` instead.

### New tool config

1. Add config files under `config/toolname/`
2. Add a symlink entry to `install.config.yaml`
3. Run `./install`

### New bin script

Drop it in `bin/` — Dotbot glob-symlinks the whole directory to `~/bin`, so it's in PATH after `./install`.

### New tealdeer custom page

Create `docs/tldr/my-<topic>.page.md` following the [tldr page format](https://github.com/tldr-pages/tldr/blob/main/contributing-guides/style-guide.md):
- `# title` header
- `> one-line description`
- `- comment` then `` `command` `` pairs (5-8 examples)
- Each code block must contain exactly one command (no `cmd1` / `cmd2` splits)

After `./install`, the page is available via `tldr my-<topic>`. Existing pages: my-shell, my-git, my-tmux, my-fzf, my-vim.

---

## Cheatsheet Tools

### `tldr my-<topic>` — Quick reference (tealdeer custom pages)

Curated "greatest hits" from each cheatsheet, accessible via tealdeer:

```sh
tldr my-git       # top git aliases
tldr my-shell     # top shell aliases
tldr my-tmux      # tmux keybindings
tldr my-fzf       # fzf bindings and completion
tldr my-vim       # vim keybindings
tldr --list | grep my-   # list all custom pages
```

Pages live in `docs/tldr/` as `*.page.md` files and are symlinked to tealdeer's custom pages directory by dotbot.

### `cheat.sh` — Full cheatsheet browser

Browse or search the full `docs/*.cheatsheet.md` files with fzf + bat:

```sh
cheat.sh              # fzf topic picker → bat render
cheat.sh grep         # search across all cheatsheets for "grep"
cheat.sh stash        # find stash-related entries across all files
```

**Dependencies:** fzf, bat (both in Brewfile.universal). Falls back gracefully: without fzf lists topics; without bat uses cat.

---

## Secrets Hygiene

- **Never commit secrets.** Tokens, passwords, and keys go in `~/.secrets.local`.
- **Non-secret machine config** (tool paths, env vars, region defaults) goes in `~/.env.local`.
- Both are covered by the `*.local` gitignore pattern and sourced silently at shell startup.
- If you accidentally commit a secret: rotate it immediately, then scrub it from git history.
- **Git identity** (`name`, `email`, `signingkey`) lives in `config/git/.gitconfig-user` — gitignored, never tracked. Copy from `config/git/.gitconfig-user.example` on each new machine.

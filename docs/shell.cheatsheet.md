# Shell Cheatsheet

Aliases and behaviors from `zsh/lib/aliases.zsh`, `zsh/lib/brew.zsh`, `zsh/lib/directory_nav.zsh`, and `zsh/zshrc.zsh`.

---

## Directory Listing (eza)

| Alias | What it shows |
|-------|---------------|
| `l` | Long list, all files, relative timestamps, octal perms, icons, git status |
| `ll` | Long list, all files, ISO timestamps, group, git + repo status |
| `la` | Long list, all files, color-scaled by age |
| `lt` | Tree view, 3 levels deep |
| `lsal` | Full `ls -lahF` piped to `less -R` |

## Navigation

| Command | Action |
|---------|--------|
| `z <query>` | Jump to frecent directory (zoxide) |
| `pu` | `pushd` — push directory onto stack |
| `po` | `popd` — pop directory off stack |
| `cd -` | Go back to previous directory |
| `..` | Expands to `../` — type `...` → `../../`, `....` → `../../../`, etc. |
| `autocd` | Type a directory name without `cd` to enter it |

Directory stack persists for the session (up to 12 entries, no duplicates).

## File Operations

| Alias | Command |
|-------|---------|
| `rm` | `rm -i` (prompts before deleting) |
| `cp` | `cp -i` (prompts before overwriting) |
| `mv` | `mv -i` (prompts before overwriting) |
| `mkdir` | `mkdir -p` (creates parent dirs automatically) |
| `_` | `sudo` |

## System Monitoring

| Alias | Command |
|-------|---------|
| `top` | `btop` (if installed, else `htop`) |
| `du` | `ncdu --color dark -rr -x --exclude .git --exclude node_modules` (if ncdu installed) |
| `free` | Hack: reads PhysMem from macOS `top` output |
| `ports` | `netstat -tulan` — show open ports |

## bat

| Alias | Command |
|-------|---------|
| `batp` | `bat -p` (plain output, no line numbers/decorations) |
| `bat_` | `bat --show-all` (show non-printing characters) |
| `preview` | `fzf --preview 'bat --color "always" {}'` (fzf + bat file preview) |

## Homebrew Maintenance

| Command | Action |
|---------|--------|
| `bubu` | Full update cycle: `brew update` → `brew outdated` → `brew upgrade` → `brew doctor` → `brew cleanup` |
| `brewupd` | `brew update` + show outdated packages |
| `brewupg` | `brew upgrade` + `brew cleanup` |

## Network

| Alias | Command |
|-------|---------|
| `ip` | Show external IP, en3 (ethernet), and en0 (WiFi) |
| `ping` | `prettyping --nolegend` (if prettyping installed) |
| `ssr` | `ssh -l root` |
| `weather` | Current conditions for Atlanta via wttr.in |
| `moon` | Current moon phase via wttr.in |

## macOS Utilities

| Alias | Command |
|-------|---------|
| `finder` | `open ./` — open current directory in Finder |
| `dscleanup` | Recursively delete all `.DS_Store` files |
| `emptytrash` | Empty Trash on all mounted volumes |
| `date` | `gdate` — GNU date (if installed via brew) |

## Shell Utilities

| Alias | Command |
|-------|---------|
| `reload!` | `source ~/.zshrc` — reload shell config |
| `cls` | Clear screen (ANSI reset, preserves scrollback) |
| `rot13` | ROT13 encode/decode via `tr` |
| `fuck` | Correct last command (thefuck, if installed) |

## History Behaviors

- Commands starting with a space are not saved to history
- History is shared across all open sessions in real time
- `CTRL+R` — fuzzy history search (fzf)
- Up/Down arrows — history substring search (matches anywhere in the command)

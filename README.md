# dotfiles

Personal dotfiles for macOS/zsh, managed by [Dotbot](https://github.com/anishathalye/dotbot).
Includes configs for zsh, tmux, Neovim, Ghostty, Starship, and more.

## Install

### First-time setup

> **New Mac?** Complete the [prerequisites](docs/RUNBOOK.md#new-mac-onboarding-prerequisites) (App Store sign-in, Apple Watch unlock, 1Password + SSH keys) before running bootstrap.

```sh
git clone --recursive git@github.com:devnall/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./bin/bootstrap.sh    # Xcode CLT, Homebrew, 1Password, machine-type marker, git identity, mise
./install             # symlinks everything, installs Brewfile packages
```

### Updating

```sh
cd ~/.dotfiles && git pull && ./install
```

The installer is idempotent — safe to re-run any time after pulling changes.

## What's in here

```
zsh/        shell config — zshrc entrypoint + modular lib/ (aliases, completions, fzf, keybindings, theme, ...)
config/     tool configs symlinked to ~/.config (git, tmux, nvim, ghostty, starship, bat, btop, mise, sheldon, ...)
packages/   Brewfiles — universal, work, personal
env/        machine-type overrides (work/personal/remote)
bin/        scripts symlinked to ~/bin
docs/       architecture, runbook, cheatsheets
```

## Machine types

| Marker | Use case |
|--------|----------|
| `~/.work` | Work machine (full macOS setup) |
| `~/.personal` | Personal machine (full macOS setup) |
| `~/.remote-full` | Linux server with Homebrew + full tool suite |
| `~/.remote` | Minimal Linux server — no external tools installed |

If no marker exists, only the universal config loads.

## Local overrides

Machine-specific configs that shouldn't live in the repo go in two gitignored files:

- `~/.env.local` — PATH additions, non-secret exports (e.g. tool paths, region defaults)
- `~/.secrets.local` — API keys, tokens, credentials

Both are sourced silently at the end of every shell session.

## Documentation

- [Architecture](docs/ARCHITECTURE.md) — design decisions and constraints
- [Runbook](docs/RUNBOOK.md) — usage, maintenance, troubleshooting
- Cheatsheets: [fzf](docs/fzf.cheatsheet.md), [git](docs/git.cheatsheet.md), [tmux](docs/tmux.cheatsheet.md), [shell](docs/shell.cheatsheet.md), [vim](docs/vim.cheatsheet.md), [kubernetes](docs/kubernetes.cheatsheet.md)

## License

MIT — see [LICENSE](LICENSE).

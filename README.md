# dotfiles

My personal macOS/zsh-centric dotfiles. Managed by [Dotbot](https://github.com/anishathalye/dotbot).

Includes configs for zsh, Neovim, vim, tmux, Ghostty, Starship, sheldon, bat, btop, fzf, and more.

---

## Install

```sh
git clone git@github.com:devnall/dotfiles.git --recursive ~/.dotfiles
touch ~/.work      # or ~/.personal, ~/.remote-full, ~/.remote — see below
cd ~/.dotfiles && ./install
```

The installer is idempotent — safe to re-run any time after pulling changes.

### Machine type markers

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

## What's in here

```
zsh/            shell config — zshrc entrypoint + modular lib/ files
config/         tool configs (nvim, tmux, ghostty, starship, bat, btop, ...)
packages/       Brewfiles — universal, work, and personal
env/            machine-type shell overrides (work.zsh / personal.zsh / remote*.zsh)
bin/            scripts symlinked to ~/bin
docs/           cheatsheets (fzf, tmux)
```

See [RUNBOOK.md](RUNBOOK.md) for detailed usage and maintenance notes.

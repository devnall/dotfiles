# dotfiles

My personal macOS dotfiles. Managed by [Dotbot](https://github.com/anishathalye/dotbot).

Includes config for zsh, Neovim, vim, tmux, Ghostty, Starship, sheldon, bat, btop, fzf, and more.

---

## Install

```sh
git clone git@github.com:devnall/dotfiles.git --recursive ~/.dotfiles
touch ~/.work      # or ~/.personal — controls which env config and Brewfile loads
cd ~/.dotfiles && ./install
```

The installer is idempotent — safe to re-run any time after pulling changes.

## Local overrides

Machine-specific config that shouldn't live in the repo goes in two gitignored files:

- `~/.env.local` — PATH additions, non-secret exports (e.g. tool paths, region defaults)
- `~/.secrets.local` — API keys, tokens, credentials

Both are sourced silently at the end of every shell session.

## What's in here

```
zsh/            shell config — zshrc entrypoint + modular lib/ files
config/         tool configs (nvim, tmux, ghostty, starship, bat, btop, ...)
packages/       Brewfiles — universal, work, and personal
env/            machine-type shell overrides (work.zsh / personal.zsh)
bin/            scripts symlinked to ~/bin
```

See [RUNBOOK.md](RUNBOOK.md) for detailed usage and maintenance notes.

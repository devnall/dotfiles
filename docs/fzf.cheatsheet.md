# fzf Cheatsheet

## Key Bindings

- `CTRL+T` — find files/directories in the current directory; insert selection into command prompt. Previews files with bat (syntax highlighted).
- `CTRL+R` — search shell history; paste selection into command line.
- `ALT+C` (or `ç` on macOS) — fuzzy find and cd into a subdirectory. Previews directory tree with eza.

## Tab Completion

`<command> ** <TAB>` — context-aware fuzzy completion:

| Command | Behavior | Preview |
|---------|----------|---------|
| `vim ** <TAB>` | files and directories (default); multi-select | bat (syntax highlighted) |
| `cd ** <TAB>` | directories only; single select | eza tree |
| `ssh ** <TAB>` | hostnames from `~/.ssh/known_hosts` | dig output |
| `export ** <TAB>` | shell variables | variable value |
| `unset ** <TAB>` | shell variables | variable value |

## Aliases

- `preview` — open fzf with bat syntax-highlighted preview (`fzf --preview 'bat --color "always" {}'`)

## tmux Integration

| Key | Action |
|-----|--------|
| `C-a u` | Fuzzy-search URLs in current tmux pane; open or copy to clipboard (via tmux-fzf-url plugin) |
| `C-a S` | SSH to host via fzf fuzzy picker (custom script) |

## Reference

- [fzf](https://junegunn.github.io/fzf/)
- [fzf GitHub Repo](https://github.com/junegunn/fzf)
- [A Practical Guide to fzf: Shell Integration](https://thevaluable.dev/fzf-shell-integration/)

# tmux

`tmux.conf` goes in `~/.config/tmux/`. The two theme files sit next to it:
`tmux-nordic.conf` (dark) and `tmux-rose-pine-dawn.conf` (light). On startup, tmux picks
one from the macOS appearance setting, and [`bin/theme-switch`](../../bin/theme-switch)
re-sources the other one live when the setting changes.

## Keys

The prefix is **`C-a`**. Most default bindings are unbound and replaced:

| Keys | Action |
|---|---|
| `\` / `-` | Split side by side / top and bottom, in the current directory |
| `\|` / `_` | The same, but full width or height |
| `h` `j` `k` `l` | Move between panes (`C-h/j/k/l` also crosses into Neovim splits) |
| `C-H` `C-J` `C-K` `C-L` | Resize by 5 |
| `+` or `=` | Zoom the pane |
| `,` `.` / `C-p` `C-n` | Previous / next window |
| `<` `>` | Move the window left / right |
| `Space` | Last window |
| `e` | Toggle synchronized panes |
| `S` | Pick an SSH host in an fzf popup; opens it in a new window ([`bin/tmux-ssh-fzf`](../../bin/tmux-ssh-fzf)) |
| `n` / `N` | Rename window / session |
| `x` / `X` / `q` | Kill the pane / window (asks) / session (asks) |
| `r` | Reload the config |

Copy mode uses vi keys: `v` starts a selection, `C-v` toggles rectangle mode,
and `y` copies.

## Plugins, without TPM

Plugins are git submodules in `~/.config/tmux/plugins/`, loaded with plain
`run-shell` lines, so a fresh machine doesn't need a plugin manager or network
access at startup. To use them, clone each one there:
[tmux-yank](https://github.com/tmux-plugins/tmux-yank),
[tmux-open](https://github.com/tmux-plugins/tmux-open),
[extrakto](https://github.com/laktak/extrakto),
[tmux-fzf-url](https://github.com/junegunn/tmux-fzf-url),
[vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator),
[tmux-prefix-highlight](https://github.com/tmux-plugins/tmux-prefix-highlight),
[tmux-online-status](https://github.com/tmux-plugins/tmux-online-status).

The status bar shows what's playing in Apple Music, using
[`bin/tunes.js`](../../bin/tunes.js) (JXA via `osascript`). `lite-install` drops
that segment on Linux.

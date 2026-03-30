# tmux Cheatsheet

Prefix key: `C-a`

---

## Sessions

| Key | Action |
|-----|--------|
| `prefix N` | Rename current session |
| `prefix q` | Kill current session |
| `prefix Q` | Kill tmux server (nukes all sessions) |
| `prefix C-d` | Detach from current session |
| `tmux list-sessions` | List all running sessions |
| `tmux attach-session -t <name>` | Attach to named session |

## Windows

| Key | Action |
|-----|--------|
| `prefix c` | New window |
| `prefix ,` | Previous window |
| `prefix .` | Next window |
| `prefix <` | Swap window left |
| `prefix >` | Swap window right |
| `prefix Space` | Jump to last window |
| `prefix n` | Rename current window |
| `prefix X` | Kill current window (with confirm) |
| `prefix 0-9` | Jump to window by number |

## Panes

| Key | Action |
|-----|--------|
| `prefix \` | Split horizontally (new pane right) |
| `prefix \|` | Split horizontally full-width |
| `prefix -` | Split vertically (new pane below) |
| `prefix _` | Split vertically full-height |
| `prefix h/j/k/l` | Move between panes (vim-style) |
| `prefix C-H/J/K/L` | Resize pane (5 lines) |
| `prefix +` or `prefix =` | Zoom/unzoom current pane |
| `prefix x` | Kill current pane |

## Copy Mode (vi-style)

| Key | Action |
|-----|--------|
| `prefix [` | Enter copy mode |
| `prefix p` | Paste buffer |
| `v` | Begin selection |
| `C-v` | Toggle rectangle selection |
| `y` | Copy selection to system clipboard and exit copy mode |
| `o` | Open URL/file under selection (uses `open` command on macOS) |
| `e` | Fuzzy-extract text from pane into prompt |

## Sync Panes

| Key | Action |
|-----|--------|
| `prefix e` | Toggle pane synchronization (broadcast input to all panes in window) |

## Misc

| Key | Action |
|-----|--------|
| `prefix r` | Reload tmux config |
| `prefix R` | Refresh client |
| `prefix ;` | Open command prompt |
| `prefix u` | Fuzzy-search URLs in current pane (fzf popup); open or copy to clipboard |
| `prefix S` | SSH to host via fzf fuzzy picker (opens in new window); fallback to prompt if fzf unavailable |
| `prefix C-a` | Send prefix to nested tmux/screen session |

## Plugins (git submodules)

| Plugin | Purpose |
|--------|---------|
| tmux-yank | System clipboard integration in copy mode |
| tmux-open | Open files/URLs from copy mode (with `o` key) |
| tmux-prefix-highlight | Status bar indicator when prefix is held or in copy mode |
| tmux-online-status | Status bar online/offline indicator |
| extrakto | Fuzzy-extract text from pane into prompt (with `e` key in copy mode) |
| tmux-fzf-url | Fuzzy-search and open/copy URLs from current pane (with `prefix u`) |
| vim-tmux-navigator | Navigate between tmux panes with Ctrl+hjkl (vim integration requires neovim plugin) |

### Plugin Updates

Plugins are managed as git submodules. Update individual plugins:
```bash
cd ~/.dotfiles
git submodule update --remote config/tmux/plugins/<plugin-name>
git add config/tmux/plugins/<plugin-name>
git commit -m "⬆️ Update <plugin-name>"
```

Update all plugins at once:
```bash
cd ~/.dotfiles
git submodule update --remote config/tmux/plugins/
git add config/tmux/plugins/
git commit -m "⬆️ Update tmux plugins"
```

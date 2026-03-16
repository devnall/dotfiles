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
| `y` | Copy selection and exit copy mode |

## Sync Panes

| Key | Action |
|-----|--------|
| `prefix e` | Enable pane synchronization (broadcast input to all panes) |
| `prefix E` | Disable pane synchronization |

## Misc

| Key | Action |
|-----|--------|
| `prefix r` | Reload tmux config |
| `prefix R` | Refresh client |
| `prefix ;` | Open command prompt |
| `prefix S` | Open SSH to host in new window |
| `prefix C-a` | Send prefix to nested tmux/screen session |

## Plugins (via TPM)

| Plugin | Purpose |
|--------|---------|
| tmux-sensible | Sane defaults |
| tmux-yank | Clipboard integration in copy mode |
| tmux-open | Open files/URLs from copy mode |
| tmux-prefix-highlight | Status bar indicator when prefix is active |
| tmux-online-status | Status bar online/offline indicator |
| extrakto | Fuzzy-extract text from pane into prompt |
| vim-tmux-navigator | Seamless pane navigation between vim and tmux |

### TPM Commands

| Command | Action |
|---------|--------|
| `prefix I` | Install plugins |
| `prefix U` | Update plugins |
| `prefix alt-u` | Remove unlisted plugins |

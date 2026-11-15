# Vim Cheatsheet

Custom keybinds and general tips for the minimal vimrc.

---

## Custom Keybinds

| Key | Action |
|-----|--------|
| `<Space>` | Leader key |
| `jj` | Exit insert mode |
| `Ctrl-H/J/K/L` | Navigate splits (left/down/up/right) |
| `Ctrl-\` | Open vertical split |
| `Ctrl-t` | New tab |
| `th` / `tl` | First / last tab |
| `tj` / `tk` | Next / previous tab |
| `t1`–`t9` | Jump to tab by number |
| `tt` | `:tabedit` (open file in new tab) |
| `tm` | `:tabm` (move current tab) |
| `F12` | Toggle invisible characters |
| `W!!` | Save as sudo (command mode) |
| `:DiffOrig` | Diff buffer against saved file |

---

## File Navigation

- `:drop file` — open file if not already open, switch to it if it is
- `:tab drop file` — same, but in a new tab
- `:tab split` — duplicate current buffer in a new tab
- `:tab help topic` — open help in a new tab

## Tab Philosophy

Tabs in vim are not like browser tabs. They're more like viewport layouts — each tab can contain multiple splits/windows. Use them for:

- Viewing the same file with different folds or positions (`:tab split`)
- Keeping a reference file open alongside your working files
- Grouping related splits (e.g., test + implementation)

## Shell Integration

- `:r !command` — insert command output below cursor
- `:r !date` — insert current date
- `:r !curl -s url` — insert URL contents
- `:%!command` — filter entire buffer through command
- `:.!command` — filter current line through command

## Folds

- `za` — toggle fold under cursor
- `zR` — open all folds
- `zM` — close all folds
- `zc` / `zo` — close / open one fold

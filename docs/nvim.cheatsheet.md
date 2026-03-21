# Neovim Cheatsheet

Leader key: `Space`

---

## Navigation

| Key | Action |
|-----|--------|
| `<C-h/j/k/l>` | Navigate splits / tmux panes |
| `<S-h>` | Previous buffer |
| `<S-l>` | Next buffer |
| `<Space>q` | Close buffer |
| `<Space>sv` | Vertical split |
| `<Space>sh` | Horizontal split |
| `n` / `N` | Next/prev search (centered) |

---

## Editing

| Key | Action |
|-----|--------|
| `jj` | Escape (insert mode) |
| `<Space>/` | Clear search highlight |
| `J` / `K` (visual) | Move selected lines down/up |
| `sa{motion}{char}` | Add surround (e.g., `saiw"`) |
| `sd{char}` | Delete surround |
| `sr{old}{new}` | Replace surround |
| Autopairs | Brackets/quotes auto-close |

---

## Find (Telescope)

| Key | Action |
|-----|--------|
| `<Space>ff` | Find files |
| `<Space>fg` | Live grep |
| `<Space>fb` | Buffers |
| `<Space>fh` | Help tags |
| `<Space>fr` | Recent files |
| `<Space>fd` | Diagnostics |

**Inside Telescope:** `<C-n>`/`<C-p>` navigate, `<CR>` select, `<C-x>` horizontal split, `<C-v>` vertical split, `<Esc>` close.

---

## File Explorer (Neo-tree)

| Key | Action |
|-----|--------|
| `<Space>e` | Toggle file explorer |

---

## LSP

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gr` | Go to references |
| `K` | Hover documentation |
| `<Space>ca` | Code action |
| `<Space>rn` | Rename symbol |
| `<Space>cd` | Diagnostic float |
| `[d` / `]d` | Prev/next diagnostic |

---

## Formatting

| Key | Action |
|-----|--------|
| `<Space>cf` | Format file (manual) |
| (auto) | Format on save if formatter available |

Configured formatters: goimports (Go), ruff_format (Python), prettier (JS/TS/JSON/YAML/Markdown), shfmt (shell), stylua (Lua), terraform_fmt (Terraform).

---

## Git

| Key | Action |
|-----|--------|
| `<Space>gs` | Git status (fugitive) |
| `<Space>gb` | Blame current line |
| `<Space>hs` | Stage hunk |
| `<Space>hr` | Reset hunk |
| `]h` / `[h` | Next/prev hunk |

---

## Completion (blink.cmp)

| Key | Action |
|-----|--------|
| `<Tab>` | Next item |
| `<S-Tab>` | Previous item |
| `<CR>` | Confirm selection |
| `<C-Space>` | Trigger completion |

---

## Theme Switching

```
:ThemeSwitch dark     " switch to NordicPine
:ThemeSwitch light    " switch to Rose Pine Dawn
```

Automatically synced by `theme-switch` script via dark-notify.

---

## Maintenance Commands

| Command | Action |
|---------|--------|
| `:Lazy` | Plugin manager UI |
| `:Lazy update` | Update plugins |
| `:Lazy sync` | Install/clean/update plugins |
| `:Mason` | LSP server manager UI |
| `:MasonUpdate` | Update Mason registries |
| `:TSUpdate` | Update treesitter parsers |
| `:LspInfo` | Show attached LSP servers |
| `:checkhealth` | Run health checks |

Headless sync: `nvim --headless "+Lazy sync" +qa`

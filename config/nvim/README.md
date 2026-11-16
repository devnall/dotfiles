# Neovim

A [lazy.nvim](https://github.com/folke/lazy.nvim) config, split into
`lua/config/` (options, keymaps, autocommands, appearance) and `lua/plugins/`
(one file per area). `lazy-lock.json` pins every plugin.

| File | Plugins |
|---|---|
| `lsp.lua` | nvim-lspconfig, with mason and mason-lspconfig installing servers |
| `completion.lua` | blink.cmp |
| `formatting.lua` | conform.nvim |
| `telescope.lua` | Telescope with the native fzf sorter |
| `treesitter.lua` | nvim-treesitter |
| `neo-tree.lua` | neo-tree file explorer |
| `git.lua` | gitsigns and vim-fugitive |
| `editing.lua` | mini.surround and nvim-autopairs |
| `lualine.lua`, `which-key.lua` | Status line and key hints |
| `tmux-navigator.lua` | `C-h/j/k/l` moves across Neovim splits and tmux panes alike |
| `colorscheme.lua` | Rosé Pine, recolored to NordicPine for dark; stock Dawn for light |

**Live theme switching:** `lua/config/appearance.lua` reads
`~/.local/state/appearance` at startup and defines a `:ThemeSwitch dark|light`
command. Each instance listens on `/tmp/nvim-$USER-*.sock`, which is how
[`bin/theme-switch`](../../bin/theme-switch) recolors running editors.

**Missing tools are fine:** Neovim starts without errors even when a language
server or formatter isn't installed.

See [`docs/nvim.cheatsheet.md`](../../docs/nvim.cheatsheet.md) for the keymaps.

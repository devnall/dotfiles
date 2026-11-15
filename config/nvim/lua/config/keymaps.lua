-- keymaps.lua — non-plugin keymaps

local map = vim.keymap.set

-- jj to escape
map("i", "jj", "<Esc>", { desc = "Escape" })

-- Clear search highlight
map("n", "<Leader>/", "<Cmd>nohlsearch<CR>", { desc = "Clear search" })

-- Splits
map("n", "<Leader>sv", "<Cmd>vsplit<CR>", { desc = "Vertical split" })
map("n", "<Leader>sh", "<Cmd>split<CR>", { desc = "Horizontal split" })

-- Buffer navigation
map("n", "<S-h>", "<Cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<S-l>", "<Cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<Leader>q", "<Cmd>bdelete<CR>", { desc = "Close buffer" })

-- Better search centering
map("n", "n", "nzzzv", { desc = "Next search result (centered)" })
map("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })

-- Move lines in visual mode
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down", silent = true })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up", silent = true })

-- Diagnostics
map("n", "<Leader>cd", vim.diagnostic.open_float, { desc = "Diagnostic float" })

-- NOTE: <C-h/j/k/l> are NOT mapped here — vim-tmux-navigator owns these

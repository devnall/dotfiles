-- autocmds.lua — autocommands

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight on yank
autocmd("TextYankPost", {
  group = augroup("YankHighlight", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Restore cursor position on file open
autocmd("BufReadPost", {
  group = augroup("RestoreCursor", { clear = true }),
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Filetype overrides: markdown/text get wrap
autocmd("FileType", {
  group = augroup("WrapFiletypes", { clear = true }),
  pattern = { "markdown", "text" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
  end,
})

-- Auto-reload on focus
autocmd({ "FocusGained", "BufEnter" }, {
  group = augroup("AutoReload", { clear = true }),
  command = "checktime",
})

-- Resize splits on VimResized
autocmd("VimResized", {
  group = augroup("ResizeSplits", { clear = true }),
  command = "tabdo wincmd =",
})

-- Diagnostic float on CursorHold
autocmd("CursorHold", {
  group = augroup("DiagnosticFloat", { clear = true }),
  callback = function()
    vim.diagnostic.open_float(nil, { focusable = false })
  end,
})

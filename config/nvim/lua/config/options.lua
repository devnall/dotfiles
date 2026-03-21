-- options.lua — vim.opt settings (carried forward from vimrc)

local opt = vim.opt

-- Formatting
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true
opt.smarttab = true
opt.autoindent = true

-- Search
opt.hlsearch = true
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true

-- Visual
opt.number = true
opt.cursorline = true
opt.termguicolors = true
opt.signcolumn = "yes"
opt.wrap = false
opt.scrolloff = 8
opt.showmatch = true
opt.laststatus = 2
opt.shortmess:append("atI")

-- Splits
opt.splitbelow = true
opt.splitright = true

-- System
opt.clipboard = "unnamed"
opt.mouse = "a"
opt.autoread = true
opt.timeoutlen = 300
opt.updatetime = 250
opt.wildmenu = true
opt.wildmode = "longest,list"
opt.backspace = "indent,eol,start"

-- No backup / swap
opt.swapfile = false
opt.backup = false
opt.writebackup = false

-- Persistent undo
opt.undofile = true

-- Diagnostics
vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  float = { border = "rounded" },
})

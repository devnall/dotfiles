-- init.lua — Neovim entrypoint

-- Set leader before anything else
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load config modules
require("config.options")
require("config.keymaps")
require("config.autocmds")

-- Setup plugins (auto-discovers lua/plugins/*.lua)
require("lazy").setup("plugins")

-- Appearance (after plugins load)
require("config.appearance").setup()

-- Named server socket for theme-switch remote commands
local user = vim.fn.expand("$USER")
local pid = vim.fn.getpid()
vim.fn.serverstart("/tmp/nvim-" .. user .. "-" .. pid .. ".sock")

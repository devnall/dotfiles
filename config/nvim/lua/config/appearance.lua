-- appearance.lua — state file reader, ThemeSwitch command, Rose Pine variant control

local M = {}

-- NordicPine highlight overrides for dark mode
-- Mapped from docs/color-palettes.md onto Rose Pine's highlight groups
local nordicpine_overrides = {
  -- Base UI
  Normal = { fg = "#c6e0df", bg = "#0f111a" },
  NormalFloat = { fg = "#c6e0df", bg = "#1c2030" },
  NormalNC = { fg = "#c6e0df", bg = "#0f111a" },
  CursorLine = { bg = "#232a3b" },
  CursorLineNr = { fg = "#c6e0df", bold = true },
  LineNr = { fg = "#555e7a" },
  Visual = { bg = "#232a3b" },
  Search = { fg = "#0f111a", bg = "#e6cc6f" },
  CurSearch = { fg = "#0f111a", bg = "#ddbc44" },
  IncSearch = { link = "CurSearch" },
  Pmenu = { fg = "#c6e0df", bg = "#1c2030" },
  PmenuSel = { fg = "#e4f5f4", bg = "#232a3b" },
  PmenuSbar = { bg = "#1c2030" },
  PmenuThumb = { bg = "#555e7a" },
  FloatBorder = { fg = "#343b51" },
  WinSeparator = { fg = "#343b51" },
  StatusLine = { fg = "#c6e0df", bg = "#1c2030" },
  StatusLineNC = { fg = "#555e7a", bg = "#1c2030" },
  Title = { fg = "#6ab4c2", bold = true },

  -- Syntax
  Comment = { fg = "#343b51", italic = true },
  String = { fg = "#e6cc6f" },
  Constant = { fg = "#e6cc6f" },
  Number = { fg = "#e6cc6f" },
  Boolean = { fg = "#cca2c0" },
  Function = { fg = "#38c9a7" },
  Keyword = { fg = "#087fab", bold = true },
  Statement = { fg = "#087fab", bold = true },
  Identifier = { fg = "#c6e0df" },
  Type = { fg = "#6ab4c2" },
  Special = { fg = "#6ab4c2" },
  SpecialComment = { fg = "#cca2c0" },
  Operator = { fg = "#c6e0df" },
  ["@punctuation"] = { fg = "#555e7a" },

  -- Diagnostics
  DiagnosticError = { fg = "#e16c58" },
  DiagnosticWarn = { fg = "#ddbc44" },
  DiagnosticInfo = { fg = "#6ab4c2" },
  DiagnosticHint = { fg = "#cca2c0" },
  DiagnosticOk = { fg = "#26a98b" },

  -- Git signs
  GitSignsAdd = { fg = "#26a98b", bg = "NONE" },
  GitSignsChange = { fg = "#cca2c0", bg = "NONE" },
  GitSignsDelete = { fg = "#e16c58", bg = "NONE" },
  DiffAdd = { bg = "#26a98b", blend = 15 },
  DiffChange = { bg = "#cca2c0", blend = 15 },
  DiffDelete = { bg = "#e16c58", blend = 15 },
}

function M.apply(mode)
  -- Reset rose-pine config to defaults before each apply, because
  -- setup() deep-merges into existing state and won't clear old overrides
  require("rose-pine.config").options = vim.deepcopy(require("rose-pine.config").options)
  require("rose-pine.config").options.highlight_groups = {}

  if mode == "light" then
    vim.o.background = "light"
    require("rose-pine").setup({
      variant = "dawn",
      dark_variant = "moon",
    })
  else
    vim.o.background = "dark"
    require("rose-pine").setup({
      variant = "moon",
      dark_variant = "moon",
      highlight_groups = nordicpine_overrides,
    })
  end
  vim.cmd("colorscheme rose-pine")
end

function M.setup()
  -- Read state file
  local state_file = vim.fn.expand("~/.local/state/appearance")
  local mode = "dark"
  local f = io.open(state_file, "r")
  if f then
    local content = f:read("*l")
    f:close()
    if content and content:match("light") then
      mode = "light"
    end
  end

  M.apply(mode)

  -- User command for live switching
  vim.api.nvim_create_user_command("ThemeSwitch", function(opts)
    M.apply(opts.args)
  end, {
    nargs = 1,
    complete = function()
      return { "dark", "light" }
    end,
    desc = "Switch between dark and light themes",
  })
end

return M

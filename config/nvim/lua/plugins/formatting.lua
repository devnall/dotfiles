return {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  keys = {
    {
      "<Leader>cf",
      function()
        require("conform").format({ async = true, lsp_fallback = true })
      end,
      desc = "Format file",
    },
  },
  opts = {
    formatters_by_ft = {
      go = { "goimports" },
      python = { "ruff_format" },
      javascript = { "prettier" },
      typescript = { "prettier" },
      json = { "prettier" },
      yaml = { "prettier" },
      markdown = { "prettier" },
      sh = { "shfmt" },
      bash = { "shfmt" },
      lua = { "stylua" },
      terraform = { "terraform_fmt" },
      tf = { "terraform_fmt" },
    },
    format_on_save = function(bufnr)
      -- Skip if formatter is not available
      local formatters = require("conform").list_formatters(bufnr)
      if #formatters == 0 then
        return
      end
      return { timeout_ms = 2000, lsp_fallback = true }
    end,
  },
}

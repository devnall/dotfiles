return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "gopls",
          "lua_ls",
          "pyright",
          "ruby_lsp",
          "ts_ls",
          "terraformls",
          "yamlls",
          "jsonls",
          "bashls",
          "marksman",
        },
        -- automatic_enable (default true) auto-configures all installed servers
      })

      -- lua_ls: suppress undefined global `vim` warning
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
          },
        },
      })

      -- LspAttach keymaps
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("LspKeymaps", { clear = true }),
        callback = function(ev)
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = ev.buf, desc = desc })
          end

          map("gd", vim.lsp.buf.definition, "Go to definition")
          map("gr", vim.lsp.buf.references, "Go to references")
          map("K", vim.lsp.buf.hover, "Hover documentation")
          map("<Leader>ca", vim.lsp.buf.code_action, "Code action")
          map("<Leader>rn", vim.lsp.buf.rename, "Rename")
          map("[d", vim.diagnostic.goto_prev, "Previous diagnostic")
          map("]d", vim.diagnostic.goto_next, "Next diagnostic")
        end,
      })
    end,
  },
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    opts = {},
  },
}

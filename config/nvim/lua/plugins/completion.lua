return {
  "saghen/blink.cmp",
  event = "InsertEnter",
  version = "*",
  opts = {
    keymap = {
      preset = "default",
      ["<Tab>"] = { "select_next", "fallback" },
      ["<S-Tab>"] = { "select_prev", "fallback" },
      ["<CR>"] = { "accept", "fallback" },
      ["<C-Space>"] = { "show" },
    },
    sources = {
      default = { "lsp", "path", "buffer" },
    },
    completion = {
      documentation = { auto_show = true },
    },
  },
}

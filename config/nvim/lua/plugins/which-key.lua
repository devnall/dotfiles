return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    spec = {
      { "<Leader>f", group = "Find" },
      { "<Leader>g", group = "Git" },
      { "<Leader>c", group = "Code" },
      { "<Leader>h", group = "Hunk" },
      { "<Leader>s", group = "Split" },
    },
  },
}

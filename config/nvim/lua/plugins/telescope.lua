return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  keys = {
    { "<Leader>ff", "<Cmd>Telescope find_files<CR>", desc = "Find files" },
    { "<Leader>fg", "<Cmd>Telescope live_grep<CR>", desc = "Live grep" },
    { "<Leader>fb", "<Cmd>Telescope buffers<CR>", desc = "Buffers" },
    { "<Leader>fh", "<Cmd>Telescope help_tags<CR>", desc = "Help tags" },
    { "<Leader>fr", "<Cmd>Telescope oldfiles<CR>", desc = "Recent files" },
    { "<Leader>fd", "<Cmd>Telescope diagnostics<CR>", desc = "Diagnostics" },
  },
  config = function()
    local telescope = require("telescope")
    telescope.setup({
      defaults = {
        file_ignore_patterns = { "node_modules", ".git/" },
      },
    })
    telescope.load_extension("fzf")
  end,
}

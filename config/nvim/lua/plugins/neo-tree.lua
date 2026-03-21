return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  keys = {
    { "<Leader>e", "<Cmd>Neotree toggle<CR>", desc = "Toggle file explorer" },
  },
  cmd = "Neotree",
  opts = {
    filesystem = {
      follow_current_file = { enabled = true },
      filtered_items = {
        visible = true,
        hide_dotfiles = false,
        hide_gitignored = false,
      },
    },
    window = {
      width = 35,
    },
    default_component_configs = {
      git_status = {
        symbols = {
          added = "+",
          modified = "~",
          deleted = "x",
          renamed = "r",
          untracked = "?",
          ignored = ".",
          unstaged = "U",
          staged = "S",
          conflict = "!",
        },
      },
    },
  },
}

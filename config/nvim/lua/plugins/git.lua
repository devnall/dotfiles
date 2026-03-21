return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local map = function(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
        end

        map("n", "]h", gs.next_hunk, "Next hunk")
        map("n", "[h", gs.prev_hunk, "Previous hunk")
        map("n", "<Leader>hs", gs.stage_hunk, "Stage hunk")
        map("n", "<Leader>hr", gs.reset_hunk, "Reset hunk")
        map("n", "<Leader>gb", gs.blame_line, "Blame line")
      end,
    },
  },
  {
    "tpope/vim-fugitive",
    cmd = "Git",
    keys = {
      { "<Leader>gs", "<Cmd>Git<CR>", desc = "Git status" },
    },
  },
}

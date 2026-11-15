return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPost", "BufNewFile" },
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").setup()

    -- Enable treesitter-based highlighting and indentation
    vim.treesitter.language.register("hcl", "terraform")

    -- Auto-install parsers if missing (non-blocking)
    local ensure = {
      "bash", "go", "gomod", "gosum", "hcl", "terraform",
      "javascript", "typescript", "json", "yaml", "toml",
      "lua", "luadoc", "markdown", "markdown_inline",
      "python", "ruby", "vim", "vimdoc", "regex",
    }
    local installed = require("nvim-treesitter").get_installed()
    local installed_set = {}
    for _, lang in ipairs(installed) do
      installed_set[lang] = true
    end
    local missing = {}
    for _, lang in ipairs(ensure) do
      if not installed_set[lang] then
        missing[#missing + 1] = lang
      end
    end
    if #missing > 0 then
      require("nvim-treesitter").install(missing)
    end
  end,
}

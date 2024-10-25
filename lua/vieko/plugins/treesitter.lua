return { -- highlight, edit, and navigate code
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  dependencies = { "windwp/nvim-ts-autotag" },
  opts = {
    ensure_installed = {
      "bash",
      "c",
      "html",
      "http",
      "lua",
      "luadoc",
      "markdown",
      "vim",
      "vimdoc",
      "typescript",
      "javascript",
    },
    auto_install = true,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
      -- additional_vim_regex_highlighting = { "ruby" },
    },
    indent = { enable = true, disable = { "ruby" } },
    autotag = { enable = true },
    incremental_selection = {
      enable = false,
      keymaps = {
        init_selection = "gnn",
        node_incremental = "grn",
        scope_incremental = "grc",
        node_decremental = "grm",
      },
    },
  },
  config = function(_, opts)
    -- see `:help nvim-treesitter`
    ---@diagnostic disable-next-line: missing-fields
    require("nvim-treesitter.configs").setup(opts)
    --    - incremental selection: included, see `:help nvim-treesitter-incremental-selection-mod`
    --    - show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
    --    - treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
  end,
}

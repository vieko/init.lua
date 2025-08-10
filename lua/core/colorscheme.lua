-- [[ COLORSCHEME ]]
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        transparent_background = false,
        integrations = {
          cmp = true,
          gitsigns = true,
          nvimtree = true,
          treesitter = true,
          mini = {
            enabled = true,
            indentscope_color = "",
          },
        },
      })
      if not vim.g.tinted_theme_loaded then
        vim.cmd.colorscheme("catppuccin")
      end
    end,
  },
}

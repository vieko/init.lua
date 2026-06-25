-- [[ COLORSCHEME ]]
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    -- `lazy = false` so `priority = 1000` actually takes effect and the
    -- fallback colorscheme (when tinty is absent) loads at startup.
    -- Without this, `defaults = { lazy = true }` leaves catppuccin with
    -- no trigger and the fallback never fires.
    lazy = false,
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

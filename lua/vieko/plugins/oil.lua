return {
  { -- filesystem explorer
    "stevearc/oil.nvim",
    dependencies = { { "echasnovski/mini.icons", opts = {} } },
    config = function()
      require("oil").setup({
        columns = {},
        keymaps = {
          ["<C-h>"] = false,
        },
        view_options = {
          show_hidden = true,
        },
        win_options = {
          colorcolumn = "",
          signcolumn = "yes:2",
          relativenumber = false,
          number = false,
        },
      })
      -- Open parent directory in current window
      vim.keymap.set("n", "-", "<cmd>Oil<cr>", { desc = "Open parent directory" })
    end,
  },
  -- {
  --   "refractalize/oil-git-status.nvim",
  --   dependencies = {
  --     "stevearc/oil.nvim",
  --   },
  --   config = true,
  -- },
}

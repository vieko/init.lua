return {
  "mistweaverco/kulala.nvim",
  config = function()
    require("kulala").setup({
      split_direction = "horizontal",
      icons = {
        inlay = {
          loading = "",
          done = "",
          error = "",
        },
        lualine = "",
      },
    })
  end,
}

-- [[ PLUGINS ]]
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  "tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically
  "christoomey/vim-tmux-navigator", -- Seamless navigation between tmux panes and vim splits
  { -- Better commentstring for typescript
    "JoosepAlviste/nvim-ts-context-commentstring",
    opts = {
      enable_autocmd = false,
    },
  },
  { import = "vieko.plugins" },
  change_detection = {
    notify = false,
  },
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = " ",
      config = "",
      event = " ",
      ft = " ",
      init = " ",
      import = " ",
      keys = " ",
      lazy = "󰒲 ",
      loaded = "●",
      not_loaded = "○",
      plugin = " ",
      runtime = " ",
      require = "󰢱 ",
      source = " ",
      start = " ",
      task = "✔ ",
      list = {
        "●",
        "➜",
        "★",
        "‒",
      },
    },
  },
})

-- [[ BOOTSTRAP ]]
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("config.lazy").load("options")

local spec = {
  { import = "core.editor" },
  { import = "core.coding" },
  { import = "core.colorscheme" },
  { import = "core.lspconfig" },
  { import = "core.treesitter" },
  { import = "plugins.conform" },
  { import = "plugins.dropbar" },
  { import = "plugins.eslint" },
  { import = "plugins.nvim-lint" },
  { import = "plugins.snacks" },
  { import = "plugins.flash" },
  { import = "langs" },
}

require("lazy").setup({
  spec = spec,
  defaults = { lazy = true, version = false },
  checker = { enabled = true },
  change_detection = { notify = false },
  ui = {
    border = "single",
    icons = {
      cmd = " ",
      config = "",
      event = "⚡ ",
      ft = " ",
      init = " ",
      import = " ",
      keys = " ",
      lazy = "󰒲 ",
      loaded = "",
      not_loaded = "",
      plugin = " ",
      runtime = " ",
      require = " ",
      source = " ",
      start = " ",
      task = " ",
      list = {
        "",
        "",
        "",
        "",
      },
    },
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

require("config.lazy").setup()

-- Defer highlights setup for better startup performance
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    require("config.highlights").setup()
  end,
})

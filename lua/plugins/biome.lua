local Lsp = require("utils.lsp")

return {
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "biome" })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      servers = {
        biome = {
          -- Only start biome LSP if biome.json exists in project
          -- Let lspconfig auto-detect root_dir via package.json or biome.json
          autostart = function()
            return Lsp.biome_config_exists()
          end,
        },
      },
    },
  },
}

-- [[ JSON ]]
return {
  { -- add json to treesitter
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "json5" } },
  },

  -- yaml schema support
  {
    "b0o/SchemaStore.nvim",
    lazy = true,
    version = false, -- last release is way too old
  },

  -- correctly setup lspconfig
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- make sure mason installs the server
      servers = {
        jsonls = {
          -- lazy-load schemastore when the client initializes.
          -- (Replaces the lspconfig-specific `on_new_config` hook, which
          -- isn't part of the `vim.lsp.config` API.)
          before_init = function(_, config)
            config.settings = config.settings or {}
            config.settings.json = config.settings.json or {}
            config.settings.json.schemas =
              vim.list_extend(config.settings.json.schemas or {}, require("schemastore").json.schemas())
          end,
          settings = {
            json = {
              format = {
                enable = true,
              },
              validate = { enable = true },
            },
          },
        },
      },
    },
  },
}

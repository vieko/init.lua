local Lsp = require("utils.lsp")
local typescript_lsp = "ts_ls" -- Only using vtsls

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- Typescript formatter
      {
        "dmmulroy/ts-error-translator.nvim",
        ft = "javascript,typescript,typescriptreact,svelte",
      },
      {
        "marilari88/twoslash-queries.nvim",
        ft = "javascript,typescript,typescriptreact,svelte",
        opts = {
          is_enabled = false, -- Use :TwoslashQueriesEnable to enable
          multi_line = true, -- to print types in multi line mode
          highlight = "Type", -- to set up a highlight group for the virtual text
        },
        keys = {
          { "<leader>dt", ":TwoslashQueriesEnable<cr>", desc = "Enable twoslash queries" },
          { "<leader>dd", ":TwoslashQueriesInspect<cr>", desc = "Inspect twoslash queries" },
        },
      },
    },
    ---@class PluginLspOpts
    opts = {
      servers = {
        ts_ls = {
          root_dir = require("lspconfig").util.root_pattern("package.json", "tsconfig.json"),
          single_file_support = false,
          handlers = {
            -- format error code with better error message
            ["textDocument/publishDiagnostics"] = function(err, result, ctx)
              require("ts-error-translator").translate_diagnostics(err, result, ctx)
              vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx)
            end,
          },
          -- inlay hints & code lens, refer to https://github.com/typescript-language-server/typescript-language-server/blob/master/docs/configuration.md/#workspacedidchangeconfiguration
          settings = {
            typescript = {
              -- Inlay Hints preferences
              inlayHints = {
                -- You can set this to 'all' or 'literals' to enable more hints
                includeInlayParameterNameHints = "literals", -- 'none' | 'literals' | 'all'
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = false,
                includeInlayVariableTypeHints = false,
                includeInlayVariableTypeHintsWhenTypeMatchesName = false,
                includeInlayPropertyDeclarationTypeHints = false,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
              -- Code Lens preferences
              implementationsCodeLens = {
                enabled = true,
              },
              referencesCodeLens = {
                enabled = true,
                showOnAllFunctions = true,
              },
              format = {
                indentSize = vim.o.shiftwidth,
                convertTabsToSpaces = vim.o.expandtab,
                tabSize = vim.o.tabstop,
              },
            },
            javascript = {
              -- Inlay Hints preferences
              inlayHints = {
                -- You can set this to 'all' or 'literals' to enable more hints
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all'
                includeInlayVariableTypeHints = true,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHintsWhenTypeMatchesName = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
              -- Code Lens preferences
              implementationsCodeLens = {
                enabled = true,
              },
              referencesCodeLens = {
                enabled = true,
                showOnAllFunctions = true,
              },
              format = {
                indentSize = vim.o.shiftwidth,
                convertTabsToSpaces = vim.o.expandtab,
                tabSize = vim.o.tabstop,
              },
            },
            completions = {
              completeFunctionCalls = true,
            },
          },
        },
      },
      -- Enable builtin LSP inlay hints on Neovim >= 0.10.0
      -- Shows inline type hints, parameter names, etc.
      inlay_hints = {
        enabled = true,
      },
      -- Enable builtin LSP code lenses on Neovim >= 0.10.0
      -- Shows actionable code actions inline (e.g., "X references", "Run tests")
      codelens = {
        enabled = true,
      },
      setup = {
        ts_ls = function(_)
          Lsp.on_attach(function(client, bufnr)
            if client.name == "ts_ls" then
              require("twoslash-queries").attach(client, bufnr)
            end
          end)
        end,
      },
    },
  },
}

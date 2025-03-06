return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        tailwindcss = {
          filetypes_exclude = { "markdown" },
          filetypes_include = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
          init_options = {
            userLanguages = {
              typescript = "javascript",
              typescriptreact = "javascriptreact"
            },
          },
          settings = {
            tailwindCSS = {
              experimental = {
                classRegex = {
                  { "cn\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
                  { "clsx\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
                  { "twMerge\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
                },
              },
              includeLanguages = {
                typescript = "javascript",
                typescriptreact = "javascriptreact",
              },
            },
          },
        },
      },
      setup = {
        tailwindcss = function(_, opts)
          local tw = require("lspconfig.configs.tailwindcss")
          opts.filetypes = opts.filetypes or {}

          vim.list_extend(opts.filetypes, tw.default_config.filetypes)

          --- @param ft string
          opts.filetypes = vim.tbl_filter(function(ft)
            return not vim.tbl_contains(opts.filetypes_exclude or {}, ft)
          end, opts.filetypes)

          vim.list_extend(opts.filetypes, opts.filetypes_include or {})
          
          -- Add root_dir pattern for monorepo
          if not opts.root_dir then
            opts.root_dir = function(fname)
              local root_patterns = {
                "tailwind.config.js",
                "tailwind.config.ts",
                "tailwind.config.cjs",
                "tailwind.config.mjs",
                "postcss.config.js",
                "postcss.config.ts",
                "postcss.config.cjs",
                "postcss.config.mjs"
              }
              local util = require("lspconfig.util")
              -- Add parent directories for monorepo patterns
              return util.root_pattern(unpack(root_patterns))(fname) or
                util.root_pattern("package.json", "tsconfig.json")(fname) or
                util.find_git_ancestor(fname)
            end
          end
        end,
      },
    },
  },
}
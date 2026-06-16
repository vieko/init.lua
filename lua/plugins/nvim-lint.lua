return {
  {
    "williamboman/mason.nvim",
    optional = true,
    opts = {
      ensure_installed = {
        "shellcheck",
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    event = "VeryLazy",
    opts = {
      linters_by_ft = {
        sh = { "shellcheck" },
        -- ESLint LSP (plugins/eslint.lua) handles JS/TS linting.
        -- nvim-lint covers everything else (shellcheck, etc.).
      },
      linters = {
        -- Custom linter definitions can go here
      },
    },
    config = function(_, opts)
      local lint = require("lint")
      lint.linters_by_ft = opts.linters_by_ft

      -- Register our custom linters
      for name, linter in pairs(opts.linters) do
        lint.linters[name] = linter
      end

      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
        callback = function()
          local names = lint._resolve_linter_by_ft(vim.bo.filetype)

          -- Create a copy of the names table to avoid modifying the original.
          names = vim.list_extend({}, names)

          -- Add fallback linters.
          if #names == 0 then
            vim.list_extend(names, lint.linters_by_ft["_"] or {})
          end

          -- Add global linters.
          vim.list_extend(names, lint.linters_by_ft["*"] or {})

          -- Run linters.
          if #names > 0 then
            -- Check the if the linter is available, otherwise it will throw an error.
            for _, name in ipairs(names) do
              -- Skip the executable check - trust our custom defined linters
              if lint.linters[name] == nil then
                vim.notify("Linter " .. name .. " is not available", vim.log.levels.INFO)
              else
                -- Run the linter
                lint.try_lint(name)
              end
            end
          end
        end,
      })
    end,
  },
}

-- [[ CODING ]]
return {
  { -- Autocompletion
    "hrsh7th/nvim-cmp",
    version = false,
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
    config = function()
      local cmp = require("cmp")
      local defaults = require("cmp.config.default")()
      cmp.setup({
        completion = { completeopt = "menu,menuone,noinsert" },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<Tab>"] = cmp.mapping.confirm({ select = true }),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),

        sources = cmp.config.sources({
          { name = "lazydev" },
          { name = "nvim_lsp" },
          { name = "path" },
        }, { name = "buffer" }),
        ---@diagnostic disable-next-line: missing-fields
        formatting = {
          format = function(_, item)
            local widths = {
              abbr = vim.g.cmp_widths and vim.g.cmp_widths.abbr or 40,
              menu = vim.g.cmp_widths and vim.g.cmp_widths.menu or 30,
            }

            for key, width in pairs(widths) do
              if item[key] and vim.fn.strdisplaywidth(item[key]) > width then
                item[key] = vim.fn.strcharpart(item[key], 0, width - 1) .. "…"
              end
            end

            return item
          end,
        },
        sorting = defaults.sorting,
      })
    end,
  },
  { -- supermaven
    "supermaven-inc/supermaven-nvim",
    event = "InsertEnter",
    enabled = true,
    config = function()
      local sm = require("supermaven-nvim")
      sm.setup({
        keymaps = {
          accept_suggestion = "<C-l>",
          clear_suggestion = "<C-h>",
        },
        color = {
          suggestion_color = "#5a6a87",
        },
        disable_inline_completion = false,
        ignore_filetypes = { "bigfile", "snacks_input", "snacks_notif" },
      })
    end,
  },
  { -- better text-objects
    "echasnovski/mini.ai",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local ai = require("mini.ai")
      ai.setup()
    end,
  },
  { -- Auto pairs
    "echasnovski/mini.pairs",
    event = "InsertEnter",
    opts = {
      modes = { insert = true, command = true, terminal = false },
      skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
      skip_ts = { "string" },
      skip_unbalanced = true,
      markdown = true,
    },
  },
  { -- Code comment
    "folke/ts-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },
}

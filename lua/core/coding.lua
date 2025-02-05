-- [[ CODING ]]
return {
  { -- Autocompletion
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    version = false,
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      {
        "L3MON4D3/LuaSnip",
        build = (function()
          if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
            return
          end
          return "make install_jsregexp"
        end)(),
        dependencies = {
          {
            "rafamadriz/friendly-snippets",
            config = function()
              require("luasnip.loaders.from_vscode").lazy_load()
            end,
          },
        },
      },
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      luasnip.config.setup({})

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },

        completion = { completeopt = "menu,menuone,noselect" },
        mapping = cmp.mapping.preset.insert({
          -- select the [n]ext item
          ["<C-n>"] = cmp.mapping.select_next_item(),
          -- select the [p]revious item
          ["<C-p>"] = cmp.mapping.select_prev_item(),

          -- scroll the documentation window [b]ack / [f]orward
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),

          -- accept ([y]es) the completion.
          ["<C-y>"] = cmp.mapping.confirm({ select = true }),
          -- <cr> will confirm the completion.
          ["<CR>"] = cmp.mapping.confirm({ select = true }),

          -- <c-e> will cancel the completion.
          ["<C-e>"] = cmp.mapping.abort(),

          -- manually trigger a completion from nvim-cmp.
          ["<C-Space>"] = cmp.mapping.complete({}),

          -- <c-l> will move you to the right of each of the expansion locations.
          -- <c-h> is similar, except moving you backwards.
          -- ["<C-l>"] = cmp.mapping(function()
          --   if luasnip.expand_or_locally_jumpable() then
          --     luasnip.expand_or_jump()
          --   end
          -- end, { "i", "s" }),
          -- ["<C-h>"] = cmp.mapping(function()
          --   if luasnip.locally_jumpable(-1) then
          --     luasnip.jump(-1)
          --   end
          -- end, { "i", "s" }),
        }),
        sources = {
          { name = "nvim_lsp", group_index = 2 },
          { name = "luasnip", group_index = 2 },
          { name = "path", group_index = 2 },
          { name = "buffer", group_index = 2 },
          { name = "lazydev", group_index = 0 },
        },
      })
    end,
  },
  { -- copilot
    "github/copilot.vim",
    -- event = "VeryLazy",
    config = function()
      vim.g.copilot_workspace_folders = { "~/Documents/Development", "~/Documents/Sandbox" }
      vim.g.copilot_assume_mapped = true
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_filetypes = {
        ["TelescopePrompt"] = false,
        -- ["grug-far"] = false,
        -- ["grug-far-history"] = false,
      }

      -- setup keymaps
      local keymap = vim.keymap.set
      local opts = { silent = true }

      -- set accept copilot suggestion
      keymap("i", "<C-y>", 'copilot#Accept("\\<CR>")', { expr = true, replace_keycodes = false })

      -- set <C-i> to accept line
      keymap("i", "<C-i>", "<Plug>(copilot-accept-line)", opts)

      -- set <C-j> to next suggestion, <C-k> to previous suggestion
      -- keymap("i", "<C-j>", "<Plug>(copilot-next)", opts)
      -- keymap("i", "<C-k>", "<Plug>(copilot-previous)", opts)

      -- set <C-d> to dismiss suggestion
      keymap("i", "<C-d>", "<Plug>(copilot-dismiss)", opts)
    end,
  },
  { -- install lsp servers
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        "prettier",
        "prettierd",
        "codespell",
        "misspell",
        "cspell",
        "markdownlint",
        "rustywind",
      },
    },
  },
  { -- Code comment
    "folke/ts-comments.nvim",
    opts = {},
    event = "VeryLazy",
  },
  { -- A better annotation generator. Supports multiple languages and annotation conventions.
    -- <C-n> to jump to next annotation, <C-p> to jump to previous annotation
    "danymat/neogen",
    dependencies = "nvim-treesitter/nvim-treesitter",
    opts = { enabled = true },
    cmd = "Neogen",
    keys = {
      { "<leader>ci", "<cmd>Neogen<cr>", desc = "Annotation generator" },
    },
  },
}

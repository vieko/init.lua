-- [[ EDITOR ]]
return {
  { -- detect tabstop and shiftwidth automatically.
    "tpope/vim-sleuth",
  },
  { -- navigation between tmux panes and vim splits
    "christoomey/vim-tmux-navigator",
    event = "VeryLazy",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
      "TmuxNavigatorProcessList",
    },
    keys = {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
  },
  { -- map keys without delay when typing
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    opts = {
      default_mappings = false,
      mappings = {
        i = {
          j = {
            k = "<Esc>",
            j = "<Esc>",
          },
        },
      },
    },
  },
  { -- Adds git related signs to the gutter, as well as utilities for managing changes.
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add = { text = "A" },
        change = { text = "M" },
        delete = { text = "D" },
        topdelete = { text = "T" },
        changedelete = { text = "C" },
        untracked = { text = "?" },
      },
    },
  },
  {
    "echasnovski/mini.statusline", -- A minimal statusline plugin for neovim.
    opts = {
      use_icons = false,
      set_vim_settings = false,
      content = {
        active = function()
          local statusline = require("mini.statusline")
          local mode, mode_hl = statusline.section_mode({ trunc_width = 120 })
          local git = statusline.section_git({ trunc_width = 75, icon = "GIT" })
          local diagnostics = statusline.section_diagnostics({ trunc_width = 75, icon = "LSP" })
          local filename = statusline.section_filename({ trunc_width = 140 })
          -- local fileinfo = statusline.section_fileinfo({ trunc_width = 120 })
          -- local location = statusline.section_location({ trunc_width = 75 })
          -- local search = statusline.section_searchcount({ trunc_width = 75 })
          local lint_progress = function()
            local linters = require("lint").get_running()
            if #linters == 0 then
              return ""
            end
            return " " .. table.concat(linters, ", ")
          end
          return statusline.combine_groups({
            { hl = mode_hl, strings = { mode } },
            { hl = "MiniStatuslineDevinfo", strings = { git, diagnostics, lint_progress() } },
            "%<", -- Mark general truncate point
            { hl = "MiniStatuslineFilename", strings = { filename } },
            "%=", -- End left alignment
            { hl = "MiniStatuslineFileinfo", strings = { vim.bo.filetype ~= "" and vim.bo.filetype } },
            { hl = mode_hl, strings = { "%l:%v" } },
            -- { hl = mode_hl, strings = { search, location } },
          })
        end,
      },
    },
  },
  { -- useful plugin to show you pending keybinds.
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts_extend = { "spec" },
    opts = {
      defaults = {},
      ---@type false | "classic" | "modern" | "helix"
      preset = vim.g.which_key_preset or "helix",
      spec = {
        {
          mode = { "n", "v" },
          { "<leader>a", group = "copilot" },
          { "<leader>b", group = "buffer" },
          { "<leader>c", group = "code" },
          { "<leader>f", group = "file/find" },
          { "<leader>g", group = "git" },
          { "<leader>q", group = "quit/session" },
          { "<leader>s", group = "search" },
          { "<leader>t", group = "toggle" },
          { "<leader>u", group = "utilities" },
          { "<leader>w", group = "window" },
          { "<leader>x", group = "diagnostics/quickfix" },
          { "[", group = "prev" },
          { "]", group = "next" },
          { "g", group = "goto" },
          -- { "gs", group = "surround" },
          { "z", group = "fold" },
        },
      },
      icons = {
        breadcrumb = "",
        separator = "",
        ellipsis = "",
        group = " ",
        mappings = false,
        colors = true,
        keys = {
          Up = " ",
          Down = " ",
          Left = " ",
          Right = " ",
          C = "ctrl",
          M = "alt",
          D = "meta",
          S = "shift",
          CR = "enter",
          Esc = "esc",
          ScrollWheelDown = "mw ",
          ScrollWheelUp = "mw ",
          NL = "enter",
          BS = "bksp",
          Space = "space",
          Tab = "tab ",
          F1 = "F1",
          F2 = "F2",
          F3 = "F3",
          F4 = "F4",
          F5 = "F5",
          F6 = "F6",
          F7 = "F7",
          F8 = "F8",
          F9 = "F9",
          F10 = "F10",
          F11 = "F11",
          F12 = "F12",
        },
      },
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Keymaps",
      },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      if not vim.tbl_isempty(opts.defaults) then
        wk.add(opts.defaults)
      end
    end,
  },
  { -- toggleterm
    "akinsho/toggleterm.nvim",
    opts = {
      size = 20,
      open_mapping = [[<c-_>]],
      dir = "git_dir",
      hide_numbers = true,
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      insert_mappings = true,
      persist_size = true,
      close_on_exit = true,
      shell = vim.o.shell,
    },
    keys = {
      {
        "<C-_>",
        "<cmd>:ToggleTerm<cr>",
        desc = "Toggle Terminal",
      },
      {
        "<leader>tt",
        "<cmd>:ToggleTerm<cr>",
        desc = "Toggle Terminal",
      },
      {
        "<leader>gg",
        function()
          local Terminal = require("toggleterm.terminal").Terminal
          local lazygit = Terminal:new({
            cmd = "lazygit",
            dir = "git_dir",
            direction = "float",
            -- 90% width and height
            float_opts = {
              width = math.floor(vim.o.columns * 0.9),
              height = math.floor(vim.o.lines * 0.9),
            },
            -- function to run on opening the terminal
            on_open = function(term)
              vim.cmd("startinsert!")
              vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })

              -- Allow to make it work for lazygit for Esc and ctrl + hjkl
              vim.keymap.set("t", "<c-h>", "<c-h>", { buffer = term.bufnr, nowait = true })
              vim.keymap.set("t", "<c-j>", "<c-j>", { buffer = term.bufnr, nowait = true })
              vim.keymap.set("t", "<c-k>", "<c-k>", { buffer = term.bufnr, nowait = true })
              vim.keymap.set("t", "<c-l>", "<c-l>", { buffer = term.bufnr, nowait = true })
              vim.keymap.set("t", "<esc>", "<esc>", { buffer = term.bufnr, nowait = true })
            end,
            -- function to run on closing the terminal
            on_close = function(_)
              vim.cmd("startinsert!")
            end,
          })

          lazygit:toggle()
        end,
        desc = "Lazygit Toggle",
        mode = "n",
      },
    },
  },
  { -- Trouble
    "folke/trouble.nvim",
    config = function()
      require("trouble").setup({})
      require("trouble.format").formatters.file_icon = function()
        return ""
      end
    end,
    opts = {
      open_no_results = true,
      warn_no_results = true,
      modes = {
        -- Diagnostics for the current buffer and errors from the current project
        errors = {
          mode = "diagnostics", -- inherit from diagnostics mode
          filter = {
            any = {
              buf = 0, -- current buffer
              {
                severity = vim.diagnostic.severity.ERROR, -- errors only
                -- limit to files in the current project
                function(item)
                  return item.filename:find((vim.loop or vim.uv).cwd(), 1, true)
                end,
              },
            },
          },
        },
      },
    },
    cmd = "Trouble",
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List",
      },
    },
    icons = {
      indent = {
        top = "│ ",
        middle = "├╴",
        last = "└╴",
        fold_open = " ",
        fold_closed = " ",
        ws = "  ",
      },
      folder_closed = " ",
      folder_open = " ",
      kinds = {
        Array = " ",
        Boolean = "󰨙 ",
        Class = " ",
        Constant = "󰏿 ",
        Constructor = " ",
        Enum = " ",
        EnumMember = " ",
        Event = " ",
        Field = " ",
        File = " ",
        Function = "󰊕 ",
        Interface = " ",
        Key = " ",
        Method = "󰊕 ",
        Module = " ",
        Namespace = "󰦮 ",
        Null = " ",
        Number = "󰎠 ",
        Object = " ",
        Operator = " ",
        Package = " ",
        Property = " ",
        String = " ",
        Struct = "󰆼 ",
        TypeParameter = " ",
        Variable = "󰀫 ",
      },
    },
  },
  { -- Highlight todo, notes, etc in comments.
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { signs = false },
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {
      modes = {
        search = {
          enabled = true,
          highlight = { backdrop = true },
        },
        char = {
          enabled = true,
          jump_labels = true,
        },
        treesitter = {
          enabled = true,
          highlight = { backdrop = true },
        },
      },
    },
    keys = {
      {
        "s",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash",
      },
      {
        "S",
        mode = { "n", "o", "x" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
      {
        "r",
        mode = "o",
        function()
          require("flash").remote()
        end,
        desc = "Remote Flash",
      },
      {
        "R",
        mode = { "o", "x" },
        function()
          require("flash").treesitter_search()
        end,
        desc = "Treesitter Search",
      },
      {
        "<c-s>",
        mode = { "c" },
        function()
          require("flash").toggle()
        end,
        desc = "Toggle Flash Search",
      },
      {
        "<leader>j",
        mode = { "n" },
        function()
          local Flash = require("flash")
          ---@param opts Flash.Format
          ---@class Flash.Match
          ---@field label1 string|number
          ---@field label2 string|number
          local function format(opts)
            return {
              { opts.match.label1, "FlashMatch" },
              { opts.match.label2, "FlashLabel" },
            }
          end
          Flash.jump({
            search = { mode = "search" },
            label = { after = false, before = { 0, 0 }, uppercase = false, format = format },
            pattern = [[\<]],
            action = function(match, state)
              state:hide()
              Flash.jump({
                search = { max_length = 0 },
                highlight = { matches = false },
                label = { format = format },
                matcher = function(win)
                  return vim.tbl_filter(function(m)
                    return m.label == match.label and m.win == win
                  end, state.results)
                end,
                labeler = function(matches)
                  for _, m in ipairs(matches) do
                    ---@type (string|number|false)?
                    m.label = m.label2
                  end
                end,
              })
            end,
            labeler = function(matches, state)
              local labels = state:labels()
              for m, match in ipairs(matches) do
                match.label1 = labels[math.floor((m - 1) / #labels) + 1]
                match.label2 = labels[(m - 1) % #labels + 1]
                ---@type (string|number|false)?
                match.label = match.label1
              end
            end,
          })
        end,
        desc = "2-Char Flash Jump",
      },
    },
  },
  { -- Add/change/delete surrounding delimiter pairs with ease.
    "kylechui/nvim-surround",
    enabled = true,
    version = "*",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({})
    end,
  },
  { -- autopairs for neovim written in lua
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    dependencies = { "hrsh7th/nvim-cmp" },
    config = function()
      require("nvim-autopairs").setup({
        enable_check_bracket_line = false,
      })
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },
}

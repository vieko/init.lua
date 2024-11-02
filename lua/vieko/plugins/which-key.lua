return { -- Useful plugin to show you pending keybinds.
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts_extend = { "spec" },
  opts = {
    defaults = {},
    ---@type false | "classic" | "modern" | "helix"
    preset = vim.g.which_key_preset or "modern",
    -- win = vim.g.which_key_window or {
    --   width = { min = 30, max = 60 },
    --   height = { min = 4, max = 0.85 },
    -- },
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
        { "<leader>w", group = "window" },
        { "<leader>x", group = "diagnostics/quickfix" },
        { "<leader>[", group = "prev" },
        { "<leader>]", group = "next" },
        { "<leader>g", group = "goto" },
        { "<leader>gs", group = "surround" },
        { "<leader>z", group = "fold" },
      },
    },
    icons = {
      breadcrumb = "",
      separator = "",
      ellisis = "",
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
      desc = "Buffer Keymaps (which-key)",
    },
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)
    if not vim.tbl_isempty(opts.defaults) then
      wk.add(opts.defaults)
    end
  end,
}

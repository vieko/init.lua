return {
  "github/copilot.vim",
  -- event = "VeryLazy",
  config = function()
    -- define options
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
    keymap("i", "<C-j>", "<Plug>(copilot-next)", opts)
    keymap("i", "<C-k>", "<Plug>(copilot-previous)", opts)

    -- set <C-d> to dismiss suggestion
    keymap("i", "<C-d>", "<Plug>(copilot-dismiss)", opts)
  end,
}

-- return {
--   "zbirenbaum/copilot.lua",
--   cmd = "Copilot",
--   event = "InsertEnter",
--   config = function()
--     require("copilot").setup({
--       panel = { enabled = false },
--       suggestion = {
--         enabled = true,
--         auto_trigger = true,
--         keymap = {
--           accept = "<C-Y>",
--         },
--       },
--     })
--   end,
-- }

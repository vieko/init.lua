return {
  "github/copilot.vim",
  config = function()
    vim.keymap.set("i", "<C-Y>", 'copilot#Accept("\\<CR>")', {
      expr = true,
      replace_keycodes = false,
    })
    -- vim.keymap.set("i", "<M-\\>", "<Plug>(copilot-suggest)")
    vim.g.copilot_no_tab_map = true
  end,
}

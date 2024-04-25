-- [[ AUTOCOMMANDS ]]
-- see `:help lua-guide-autocommands`

-- highlight when yanking (copying) text
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- refresh buffers when files change on disk
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  pattern = "*",
  desc = "Refresh buffers when files change on disk",
  group = vim.api.nvim_create_augroup("refresh-on-save", { clear = true }),
  callback = function()
    vim.api.nvim_command("checktime")
  end,
})

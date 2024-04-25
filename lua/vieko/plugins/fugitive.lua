return { -- Git commands in nvim
  "tpope/vim-fugitive",
  config = function()
    vim.keymap.set("n", "<leader>gs", vim.cmd.Git, { desc = "Launch Fugitive" })

    vim.api.nvim_create_autocmd("BufWinEnter", {
      pattern = "*",
      group = vim.api.nvim_create_augroup("vieko-fugitive", { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc)
          vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "Fugitive: " .. desc, remap = false })
        end
        if vim.bo.filetype ~= "fugitive" then
          return
        end
        map("<leader>p", vim.cmd.Git("push"), "Push")
        map("<leader>P", vim.cmd.Git("pull"), "Pull")
      end,
    })
  end,
}

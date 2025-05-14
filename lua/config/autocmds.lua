-- [[ AUTOCOMMANDS ]]
local function augroup(name)
  return vim.api.nvim_create_augroup("vieko_" .. name, { clear = true })
end

-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = {
--     "json",
--     "jsonc",
--     "js",
--     "jsx",
--     "javascript",
--     "javascriptreact",
--     "ts",
--     "tsx",
--     "typescript",
--     "typescriptreact",
--     "lua",
--     "python",
--     "html",
--     "css",
--     "yaml",
--     "toml",
--     "go",
--   },
--   group = augroup("filetype_folds"),
--   callback = function()
--     vim.opt.foldmethod = "expr" -- Use expression-based folding
--     vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
--     vim.opt.foldenable = true
--     vim.opt.foldlevel = 99
--     vim.opt.foldlevelstart = 99
--   end,
-- })

-- highlight when yanking (copying) text
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    vim.highlight.on_yank({ higroup = "Yank", timeout = 150 })
  end,
})

-- resize splits when the window is resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
  group = augroup("resize_splits"),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- save cursor position when leaving a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("last_loc"),
  callback = function(event)
    local exclude = { "gitcommit" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
      return
    end
    vim.b[buf].lazyvim_last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "PlenaryTestPopup",
    "help",
    "lspinfo",
    "notify",
    "qf",
    "grug-far",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "neotest-output",
    "checkhealth",
    "neotest-summary",
    "neotest-output-panel",
    "dbout",
    "gitsigns-blame",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true, desc = "Quit buffer" })
  end,
})

-- make it easier to close man-files when opened inline
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("man_unlisted"),
  pattern = { "man" },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
  end,
})

-- Set filetype for .env and .env.* files
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = augroup("env_filetype"),
  pattern = { "*.env", ".env.*" },
  callback = function()
    vim.opt_local.filetype = "sh"
    vim.diagnostic.enable(false)
  end,
})

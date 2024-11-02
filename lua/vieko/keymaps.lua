-- [[ GLOBALS ]]
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- [[ KEYMAPS ]]
local function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

-- disable arrows
local arrows = { "<up>", "<down>", "<left>", "<right>" }
for _, arrow in ipairs(arrows) do
  map("n", arrow, "", { desc = "Disabled arrow key" })
  map("i", arrow, "", { desc = "Disabled arrow key" })
end

-- set highlight on search, but clear on pressing <esc> in normal and insert modes
map({ "i", "n" }, "<Esc>", "<cmd>noh<CR><Esc>", { desc = "Escape and clear search" })

-- move through wrapped lines when no count is given
map({ "n", "x" }, "j", [[v:count ? 'j' : 'gj']], { expr = true, desc = "Move down (including wrapped lines)" })
map({ "n", "x" }, "k", [[v:count ? 'k' : 'gk']], { expr = true, desc = "Move up (including wrapped lines)" })

-- move lines up and down in visual mode
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected lines down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected lines up" })

-- half page up and down keeping the cursor centered
map("n", "<C-u>", "<C-u>zz") -- half page up
map("n", "<C-d>", "<C-d>zz") -- half page down
map("n", "<C-b>", "<C-b>zz") -- page up
map("n", "<C-f>", "<C-f>zz") -- page down
map("n", "<C-o>", "<C-o>zz") -- jump back
map("n", "<C-i>", "<C-i>zz") -- jump forward

-- search terms stay in the middle of the screen
map("n", "n", "nzzzv", { desc = "Next search result (centered)" })
map("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })

-- prevent capital Q from clobbering the current buffer
map("n", "Q", "<Nop>", { desc = "Prevent Ex Mode when pressing Q" })

-- move to the beginning and end of line
map({ "n", "v", "o" }, "gl", "$", { desc = "Go to end of line" })
map({ "n", "v", "o" }, "gh", "^", { desc = "Go to start of line" })

-- buffers
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })

-- add undo break-points
local punctuation_marks = { ",", ".", ";", "!", "?", "(", ")", "{", "}" }
for _, mark in ipairs(punctuation_marks) do
  map("i", mark, mark .. "<c-g>u", { desc = "Create undo break-point" })
end

-- Preserve visual selection while indenting
map("v", "<", "<gv", { desc = "Indent left and maintain selection" })
map("v", ">", ">gv", { desc = "Indent right and maintain selection" })

-- save file
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

-- quit
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })

-- commenting
map("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Below" })
map("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Above" })

-- lazy
map("n", "<leader>zz", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- new file
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

map("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
map("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })

map("n", "[q", ":cprev<CR>zz", { desc = "Previous Quickfix item" })
map("n", "]q", ":cnext<CR>zz", { desc = "Next Quickfix item" })

-- copy, paste and delete with considerations
map("x", "<leader>p", '"_dP', { desc = "Paste without yanking" })
map({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to system clipboard" })
map({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete to blackhole register" })
map({ "n", "x" }, "<leader>Y", '"+Y', { desc = "Yank line to system clipboard" })
map("x", "<leader>P", '"+P', { desc = "Paste from system clipboard" })

-- diagnostic
local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
map("n", "<leader>cq", vim.diagnostic.setloclist, { desc = "Open Diagnostics Quick list" })
map("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
map("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
map("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
map("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
map("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
map("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

-- move between windows
map("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
map("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
map("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
map("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- split window vertically
map("n", "<C-w>\\", ":vsplit<CR>")

-- split window horizontally
map("n", "<C-w>-", ":split<CR>")

-- make windows roughly the same size
map("n", "<A-;>", "<C-W>=")

-- size windows horizontally
map("n", "<A-h>", "<C-w>>")
map("n", "<A-l>", "<C-w><")

-- size windows vertically
map("n", "<A-k>", "<C-w>+")
map("n", "<A-j>", "<C-w>-")

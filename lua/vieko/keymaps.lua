-- [[ KEYMAPS ]]

-- disable arrows
vim.keymap.set("n", "<up>", "")
vim.keymap.set("n", "<down>", "")
vim.keymap.set("n", "<left>", "")
vim.keymap.set("n", "<right>", "")
vim.keymap.set("i", "<up>", "")
vim.keymap.set("i", "<down>", "")
vim.keymap.set("i", "<left>", "")
vim.keymap.set("i", "<right>", "")

-- set highlight on search, but clear on pressing <esc> in normal mode
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- move lines up and down in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- half page up and down keeping the cursor centered
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-d>", "<C-d>zz")

-- search terms stay in the middle of the screen
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- prevent capital Q from clobbering the current buffer
vim.keymap.set("n", "Q", "<nop>")

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- this won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- move between windows
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- split window vertically
vim.keymap.set("n", "<C-w>\\", ":vsplit<CR>")

-- split window horizontally
vim.keymap.set("n", "<C-w>-", ":split<CR>")

-- make windows roughly the same size
vim.keymap.set("n", "<A-;>", "<C-W>=")

-- size windows horizontally
vim.keymap.set("n", "<A-h>", "<C-w>>")
vim.keymap.set("n", "<A-l>", "<C-w><")

-- size windows vertically
vim.keymap.set("n", "<A-k>", "<C-w>+")
vim.keymap.set("n", "<A-j>", "<C-w>-")

-- navigate quickfix list
vim.keymap.set("n", "[q", ":cprev<CR>zz", { desc = "Go to the previous [Q]uickfix item" })
vim.keymap.set("n", "]q", ":cnext<CR>zz", { desc = "Go to the next [Q]uickfix item" })

-- navigate location list
vim.keymap.set("n", "[l", ":lprev<CR>zz", { desc = "Go to the previous [L]ocation item" })
vim.keymap.set("n", "]l", ":lnext<CR>zz", { desc = "Go to the next [L]ocation item" })

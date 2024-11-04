-- [[ KEYMAPS ]]
---@module 'config.keymaps'
local M = {}
local auto_format = true

-- helper functions
local function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

local function disable_arrows()
  local arrows = { "<up>", "<down>", "<left>", "<right>" }
  for _, arrow in ipairs(arrows) do
    map("n", arrow, "", { desc = "Disabled arrow key" })
    map("i", arrow, "", { desc = "Disabled arrow key" })
  end
end

-- helper groups
vim.api.nvim_create_user_command("FormatDisable", function(args)
  if args.bang then
    -- FormatDisable! Will disable formatting just for this buffer
    vim.b.disable_autoformat = true
  else
    vim.g.disable_autoformat = true
  end
end, {
  desc = "Disable autoformat-on-save",
  bang = true,
})
vim.api.nvim_create_user_command("FormatEnable", function()
  vim.b.disable_autoformat = false
  vim.g.disable_autoformat = false
end, {
  desc = "Re-enable autoformat-on-save",
})

local function setup_navigation_maps()
  -- move through wrapped lines when no count is given
  map({ "n", "x" }, "j", [[v:count ? 'j' : 'gj']], { expr = true, desc = "Move down (including wrapped lines)" })
  map({ "n", "x" }, "k", [[v:count ? 'k' : 'gk']], { expr = true, desc = "Move up (including wrapped lines)" })

  -- half page up and down keeping the cursor centered
  local centered_movements = {
    { key = "<C-u>", desc = "Half page up" },
    { key = "<C-d>", desc = "Half page down" },
    { key = "<C-b>", desc = "Page up" },
    { key = "<C-f>", desc = "Page down" },
    { key = "<C-o>", desc = "Jump back" },
    { key = "<C-i>", desc = "Jump forward" },
  }
  for _, movement in ipairs(centered_movements) do
    map("n", movement.key, movement.key .. "zz", { desc = movement.desc })
  end

  -- move to the beginning and end of line
  map({ "n", "v", "o" }, "gl", "$", { desc = "Go to end of line" })
  map({ "n", "v", "o" }, "gh", "^", { desc = "Go to start of line" })
end

local function setup_window_management()
  -- move between windows
  local window_movements = {
    { key = "h", desc = "Move focus to the left window" },
    { key = "l", desc = "Move focus to the right window" },
    { key = "j", desc = "Move focus to the lower window" },
    { key = "k", desc = "Move focus to the upper window" },
  }
  for _, movement in ipairs(window_movements) do
    map("n", "<C-" .. movement.key .. ">", "<C-w><C-" .. movement.key .. ">", { desc = movement.desc })
  end

  -- window splitting and sizing
  map("n", "<C-w>\\", ":vsplit<CR>", { desc = "Split window vertically" })
  map("n", "<C-w>-", ":split<CR>", { desc = "Split window horizontally" })
  map("n", "<A-;>", "<C-W>=", { desc = "Equalize window sizes" })

  -- window resizing
  local resize_maps = {
    { key = "h", cmd = "<cmd>vertical resize -2<CR>", desc = "Decrease Width" },
    { key = "l", cmd = "<cmd>vertical resize +2<CR>", desc = "Increase Width" },
    { key = "k", cmd = "<cmd>resize -2<CR>", desc = "Decrease Height" },
    { key = "j", cmd = "<cmd>resize +2<CR>", desc = "Increase Height" },
  }
  for _, resize in ipairs(resize_maps) do
    map("n", "<A-" .. resize.key .. ">", resize.cmd, { desc = resize.desc })
  end
end

local function setup_clipboard_operations()
  -- System clipboard integration
  local clipboard_maps = {
    { mode = { "n", "v" }, lhs = "<leader>y", rhs = '"+y', desc = "Yank to system clipboard" },
    { mode = { "n", "v" }, lhs = "<leader>d", rhs = '"_d', desc = "Delete to blackhole register" },
    { mode = { "n", "x" }, lhs = "<leader>Y", rhs = '"+Y', desc = "Yank line to system clipboard" },
    { mode = "x", lhs = "<leader>p", rhs = '"_dP', desc = "Paste without yanking" },
    { mode = "x", lhs = "<leader>P", rhs = '"+P', desc = "Paste from system clipboard" },
  }

  for _, mapping in ipairs(clipboard_maps) do
    map(mapping.mode, mapping.lhs, mapping.rhs, { desc = mapping.desc })
  end
end

local function setup_diagnostic_navigation()
  local diagnostic_goto = function(next, severity)
    local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
    severity = severity and vim.diagnostic.severity[severity] or nil
    return function()
      go({ severity = severity })
    end
  end

  local diagnostic_maps = {
    { lhs = "<leader>cd", rhs = vim.diagnostic.open_float, desc = "Line Diagnostics" },
    { lhs = "<leader>cq", rhs = vim.diagnostic.setloclist, desc = "Open Diagnostics Quick list" },
    { lhs = "]d", rhs = diagnostic_goto(true), desc = "Next Diagnostic" },
    { lhs = "[d", rhs = diagnostic_goto(false), desc = "Prev Diagnostic" },
    { lhs = "]e", rhs = diagnostic_goto(true, "ERROR"), desc = "Next Error" },
    { lhs = "[e", rhs = diagnostic_goto(false, "ERROR"), desc = "Prev Error" },
    { lhs = "]w", rhs = diagnostic_goto(true, "WARN"), desc = "Next Warning" },
    { lhs = "[w", rhs = diagnostic_goto(false, "WARN"), desc = "Prev Warning" },
  }

  for _, mapping in ipairs(diagnostic_maps) do
    map("n", mapping.lhs, mapping.rhs, { desc = mapping.desc })
  end
end

local function setup_quality_of_life_tweaks()
  -- set highlight on search, but clear on pressing <esc> in normal and insert modes
  map({ "i", "n" }, "<Esc>", "<cmd>noh<CR><Esc>", { desc = "Escape and clear search" })

  -- prevent capital Q from clobbering the current buffer
  map("n", "Q", "<Nop>", { desc = "Prevent Ex Mode when pressing Q" })

  -- add undo break-points
  local punctuation_marks = { ",", ".", ";", "!", "?", "(", ")", "{", "}" }
  for _, mark in ipairs(punctuation_marks) do
    map("i", mark, mark .. "<c-g>u", { desc = "Create undo break-point" })
  end

  -- search terms stay in the middle of the screen
  map("n", "n", "nzzzv", { desc = "Next search result (centered)" })
  map("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })

  -- Preserve visual selection while indenting
  map("v", "<", "<gv", { desc = "Indent left and maintain selection" })
  map("v", ">", ">gv", { desc = "Indent right and maintain selection" })

  -- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
  map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
  map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
  map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
  map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
  map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
  map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
end

local function setup_buffer_operations()
  -- buffer navigation
  map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
  map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
  map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })

  -- new file
  map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

  -- save file
  map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

  -- quit all
  map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })

  -- move lines up and down in visual mode
  map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected lines down" })
  map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected lines up" })

  -- commenting
  map("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Below" })
  map("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Above" })
end

local function setup_terminal_mappings()
  local terminal_maps = {
    { mode = "t", lhs = "<Esc><Esc>", rhs = "<C-\\><C-n>", desc = "Enter Normal Mode" },
    { mode = "t", lhs = "<C-h>", rhs = "<cmd>wincmd h<cr>", desc = "Go to Left Window" },
    { mode = "t", lhs = "<C-j>", rhs = "<cmd>wincmd j<cr>", desc = "Go to Lower Window" },
    { mode = "t", lhs = "<C-k>", rhs = "<cmd>wincmd k<cr>", desc = "Go to Upper Window" },
    { mode = "t", lhs = "<C-l>", rhs = "<cmd>wincmd l<cr>", desc = "Go to Right Window" },
    { mode = "t", lhs = "<C-/>", rhs = "<cmd>close<cr>", desc = "Hide Terminal" },
  }
  for _, mapping in ipairs(terminal_maps) do
    map(mapping.mode, mapping.lhs, mapping.rhs, { desc = mapping.desc })
  end
end

local function setup_window_splits()
  local window_splits = {
    { mode = "n", lhs = "<leader>ww", rhs = "<C-W>p", desc = "Other Window" },
    { mode = "n", lhs = "<leader>wd", rhs = "<C-W>c", desc = "Delete Window" },
    { mode = "n", lhs = "<leader>w-", rhs = "<C-W>s", desc = "Split Window Below" },
    { mode = "n", lhs = "<leader>w|", rhs = "<C-W>v", desc = "Split Window Right" },
    { mode = "n", lhs = "<leader>-", rhs = "<C-W>s", desc = "Split Window Below" },
    { mode = "n", lhs = "<leader>|", rhs = "<C-W>v", desc = "Split Window Right" },
  }
  for _, mapping in ipairs(window_splits) do
    map(mapping.mode, mapping.lhs, mapping.rhs, { desc = mapping.desc, remap = true })
  end
end

local function setup_toggles()
  -- Toggle wrap
  map("n", "<leader>tw", "<cmd>set wrap!<CR>", {
    desc = "Toggle Wrap",
  })
  -- Toggle spell
  map("n", "<leader>ts", "<cmd>set spell!<CR>", {
    desc = "Toggle Spell",
    silent = true,
  })

  -- toggle autoformat
  map("n", "<leader>ta", function()
    auto_format = not auto_format
    vim.notify(string.format("Autoformat %s", auto_format and "enabled" or "disabled"), vim.log.levels.INFO)
    if auto_format then
      vim.cmd("FormatEnable")
    else
      vim.cmd("FormatDisable")
    end
  end, { desc = "Toggle Autoformat" })
end

local function setup_utils()
  local util_maps = {
    -- inspection
    { lhs = "<leader>ui", rhs = vim.show_pos, desc = "Inspect Pos" },
    { lhs = "<leader>uI", rhs = "<cmd>InspectTree<cr>", desc = "Inspect Tree" },
    -- spellcheck
    {
      lhs = "<leader>us",
      rhs = "<cmd>lua require('utils.cspell').add_word_to_c_spell_dictionary()<CR>",
      desc = "Add unknown to cspell dictionary",
    },
  }
  for _, mapping in ipairs(util_maps) do
    map("n", mapping.lhs, mapping.rhs, { desc = mapping.desc })
  end

  -- tools
  map("n", "<leader>uz", "<cmd>Lazy<cr>", { desc = "Lazy" })
end

local function setup_maybe_remove()
  map("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
  map("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })

  map("n", "[q", ":cprev<CR>zz", { desc = "Previous Quickfix item" })
  map("n", "]q", ":cnext<CR>zz", { desc = "Next Quickfix item" })

  -- Fix Spell checking
  map("n", "z0", "1z=", {
    desc = "Fix world under cursor",
  })
end

--- Setup all keymaps
function M.setup()
  disable_arrows()
  -- setup keymaps
  setup_navigation_maps()
  setup_window_management()
  setup_clipboard_operations()
  setup_diagnostic_navigation()
  setup_quality_of_life_tweaks()
  setup_buffer_operations()
  setup_terminal_mappings()
  setup_window_splits()
  setup_toggles()
  setup_utils()
  setup_maybe_remove()
end

return M.setup()

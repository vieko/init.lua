-- [[ OPTIONS ]]
vim.opt.autoindent = true
vim.opt.backup = false
vim.opt.breakindent = true
vim.opt.clipboard = "unnamedplus"
vim.opt.cmdheight = 1
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.copyindent = true
vim.opt.colorcolumn = "80"
vim.opt.cursorcolumn = false
vim.opt.cursorline = true
vim.opt.errorbells = false
vim.opt.expandtab = true
vim.opt.fileencoding = "utf-8"
vim.opt.fillchars = { eob = " " }
vim.opt.foldenable = false
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.formatoptions:remove("o")
vim.opt.guicursor = ""
vim.opt.history = 100
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.inccommand = "split"
vim.opt.infercase = true
vim.opt.laststatus = 3
vim.opt.linebreak = true
vim.opt.list = true
vim.opt.listchars = {
  tab = "» ",
  space = "·",
  extends = "›",
  precedes = "‹",
  nbsp = "␣",
  -- eol = "¬",
  -- trail = ".",
}
vim.opt.mouse = "a"
vim.opt.number = true
vim.opt.numberwidth = 3
vim.opt.preserveindent = true
vim.opt.pumheight = 10
vim.opt.relativenumber = true
vim.opt.scrolloff = 8
vim.opt.shada = { "'10", "<0", "s10", "h" }
vim.opt.shell = "fish"
vim.opt.shiftwidth = 2
vim.opt.showmatch = false
vim.opt.showmode = false
vim.opt.showtabline = 0
vim.opt.shortmess:append("I")
vim.opt.shortmess:append("c")
vim.opt.sidescrolloff = 8
vim.opt.signcolumn = "yes:2"
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.smarttab = true
vim.opt.softtabstop = 2
vim.opt.spell = false
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.swapfile = false
vim.opt.tabstop = 2
vim.opt.termguicolors = true
vim.opt.timeoutlen = 300
vim.opt.undodir = vim.fn.stdpath("data") .. "/undodir"
vim.opt.undofile = true
vim.opt.updatetime = 250
vim.opt.virtualedit = "block"
vim.opt.wildignorecase = true
vim.opt.wrap = true -- false
vim.opt.writebackup = false
vim.g.have_nerd_font = false

-- [[ UTILITIES ]]
vim.g.clipboard = {
  name = "xclip",
  copy = {
    ["+"] = "xclip -selection clipboard",
    ["*"] = "xclip -selection clipboard",
  },
  paste = {
    ["+"] = "xclip -selection clipboard -o",
    ["*"] = "xclip -selection clipboard -o",
  },
  cache_enabled = 0,
}

-- [[ NETRW ]]
vim.g.netrw_keepdir = 0
vim.g.netrw_winsize = 20
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_browse_split = 4

-- [[ DISABLE BUILTINS ]]
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwplugin = 1
-- vim.g.loaded_netrwsettings = 1

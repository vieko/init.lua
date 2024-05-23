return { -- Collection of various small independent plugins/modules
  "echasnovski/mini.nvim",
  config = function()
    -- better around/inside textobjects
    --  - va)  - [V]isually select [A]round [)]paren
    --  - yinq - [Y]ank [I]nside [N]ext [']quote
    --  - ci'  - [C]hange [I]nside [']quote
    require("mini.ai").setup({ n_lines = 500 })
    -- add/delete/replace surroundings (brackets, quotes, etc.)
    -- - caiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
    -- - cd'   - [S]urround [D]elete [']quotes
    -- - cr)'  - [S]urround [R]eplace [)] [']
    -- require("mini.surround").setup({
    --   mappings = {
    --     add = "ca", -- Add surrounding in Normal and Visual modes
    --     delete = "cd", -- Delete surrounding
    --     find = "cf", -- Find surrounding (to the right)
    --     find_left = "cF", -- Find surrounding (to the left)
    --     highlight = "ch", -- Highlight surrounding
    --     replace = "cr", -- Replace surrounding
    --     update_n_lines = "cn", -- Update `n_lines`
    --     suffix_last = "l", -- Suffix to search with "prev" method
    --     suffix_next = "n", -- Suffix to search with "next" method
    --   },
    -- })
    -- simple and easy statusline.
    local statusline = require("mini.statusline")
    local active = function()
      local mode, mode_hl = statusline.section_mode({ trunc_width = 120 })
      local git = statusline.section_git({ trunc_width = 75, icon = "GIT" })
      local diagnostics = statusline.section_diagnostics({ trunc_width = 75, icon = "LSP" })
      local filename = MiniStatusline.section_filename({ trunc_width = 140 })
      local fileinfo = statusline.section_fileinfo({ trunc_width = 120 })
      local location = statusline.section_location({ trunc_width = 75 })
      local search = statusline.section_searchcount({ trunc_width = 75 })

      return MiniStatusline.combine_groups({
        { hl = mode_hl, strings = { mode } },
        { hl = "MiniStatuslineDevinfo", strings = { git, diagnostics } },
        "%<", -- Mark general truncate point
        { hl = "MiniStatuslineFilename", strings = { filename } },
        "%=", -- End left alignment
        { hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
        { hl = mode_hl, strings = { search, location } },
      })
    end
    statusline.setup({ use_icons = vim.g.have_nerd_font, set_vim_settings = false, content = { active = active } })
  end,
}

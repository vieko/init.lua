local git_ignored = setmetatable({}, {
  __index = function(self, key)
    local proc = vim.system({ "git", "ls-files", "--ignored", "--exclude-standard", "--others", "--directory" }, {
      cwd = key,
      text = true,
    })
    local result = proc:wait()
    local ret = {}
    if result.code == 0 then
      for line in vim.gsplit(result.stdout, "\n", { plain = true, trimempty = true }) do
        -- Remove trailing slash
        line = line:gsub("/$", "")
        table.insert(ret, line)
      end
    end

    rawset(self, key, ret)
    return ret
  end,
})

local function max_height()
  local height = vim.fn.winheight(0)
  if height >= 40 then
    return 30
  elseif height >= 30 then
    return 20
  else
    return 10
  end
end

return {
  { -- filesystem explorer
    "stevearc/oil.nvim",
    opts = {
      default_file_explorer = false,
      skip_confirm_for_simple_edits = true,
      use_default_keymaps = true,
      view_options = {
        show_hidden = false,
        is_hidden_file = function(name, _)
          -- dotfiles are always considered hidden
          if vim.startswith(name, ".") then
            return true
          end
          local dir = require("oil").get_current_dir()
          -- if no local directory (e.g. for ssh connections), always show
          if not dir then
            return false
          end
          -- Check if file is gitignored
          return vim.list_contains(git_ignored[dir], name)
        end,
      },
      win_options = {
        colorcolumn = "",
        signcolumn = "yes:2",
        relativenumber = false,
        number = false,
      },
      columns = {},
      float = {
        padding = 2,
        max_width = 120,
        max_height = max_height(),
        border = "rounded",
        win_options = {
          winblend = 0,
        },
      },
      keymaps = {
        ["<C-c>"] = false,
        ["<C-h>"] = false,
        ["<C-s>"] = {
          desc = "Save all changes",
          callback = function()
            require("oil").save({ confirm = false })
          end,
        },
        ["q"] = "actions.close",
        ["<C-y>"] = "action.copy_entry_path",
      },
    },
    keys = {
      {
        "<leader>te",
        function()
          -- require("oil").toggle_float()
          require("oil").open()
        end,
        desc = "Toggle File Explorer",
      },
      {
        "-",
        function()
          require("oil").open()
        end,
        desc = "Open Parent Directory",
      },
    },
  },
  {
    "refractalize/oil-git-status.nvim",
    dependencies = {
      "stevearc/oil.nvim",
    },
    config = true,
  },
}

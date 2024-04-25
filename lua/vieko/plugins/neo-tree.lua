return { -- File Explorer
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  init = function()
    vim.keymap.set("n", "\\", "<Cmd>Neotree reveal toggle<CR>", { desc = "toggle tree" })
  end,
  config = function()
    require("neo-tree").setup({
      sources = {
        "filesystem",
        "buffers",
        "git_status",
        "document_symbols",
      },
      close_if_last_window = true,
      default_component_configs = {
        diagnostics = {
          symbols = {
            hint = "H",
            info = "I",
            warn = "W",
            error = "E",
          },
          highlights = {
            hint = "DiagnosticSignHint",
            info = "DiagnosticSignInfo",
            warn = "DiagnosticSignWarn",
            error = "DiagnosticSignError",
          },
        },
        modified = {
          symbol = "[+]",
          highlight = "NeoTreeModified",
        },
        name = {
          trailing_slash = false,
          highlight_opened_files = false,
          use_git_status_colors = false,
          highlight = "NeoTreeFileName",
        },
        git_status = {
          symbols = {
            added = "A",
            modified = "M",
            deleted = "D",
            renamed = "R",
            untracked = "?",
            ignored = "!",
            unstaged = "U",
            staged = "S",
            conflict = "C",
          },
        },
      },
      filesystem = {
        window = {
          mappings = {
            ["\\"] = "close_window",
          },
        },
        hijack_netrw_behavior = "open_default",
        filtered_items = {
          visible = false,
          hide_dotfiles = true,
          hide_gitignored = true,
          hide_hidden = true,
          hide_by_name = {
            "node_modules",
          },
          always_show = {
            ".gitignore",
          },
        },
        components = {
          icon = function(config, node, state)
            if node.type == "file" or node.type == "directory" then
              return {}
            end
            -- if node.type == "directory" then
            --   return {
            --     text = "- ",
            --     highlight = config.highlight,
            --   }
            -- end
            -- if node.type == "file" then
            --   return {
            --     text = "* ",
            --     highlight = config.highlight,
            --   }
            -- end
            return require("neo-tree.sources.common.components").icon(config, node, state)
          end,
        },
      },
    })
  end,
}

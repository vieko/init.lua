-- [[ TREESITTER ]]
--
-- Uses nvim-treesitter `main` branch (the legacy `master` branch is frozen and
-- broken against Neovim 0.12+; `Query:iter_matches` API changed and the old
-- plugin still passes the removed `{ all = false }` option).
--
-- `main` is a parser/query installer only — no module system. Highlight,
-- indent, and folds are wired up via the autocmd below using the built-in
-- `vim.treesitter` APIs. `auto_install` parity is provided by the FileType
-- handler installing missing parsers on demand.
--
-- Textobjects + incremental_selection from the legacy plugin are intentionally
-- dropped here; `mini.ai` defaults in `core/coding.lua` cover the common
-- cases (`af`/`if`/`aa`/`ia`).
return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = function()
      pcall(function()
        require("nvim-treesitter").update({ async = false })
      end)
    end,
    opts_extend = { "ensure_installed" },
    opts = {
      ensure_installed = {
        "bash",
        "c",
        "diff",
        -- "go", -- Disabled: Go not installed
        "html",
        "http",
        "javascript",
        "jsdoc",
        "json",
        -- "jsonc" -- unsupported on nvim-treesitter `main`; jsonc filetype
        --             still highlights via the json parser + comment injections.
        "lua",
        "luadoc",
        "luap",
        "markdown",
        "markdown_inline",
        "printf",
        "python",
        "query",
        "regex",
        -- "rust", -- Disabled: Rust not needed
        -- "toml", -- Disabled: only used for Rust Cargo.toml
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "xml",
        "yaml",
      },
    },
    config = function(_, opts)
      local ts = require("nvim-treesitter")
      ts.setup()

      -- Install the configured parsers. `install` is idempotent and async;
      -- it no-ops for parsers already present.
      if opts.ensure_installed and #opts.ensure_installed > 0 then
        pcall(ts.install, opts.ensure_installed)
      end

      -- Per-buffer activation: highlight + indent. Lazy-installs missing
      -- parsers to mimic the old `auto_install` behavior.
      local group = vim.api.nvim_create_augroup("vieko.treesitter", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        callback = function(ev)
          local buf = ev.buf
          local ft = vim.bo[buf].filetype
          if ft == "" then
            return
          end

          local lang = vim.treesitter.language.get_lang(ft) or ft

          -- If the parser isn't available yet, kick off an install and bail.
          -- The next time this filetype is opened the parser will be ready.
          if not pcall(vim.treesitter.language.add, lang) then
            pcall(ts.install, { lang })
            return
          end

          -- Enable treesitter highlighting for this buffer.
          pcall(vim.treesitter.start, buf, lang)

          -- Best-effort treesitter-based indent. nvim-treesitter ships
          -- indent queries for most ensure_installed languages.
          pcall(function()
            vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end)
        end,
      })

      -- Re-fire FileType for buffers that were already loaded before this
      -- config ran (e.g., the first file opened from the command line).
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) then
          local ft = vim.bo[buf].filetype
          if ft ~= "" then
            vim.api.nvim_exec_autocmds("FileType", {
              group = group,
              buffer = buf,
            })
          end
        end
      end
    end,
  },
  -- Use treesitter to auto close and auto rename html tag
  {
    "windwp/nvim-ts-autotag",
    event = "BufReadPre",
    opts = {},
  },
  -- Auto highlight word under cursor
  {
    "echasnovski/mini.cursorword",
    event = "LspAttach",
    config = function()
      local mc = require("mini.cursorword")
      mc.setup({
        delay = 100,
      })
    end,
  },
}

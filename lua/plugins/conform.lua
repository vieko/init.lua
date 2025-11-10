-- [[ CONFORM ]]
local Lsp = require("utils.lsp")

---Run the first available formatter followed by more formatters
---@param bufnr integer
---@param ... string
---@return string
local function first(bufnr, ...)
  local conform = require("conform")
  for i = 1, select("#", ...) do
    local formatter = select(i, ...)
    if conform.get_formatter_info(formatter, bufnr).available then
      return formatter
    end
  end
  return select(1, ...)
end

return {
  -- Setup config for formatter
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    ---@type conform.setupOpts
    opts = {
      format_on_save = function(bufnr)
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        return { timeout_ms = 3000, lsp_format = "fallback" }
      end,
      formatters_by_ft = {
        sh = { "shfmt" },
        yaml = { "prettier", "dprint", stop_after_first = true },
        ["markdown"] = { "prettier", "dprint", stop_after_first = true },
        ["markdown.mdx"] = { "prettier", "dprint", stop_after_first = true },
        ["javascript"] = { "prettier", "biome", "dprint", stop_after_first = true },
        ["javascriptreact"] = function(bufnr)
          return { "rustywind", first(bufnr, "prettier", "biome", "dprint") }
        end,
        ["typescript"] = { "prettier", "biome", "dprint", stop_after_first = true },
        ["typescriptreact"] = function(bufnr)
          return { "rustywind", first(bufnr, "prettier", "biome", "dprint") }
        end,
        ["svelte"] = function(bufnr)
          return { "rustywind", first(bufnr, "prettier", "biome", "dprint") }
        end,
      },
      formatters = {
        biome = {
          condition = function()
            -- Only use biome if config exists and is NOT in nvim config dir
            local path = Lsp.biome_config_path()
            return path ~= nil and not path:match("nvim")
          end,
        },
        deno_fmt = {
          condition = function()
            return Lsp.deno_config_exist()
          end,
        },
        dprint = {
          condition = function()
            return Lsp.dprint_config_exist()
          end,
        },
        prettier = {
          condition = function()
            local ft = vim.bo.filetype

            -- Always allow prettier for markdown (biome doesn't support markdown)
            if ft == "markdown" or ft == "markdown.mdx" then
              return Lsp.prettier_config_exists()
            end

            -- For JS/TS files: prefer biome if available, otherwise check for prettier config
            local biome_path = Lsp.biome_config_path()
            local has_biome = biome_path ~= nil and not biome_path:match("nvim")

            -- Don't use prettier if biome is configured for this project
            if has_biome then
              return false
            end

            -- Use prettier if it's explicitly configured
            return Lsp.prettier_config_exists()
          end,
        },
        prettierd = {
          condition = function()
            -- Same logic as prettier
            local ft = vim.bo.filetype

            if ft == "markdown" or ft == "markdown.mdx" then
              return Lsp.prettier_config_exists()
            end

            local biome_path = Lsp.biome_config_path()
            local has_biome = biome_path ~= nil and not biome_path:match("nvim")

            if has_biome then
              return false
            end

            return Lsp.prettier_config_exists()
          end,
        },
      },
    },
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
      -- Async formatting
      vim.api.nvim_create_user_command("Format", function(args)
        local range = nil
        if args.count ~= -1 then
          local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
          range = {
            start = { args.line1, 0 },
            ["end"] = { args.line2, end_line:len() },
          }
        end
        require("conform").format({ async = true, lsp_format = "fallback", range = range })
      end, { range = true })

      vim.api.nvim_create_user_command("FormatDisable", function(args)
        if args.bang then
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
    end,
  },
}

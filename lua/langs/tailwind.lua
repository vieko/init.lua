-- [[ TAILWIND ]]

-- Auto-detect Tailwind CSS v4 configuration
local function find_tailwind_config()
  local experimental_config = {}

  -- Find git root or use current working directory
  local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
  local root_dir = (git_root and vim.v.shell_error == 0) and git_root or vim.fn.getcwd()

  -- Common locations for Tailwind v4 CSS entrypoints in monorepos
  local possible_css_paths = {
    "packages/ui/src/styles/globals.css",
    "src/styles/globals.css",
    "app/globals.css",
    "styles/globals.css",
  }

  -- Find the CSS entrypoint
  local css_file = nil
  for _, path in ipairs(possible_css_paths) do
    local full_path = root_dir .. "/" .. path
    if vim.fn.filereadable(full_path) == 1 then
      -- Check if it contains @import "tailwindcss"
      local content = vim.fn.readfile(full_path, "", 10) -- Read first 10 lines
      for _, line in ipairs(content) do
        if line:match('@import%s+"tailwindcss"') then
          css_file = full_path
          break
        end
      end
      if css_file then break end
    end
  end

  -- If found, set up patterns for monorepo structure
  if css_file then
    experimental_config[css_file] = {
      root_dir .. "/apps/**/src/**/*",
      root_dir .. "/packages/**/src/**/*",
      root_dir .. "/src/**/*", -- Fallback for non-monorepo
    }
  end

  return experimental_config
end

local experimental_config = find_tailwind_config()

return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      -- Extend the existing opts with tailwind configuration
      opts.servers = opts.servers or {}
      opts.setup = opts.setup or {}

      -- Configure tailwindcss server settings
      opts.servers.tailwindcss = {
        mason = false,  -- Use globally installed server, not Mason
        settings = {
          tailwindCSS = {
            validate = true,
            hovers = true,
            suggestions = true,
            colorDecorators = true,
            experimental = {
              configFile = experimental_config,
            },
          },
        },
      }

      -- Use custom setup function to ensure our settings are applied
      opts.setup.tailwindcss = function(_, server_opts)
        -- Deep merge our settings with server_opts
        server_opts.settings = server_opts.settings or {}
        server_opts.settings.tailwindCSS = vim.tbl_deep_extend("force",
          server_opts.settings.tailwindCSS or {},
          {
            validate = true,
            hovers = true,
            suggestions = true,
            colorDecorators = true,
            experimental = {
              configFile = experimental_config,
            },
          }
        )

        -- Setup the server with our modified settings using new nvim 0.11+ API
        if vim.fn.has("nvim-0.11") == 1 then
          -- Use new vim.lsp.config API (nvim 0.11+)
          vim.lsp.config.tailwindcss = server_opts
          vim.lsp.enable("tailwindcss")
        else
          -- Fallback to old lspconfig API
          require("lspconfig").tailwindcss.setup(server_opts)
        end

        -- Return true to skip default setup
        return true
      end

      return opts
    end,
  },
}

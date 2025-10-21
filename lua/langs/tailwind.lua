-- [[ TAILWIND ]]

-- Auto-detect Tailwind CSS configuration (v3 or v4)
local function find_tailwind_config(root_dir)
  local experimental_config = {}

  -- Check for Tailwind v3 (tailwind.config.{js,ts,cjs,mjs})
  local v3_config_patterns = {
    "tailwind.config.js",
    "tailwind.config.ts",
    "tailwind.config.cjs",
    "tailwind.config.mjs",
  }

  for _, config_file in ipairs(v3_config_patterns) do
    local config_path = root_dir .. "/" .. config_file
    if vim.fn.filereadable(config_path) == 1 then
      -- v3 detected - return nil to use default behavior
      return nil
    end
  end

  -- Check for Tailwind v4 (@import "tailwindcss" in CSS files)
  local possible_css_paths = {
    "packages/ui/src/styles/globals.css",
    "src/styles/globals.css",
    "app/globals.css",
    "styles/globals.css",
  }

  local css_file = nil
  for _, path in ipairs(possible_css_paths) do
    local full_path = root_dir .. "/" .. path
    if vim.fn.filereadable(full_path) == 1 then
      -- Check if it contains @import "tailwindcss" (v4 indicator)
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

  -- If v4 detected, set up patterns for monorepo structure
  if css_file then
    experimental_config[css_file] = {
      root_dir .. "/apps/**/src/**/*",
      root_dir .. "/packages/**/src/**/*",
      root_dir .. "/src/**/*", -- Fallback for non-monorepo
    }
    return experimental_config
  end

  -- No v3 or v4 detected - return empty config
  return {}
end

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
        -- Detect Tailwind version based on root_dir
        local root_dir = server_opts.root_dir
        if type(root_dir) == "function" then
          -- root_dir is a function, call it with current buffer path
          root_dir = root_dir(vim.api.nvim_buf_get_name(0))
        end

        local experimental_config = find_tailwind_config(root_dir or vim.fn.getcwd())

        -- Build settings based on detected version
        local tailwind_settings = {
          validate = true,
          hovers = true,
          suggestions = true,
          colorDecorators = true,
        }

        -- Add experimental.configFile for v4, or if v3 (nil), don't add it
        if experimental_config then
          tailwind_settings.experimental = {
            configFile = experimental_config,
          }
        end

        -- Deep merge our settings with server_opts
        server_opts.settings = server_opts.settings or {}
        server_opts.settings.tailwindCSS = vim.tbl_deep_extend("force",
          server_opts.settings.tailwindCSS or {},
          tailwind_settings
        )

        -- Let lspconfig handle the setup with our merged settings
        -- lspconfig will use the appropriate API based on nvim version
        return false
      end

      return opts
    end,
  },
}

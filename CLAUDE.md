# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture

This Neovim configuration uses **lazy.nvim** as the plugin manager with a modular architecture:

- **Bootstrap**: `init.lua` handles lazy.nvim installation and loads core configs
- **Modular Loading**: Uses `require("config.lazy").load()` for sequential config loading
- **Lazy Loading**: Plugins are lazy-loaded by default with event/cmd triggers
- **Separation of Concerns**: Clear directory structure with focused responsibilities

### Directory Structure
- `config/`: Core Neovim configuration (options, keymaps, autocmds, highlights, theme)
- `core/`: Core functionality modules (editor, coding, colorscheme, lsp, treesitter)
- `langs/`: Language-specific configurations (go, rust, typescript, lua, etc.)
- `plugins/`: Individual plugin configurations
- `utils/`: Shared utility functions and helpers
- `lint/linters/`: Custom linter configurations

## Commands

### Formatting
- `Format` - Run formatters on current buffer (async)
- `FormatDisable [!]` - Disable autoformat globally or buffer-local (with !)
- `FormatEnable` - Re-enable autoformat

### ESLint Integration  
- `ToggleEslint` - Toggle ESLint LSP client on/off
- `EslintFixAll` - Fix all ESLint issues in current buffer

### Development
- Use `stylua .` to format all Lua files according to stylua.toml config
- No test commands - this is a configuration repository

## Code Patterns

### Lua Module Pattern
```lua
-- [[ SECTION NAME ]]
local M = {}

---@param param string Description
---@return boolean
function M.some_function(param)
  -- implementation
end

return M
```

### Plugin Configuration Pattern
```lua
return {
  {
    "plugin/name",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      -- plugin options
    },
    config = function(_, opts)
      require("plugin").setup(opts)
    end,
  },
}
```

### Conditional Plugin Loading
Use condition functions in formatters/LSP configs to check for project-specific configs:
- `Lsp.biome_config_path()` - Check for biome config
- `Lsp.dprint_config_exist()` - Check for dprint config

## Formatter Hierarchy

**JavaScript/TypeScript**: biome → prettier → dprint (first available)
**React/Svelte**: rustywind + (biome → prettier → dprint) for Tailwind + JS formatting
**Lua**: stylua only
**Shell**: shfmt
**YAML/Markdown**: prettier → dprint

## LSP Configuration

- Uses `utils.lsp` for common LSP operations
- Keymaps auto-configured via `setup_keymaps()` function  
- Language-specific servers configured in `langs/` directory
- ESLint integration toggleable via `ToggleEslint` command

## Key Integrations

- **Tmux Navigation**: Seamless pane switching with vim-tmux-navigator
- **Git**: Fugitive for git operations
- **Completion**: nvim-cmp with LSP, buffer, and path sources
- **Picker**: Snacks picker for LSP navigation (definitions, references, symbols)
- **Auto-pairs**: mini.pairs for bracket/quote completion
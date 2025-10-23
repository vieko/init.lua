# My neovim config since 2024

A modular Neovim configuration built with lazy.nvim, featuring comprehensive LSP support, multiple language configurations, and tinted-theming integration.

## Structure

```
├── config/     # Core Neovim settings (options, keymaps, autocmds, highlights, theme)
├── core/       # Plugin categories (editor, coding, colorscheme, LSP, treesitter)
├── langs/      # Language-specific configurations
├── plugins/    # Individual plugin configurations
├── utils/      # Shared utilities and helpers
└── lint/       # Custom linter configurations
```

## Plugins

- **UI**: bufferline, lualine, noice, mini.icons
- **Editor**: fugitive, gitsigns, tmux-navigator, flash
- **Coding**: nvim-cmp, conform, nvim-lint, ESLint integration
- **LSP**: Full language server integration with diagnostics
- **Theme**: tinted-theming + Catppuccin with custom highlights

## Development

Use `stylua .` to format all Lua files according to stylua.toml config.

## Sources

- https://github.com/nvim-lua/kickstart.nvim
- https://github.com/LazyVim/LazyVim
- https://github.com/tinted-theming

## TODO

- [ ] extract themes from tinted-theming, make your own onedark instead
- [ ] multi-cursor?
- [ ] test Biome formatter (install `npm install -g @biomejs/biome` and add biome.json to projects)

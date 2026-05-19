-- [[ TAILWIND ]]
--
-- `tailwindcss-language-server` v0.14+ natively auto-detects both
-- Tailwind v3 (`tailwind.config.{js,ts,cjs,mjs}` + `postcss.config.*`) and
-- Tailwind v4 (`@import "tailwindcss"` in any CSS file in the workspace).
-- The older `experimental.configFile` mapping that this file used to
-- compute is a legacy workaround for pre-0.12 servers; supplying it with
-- modern versions actively breaks v4 auto-discovery whenever the project
-- layout doesn't match the hardcoded CSS paths.
--
-- The lspconfig-provided defaults (root_dir, filetypes, capabilities,
-- lint/classAttributes/includeLanguages settings) already cover every
-- modern stack: HTML/JS/TS/JSX/TSX/Vue/Svelte/Astro/CSS/SCSS/etc.
-- See `~/.local/share/nvim/lazy/nvim-lspconfig/lsp/tailwindcss.lua`.

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Empty table = "enable with all lspconfig defaults".
        -- Per-project tweaks (e.g. extra `classAttributes` for a CMS,
        -- custom `experimental.classRegex` for cn()-style helpers) belong
        -- in a project-local `.nvim.lua` (exrc is enabled), not here.
        tailwindcss = {},
      },
    },
  },
}

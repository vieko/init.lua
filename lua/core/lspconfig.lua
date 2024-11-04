---@class LSPDiagnosticSigns
---@field Error string
---@field Warn string
---@field Hint string
---@field Info string
local diagnostics = {
  Error = "E ",
  Warn = "W ",
  Hint = "H ",
  Info = "I ",
}

---@param client table
---@param buffer number
local setup_keymaps = function(client, buffer)
  local map = function(keys, func, desc)
    vim.keymap.set("n", keys, func, { buffer = buffer, desc = "LSP: " .. desc })
  end

  map("<leader>ca", vim.lsp.buf.code_action, "Code Actions")
  map("<leader>.", vim.lsp.buf.code_action, "Code Actions")

  map("<leader>cA", require("utils.lsp").action.source, "Source Actions")
  map("<leader>cr", vim.lsp.buf.rename, "Code Rename")
  map("<leader>cf", vim.lsp.buf.format, "Code Format")

  if client.server_capabilities.hoverProvider then
    map("<leader>k", vim.lsp.buf.hover, "Documentation")
    map("K", vim.lsp.buf.hover, "Documentation")
  end
  if client.server_capabilities.definitionProvider or client.server_capabilities.declarationProvider then
    map("gd", vim.lsp.buf.definition, "Goto Definition")
    map("gD", vim.lsp.buf.declaration, "Goto Declaration")
  end
  if client.server_capabilities.referencesProvider then
    vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = buffer, desc = "Goto References", nowait = true })
  end
  if client.server_capabilities.implementationProvider then
    map("gi", vim.lsp.buf.implementation, "Goto Implementation")
  end
  if client.server_capabilities.typeDefinitionProvider then
    map("gy", vim.lsp.buf.type_definition, "Goto Type Definition")
  end

  if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
    map("<leader>th", function()
      require("utils.toggle").inlay_hints(buffer)
    end, "Toggle Inlay Hints")
  end
end

---@class LSPOptions
---@field diagnostics table
---@field inlay_hints table
---@field capabilities table
---@field servers table
---@field setup table<string, function>

return {
  { -- lspconfig
    "neovim/nvim-lspconfig",
    event = "VeryLazy",
    dependencies = {
      "mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    ---@return LSPOptions
    opts = function()
      -- local border = "rounded"
      -- vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
      --   border = border,
      -- })
      -- vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
      --   border = border,
      -- })
      -- vim.diagnostic.config({
      --   float = { border = border },
      -- })
      return {
        -- options for vim.diagnostic.config()
        ---@type vim.diagnostic.Opts
        diagnostics = {
          underline = true,
          update_in_insert = false,
          virtual_text = {
            spacing = 4,
            source = "if_many",
            prefix = "",
          },
          severity_sort = true,
          signs = {
            text = {
              [vim.diagnostic.severity.ERROR] = diagnostics.Error,
              [vim.diagnostic.severity.WARN] = diagnostics.Warn,
              [vim.diagnostic.severity.HINT] = diagnostics.Hint,
              [vim.diagnostic.severity.INFO] = diagnostics.Info,
            },
          },
        },
        -- Enable this to enable the builtin LSP inlay hints on Neovim >= 0.10.0
        -- Be aware that you also will need to properly configure your LSP server to
        -- provide the inlay hints.
        inlay_hints = {
          enabled = true,
          exclude = { "vue" }, -- filetypes for which you don't want to enable inlay hints
        },
        -- add any global capabilities here
        capabilities = {
          workspace = {
            fileOperations = {
              didRename = true,
              willRename = true,
            },
          },
        },
        servers = {},
        setup = {},
      }
    end,
    ---@param _ any
    ---@param opts LSPOptions
    config = function(_, opts)
      -- Setup keymaps
      require("utils.lsp").on_attach(setup_keymaps)
      require("utils.lsp").setup()
      require("utils.lsp").on_dynamic_capability(setup_keymaps)

      -- diagnostics signs
      if type(opts.diagnostics.signs) ~= "boolean" then
        for severity, icon in pairs(opts.diagnostics.signs.text) do
          local name = vim.diagnostic.severity[severity]:lower():gsub("^%l", string.upper)
          name = "DiagnosticSign" .. name
          vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
        end
      end

      -- inlay hints
      if opts.inlay_hints.enabled then
        require("utils.lsp").on_supports_method("textDocument/inlayHint", function(_, buffer)
          if
            vim.api.nvim_buf_is_valid(buffer)
            and vim.bo[buffer].buftype == ""
            and not vim.tbl_contains(opts.inlay_hints.exclude, vim.bo[buffer].filetype)
          then
            require("utils.toggle").inlay_hints(buffer, true)
          end
        end)
      end

      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

      local servers = opts.servers
      local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        has_cmp and cmp_nvim_lsp.default_capabilities() or {},
        opts.capabilities or {}
      )

      local function setup(server)
        local server_opts = vim.tbl_deep_extend("force", {
          capabilities = vim.deepcopy(capabilities),
        }, servers[server] or {})

        if opts.setup[server] then
          if opts.setup[server](server, server_opts) then
            return
          end
        elseif opts.setup["*"] then
          if opts.setup["*"](server, server_opts) then
            return
          end
        end
        require("lspconfig")[server].setup(server_opts)
      end

      -- get all the servers that are available through mason-lspconfig
      local have_mason, mlsp = pcall(require, "mason-lspconfig")
      local all_mslp_servers = {}
      if have_mason then
        all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
      end

      local ensure_installed = {} ---@type string[]
      for server, server_opts in pairs(servers) do
        if server_opts then
          server_opts = server_opts == true and {} or server_opts
          if server_opts.enabled ~= false then
            -- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
            if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
              setup(server)
            else
              ensure_installed[#ensure_installed + 1] = server
            end
          end
        end
      end

      if have_mason then
        mlsp.setup({
          ensure_installed = vim.tbl_deep_extend("force", ensure_installed, {}),
          handlers = { setup },
        })
      end
    end,
  },
  { -- cmdline tools and lsp servers
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    build = ":MasonUpdate",
    opts_extend = { "ensure_installed" },
    opts = {
      ensure_installed = {
        "stylua",
      },
      ui = {
        border = "rounded",
      },
    },
    ---@param opts MasonSettings | {ensure_installed: string[]}
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      mr:on("package:install:success", function()
        vim.defer_fn(function()
          -- trigger FileType event to possibly load this newly installed LSP server
          require("lazy.core.handler.event").trigger({
            event = "FileType",
            buf = vim.api.nvim_get_current_buf(),
          })
        end, 100)
      end)

      mr.refresh(function()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end)
    end,
  },
  { -- Useful status updates for LSP.
    "j-hui/fidget.nvim",
    config = function()
      require("fidget").setup({
        progress = {
          display = {
            done_icon = "",
          },
        },
        notification = {
          window = {
            winblend = 0,
          },
        },
      })
    end,
  },
}

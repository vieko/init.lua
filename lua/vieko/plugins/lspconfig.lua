return { -- LSP Configuration & Plugins
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",

    { -- Useful status updates for LSP.
      "j-hui/fidget.nvim",
      config = function()
        require("fidget").setup({
          notification = {
            window = {
              winblend = 0,
            },
          },
        })
      end,
    },

    -- used for completion, annotations and signatures of Neovim apis
    {
      "folke/lazydev.nvim",
      ft = "lua",
      opts = {
        library = {
          "luvit-meta/library",
        },
      },
    },
    { "Bilal2453/luvit-meta", lazy = true },
  },
  config = function()
    -- `:help lsp-vs-treesitter`
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("vieko-lsp-attach", { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc)
          vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
        end
        --  To jump back, press <C-t>.
        map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
        map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
        map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
        map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
        map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
        map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
        map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
        map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
        map("K", vim.lsp.buf.hover, "Hover Documentation")
        map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

        -- highlight references
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.server_capabilities.documentHighlightProvider then
          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            buffer = event.buf,
            callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            buffer = event.buf,
            callback = vim.lsp.buf.clear_references,
          })
        end
      end,
    })

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

    local function organize_imports()
      local params = {
        command = "_typescript.organizeImports",
        arguments = { vim.api.nvim_buf_get_name(0) },
        title = "",
      }
      vim.lsp.buf.execute_command(params)
    end

    -- Enable the following language servers
    -- `:help lspconfig-all` for a list of all the pre-configured LSPs
    local servers = {
      pylsp = {},
      bashls = {},
      cssls = {
        settings = {
          css = {
            validate = true,
            lint = {
              unknownAtRules = "ignore",
            },
          },
        },
      },
      tsserver = {
        --- @diagnostic disable-next-line: unused-local
        on_attach = function(client, bufnr)
          vim.keymap.set("n", "<leader>co", organize_imports, { desc = "LSP: [O]rganize imports", buffer = bufnr })
        end,
      },
      tailwindcss = {
        settings = {
          css = {
            validate = true,
            lint = {
              unknownAtRules = "ignore",
            },
          },
        },
      },
      lua_ls = {
        -- cmd = {...},
        -- filetypes = { ...},
        -- capabilities = {},
        settings = {
          Lua = {
            completion = {
              callSnippet = "Replace",
            },
            -- diagnostics = { disable = { "missing-fields" } },
          },
        },
      },
    }

    -- Set the border style for lsp info
    require("lspconfig.ui.windows").default_options.border = "rounded"

    --  You can press `g?` for help in this menu.
    require("mason").setup({
      ui = {
        border = "rounded",
      },
    })

    local ensure_installed = vim.tbl_keys(servers or {})
    vim.list_extend(ensure_installed, {
      "stylua",
      "prettier",
      "prettierd",
    })
    require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

    require("mason-lspconfig").setup({
      handlers = {
        function(server_name)
          local server = servers[server_name] or {}
          server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
          require("lspconfig")[server_name].setup(server)
        end,
      },
    })
    local _border = "rounded" -- "single", "double", "rounded", "solid", or "shadow"
    vim.diagnostic.config({
      float = {
        border = _border,
        source = "if_many",
        focusable = false,
        style = "minimal",
        header = "",
        prefix = "",
      },
    })
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
      border = _border,
      focusable = false,
    })
    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
      border = _border,
      focusable = false,
    })
  end,
}

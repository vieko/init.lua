-- [[ LSP CLIENT MANAGEMENT ]]
local M = {}

M.start_lsp_client_by_name = function(name, opts)
  local core = require("utils.lsp.core")
  local clients = core.get_clients()
  for _, client in ipairs(clients) do
    if client.name == name then
      vim.notify("LSP client: " .. name .. " is already running", vim.log.levels.INFO, { title = "LSP" })
      return
    end
  end
  require("lspconfig")[name].setup(opts)
  vim.notify("Started LSP client: " .. name, vim.log.levels.INFO, { title = "LSP" })
end

M.stop_lsp_client_by_name = function(name)
  local clients = vim.lsp.get_active_clients()
  for _, client in ipairs(clients) do
    if client.name == name then
      vim.lsp.stop_client(client.id, true)
      vim.notify("Stopped LSP client: " .. name)
      return
    end
  end
  vim.notify("No active LSP client with name: " .. name)
end

return M
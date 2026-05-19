-- [[ LSP CLIENT MANAGEMENT ]]
local M = {}

M.start_lsp_client_by_name = function(name, opts)
  local clients = vim.lsp.get_clients({ name = name })
  if #clients > 0 then
    vim.notify("LSP client: " .. name .. " is already running", vim.log.levels.INFO, { title = "LSP" })
    return
  end
  vim.lsp.config(name, opts)
  vim.lsp.enable(name)
  vim.notify("Started LSP client: " .. name, vim.log.levels.INFO, { title = "LSP" })
end

M.stop_lsp_client_by_name = function(name)
  local clients = vim.lsp.get_clients({ name = name })
  if #clients == 0 then
    vim.notify("No active LSP client with name: " .. name)
    return
  end
  for _, c in ipairs(clients) do
    vim.lsp.stop_client(c.id, true)
  end
  vim.notify("Stopped LSP client: " .. name)
end

return M
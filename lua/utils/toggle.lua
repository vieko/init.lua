-- Borrowed from LazyVim Toggle
local M = {}

---@param buf? number
---@param value? boolean
function M.inlay_hints(buf, value)
  local ih = vim.lsp.buf.inlay_hint or vim.lsp.inlay_hint
  if type(ih) == "function" then
    ih(buf, value)
  elseif type(ih) == "table" and ih.enable then
    if value == nil then
      value = not ih.is_enabled({ bufnr = buf or 0 })
    end
    ih.enable(value, { bufnr = buf })
  end
end

-- Neovim 0.12's built-in LSP document-color highlighting paints hex/rgb and
-- Tailwind classes in their actual color (default style "background"). It is
-- enabled globally on load; we disable it per buffer on attach (see
-- lspconfig.lua) and use this to toggle it back on for the current buffer.
---@param buf? number
---@param value? boolean
function M.document_color(buf, value)
  local dc = vim.lsp.document_color
  if not (dc and dc.enable) then
    return
  end
  buf = buf or 0
  if value == nil then
    value = not dc.is_enabled({ bufnr = buf })
  end
  dc.enable(value, { bufnr = buf })
end

return M

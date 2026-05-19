-- [[ LSP KEYMAPS ]]
local M = {}

--- Setup custom keymaps for a specific LSP client.
--- Called from per-language specs (see `langs/python.lua`) to attach a
--- keymap table only when the named client attaches to a buffer.
---@param name string LSP client name
---@param keymaps table list of `{ lhs, rhs, desc = ... }` entries
---@param prefix string label prepended to each keymap's desc
function M.register_keymaps(name, keymaps, prefix)
  local core = require("utils.lsp.core")
  core.on_attach(function(client, bufnr)
    if client.name == name then
      local map = function(keys, func, desc)
        vim.keymap.set("n", keys, func, { buffer = bufnr, desc = prefix .. ": " .. desc })
      end

      for _, keys in pairs(keymaps) do
        map(keys[1], keys[2], keys.desc)
      end
    end
  end)
end

return M

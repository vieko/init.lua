-- [[ KEYMAP UTILITIES ]]
local M = {}

---Create a keymap with consistent defaults
---@param mode string|table The mode(s) for the keymap
---@param lhs string The left-hand side (key combination)
---@param rhs string|function The right-hand side (command or function)
---@param opts table|nil Optional parameters
function M.map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

return M
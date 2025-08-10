-- [[ LSP UTILITIES - MAIN FACADE ]]
local keymaps = require("utils.lsp.keymaps")
local config = require("utils.lsp.config") 
local client = require("utils.lsp.client")
local actions = require("utils.lsp.actions")
local core = require("utils.lsp.core")

-- Re-export all functionality from sub-modules
local M = {
  -- From keymaps
  kind_filter = keymaps.kind_filter,
  get_default_keymaps = keymaps.get_default_keymaps,
  get_kind_filter = keymaps.get_kind_filter,
  register_keymaps = keymaps.register_keymaps,
  
  -- From config
  biome_config_path = config.biome_config_path,
  biome_config_exists = config.biome_config_exists,
  dprint_config_path = config.dprint_config_path,
  dprint_config_exist = config.dprint_config_exist,
  deno_config_exist = config.deno_config_exist,
  spectral_config_path = config.spectral_config_path,
  eslint_config_exists = config.eslint_config_exists,
  
  -- From client
  start_lsp_client_by_name = client.start_lsp_client_by_name,
  stop_lsp_client_by_name = client.stop_lsp_client_by_name,
  
  -- From actions
  execute = actions.execute,
  action = actions.action,
  
  -- From core
  get_clients = core.get_clients,
  on_attach = core.on_attach,
  on_supports_method = core.on_supports_method,
  on_dynamic_capability = core.on_dynamic_capability,
  setup = core.setup,
  _supports_method = core._supports_method,
  _check_methods = core._check_methods,
}

return M

-- [[ LSP UTILITIES - MAIN FACADE ]]
local keymaps = require("utils.lsp.keymaps")
local config = require("utils.lsp.config")
local client = require("utils.lsp.client")
local actions = require("utils.lsp.actions")
local core = require("utils.lsp.core")

local M = {
  -- From keymaps
  register_keymaps = keymaps.register_keymaps,

  -- From config
  biome_config_path = config.biome_config_path,
  biome_config_exists = config.biome_config_exists,
  dprint_config_path = config.dprint_config_path,
  dprint_config_exist = config.dprint_config_exist,
  deno_config_exist = config.deno_config_exist,
  spectral_config_path = config.spectral_config_path,
  eslint_config_exists = config.eslint_config_exists,
  prettier_config_exists = config.prettier_config_exists,

  -- From client
  start_lsp_client_by_name = client.start_lsp_client_by_name,
  stop_lsp_client_by_name = client.stop_lsp_client_by_name,

  -- From actions
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

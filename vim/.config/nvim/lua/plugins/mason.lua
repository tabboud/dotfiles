local M = {}

local options = {
  providers = {
    -- Use client providers instead of registry-api due to SSL issues using a VPN
    -- ref: https://github.com/williamboman/mason.nvim/issues/633
    "mason.providers.client",
    -- "mason.providers.registry-api" -- This is the default provider. You can still include it here if you want, as a fallback to the client provider.
  },
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗",
    },
  },
}

local tool_installer_options = {
  ensure_installed = {
    -- go
    "delve",
    "gofumpt",
    "goimports",
    "golangci-lint",
    "gopls",
    "impl",
    "staticcheck",

    -- lua
    'lua-language-server',
    'stylua',

    -- vim
    'vim-language-server',
    'shellcheck',
  },

  -- if set to true this will check each tool for updates. If updates
  -- are available the tool will be updated. This setting does not
  -- affect :MasonToolsUpdate or :MasonToolsInstall.
  -- Default: false
  auto_update = false,

  -- automatically install / update on startup. If set to false nothing
  -- will happen on startup. You can use :MasonToolsInstall or
  -- :MasonToolsUpdate to install tools and check for updates.
  -- Default: true
  run_on_start = false,

  -- set a delay (in ms) before the installation starts. This is only
  -- effective if run_on_start is set to true.
  -- e.g.: 5000 = 5 second delay, 10000 = 10 second delay, etc...
  -- Default: 0
  start_delay = 3000, -- 3 second delay
}

function M.setup()
  local ok, mason = pcall(require, "mason")
  if not ok then
    print("mason not installed, skipping setup")
    return
  end

  mason.setup(options)

  local masonlspconfig_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
  if not masonlspconfig_ok then
    print("mason-lspconfig not installed, skipping setup")
    return
  end

  mason_lspconfig.setup()

  local tool_installer_ok, tool_installer = pcall(require, "mason-tool-installer")
  if not tool_installer_ok then
    print("mason-tool-installer could not be required for mason setup...skipping install")
    return
  end
  tool_installer.setup(tool_installer_options)
end

return M

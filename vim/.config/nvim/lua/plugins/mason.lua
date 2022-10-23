local lspconfig = require("lspconfig")

local M = {}

local options = {
  ui = {
    icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗",
		},
  },
}

function M.setup()
  local ok, mason = pcall(require, "mason")
  if not ok then
    print("mason not installed, skipping setup")
    return
  end

  mason.setup(options)

  local ok, mason_lspconfig = pcall(require, "mason-lspconfig")
  if not ok then
    print("mason-lspconfig not installed, skipping setup")
    return
  end

  mason_lspconfig.setup()
  mason_lspconfig.setup_handlers({
    function(server_name)
      lspconfig[server_name].setup({})
    end,
  })
end

return M

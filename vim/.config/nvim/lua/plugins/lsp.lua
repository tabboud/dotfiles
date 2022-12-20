local neodev = require('neodev')
local lspconfig = require('lspconfig')
local mason = require('mason')
local mason_lspconfig = require('mason-lspconfig')
local mason_tool_installer = require('mason-tool-installer')
local icons = require("icons")

local mason_options = {
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
  auto_update = false,
  run_on_start = false,
}

local get_capabilities = function()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  }
  local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  if ok then
    capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
  end
  return capabilities
end

-- document_highlight adds an autocmd to enable document highlight on CursorHold
-- if the server supports it. This should be called from clients on_attach methods.
local document_highlight = function(client, bufnr)
  if client.server_capabilities.documentHighlightProvider then
    vim.api.nvim_create_autocmd("CursorHold", {
      buffer = bufnr,
      command = "lua vim.lsp.buf.document_highlight()",
    })
    vim.api.nvim_create_autocmd("CursorMoved", {
      buffer = bufnr,
      command = "lua vim.lsp.buf.clear_references()",
    })
  end
end

-- document_formatting adds an autocmd to enable document formatting
-- if the server supports it.
local document_formatting = function(client, bufnr)
  if client.server_capabilities.documentFormattingProvider then
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      command = "lua vim.lsp.buf.format()",
    })
  end
end

local setup_keymaps = function(bufnr)
  local nnoremap = require("keymaps").nnoremap
  local noremap = require("keymaps").noremap
  nnoremap("gW", "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>", { buffer = bufnr, desc = "LSP: Workspace symbols" })
  nnoremap("<c-]>", "<cmd>lua vim.lsp.buf.definition()<CR>", { buffer = bufnr, desc = "LSP: Go to definition" })
  noremap({ 'n', 'i' }, '<C-p>', vim.lsp.buf.signature_help, { buffer = bufnr, desc = "LSP: Signature help" })
end

local on_attach = function(client, bufnr)
  setup_keymaps(bufnr)
  document_highlight(client, bufnr)
  document_formatting(client, bufnr)

  -- Inject nvim-navic to allow for breadcrumbs in the winbar
  if client.server_capabilities.documentSymbolProvider then
    require("nvim-navic").attach(client, bufnr)
  end

  -- register lsp-status if available to show LSP progress messages
  -- in the status line. See plugins/lualine.lua for how this is setup.
  local lsp_status_ok, lsp_status = pcall(require, 'lsp-status')
  if lsp_status_ok then
    lsp_status.on_attach(client)
  end
end

-- Diagnostic sign mappings
local diagnostic_signs = {
  { name = "LspDiagnosticsSignError", text = icons.lsp.error },
  { name = "LspDiagnosticsSignWarning", text = icons.lsp.warning },
  { name = "LspDiagnosticsSignHint", text = icons.lsp.hint },
  { name = "LspDiagnosticsSignInformation", text = icons.lsp.info },
  { name = "DiagnosticSignError", text = icons.lsp.error },
  { name = "DiagnosticSignWarn", text = icons.lsp.warning },
  { name = "DiagnosticSignHint", text = icons.lsp.hint },
  { name = "DiagnosticSignInfo", text = icons.lsp.info },
}
for _, sign in ipairs(diagnostic_signs) do
  vim.fn.sign_define(sign.name, {
    text = sign.text,
    texthl = sign.name,
    linehl = "",
    numhl = sign.name,
  })
end

-- setup neodev before lspconfig
neodev.setup()

local runtime_path = vim.split(package.path, ';', {})
table.insert(runtime_path, 'lua/?.lua')
table.insert(runtime_path, 'lua/?/init.lua')

-- Finally setup all the LSP servers
local servers = {
  -- gopls settings
  -- Settings can be found here: https://github.com/golang/tools/blob/master/gopls/doc/settings.md
  gopls = {
    gopls = {
      -- enables placeholders for function parameters or struct fields in completion responses
      usePlaceholders = true,
      gofumpt = false,
      staticcheck = false,
      analyses = {
        shadow = false,
        unusedparams = false,
      },
      codelenses = {
        test = true,
      },
    },
  },

  -- lua-language-server settings
  sumneko_lua = {
    Lua = {
      runtime = { version = 'LuaJIT', path = runtime_path },
      completion = { callSnippet = 'Replace' },
      diagnostics = { globals = { 'vim' } },
      workspace = {
        library = vim.api.nvim_get_runtime_file('', true),
        checkThirdParty = false,
        maxPreload = 2000,
        preloadFileSize = 50000,
      },
      telemetry = { enable = false },
    },
  },
}

-- Setup mason so it can manage external tooling
mason.setup(mason_options)
mason_tool_installer.setup(tool_installer_options)

-- Setup the LSP servers
mason_lspconfig.setup()
mason_lspconfig.setup_handlers {
  function(server_name)
    lspconfig[server_name].setup {
      capabilities = get_capabilities(),
      on_attach = on_attach,
      settings = servers[server_name],
    }
  end,
}
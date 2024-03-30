-----------------
-- LSP
-----------------
local LSP = {}
function LSP.setup()
  local lspconfig = require('lspconfig')
  local lspsaga = require('lspsaga')
  local mason = require('mason')
  local mason_lspconfig = require('mason-lspconfig')
  local mason_tool_installer = require('mason-tool-installer')
  local icons = require("icons")

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
    local m = function(lhs, rhs, desc)
      require('keymaps').nnoremap(lhs, rhs, { buffer = bufnr, desc = desc })
    end

    -- nvim-lspconfig keymaps
    m("gW", "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>", "LSP: Workspace symbols")
    m("<c-]>", "<cmd>lua vim.lsp.buf.definition()<CR>", "LSP: Go to definition")

    -- lsp-saga keymaps
    -- TODO: Use native lsp functions instead and leverage telescope-ui-select as the picker
    m("<leader>rn", "<cmd>Lspsaga rename<CR>", "LSP: Rename word under cursor")
    m("ga", "<cmd>Lspsaga code_action<CR>", "LSP: Code Action")
    m("g]", "<cmd>Lspsaga diagnostic_jump_next<CR>", "LSP: Diagnostics next")
    m("g[", "<cmd>Lspsaga diagnostic_jump_prev<CR>", "LSP: Diagnostics prev")
    m("K", "<cmd>Lspsaga hover_doc<CR>", "LSP: Hover docs")
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
    { name = "LspDiagnosticsSignError",       text = icons.lsp.error },
    { name = "LspDiagnosticsSignWarning",     text = icons.lsp.warning },
    { name = "LspDiagnosticsSignHint",        text = icons.lsp.hint },
    { name = "LspDiagnosticsSignInformation", text = icons.lsp.info },
    { name = "DiagnosticSignError",           text = icons.lsp.error },
    { name = "DiagnosticSignWarn",            text = icons.lsp.warning },
    { name = "DiagnosticSignHint",            text = icons.lsp.hint },
    { name = "DiagnosticSignInfo",            text = icons.lsp.info },
  }
  for _, sign in ipairs(diagnostic_signs) do
    vim.fn.sign_define(sign.name, {
      text = sign.text,
      texthl = sign.name,
      linehl = "",
      numhl = sign.name,
    })
  end

  -- nvim-navic: add in the winbar extension after loading
  vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"

  -- Setup mason so it can manage external tooling
  mason.setup({
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
  })
  mason_tool_installer.setup({
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

      -- rust
      'rust-analyzer',

      -- vim
      'vim-language-server',
      'shellcheck',
    },
    auto_update = false,
    run_on_start = false,
  })

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
          nilness = true,
          unusedwrite = true,
          useany = true,
        },
        codelenses = {
          test = true,
          tidy = true,
          upgrade_dependency = true,
          vendor = true,
        },
      },
    },

    -- lua-language-server settings
    lua_ls = {
      Lua = {
        runtime = {
          version = 'LuaJIT',
        },
        completion = {
          callSnippet = 'Replace',
        },
        diagnostics = {
          globals = {
            'vim',
          },
        },
        workspace = {
          -- Make the server aware of Neovim runtime files,
          library = {
            [vim.fn.expand "$VIMRUNTIME/lua"] = true,
            [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
          },
          checkThirdParty = false,
          maxPreload = 2000,
        },
        telemetry = {
          enable = false,
        },
      },
    },
  }

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

  -- setup lsp-saga
  lspsaga.setup()
end

return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    'neovim/nvim-lspconfig',
    config = function()
      LSP.setup()
    end,
    dependencies = {
      -- Automatically install LSPs/tools to stdpath
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",

      -- Better UI for hover, code-actions, and diagnostics
      "glepnir/lspsaga.nvim",

      -- Show current code context in the winbar
      "SmiteshP/nvim-navic",

      -- Get LSP loading status in the status bar
      "nvim-lua/lsp-status.nvim",
      "mrded/nvim-lsp-notify"
    },
  },
  -- Provides a small window to show diagnostics, telescope results, etc.
  { import = "plugins.trouble" },
  {
    'mrded/nvim-lsp-notify',
    dependencies = { 'rcarriga/nvim-notify' },
    config = function()
      require('lsp-notify').setup({
        notify = require('notify'),
      })
    end
  },
  {
    'rcarriga/nvim-notify',
    config = function()
      vim.opt.termguicolors = true
      require("notify").setup({
        background_colour = "#000000",
      })
    end
  },
}

local lspconfig = require('lspconfig')
local cmp_nvim_lsp = require('cmp_nvim_lsp')
local vim_diag = require('vim.diagnostic')
local fn = vim.fn
local icons = require("icons")

local M = {}

M.diagnostic_config = {
  update_in_insert = false,
  underline = false,
  signs = true,
  severity_sort = true,
  virtual_text = {
    prefix = "",
    spacing = 4,
  },
}

M.get_capabilities = function()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  }
  return cmp_nvim_lsp.default_capabilities(capabilities)
end

-- document_highlight adds an autocmd to enable document highlight on CursorHold
-- if the server supports it. This should be called from clients on_attach methods.
M.document_highlight = function(client, bufnr)
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
M.document_formatting = function(client, bufnr)
    if client.server_capabilities.documentFormattingProvider then
        vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            command = "lua vim.lsp.buf.format()",
        })
    end
end

local on_attach = function(client, bufnr)
  vim.api.nvim_set_keymap("n", "<Leader>o", "<cmd>lua vim.lsp.buf.document_symbol()<CR>", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("n", "ga", "<cmd>lua vim.lsp.buf.code_action()<CR>", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("n", "<c-]>", "<cmd>lua vim.lsp.buf.definition()<CR>", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", { noremap = true, silent = true })
  -- vim.api.nvim_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", {noremap = true, silent = true})
  -- vim.api.nvim_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", {noremap = true, silent = true})
  vim.api.nvim_set_keymap("n", "gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("n", "g]", "<cmd>lua vim.diagnostic.goto_next()<CR>", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("n", "g[", "<cmd>lua vim.diagnostic.goto_prev()<CR>", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("n", "<Leader>e", "<cmd>lua vim.diagnostic.open_float()<CR>", { noremap = true, silent = true })

  -- TODO(tabboud): Add a popup window for renaming
  --                Testing out using lspsaga for renames instead
  -- vim.api.nvim_set_keymap("n", "<Leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", {noremap = true, silent = true})
  -- vim.api.nvim_set_keymap("n", "<Leader>rn", "<cmd>lua require('lspsaga.rename').lsp_rename<CR>", {noremap = true, silent = true})

  vim.api.nvim_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("n", "<c-p>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", { noremap = true, silent = true })
  -- vim.api.nvim_set_keymap("n", "g0", "<cmd>lua vim.lsp.buf.document_symbol()<CR>", {noremap = true, silent = true})
  vim.api.nvim_set_keymap("n", "gW", "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>", { noremap = true, silent = true })

  M.document_highlight(client, bufnr)
  M.document_formatting(client, bufnr)
end

-- Custom publishDiagnostics event handler
vim.lsp.handlers["textDocument/publishDiagnostics"] = function(_, result, ctx)
  local uri = result.uri
  local bufnr = vim.uri_to_bufnr(uri)
  if not bufnr then
    return
  end

  local diagnostics = result.diagnostics
  for i, diagnostic in ipairs(diagnostics) do
    local rng = diagnostic.range
    diagnostics[i].lnum = rng["start"].line
    diagnostics[i].end_lnum = rng["end"].line
    diagnostics[i].col = rng["start"].character
    diagnostics[i].end_col = rng["end"].character
  end

  local namespace = vim.lsp.diagnostic.get_namespace(ctx.client_id)
  vim_diag.set(namespace, bufnr, diagnostics, M.diagnostic_config)
  if not vim.api.nvim_buf_is_loaded(bufnr) then
    return
  end

  vim_diag.show(namespace, bufnr, diagnostics, M.diagnostic_config)
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

--
-- gopls setup
-- Settings can be found here: https://github.com/golang/tools/blob/master/gopls/doc/settings.md
if fn.executable("gopls") > 0 then
  lspconfig.gopls.setup {
    filetypes = { "go", "gomod", },
    on_attach = function(client, bufnr)
      require "lsp_signature".on_attach() -- Note: add in lsp client on-attach
      on_attach(client, bufnr)
    end,
    capabilities = M.get_capabilities(),
    cmd = {
      "gopls",
    },
    flags = {
      debounce_text_changes = 500,
    },
    settings = {
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
  }
end

if fn.executable("lua-language-server") > 0 then
  -- settings for lua-language-server can be found on https://github.com/sumneko/lua-language-server/wiki/Settings .
  lspconfig.sumneko_lua.setup {
    on_attach = on_attach,
    capabilities = M.get_capabilities(),
    settings = {
      Lua = {
        runtime = {
          version = "LuaJIT",
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = { "vim" },
        },
        workspace = {
          -- Make the server aware of Neovim runtime files,
          -- see also https://github.com/sumneko/lua-language-server/wiki/Libraries#link-to-workspace .
          -- Lua-dev.nvim also has similar settings for sumneko lua, https://github.com/folke/lua-dev.nvim/blob/main/lua/lua-dev/sumneko.lua .
          library = {
            fn.stdpath("data") .. "/site/pack/packer/opt/emmylua-nvim",
            fn.stdpath("config"),
          },
          maxPreload = 2000,
          preloadFileSize = 50000,
        },
      },
    },
  }
end

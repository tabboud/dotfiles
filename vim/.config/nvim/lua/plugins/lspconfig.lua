local lspconfig = require('lspconfig')
local fn = vim.fn
local icons = require("icons")

local M = {}

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
  local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  if ok then
    capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
  end
  return capabilities
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

local setup_keymaps = function()
  local keymap = function(mode, l, r, opts)
    opts = opts or {}
    opts.buffer = true
    vim.keymap.set(mode, l, r, opts)
  end
  local opts = { noremap = true, silent = true }
  vim.api.nvim_set_keymap("n", "<Leader>o", "<cmd>lua vim.lsp.buf.document_symbol()<CR>", opts)
  vim.api.nvim_set_keymap("n", "<c-]>", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
  keymap({ 'n', 'i' }, '<C-p>', vim.lsp.buf.signature_help, { desc = 'Lsp: Signature help' })
  vim.api.nvim_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
  vim.api.nvim_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  vim.api.nvim_set_keymap("n", "gW", "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>", opts)
  vim.api.nvim_set_keymap("n", "gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
end

local on_attach = function(client, bufnr)
  setup_keymaps()
  M.document_highlight(client, bufnr)
  M.document_formatting(client, bufnr)
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

-- Use <c-s> to open signature help window
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers['signature_help'], {
  border = 'single',
  close_events = { "CursorMoved", "BufHidden" },
})
vim.keymap.set('i', '<c-s>', vim.lsp.buf.signature_help)

--
-- gopls setup
-- Settings can be found here: https://github.com/golang/tools/blob/master/gopls/doc/settings.md
if fn.executable("gopls") > 0 then
  lspconfig.gopls.setup {
    filetypes = { "go", "gomod", },
    on_attach = function(client, bufnr)
      -- TODO(tabboud): lsp-signature is not used anymore. find a replacement
      -- require "lsp_signature".on_attach() -- Note: add in lsp client on-attach
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
        completion = {
          callSnippet = 'Replace',
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = { "vim" },
        },
        workspace = {
          -- Make the server aware of Neovim runtime files,
          library = {
            [vim.fn.expand "$VIMRUNTIME/lua"] = true,
            [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
          },
          maxPreload = 2000,
          preloadFileSize = 50000,
        },
      },
    },
  }
end

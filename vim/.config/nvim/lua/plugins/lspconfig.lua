local lspconfig = require('lspconfig')
local cmp_nvim_lsp = require('cmp_nvim_lsp')
local vim_diag = require('vim.diagnostic')

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

M.icons = {
    error = " ",
    warn = " ",
    hint = " ",
    info = " ",
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
    return cmp_nvim_lsp.update_capabilities(capabilities)
end

local on_attach = function(client, bufnr)
  vim.api.nvim_set_keymap("n", "<Leader>o", "<cmd>lua vim.lsp.buf.document_symbol()<CR>", {noremap = true, silent = true})
  vim.api.nvim_set_keymap("n", "ga", "<cmd>lua vim.lsp.buf.code_action()<CR>", {noremap = true, silent = true})
  vim.api.nvim_set_keymap("n", "<c-]>", "<cmd>lua vim.lsp.buf.definition()<CR>", {noremap = true, silent = true})
  vim.api.nvim_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", {noremap = true, silent = true})
  vim.api.nvim_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", {noremap = true, silent = true})
  -- vim.api.nvim_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", {noremap = true, silent = true})
  -- vim.api.nvim_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", {noremap = true, silent = true})
  vim.api.nvim_set_keymap("n", "gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>", {noremap = true, silent = true})
  vim.api.nvim_set_keymap("n", "g]", "<cmd>lua vim.diagnostic.goto_next()<CR>", {noremap = true, silent = true})
  vim.api.nvim_set_keymap("n", "g[", "<cmd>lua vim.diagnostic.goto_prev()<CR>", {noremap = true, silent = true})
  vim.api.nvim_set_keymap("n", "<Leader>e", "<cmd>lua vim.diagnostic.open_float()<CR>", {noremap = true, silent = true})
  vim.api.nvim_set_keymap("n", "<Leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", {noremap = true, silent = true})
  vim.api.nvim_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", {noremap = true, silent = true})
  vim.api.nvim_set_keymap("n", "<c-p>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", {noremap = true, silent = true})
  -- vim.api.nvim_set_keymap("n", "g0", "<cmd>lua vim.lsp.buf.document_symbol()<CR>", {noremap = true, silent = true})
  vim.api.nvim_set_keymap("n", "gW", "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>", {noremap = true, silent = true})

    -- Setup highlight under cursor if the server supports it
    -- This replaces any usage of treesitter
   if client.resolved_capabilities.document_highlight then
        vim.api.nvim_create_autocmd("CursorHold", {
            buffer = bufnr,
            command = "lua vim.lsp.buf.document_highlight()",
        })
        vim.api.nvim_create_autocmd("CursorMoved", {
            buffer = bufnr,
            command = "lua vim.lsp.buf.clear_references()",
        })
   end

   -- Handle document formatting on buffer write
   if client.resolved_capabilities.document_formatting then
       vim.api.nvim_create_autocmd("BufWritePre", {
           buffer = bufnr,
           command = "lua vim.lsp.buf.formatting_seq_sync()",
       })
   end
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
vim.fn.sign_define("LspDiagnosticsSignError",{
    text=M.icons.error,
    texthl="LspDiagnosticsSignError",
    linehl="",
    numhl="",
})
vim.fn.sign_define("LspDiagnosticsSignWarning", {
    text=M.icons.warn,
    texthl="LspDiagnosticsSignWarning",
    linehl="",
    numhl="",
})
vim.fn.sign_define("LspDiagnosticsSignInformation", {
    text=M.icons.info,
    texthl="LspDiagnosticsSignInformation",
    linehl="",
    numhl="",
})
vim.fn.sign_define("LspDiagnosticsSignHint", {
    text=M.icons.hint,
    texthl="LspDiagnosticsSignHint",
    linehl="",
    numhl="",
})

vim.fn.sign_define("DiagnosticSignError", {
    text = M.icons.error,
    numhl = "DiagnosticSignError",
})
vim.fn.sign_define("DiagnosticSignWarn", {
    text = M.icons.warn,
    numhl = "DiagnosticSignWarn",
})
vim.fn.sign_define("DiagnosticSignHint", {
    text = M.icons.hint,
    numhl = "DiagnosticSignHint",
})
vim.fn.sign_define("DiagnosticSignInfo", {
    text = M.icons.info,
    numhl = "DiagnosticSignInfo",
})

--
-- gopls setup
-- Settings can be found here: https://github.com/golang/tools/blob/master/gopls/doc/settings.md
lspconfig.gopls.setup{
  filetypes = { "go", "gomod", },
  on_attach = function(client, bufnr)
    require "lsp_signature".on_attach()  -- Note: add in lsp client on-attach
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

      gofumpt = true,
      staticcheck = false,
      analyses = {
          shadow = false,
          unusedparams = false,
      },
      codelenses = {
        test = false,
      },
    },
  },
}


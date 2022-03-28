local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

local on_attach = function(client, bufnr)
  vim.api.nvim_set_keymap("n", "<Leader>o", "<cmd>lua vim.lsp.buf.document_symbol()<CR>", {noremap = true, silent = true})
  vim.api.nvim_set_keymap("n", "ga", "<cmd>lua vim.lsp.buf.code_action()<CR>", {noremap = true, silent = true})
  vim.api.nvim_set_keymap("n", "<c-]>", "<cmd>lua vim.lsp.buf.definition()<CR>", {noremap = true, silent = true})
  vim.api.nvim_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", {noremap = true, silent = true})
  vim.api.nvim_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", {noremap = true, silent = true})
  vim.api.nvim_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", {noremap = true, silent = true})
  vim.api.nvim_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", {noremap = true, silent = true})
  vim.api.nvim_set_keymap("n", "gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>", {noremap = true, silent = true})
  vim.api.nvim_set_keymap("n", "g]", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", {noremap = true, silent = true})
  vim.api.nvim_set_keymap("n", "g[", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", {noremap = true, silent = true})
  vim.api.nvim_set_keymap("n", "<Leader>e", "<cmd>lua vim.diagnostic.open_float()<CR>", {noremap = true, silent = true})
  vim.api.nvim_set_keymap("n", "<Leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", {noremap = true, silent = true})
  vim.api.nvim_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", {noremap = true, silent = true})
  vim.api.nvim_set_keymap("n", "<c-p>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", {noremap = true, silent = true})
  vim.api.nvim_set_keymap("n", "g0", "<cmd>lua vim.lsp.buf.document_symbol()<CR>", {noremap = true, silent = true})
  vim.api.nvim_set_keymap("n", "gW", "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>", {noremap = true, silent = true})

    -- Setup highlight under cursor if the server supports it
    -- This replaces any usage of treesitter
    if client.resolved_capabilities.document_highlight then
        vim.api.nvim_exec([[
            if (&background == "light")
                " Match intellij hover bg color
                hi LspReferenceRead cterm=bold ctermbg=red guibg=#E4E4FF
                hi LspReferenceText cterm=bold ctermbg=red guibg=#E4E4FF
                hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
            else
                hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
                hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
                hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
            endif
          augroup lsp_document_highlight
            autocmd!
            autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
            autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
          augroup END
        ]], false)
    end
end

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = true,
    virtual_text = false,
    signs = true,
    update_in_insert = false,
  }
)

vim.fn.sign_define("LspDiagnosticsSignError", {text="", texthl="LspDiagnosticsSignError", linehl="", numhl=""})
vim.fn.sign_define("LspDiagnosticsSignWarning", {text="", texthl="LspDiagnosticsSignWarning", linehl="", numhl=""})
vim.fn.sign_define("LspDiagnosticsSignInformation", {text="", texthl="LspDiagnosticsSignInformation", linehl="", numhl=""})
vim.fn.sign_define("LspDiagnosticsSignHint", {text="ﯦ", texthl="LspDiagnosticsSignHint", linehl="", numhl=""})

vim.fn.sign_define("DiagnosticSignError", {text="", texthl="DiagnosticSignError", linehl="", numhl=""})
vim.fn.sign_define("DiagnosticSignWarn", {text="", texthl="DiagnosticSignWarn", linehl="", numhl=""})
vim.fn.sign_define("DiagnosticSignInfo", {text="", texthl="DiagnosticSignInfo", linehl="", numhl=""})
vim.fn.sign_define("DiagnosticSignHint", {text="ﯦ", texthl="DiagnosticSignHint", linehl="", numhl=""})

--
-- gopls setup
lspconfig.gopls.setup{
  on_attach = on_attach,
  capabilities = capabilities,
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
    },
  },
}


-- lsp.lua
local icons = require("icons")

vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.WARN] = icons.lsp.warn,
      [vim.diagnostic.severity.ERROR] = icons.lsp.error,
      [vim.diagnostic.severity.INFO] = icons.lsp.info,
      [vim.diagnostic.severity.HINT] = icons.lsp.hint,
    },
    numhl = {
      [vim.diagnostic.severity.WARN] = "WarningMsg",
      [vim.diagnostic.severity.ERROR] = "ErrorMsg",
      [vim.diagnostic.severity.INFO] = "DiagnosticInfo",
      [vim.diagnostic.severity.HINT] = "DiagnosticHint",
    },
  },
})

---Synchronously applies the "source.organizeImports" code action for bufnr.
---@param client vim.lsp.Client
---@param bufnr integer
local function organize_imports(client, bufnr)
  local params = {
    textDocument = vim.lsp.util.make_text_document_params(bufnr),
    range = { start = { line = 0, character = 0 }, ["end"] = { line = 0, character = 0 } },
    context = { only = { "source.organizeImports" }, diagnostics = {} },
  }
  local res = client:request_sync("textDocument/codeAction", params, 2000, bufnr)
  for _, action in ipairs(res and res.result or {}) do
    if action.edit then
      vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
    elseif action.command then
      client:exec_cmd(action.command, { bufnr = bufnr })
    end
  end
end

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("dotfiles_lsp", { clear = true }),
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end
    -- One group per client and buffer so re-attaching does not stack autocmds
    local group = vim.api.nvim_create_augroup(("dotfiles_lsp_%d_%d"):format(client.id, bufnr), { clear = true })

    -- Keymaps
    local opts = { silent = true, buffer = bufnr }
    vim.keymap.set("n", "gW", vim.lsp.buf.workspace_symbol, opts)
    vim.keymap.set("n", "<c-]>", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "ga", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

    -- prefix diagnostics with the name of the client
    vim.diagnostic.config({
      virtual_text = {
        format = function(d)
          return string.format("%s: %s", client.name, d.message)
        end,
      },
    }, vim.lsp.diagnostic.get_namespace(client.id))

    -- turn on document highlight
    if client:supports_method("textDocument/documentHighlight") then
      vim.api.nvim_create_autocmd("CursorHold", {
        group = group,
        buffer = bufnr,
        callback = function() vim.lsp.buf.document_highlight() end,
      })
      vim.api.nvim_create_autocmd("CursorMoved", {
        group = group,
        buffer = bufnr,
        callback = function() vim.lsp.buf.clear_references() end,
      })
    end

    -- Format on save. Go always organizes imports and formats; everything else
    -- only formats when vim.g.autoformat is enabled (toggled via snacks).
    if client:supports_method("textDocument/formatting") then
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = group,
        buffer = bufnr,
        callback = function()
          if vim.bo[bufnr].filetype == "go" then
            organize_imports(client, bufnr)
          elseif not vim.g.autoformat then
            return
          end
          vim.lsp.buf.format({ bufnr = bufnr, id = client.id })
        end,
      })
    end

    -- turn on breadcrumbs if document symbols are supported
    if client:supports_method("textDocument/documentSymbol") then
      require("nvim-navic").attach(client, bufnr)
    end

    -- turn off semantic token support
    client.server_capabilities.semanticTokensProvider = nil

    if client:supports_method("textDocument/codeLens") then
      vim.keymap.set("n", "<leader>cr", vim.lsp.codelens.run, { buffer = bufnr, desc = "CodeLens: run" })
    end
  end,
})

-- Enable code-lens globally; newly attached clients follow this (toggled via snacks)
vim.lsp.codelens.enable(true)

-- nvim-navic: add in the winbar extension after loading
vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"

require("mason").setup()

-- Ensure LSP servers are installed and enable them via nvim 0.12 native vim.lsp.enable().
-- automatic_enable = true calls vim.lsp.enable() for each managed server, which picks up
-- server config from after/lsp/*.lua files automatically.
-- LSP completion capabilities are registered by blink.cmp's plugin/ script.
require("mason-lspconfig").setup({
  ensure_installed = {
    "gopls",
    "lua_ls",
    "pylsp",
    "rust_analyzer",
    "vimls",
    "yamlls",
  },
  automatic_enable = true,
})

-- Non-LSP tooling (LSP servers are handled by mason-lspconfig above)
require("mason-tool-installer").setup({
  ensure_installed = {
    -- go
    "delve",
    "goimports",
    "golangci-lint",
    "impl",
    "staticcheck",

    -- lua
    "stylua",

    -- python
    "mypy", -- type checking for python

    -- shell
    "shellcheck",
  },
})

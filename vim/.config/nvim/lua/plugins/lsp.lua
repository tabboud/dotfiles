-- lsp.lua
local mason_tool_installer = require("mason-tool-installer")
local icons = require("icons")

-- LSP On-Attach autocmd
vim.api.nvim_create_autocmd({ "LspAttach" }, {
	callback = function(args)
		local bufnr = args.buf
		local client_id = args.data.client_id
		local client = vim.lsp.get_client_by_id(client_id)
		if not client then
			return
		end

		-- Keymaps
    local opts = { noremap = true, silent = true, buffer = bufnr }
		vim.keymap.set("n", "gW", vim.lsp.buf.workspace_symbol, opts)
		vim.keymap.set("n", "<c-]>", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "ga", vim.lsp.buf.code_action, opts)
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

		local ns = vim.lsp.diagnostic.get_namespace(client_id)
		vim.diagnostic.config(
			---@type vim.diagnostic.Opts?
			{
				virtual_text = {
					format = function(d)
						-- prefix diagnostics with the name of the client
						return string.format("%s: %s", client.name, d.message)
					end,
				},
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
			},
			ns
		)

		-- turn on document highlight
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

		-- turn on document formatting (toggling enabled via snacks toggles)
		if client.server_capabilities.documentFormattingProvider then
			vim.api.nvim_create_autocmd("BufWritePre", {
				buffer = bufnr,
				callback = function()
					if vim.g.autoformat then
						vim.lsp.buf.format()
					end
				end,
			})
		end

		-- turn on breadcrumbs if document symbols are supported
		if client.server_capabilities.documentSymbolProvider then
			require("nvim-navic").attach(client, bufnr)
		end

		-- turn on inlay-hints with a keymap toggle
		if client.server_capabilities.inlayHintProvider then
			vim.keymap.set("n", "<leader>dh", function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ nil }))
			end, { buffer = bufnr, desc = "✨LSP toggle inlay hints" })
		end

		-- turn off semantic token support
		if client.server_capabilities.semanticTokensProvider then
			client.server_capabilities.semanticTokensProvider = nil
		end

    -- enable code-lens if supported
    if client.server_capabilities.codeLensProvider then
      vim.lsp.codelens.enable(not vim.lsp.codelens.is_enabled())
    end
	end,
})

-- nvim-navic: add in the winbar extension after loading
vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"

-- Initialize mason
require("mason").setup()

-- Ensure LSP servers are installed and enable them via nvim 0.12 native vim.lsp.enable().
-- automatic_enable = true calls vim.lsp.enable() for each managed server, which picks up
-- server config from after/lsp/*.lua files automatically.
require("mason-lspconfig").setup({
  ensure_installed = {
    "gopls",
    "lua_ls",
    "pylsp",
    "yamlls",
  },
  automatic_enable = true,
})

-- Setup mason so it can manage external tooling
mason_tool_installer.setup({
	ensure_installed = {
		-- go
		"delve",
		"goimports",
		"golangci-lint",
		"gopls",
		"impl",
		"staticcheck",

		-- lua
		"lua-language-server",
		"stylua",

		-- rust
		"rust-analyzer",

		-- python
		"python-lsp-server",
		"mypy", -- type checking for python

		-- vim
		"vim-language-server",
		"shellcheck",
	},
})

local get_capabilities = function()
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities.textDocument.completion.completionItem.snippetSupport = true
	capabilities.textDocument.completion.completionItem.resolveSupport = {
		properties = { "documentation", "detail", "additionalTextEdits" },
	}
	-- blink.nvim
	local has_blink_cmp, blink_cmp = pcall(require, "blink.cmp")
	if has_blink_cmp then
		return blink_cmp.get_lsp_capabilities(capabilities)
	end
	return capabilities
end

-- Add the same capabilities to ALL server configurations.
-- Refer to :h vim.lsp.config() for more information.
vim.lsp.config("*", {
	capabilities = get_capabilities(),
})


local venv_path = os.getenv("VIRTUAL_ENV")
local py_path = nil

-- Determine the Python executable path
if venv_path ~= nil then
	py_path = venv_path .. "/bin/python3"
else
	-- Fallback to the default Python interpreter
	py_path = vim.g.python3_host_prog
end

return {
	on_init = function(client)
		-- Disable formatting — pylsp runs black/ruff on save otherwise
		-- See ftplugin/python.vim which disables editorconfig for python files
		-- that caused format on save to occur
		-- client.server_capabilities.documentFormattingProvider = false
		-- client.server_capabilities.documentRangeFormattingProvider = false
	end,
	-- capabilities = {
	-- 	textDocument = {
	-- 		synchronization = {
	-- Disable willSaveWaitUntil so pylsp cannot inject edits before save
	-- 			willSaveWaitUntil = false,
	-- 		},
	-- 	},
	-- },

	-- Setting References
	-- https://github.com/python-lsp/python-lsp-server
	-- https://github.com/python-lsp/python-lsp-server/blob/develop/CONFIGURATION.md
	settings = {
		pylsp = {
			plugins = {
				-- autopep8 formatting
				autopep8 = { enabled = true },
				pycodestyle = {
					enabled = true, -- Enable PEP8 style warnings
					ignore = {
						-- "E501", -- ae
						-- "W291", -- trailing whitespace
						"W293", -- blank line contains whitespace
					},
					maxLineLength = 120,
				},
				-- linter options
				pyflakes = { enabled = false }, -- Disables all pyflakes diagnostics
				mccabe = { enabled = false }, -- Disables all complexity warnings
				flake8 = { enabled = false },
				pylint = { enabled = false },
				pylsp = { enabled = false },
				preload = { enabled = false },

				yapf = { enabled = false }, -- covered by black
				pydocstyle = { enabled = false },

				-- TODO: Install mypy separately
				pylsp_mypy = {
					enabled = false,
					overrides = { "--python-executable", py_path, true },
					report_progress = true,
					live_mode = false,
				},
			},
		},
	},
}

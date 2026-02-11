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
  -- capabilities = {
  -- 	documentFormattingProvider = false,
  -- 	documentRangeFormattingProvider = false,
  -- },

  -- Setting References
  -- https://github.com/python-lsp/python-lsp-server
  settings = {
    pylsp = {
      plugins = {
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
        pyflakes = { enabled = true }, -- Disables all pyflakes diagnostics
        mccabe = { enabled = true },   -- Disables all complexity warnings
        -- TODO: Install mypy separately
        pylsp_mypy = {
          enabled = true,
          overrides = { "--python-executable", py_path, true },
          report_progress = true,
          live_mode = false
        },
      },
    },
  },
}

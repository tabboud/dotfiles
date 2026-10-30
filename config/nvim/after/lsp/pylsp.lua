-- Python executable used by mypy, preferring the active virtualenv
local venv_path = os.getenv("VIRTUAL_ENV")
local py_path = venv_path and venv_path .. "/bin/python3" or vim.g.python3_host_prog

return {
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
        preload = { enabled = false },

        yapf = { enabled = false }, -- formatting handled by autopep8
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

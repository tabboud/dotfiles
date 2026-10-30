-- testing.lua
-- nvim-dap and neotest are lazy-loaded: vim.pack.add() is called inside the FileType
-- autocmd so they are not loaded until a Go file is opened. The lockfile ensures they
-- are installed at startup even though loading is deferred.

vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  once = true,
  callback = function()
    vim.pack.add({
      'https://github.com/mfussenegger/nvim-dap',
      'https://github.com/leoluz/nvim-dap-go',
      'https://github.com/rcarriga/nvim-dap-ui',
      'https://github.com/theHamsta/nvim-dap-virtual-text',
      'https://github.com/nvim-neotest/neotest',
      'https://github.com/nvim-neotest/nvim-nio',
      { src = 'https://github.com/fredrikaverpil/neotest-golang', version = vim.version.range('*') },
    })

    local icons = require("icons")

    -- nvim-dap
    vim.fn.sign_define("DapBreakpoint", { text = icons.dap.error, texthl = "DiagnosticSignError" })
    vim.fn.sign_define("DapBreakpointRejected", { text = icons.dap.rejected, texthl = "DiagnosticSignHint" })
    vim.fn.sign_define("DapStopped", {
      text = icons.dap.stop,
      texthl = "DiagnosticSignInfo",
      linehl = "DiagnosticUnderlineInfo",
      numhl = "DiagnosticSignInfo",
    })

    require("nvim-dap-virtual-text").setup({
      commented = true,
      virt_text_pos = 'eol',
    })

    local dap, dapui = require("dap"), require("dapui")
    dapui.setup()
    dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
    dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
    dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

    require('dap-go').setup()

    vim.keymap.set("n", "<leader>dr", function() require('dap-go').debug_test() end, { desc = "Debug: Run nearest test" })
    vim.keymap.set("n", "<leader>db", function() dap.toggle_breakpoint() end, { desc = "Debug: Toggle breakpoint" })

    -- neotest
    local neotest = require("neotest")
    vim.diagnostic.config({ virtual_text = false }, vim.api.nvim_create_namespace("neotest"))

    ---@type neotest.Config
    neotest.setup({
      icons = icons.neotest,
      adapters = {
        require("neotest-golang")({
          runner = "go",
          go_test_args = {
            "-v",
            "-count=1",
          },
          warn_test_name_dupes = false,
        }),
      },
    })

    vim.keymap.set("n", '<leader>Ts', function() neotest.summary.toggle() end, { desc = "Test: Toggle test summary" })
    vim.keymap.set("n", '<leader>To', function() neotest.output_panel.toggle() end, { desc = "Test: Toggle test output panel" })
    vim.keymap.set("n", '<leader>Tr', function() neotest.run.run() end, { desc = 'Test: Run nearest test' })
    vim.keymap.set("n", '<leader>Tl', function() neotest.run.run_last() end, { desc = 'Test: Run last test' })

    -- Auto scroll to the bottom of the output-panel
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "neotest-output-panel",
      callback = function()
        vim.cmd("norm G")
      end,
    })
  end,
})

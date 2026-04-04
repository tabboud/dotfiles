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
      'https://github.com/igorlfs/nvim-dap-view',
      'https://github.com/nvim-neotest/neotest',
      'https://github.com/nvim-neotest/nvim-nio',
      { src = 'https://github.com/fredrikaverpil/neotest-golang', version = vim.version.range('*') },
    })

    -- nvim-dap setup
    local function configure()
      local dap_icons = require("icons").dap
      local dap_breakpoint = {
        error = {
          text = dap_icons.error,
          texthl = "LspDiagnosticsSignError",
          linehl = "",
          numhl = "",
        },
        rejected = {
          text = "",
          texthl = "LspDiagnosticsSignHint",
          linehl = "",
          numhl = "",
        },
        stopped = {
          text = dap_icons.stop,
          texthl = "LspDiagnosticsSignInformation",
          linehl = "DiagnosticUnderlineInfo",
          numhl = "LspDiagnosticsSignInformation",
        },
      }

      vim.fn.sign_define("DapBreakpoint", dap_breakpoint.error)
      vim.fn.sign_define("DapStopped", dap_breakpoint.stopped)
      vim.fn.sign_define("DapBreakpointRejected", dap_breakpoint.rejected)
    end

    local function configure_exts()
      require("nvim-dap-virtual-text").setup {
        enable = true,
        enable_commands = true,
        highlight_changed_variables = true,
        highlight_new_as_changed = false,
        show_stop_reason = true,
        commented = true,
        virt_text_pos = 'eol',
        all_frames = false,
        virt_lines = false,
        virt_text_win_col = nil
      }

      local dap, dapui = require "dap", require "dapui"
      dapui.setup {}
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open({})
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close({})
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close({})
      end
    end

    local function configure_debuggers()
      require('dap-go').setup()
    end

    local function setup_keymaps()
      vim.keymap.set("n", "<leader>dr", "<cmd>lua require('dap-go').debug_test()<CR>",
        { desc = "Debug: Run nearest test" })
      vim.keymap.set("n", "<leader>db", "<cmd>DapToggleBreakpoint<CR>", { desc = "Debug: Toggle breakpoint" })
    end

    configure()
    configure_exts()
    configure_debuggers()
    setup_keymaps()

    -- neotest setup
    local neotest_ns = vim.api.nvim_create_namespace("neotest")
    vim.diagnostic.config({ virtual_text = false }, neotest_ns)

    local neotest_icons = require('icons').neotest
    ---@type neotest.Config
    require("neotest").setup({
      icons = neotest_icons,
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
      consumers = {
        notify = function(client)
          client.listeners.results = function(adapter_id, results, partial)
            if partial then
              return
            end
          end
          return {}
        end,
      },
    })

    vim.keymap.set("n", '<leader>ts', function()
      return require("neotest").summary.toggle()
    end, { desc = "Test: Toggle test summary" })

    vim.keymap.set("n", '<leader>to', function()
      return require("neotest").output_panel.toggle()
    end, { desc = "Test: Toggle test output panel" })

    vim.keymap.set("n", '<leader>tr', function()
      return require("neotest").run.run()
    end, { desc = 'Test: Run nearest test' })

    vim.keymap.set("n", '<leader>tl', function()
      return require("neotest").run.run_last()
    end, { desc = 'Test: Run last test' })

    -- Auto scroll to the bottom of the output-panel
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "neotest-output-panel",
      callback = function()
        vim.cmd("norm G")
      end,
    })
  end,
})

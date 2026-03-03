-- Your nvim-dap config
return {
  {
    'mfussenegger/nvim-dap',
    ft = { 'go' },
    config = function()
      local function configure()
        local icons = require("icons").dap
        local dap_breakpoint = {
          error = {
            text = icons.error,
            texthl = "LspDiagnosticsSignError",
            linehl = "",
            numhl = "",
          },
          rejected = {
            text = "",
            texthl = "LspDiagnosticsSignHint",
            linehl = "",
            numhl = "",
          },
          stopped = {
            text = icons.stop,
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
          highlight_changed_variables = true, -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
          highlight_new_as_changed = false,   -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
          show_stop_reason = true,            -- show stop reason when stopped for exceptions
          commented = true,                   -- prefix virtual text with comment string
          -- experimental features:
          virt_text_pos = 'eol',              -- position of virtual text, see `:h nvim_buf_set_extmark()`
          all_frames = false,                 -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
          virt_lines = false,                 -- show virtual lines instead of virtual text (will flicker!)
          virt_text_win_col = nil             -- position the virtual text at a fixed window column (starting from the first text column) ,
        }

        local dap, dapui = require "dap", require "dapui"
        dapui.setup {} -- use default
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

      local setup_keymaps = function()
        vim.keymap.set("n", "<leader>dr", "<cmd>lua require('dap-go').debug_test()<CR>",
          { desc = "Debug: Run nearest test" })
        vim.keymap.set("n", "<leader>db", "<cmd>DapToggleBreakpoint<CR>", { desc = "Debug: Toggle breakpoint" })
      end

      -- Setup everything
      configure()           -- Configuration
      configure_exts()      -- Extensions
      configure_debuggers() -- Debugger
      setup_keymaps()
    end,
    dependencies = {
      'leoluz/nvim-dap-go',
      'rcarriga/nvim-dap-ui',
      'theHamsta/nvim-dap-virtual-text',
      "igorlfs/nvim-dap-view",
    },
  },
  {
    "nvim-neotest/neotest",
    ft = { 'go' },
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      -- Go test adapter
      { "fredrikaverpil/neotest-golang", version = "*" },
    },
    config = function()
      local neotest_ns = vim.api.nvim_create_namespace("neotest")
      vim.diagnostic.config({ virtual_text = false }, neotest_ns)

      local icons = require('icons').neotest
      ---@type neotest.Config
      require("neotest").setup({
        icons = icons,
        adapters = {
          require("neotest-golang")({
            runner = "go",
            go_test_args = {
              "-v",
              "-count=1",
              -- "-race",
            },
            warn_test_name_dupes = false,
          }),
        },
        consumers = {
          notify = function(client)
            client.listeners.results = function(adapter_id, results, partial)
              -- Partial results can be very frequent
              if partial then
                return
              end
              -- Skip logging for now
              -- require("neotest.lib").notify("Tests completed from neotest-lib")
            end
            return {}
          end,
        },
      })

      -- KEYS
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
    end
  },
}

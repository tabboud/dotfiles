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
        local keymaps = require('keymaps')
        keymaps.nnoremap("<leader>dr", "<cmd>lua require('dap-go').debug_test()<CR>",
          { desc = "Debug: Run nearest test" })
        keymaps.nnoremap("<leader>db", "<cmd>DapToggleBreakpoint<CR>", { desc = "Debug: Toggle breakpoint" })
      end

      -- Setup everything
      configure()       -- Configuration
      configure_exts()  -- Extensions
      configure_debuggers() -- Debugger
      setup_keymaps()
    end,
    dependencies = {
      'leoluz/nvim-dap-go',
      'rcarriga/nvim-dap-ui',
      'theHamsta/nvim-dap-virtual-text',
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
      "nvim-neotest/neotest-go",
    },
    config = function()
      local neotest_ns = vim.api.nvim_create_namespace("neotest")
      vim.diagnostic.config({ virtual_text = false }, neotest_ns)

      local keymaps = function()
        local keymaps = require('keymaps')

        keymaps.nnoremap('<leader>ts', function()
          return require("neotest").summary.toggle()
        end, { desc = "Test: Toggle test summary" })

        keymaps.nnoremap('<leader>to', function()
          return require("neotest").output_panel.toggle()
        end, { desc = "Test: Toggle test output panel" })

        keymaps.nnoremap('<leader>tr', function()
          return require("neotest").run.run()
        end, { desc = 'Test: Run nearest test' })

        keymaps.nnoremap('<leader>tl', function()
          return require("neotest").run.run_last()
        end, { desc = 'Test: Run last test' })
      end

      local icons = require('icons').neotest
      require("neotest").setup({
        adapters = {
          -- custom config for neotest-go adapter
          require("neotest-go")({
            experimental = {
              test_table = true,
            },
            args = { "-count=1", "-timeout=60s" }
          })
        },
        icons = icons,
        status = {
          virtual_text = false,
          signs = true,
        },
        summary = {
          animated = true,
          enabled = true,
          expand_errors = true,
          follow = true,
          mappings = {
            attach = "a",
            clear_marked = "M",
            clear_target = "T",
            expand = { "<CR>", "<2-LeftMouse>" },
            expand_all = "e",
            jumpto = "i",
            mark = "m",
            next_failed = "J",
            output = "o",
            prev_failed = "K",
            run = "r",
            debug = "d",
            run_marked = "R",
            debug_marked = "D",
            short = "O",
            stop = "u",
            target = "t"
          }
        },
        consumers = {
          notify = function(client)
            client.listeners.results = function(adapter_id, results, partial)
              -- Partial results can be very frequent
              if partial then
                return
              end
              require("neotest.lib").notify("Tests completed")
              vim.notify('Tests completed', vim.log.levels.INFO, {})
            end
            return {}
          end,
        },
      })

      keymaps()

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

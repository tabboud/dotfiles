return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-lua/lsp-status.nvim' },
    config = function()
      local icons = require("icons").lualine
      local ok, lsp_status = pcall(require, 'lsp-status')
      if ok then
        lsp_status.register_progress()
      end

      -- projectName returns the name of the containing directory (or project).
      local project_name = function()
        local project = vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
        return string.format("%s %s", icons.Folder, project)
      end

      -- get_lsp_status returns the current status of the LSP server.
      -- If progress messages are available, then they will be shown in real-time, otherwise
      -- just the currently attached LSP server will be shown or 'none' if none are attached.
      -- Progress messages are retrieved from https://github.com/nvim-lua/lsp-status.nvim
      -- via the "lsp-status.status_progress()" method, which is configured to be attached
      -- in lspconfig's "on_attach" callback.
      local get_lsp_status = function()
        for _, client in ipairs(vim.lsp.get_active_clients()) do
          if client.attached_buffers[vim.api.nvim_get_current_buf()] then
            local msgs_ok, progress_msg = pcall(function() return require('lsp-status').status_progress() end)
            if msgs_ok and progress_msg ~= '' then
              -- show LSP progress message if available
              return string.format("%s LSP: %s ", icons.Lsp, progress_msg)
            end
            -- fallback to just the currently attached LSP server
            return string.format("%s LSP: %s ", icons.Lsp, client.name)
          end
        end
        -- no clients attached
        return string.format("%s LSP: none ", icons.Lsp)
      end

      -- Show the current search count
      local search_count = function()
        if vim.v.hlsearch == 0 then
          return ''
        end

        local result = vim.fn.searchcount { maxcount = 999, timeout = 500 }
        local denominator = math.min(result.total, result.maxcount)
        return string.format('%s [%d/%d]', icons.Search, result.current, denominator)
      end

      -- Show test results
      -- TODO: Only load this if neotest is loaded, otherwise this loads neotest/neotest-go
      local neotest_status = function()
        local status_ok, neotest = pcall(require, "neotest")
        if not status_ok then
          return ""
        end
        local adapters = neotest.state.adapter_ids()
        if #adapters > 0 then
          local status = neotest.state.status_counts(adapters[1], {
            buffer = vim.api.nvim_buf_get_name(0),
          })
          local sections = {
            {
              sign = "",
              count = status.failed,
              base = "NeotestFailed",
              tag = "test_fail",
            },
            {
              sign = "",
              count = status.running,
              base = "NeotestRunning",
              tag = "test_running",
            },
            {
              sign = "",
              count = status.passed,
              base = "NeotestPassed",
              tag = "test_pass",
            },
          }

          local result = {}
          for _, section in ipairs(sections) do
            if section.count > 0 then
              table.insert(
                result,
                "%#"
                .. section.base
                .. "#"
                .. section.sign
                .. " "
                .. section.count
              )
            end
          end

          return table.concat(result, " ")
        end
        return ""
      end

      require('lualine').setup {
        options = {
          theme = IsLightMode() and "onelight" or "jellybeans",
          component_separators = { left = icons.ComponentSeparator, right = icons.ComponentSeparator },
          section_separators = { left = '', right = '' },
        },
        sections = {
          lualine_a = { "branch" },
          lualine_b = { "diff" },
          lualine_c = { search_count, neotest_status },
          lualine_x = { get_lsp_status, "diagnostics" },
          lualine_y = {},
          lualine_z = { project_name },
        },
        inactive_sections = {
          lualine_a = { "filename" },
          lualine_b = {},
          lualine_c = {},
          lualine_x = {},
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {},
        extensions = {},
      }
    end
  },
  {
    'akinsho/bufferline.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require("bufferline").setup {
        options = {
          diagnostics = "nvim_lsp",
          separator_style = "slant",
          offsets = {
            {
              -- Don't show buffers above neotree
              filetype = "neo-tree",
              text = "",
              text_align = "left",
              separator = true,
            }
          },
        }
      }
      local keymaps = require("keymaps")
      keymaps.nnoremap("gn", "<cmd>BufferLineCycleNext<cr>", { desc = "Buffer: Go to next" })
      keymaps.nnoremap("gp", "<cmd>BufferLineCyclePrev<cr>", { desc = "Buffer: Go to prev" })
    end,
  },
  {
    enabled = true,
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
      require("ibl").setup({
        exclude = {
          buftypes = { "terminal", "nofile" },
          filetypes = {
            "help",
            "text",
            "NeogitStatus",
            "Trouble",
          },
        },
        indent = {
          char = "▏",
        },
        scope = {
          show_start = false,
          show_end = false,
        },
      })
    end,
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local icons = require('icons')
      require('todo-comments').setup({
        keywords = {
          TDA = { icon = icons.lsp.hint, color = "hint" },
        },
        highlight = {
          -- default pattern
          -- pattern = [[.*<(KEYWORDS)\s*:]], -- pattern or table of patterns, used for highlighting (vim regex)
          -- pattern to highlight "TODO(author)"
          pattern = [[(KEYWORDS)\s*(\([^\)]*\))?]],
        },
        search = {
          command = "rg",
          args = {
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--hidden",       -- search hidden files
            "--glob=!vendor", -- ignore the vendor directory
          },
          pattern = [[\b(KEYWORDS)\s*(\([^\)]*\))?:]],
          -- pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
        },
      })
    end,
    keys = {
      { "]t",         function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
      { "[t",         function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
      { "<leader>xt", "<cmd>TodoTrouble<cr>",                              desc = "Todo (Trouble)" },
      { "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>",      desc = "Todo/Fix/Fixme (Trouble)" },
      { "<leader>st", "<cmd>TodoTelescope<cr>",                            desc = "Todo" },
      { "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>",    desc = "Todo/Fix/Fixme" },
    },
  },
  -- Manage pre-defined window layouts
  {
    "folke/edgy.nvim",
    event = "VeryLazy",
    init = function()
      vim.opt.laststatus = 3
      vim.opt.splitkeep = "screen"
    end,
    opts = {
      animate = {
        enabled = false,
      },
      options = {
        left = { size = 40 },
      },
      wo = {
        winfixwidth = false,
      },
      exit_when_last = true,
      right = {
        { title = "Neotest Summary", ft = "neotest-summary", size = { height = 15 } },
      },
      bottom = {
        -- toggleterm / lazyterm at the bottom with a height of 40% of the screen
        {
          ft = "terminal",
          size = { height = 0.4 },
          -- exclude floating windows
          filter = function(buf, win)
            return vim.api.nvim_win_get_config(win).relative == ""
          end,
        },
        {
          ft = "lazyterm",
          title = "LazyTerm",
          size = { height = 0.4 },
          filter = function(buf)
            return not vim.b[buf].lazyterm_cmd
          end,
        },
        "Trouble",
        { ft = "qf",             title = "QuickFix" },
        {
          ft = "help",
          size = { height = 20 },
          -- only show help buffers
          filter = function(buf)
            return vim.bo[buf].buftype == "help"
          end,
        },
        { title = "Test Output", ft = "neotest-output-panel", size = { height = 15 } },
      },
      left = {
        {
          title = "Neo-Tree",
          ft = "neo-tree",
          filter = function(buf)
            return vim.b[buf].neo_tree_source == "filesystem"
          end,
          pinned = true,
          size = { width = 0.2, height = 0.5 },
          -- open = function()
          --   require("neo-tree.command").execute({
          --     position = "left",
          --     source = "filesystem",
          --   })
          -- end,
        },
        -- {
        --   ft = "Outline",
        --   pinned = true,
        --   open = "AerialOpen",
        -- },
      },
    },
  },
}

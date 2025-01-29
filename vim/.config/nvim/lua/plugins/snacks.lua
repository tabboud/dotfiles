return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,

    ---@type snacks.Config
    opts = {
      terminal = { enabled = true },
      bigfile = { enabled = true },
      bufdelete = { enabled = true },
      statuscolumn = { enabled = false },
      indent = {},
      notifier = {},
      input = {
        enabled = true,
        win = {
          keys = {
            -- ESC drops back to normal mode instead of cancel by default
            i_esc = { "<esc>", "stopinsert", mode = "i" },
          },
        }
      },
      ---@type snacks.picker.Config
      picker = {
        enabled = true,
        formatters = {
          file = {
            -- TODO: Try and toggle this or at least show the full path in the preview window?
            filename_first = true,
          }
        },
        -- Testing layout cycles
        -- actions = {
        --   cycle_layouts = function() require("util.snacks_picker").set_next_preferred_layout() end,
        -- },
        -- layout = {
        --   preset = function() return require("util.snacks_picker").preferred_layout() end,
        -- },
        layout = "vscode",
        win = {
          input = {
            keys = {
              ["<Esc>"] = "close",
              ["<C-c>"] = { "close", mode = "i" },
              -- to close the picker on ESC instead of going to normal mode,
              -- add the following keymap to your config
              -- ["<Esc>"] = { "close", mode = { "n", "i" } },
              ["<C-e>"] = { "toggle_preview", mode = { "i", "n" } },
              ["<C-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
              ["<C-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
              ["<C-f>"] = { "list_scroll_down", mode = { "i", "n" } },
              ["<C-b>"] = { "list_scroll_up", mode = { "i", "n" } },
              -- ["<C-p>"] = { "history_back", mode = { "i", "n" } },
              -- ["<C-n>"] = { "history_forward", mode = { "i", "n" } },
              ["<a-c>"] = { "cycle_layouts", mode = { "i", "n" } },
            },
          },
        }
      },
    },
    keys = {
      { "<c-/>",           function() Snacks.terminal() end,                                       desc = "Toggle Terminal" },
      { "<c-_>",           function() Snacks.terminal() end,                                       desc = "which_key_ignore" },
      { "<c-c>",           function() Snacks.bufdelete.delete() end,                               desc = "delete buffer" },
      { "<leader>nh",      function() Snacks.notifier.show_history() end,                          desc = "Show notification history" },

      -- Picker keymaps
      { "<leader><Enter>", function() Snacks.picker.buffers({ current = false }) end,              desc = "Buffers" },
      -- { "<leader>/",       function() Snacks.picker.grep() end,                                    desc = "Grep" },
      -- { "<leader>:",       function() Snacks.picker.command_history() end,                         desc = "Command History" },
      -- { "<leader><space>", function() Snacks.picker.files() end,                                   desc = "Find Files" },
      -- find
      -- { "<leader>fb",      function() Snacks.picker.buffers() end,                                 desc = "Buffers" },
      -- Edit nvim config
      { "<leader>ed",      function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
      -- Exclude vendor directory when choosing files
      {
        "<leader>p",
        function()
          -- check if we're in git first
          local in_git = function()
            return Snacks.git.get_root() ~= nil
          end
          if in_git() then
            Snacks.picker.git_files()
          else
            Snacks.picker.files({
              exclude = { "vendor" },
            })
          end
        end,
        desc = "Find Files"
      },
      -- { "<leader>p",       function() Snacks.picker.git_files() end,                  desc = "Find Git Files" },
      -- { "<leader>pr",      function() Snacks.picker.recent() end,         desc = "Recent" },
      -- git
      -- { "<leader>gc",      function() Snacks.picker.git_log() end,                                 desc = "Git Log" },
      -- { "<leader>gs",      function() Snacks.picker.git_status() end,                              desc = "Git Status" },
      -- Grep
      -- { "<leader>sb",      function() Snacks.picker.lines() end,                                   desc = "Buffer Lines" },
      -- { "<leader>sB",      function() Snacks.picker.grep_buffers() end,                            desc = "Grep Open Buffers" },
      --
      ---@type snacks.picker.grep.Config
      { "rg",         function() Snacks.picker.grep({ hidden = true }) end, desc = "Grep (rg)" },
      -- { "<leader>sw",      function() Snacks.picker.grep_word() end,                               desc = "Visual selection or word", mode = { "n", "x" } },
      -- search
      -- { '<leader>s"',      function() Snacks.picker.registers() end,                               desc = "Registers" },
      -- { "<leader>sa",      function() Snacks.picker.autocmds() end,                                desc = "Autocmds" },
      -- { "<leader>sc",      function() Snacks.picker.command_history() end,                         desc = "Command History" },
      -- { "<leader>sC",      function() Snacks.picker.commands() end,                                desc = "Commands" },
      -- { "<leader>sd",      function() Snacks.picker.diagnostics() end,                             desc = "Diagnostics" },
      { "<leader>h",  function() Snacks.picker.help() end,                  desc = "Help Pages" },
      -- { "<leader>sH",      function() Snacks.picker.highlights() end,                              desc = "Highlights" },
      -- { "<leader>sj",      function() Snacks.picker.jumps() end,                                   desc = "Jumps" },
      -- { "<leader>sk",      function() Snacks.picker.keymaps() end,                                 desc = "Keymaps" },
      -- { "<leader>sl",      function() Snacks.picker.loclist() end,                                 desc = "Location List" },
      -- { "<leader>sM",      function() Snacks.picker.man() end,                                     desc = "Man Pages" },
      -- { "<leader>sm",      function() Snacks.picker.marks() end,                                   desc = "Marks" },
      { "<leader>sR", function() Snacks.picker.resume() end,                desc = "Resume" },
      -- { "<leader>sq",      function() Snacks.picker.qflist() end,                                  desc = "Quickfix List" },
      -- { "<leader>uC",      function() Snacks.picker.colorschemes() end,                            desc = "Colorschemes" },
      -- { "<leader>qp",      function() Snacks.picker.projects() end,                                desc = "Projects" },
      -- LSP
      -- { "gd",              function() Snacks.picker.lsp_definitions() end,                         desc = "Goto Definition" },
      { "gr",         function() Snacks.picker.lsp_references() end,        nowait = true,                 desc = "References" },
      { "gi",         function() Snacks.picker.lsp_implementations() end,   desc = "Goto Implementation" },
      -- { "gy",              function() Snacks.picker.lsp_type_definitions() end,                    desc = "Goto T[y]pe Definition" },
      { "<leader>sw", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
    },
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          -- Setup some globals for debugging (lazy-loaded)
          _G.dd = function(...)
            Snacks.debug.inspect(...)
          end
          _G.bt = function()
            Snacks.debug.backtrace()
          end
          vim.print = _G.dd -- Override print to use snacks -> `:=<thing-to-print>` command

          -- Create some toggle mappings
          Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
          Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
          Snacks.toggle.diagnostics():map("<leader>ud")
          Snacks.toggle.line_number():map("<leader>ul")
          Snacks.toggle.treesitter():map("<leader>uT")
          Snacks.toggle.inlay_hints():map("<leader>uh")
          Snacks.toggle.indent():map("<leader>ug")
        end,
      })
    end,
  }
}

local idx = 1
local layouts = {
  "ivy",
  "vscode",
  -- "ivy_split",
  -- "sidebar"
}

---Get the preferred layout
---@return string
local preferred_layout = function()
  return layouts[idx]
end

---Cycle the picker layout
---@param picker snacks.Picker
local cycle_layout = function(picker)
  idx = idx % #layouts + 1
  picker:set_layout(layouts[idx])
end

return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,

    ---@type snacks.Config
    opts = {
      terminal = { enabled = false },
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
        formatters = {
          file = {
            -- TODO: Try and toggle this or at least show the full path in the preview window?
            filename_first = true,
            truncate = 80,
          }
        },
        -- Testing layout cycles
        actions = {
          cycle_layouts = function(picker)
            cycle_layout(picker)
          end,
        },
        layout = {
          preset = function()
            return preferred_layout()
          end,
        },
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
        },
        sources = {
          explorer = {
            hidden = true
          }
        }
      },
    },
    keys = {
      -- { "<c-/>",           function() Snacks.terminal() end,                                       desc = "Toggle Terminal" },
      { "<c-_>",           function() Snacks.terminal() end,                                       desc = "which_key_ignore" },
      { "<c-c>",           function() Snacks.bufdelete.delete() end,                               desc = "delete buffer" },
      { "<leader>nh",      function() Snacks.notifier.show_history() end,                          desc = "Show notification history" },

      -- Picker keymaps
      { "<leader><Enter>", function() Snacks.picker.buffers({ current = false }) end,              desc = "Buffers" },
      -- { "<leader>e",       function() Snacks.picker.explorer() end,                                desc = "Explorer" },
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
      {
        "rg",
        function()
          Snacks.picker.grep({
            hidden = true
          })
        end,
        desc = "Grep (rg)"
      },
      -- { "<leader>sw",      function() Snacks.picker.grep_word() end,                               desc = "Visual selection or word", mode = { "n", "x" } },
      -- search
      -- { '<leader>s"',      function() Snacks.picker.registers() end,                               desc = "Registers" },
      -- { "<leader>sa",      function() Snacks.picker.autocmds() end,                                desc = "Autocmds" },
      -- { "<leader>sc",      function() Snacks.picker.command_history() end,                         desc = "Command History" },
      -- { "<leader>sC",      function() Snacks.picker.commands() end,                                desc = "Commands" },
      -- { "<leader>sd",      function() Snacks.picker.diagnostics() end,                             desc = "Diagnostics" },
      -- TODO(tabboud): Figure out how to make the help full screen
      { "<leader>h",  function() Snacks.picker.help() end,   desc = "Help Pages" },
      -- { "<leader>sH",      function() Snacks.picker.highlights() end,                              desc = "Highlights" },
      -- { "<leader>sj",      function() Snacks.picker.jumps() end,                                   desc = "Jumps" },
      -- { "<leader>sk",      function() Snacks.picker.keymaps() end,                                 desc = "Keymaps" },
      -- { "<leader>sl",      function() Snacks.picker.loclist() end,                                 desc = "Location List" },
      -- { "<leader>sM",      function() Snacks.picker.man() end,                                     desc = "Man Pages" },
      -- { "<leader>sm",      function() Snacks.picker.marks() end,                                   desc = "Marks" },
      { "<leader>sR", function() Snacks.picker.resume() end, desc = "Resume" },
      -- { "<leader>sq",      function() Snacks.picker.qflist() end,                                  desc = "Quickfix List" },
      -- { "<leader>uC",      function() Snacks.picker.colorschemes() end,                            desc = "Colorschemes" },
      -- { "<leader>qp",      function() Snacks.picker.projects() end,                                desc = "Projects" },
      -- LSP
      -- { "gd",              function() Snacks.picker.lsp_definitions() end,                         desc = "Goto Definition" },
      {
        "gr",
        function()
          ---@type snacks.picker.lsp.references.Config
          Snacks.picker.lsp_references({
            title = "LSP References",
            -- TODO(tabboud):  Add keymaps to toggle test files, mock files, etc.
            -- pattern = function(picker)
            --   return "!ingress.go"
            -- end,
            ---@type snacks.picker.filter.Config
            filter = {
              filter = function(item, filter)
                if item.file:match("_test.go") or item.file:match("conjure.go") then
                  return false
                end
                return true
              end
            },
          })
        end,
        nowait = true,
        desc = "References"
      },
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

          -- Toggle Mappings
          Snacks.toggle.diagnostics():map("<leader>td")
          Snacks.toggle.line_number():map("<leader>tl")
          Snacks.toggle.inlay_hints():map("<leader>th")
          Snacks.toggle.indent():map("<leader>ti")
          Snacks.toggle.option("list", {name = "List Chars"})
          Snacks.toggle.option("wrap", { name = "Line Wrap" }):map("<leader>tw")
          Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>tL")
        end,
      })
    end,
  }
}

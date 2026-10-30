-- snacks.lua
local trouble_snacks = require("trouble.sources.snacks")

local idx = 1
local layouts = {
  "ivy",
  "vscode",
}

---Cycle the picker layout
---@param picker snacks.Picker
local cycle_layout = function(picker)
  idx = idx % #layouts + 1
  picker:set_layout(layouts[idx])
end

---Find files with git_files inside a git repo, falling back to all files.
local find_files = function()
  if Snacks.git.get_root() ~= nil then
    Snacks.picker.git_files()
  else
    Snacks.picker.files({ exclude = { "vendor" } })
  end
end

---@type snacks.Config
local opts = {
  bigfile = {},
  indent = {},
  notifier = {},
  input = {
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
        filename_first = true,
        truncate = 80,
      }
    },
    actions = vim.tbl_extend("force", { cycle_layouts = cycle_layout }, trouble_snacks.actions),
    layout = {
      preset = function()
        return layouts[idx]
      end,
    },
    win = {
      input = {
        keys = {
          ["<Esc>"] = "close",
          ["<C-c>"] = { "close", mode = "i" },
          ["<C-e>"] = { "toggle_preview", mode = { "i", "n" } },
          ["<C-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
          ["<C-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
          ["<C-f>"] = { "list_scroll_down", mode = { "i", "n" } },
          ["<C-b>"] = { "list_scroll_up", mode = { "i", "n" } },
          ["<a-c>"] = { "cycle_layouts", mode = { "i", "n" } },
          ["<c-t>"] = { "trouble_open", mode = { "n", "i" } },
        },
      },
    },
  },
  dashboard = {
    preset = {
      ---@type snacks.dashboard.Item[]
      keys = {
        { icon = " ", key = "f", desc = "Find File", action = find_files },
        { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
        { icon = " ", key = "g", desc = "Grep", action = ":lua Snacks.dashboard.pick('live_grep')" },
        { icon = " ", key = "h", desc = "Git", action = function() require("neogit").open() end },
        { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
        {
          icon = " ",
          key = "d",
          desc = "Dotfiles",
          action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.getenv('DOTFILES'), hidden=true})",
        },
        { icon = " ", key = "s", desc = "Restore Session", action = function() vim.cmd("SessionManager load_current_dir_session") end },
        { icon = " ", key = "q", desc = "Quit", action = ":qa" },
      },
    },
    sections = {
      { section = "header" },
      { section = "keys", gap = 1, padding = 1 },
    },
  },
}

require("snacks").setup(opts)

-- Globals for debugging
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
Snacks.toggle.option("wrap", { name = "Line Wrap" }):map("<leader>tw")
Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>tL")
Snacks.toggle.option("cursorcolumn", { name = "Cursor Column" }):map("<leader>tcc")
Snacks.toggle.option("cursorline", { name = "Cursor Line" }):map("<leader>tcl")
Snacks.toggle({
  name = "Auto Format",
  get = function() return vim.g.autoformat end,
  set = function(state) vim.g.autoformat = state end,
}):map("<leader>tf")
Snacks.toggle({
  name = "CodeLens",
  get = function() return vim.lsp.codelens.is_enabled() end,
  set = function(state) vim.lsp.codelens.enable(state) end,
}):map("<leader>tC")

-- Keymaps
vim.keymap.set("n", "<c-_>",           function() Snacks.terminal() end,                                       { desc = "which_key_ignore" })
vim.keymap.set("n", "<c-c>",           function() Snacks.bufdelete.delete() end,                               { desc = "delete buffer" })
vim.keymap.set("n", "<leader>nh",      function() Snacks.notifier.show_history() end,                          { desc = "Show notification history" })

-- Picker keymaps
vim.keymap.set("n", "<leader><Enter>", function() Snacks.picker.buffers({ current = false }) end,              { desc = "Buffers" })
vim.keymap.set("n", "<leader>ed",      function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, { desc = "Find Config File" })
vim.keymap.set("n", "<leader>p",       find_files,                                                             { desc = "Find Files" })
vim.keymap.set("n", "rg",              function() Snacks.picker.grep({ hidden = true }) end,                   { desc = "Grep (rg)" })
vim.keymap.set("n", "<leader>h",       function() Snacks.picker.help() end,                                    { desc = "Help Pages" })
vim.keymap.set("n", "<leader>sR",      function() Snacks.picker.resume() end,                                  { desc = "Resume" })

-- LSP pickers
vim.keymap.set("n", "gr",              function() Snacks.picker.lsp_references() end,                          { nowait = true, desc = "References" })
vim.keymap.set("n", "gi",              function() Snacks.picker.lsp_implementations() end,                     { desc = "Goto Implementation" })
vim.keymap.set("n", "<leader>sw",      function() Snacks.picker.lsp_workspace_symbols() end,                   { desc = "LSP Workspace Symbols" })

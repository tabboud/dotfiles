-- snacks.lua
-- Merged with dashboard.lua (previously a separate lazy.nvim spec for snacks).
-- The trouble.sources.snacks picker integration (previously in trouble.lua `specs`) is also merged here.

local idx = 1
local layouts = {
  "ivy",
  "vscode",
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

-- Dashboard helpers
local in_git_repo = function()
  return Snacks.git.get_root() ~= nil
end

-- Build picker actions: merge trouble.sources.snacks if available
local picker_actions = {
  cycle_layouts = function(picker)
    cycle_layout(picker)
  end,
}
local has_trouble, trouble_snacks = pcall(require, "trouble.sources.snacks")
if has_trouble then
  picker_actions = vim.tbl_extend("force", picker_actions, trouble_snacks.actions)
end

-- Build picker input keys: add trouble_open if trouble is available
local picker_input_keys = {
  ["<Esc>"] = "close",
  ["<C-c>"] = { "close", mode = "i" },
  ["<C-e>"] = { "toggle_preview", mode = { "i", "n" } },
  ["<C-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
  ["<C-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
  ["<C-f>"] = { "list_scroll_down", mode = { "i", "n" } },
  ["<C-b>"] = { "list_scroll_up", mode = { "i", "n" } },
  ["<a-c>"] = { "cycle_layouts", mode = { "i", "n" } },
}
if has_trouble then
  picker_input_keys["<c-t>"] = { "trouble_open", mode = { "n", "i" } }
end

---@type snacks.Config
local opts = {
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
        filename_first = true,
        truncate = 80,
      }
    },
    actions = picker_actions,
    layout = {
      preset = function()
        return preferred_layout()
      end,
    },
    win = {
      input = {
        keys = picker_input_keys,
      },
    },
    sources = {
      explorer = {
        hidden = true
      }
    }
  },
  -- Dashboard config (merged from dashboard.lua)
  dashboard = {
    enabled = true,
    row = nil,
    col = nil,
    preset = {
      ---@type snacks.dashboard.Item[]
      keys = {
        {
          icon = " ",
          key = "f",
          desc = "Find File",
          action = function()
            if in_git_repo() then
              Snacks.picker.git_files()
            else
              Snacks.picker.files()
            end
          end,
        },
        { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
        { icon = " ", key = "g", desc = "Grep", action = ":lua Snacks.dashboard.pick('live_grep')" },
        {
          icon = " ",
          key = "h",
          desc = "Git",
          action = function()
            require("neogit").open()
          end,
        },
        {
          icon = " ",
          key = "r",
          desc = "Recent Files",
          action = ":lua Snacks.dashboard.pick('oldfiles')",
        },
        {
          icon = " ",
          key = "d",
          desc = "Dotfiles",
          action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.getenv('DOTFILES'), hidden=true})",
        },
        {
          icon = " ",
          key = "s",
          desc = "Restore Session",
          action = function()
            vim.cmd("SessionManager load_current_dir_session")
          end,
        },
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

-- Startup autocmd (was lazy.nvim `init` callback, fired after VeryLazy event)
vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    vim.schedule(function()
      -- Setup some globals for debugging
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
      Snacks.toggle({
        name = "Auto Format",
        get = function() return vim.g.autoformat end,
        set = function(state) vim.g.autoformat = state end,
      }):map("<leader>tf")
    end)
  end,
})

-- Keymaps
vim.keymap.set("n", "<c-_>",           function() Snacks.terminal() end,                                       { desc = "which_key_ignore" })
vim.keymap.set("n", "<c-c>",           function() Snacks.bufdelete.delete() end,                               { desc = "delete buffer" })
vim.keymap.set("n", "<leader>nh",      function() Snacks.notifier.show_history() end,                          { desc = "Show notification history" })

-- Picker keymaps
vim.keymap.set("n", "<leader><Enter>", function() Snacks.picker.buffers({ current = false }) end,              { desc = "Buffers" })
vim.keymap.set("n", "<leader>ed",      function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, { desc = "Find Config File" })
vim.keymap.set("n", "<leader>p", function()
  if in_git_repo() then
    Snacks.picker.git_files()
  else
    Snacks.picker.files({ exclude = { "vendor" } })
  end
end, { desc = "Find Files" })
vim.keymap.set("n", "rg", function()
  ---@type snacks.picker.grep.Config
  Snacks.picker.grep({ hidden = true })
end, { desc = "Grep (rg)" })
vim.keymap.set("n", "<leader>h",  function() Snacks.picker.help() end,   { desc = "Help Pages" })
vim.keymap.set("n", "<leader>sR", function() Snacks.picker.resume() end, { desc = "Resume" })

-- LSP pickers
vim.keymap.set("n", "gr", function()
  ---@type snacks.picker.lsp.references.Config
  Snacks.picker.lsp_references()
end, { nowait = true, desc = "References" })
vim.keymap.set("n", "gi",         function() Snacks.picker.lsp_implementations() end,   { desc = "Goto Implementation" })
vim.keymap.set("n", "<leader>sw", function() Snacks.picker.lsp_workspace_symbols() end, { desc = "LSP Workspace Symbols" })

-- Dashboard autocmd
local group = vim.api.nvim_create_augroup("Startup", { clear = true })
vim.api.nvim_create_autocmd("FileType", { group = group, pattern = "startup", command = "setlocal list&" })

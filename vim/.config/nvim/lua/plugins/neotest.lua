local neotest_ns = vim.api.nvim_create_namespace("neotest")
vim.diagnostic.config({
  virtual_text = {
    format = function(diagnostic)
      local message =
      diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
      return message
    end,
  },
}, neotest_ns)

local keymaps = function()
  local keymap = function(mode, l, r, opts)
    opts = opts or {}
    opts.buffer = true
    vim.keymap.set(mode, l, r, opts)
  end
  -- see :h neotest.Config
  -- toggle test summary
  keymap({ 'n', 'i' }, '<leader>st', function()
    return require("neotest").summary.toggle()
  end, { desc = 'Neotest: Toggle summary' })
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
  icons = {
    child_indent = "│",
    child_prefix = "├",
    collapsed = "─",
    expanded = "╮",
    failed = icons.failed,
    final_child_indent = " ",
    final_child_prefix = "╰",
    non_collapsible = "─",
    passed = icons.passed,
    running = "",
    running_animated = { "/", "|", "\\", "-", "/", "|", "\\", "-" },
    skipped = icons.skipped,
    unknown = icons.unknown,
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
  }
})

keymaps()

local neotest_ns = vim.api.nvim_create_namespace("neotest")
vim.diagnostic.config({
  virtual_text = {
    format = function(diagnostic)
      return diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
    end,
  },
}, neotest_ns)

local keymaps = function()
  local keymaps = require('keymaps')

  keymaps.nnoremap('<leader>ts', function()
    return require("neotest").summary.toggle()
  end, { desc = "Test: Toggle test summary" })

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
  icons = {
    child_indent = "│",
    child_prefix = "├",
    collapsed = "─",
    expanded = "╮",
    final_child_indent = " ",
    final_child_prefix = "╰",
    non_collapsible = "─",
    running = "",
    running_animated = { "/", "|", "\\", "-", "/", "|", "\\", "-" },
    passed = icons.passed,
    failed = icons.failed,
    skipped = icons.skipped,
    unknown = icons.unknown,
  },
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
  }
})

keymaps()

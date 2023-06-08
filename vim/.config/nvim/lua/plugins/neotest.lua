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
  }
})

keymaps()

-- Auto scroll to the bottom of the output-panel
vim.api.nvim_create_autocmd("FileType", {
  pattern = "neotest-output-panel",
  callback = function()
    vim.cmd("norm G")
  end,
})

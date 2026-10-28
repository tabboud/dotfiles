-- git.lua
local icons = require("icons")

-- vim-fugitive
vim.keymap.set("n", "<leader>gb", "<cmd>Git blame<cr>", { desc = "Git: blame" })

-- neogit
require("neogit").setup({})
vim.keymap.set("n", "<leader>gg", function() require("neogit").open({ kind = "tab" }) end, { desc = "Git: Show status pane" })

-- diffview
require("diffview").setup({
  enhanced_diff_hl = true,
  hooks = {
    diff_buf_read = function(_)
      vim.opt_local.list = false
      vim.opt_local.colorcolumn = { 80 }
    end,

    diff_buf_win_enter = function(_, _, ctx)
      if ctx.layout_name:match("^diff2") then
        if ctx.symbol == "a" then
          vim.opt_local.winhl = table.concat({
            "DiffAdd:DiffviewDiffAddAsDelete",
            "DiffDelete:DiffviewDiffDelete",
            "DiffChange:DiffAddAsDelete",
            "DiffText:DiffDeleteText",
          }, ",")
        elseif ctx.symbol == "b" then
          vim.opt_local.winhl = table.concat({
            "DiffDelete:DiffviewDiffDelete",
            "DiffChange:DiffAdd",
            "DiffText:DiffAddText",
          }, ",")
        end
      end
    end,
  }
})

-- gitsigns
require("gitsigns").setup({
  signs = {
    add          = { text = icons.git.GitAdd },
    change       = { text = icons.git.GitChange },
    delete       = { text = icons.git.GitDelete },
    topdelete    = { text = icons.git.GitTopDelete },
    changedelete = { text = icons.git.GitChangeDelete },
  },
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    vim.keymap.set("n", ']c', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function()
        gs.next_hunk({ preview = false })
      end)
      return '<Ignore>'
    end, { expr = true, buffer = bufnr, desc = "Git: go to next hunk" })

    vim.keymap.set("n", '[c', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function()
        gs.prev_hunk({ preview = false })
      end)
      return '<Ignore>'
    end, { expr = true, buffer = bufnr, desc = "Git: go to previous hunk" })

    vim.keymap.set("n", '<leader>gd', gs.diffthis, { buffer = bufnr, desc = "Git: diff current file" })
    vim.keymap.set("n", '<leader>gp', gs.preview_hunk, { buffer = bufnr, desc = "Git: preview hunk" })
    vim.keymap.set("n", '<leader>gs', gs.stage_hunk, { buffer = bufnr, desc = "Git: stage hunk" })
  end
})

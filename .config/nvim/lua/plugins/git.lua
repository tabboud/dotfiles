return {
  {
    'tpope/vim-fugitive',
    keys = {
      { '<leader>gb', mode = 'n', '<cmd>Git blame<cr>', desc = "Git: blame" },
    },
  },
  {
    'TimUntersberger/neogit',
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
      { "<leader>gg", function() require("neogit").open({ kind = "split_above" }) end, desc = "Git: Show status pane" },
    },
    config = true,
  },
  {
    'sindrets/diffview.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    -- only load this plugin on the following commands
    cmd = { 'DiffviewOpen', 'DiffviewFileHistory', 'DiffViewLog' },
    opts = {
      -- See ':h diffview-config-enhanced_diff_hl'
      enhanced_diff_hl = true,

      -- See ':h diffview-config-hooks'
      hooks = {
        diff_buf_read = function(_)
          -- Change local options in diff buffers
          -- vim.opt_local.wrap = false
          vim.opt_local.list = false
          vim.opt_local.colorcolumn = { 80 }
        end,

        diff_buf_win_enter = function(_, _, ctx)
          -- Highlight 'DiffChange' as 'DiffDelete' on the left, and 'DiffAdd' on the right.
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
    },
  },
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs     = {
        add          = { text = require("icons").git.GitAdd },
        change       = { text = require("icons").git.GitChange },
        delete       = { text = require("icons").git.GitDelete },
        topdelete    = { text = require("icons").git.GitTopDelete },
        changedelete = { text = require("icons").git.GitChangeDelete },
      },
      -- Key mappings
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        -- Navigation
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

        -- Actions
        -- Using a different prefix rather than "g" since that conflicts with
        -- some of the "g" native vim commands and subsequent remaps for lspconfig/telescope
        -- nnoremap('<leader>gb', gs.toggle_current_line_blame, { buffer = bufnr, desc = "Git: Toggle current line blame" })
        vim.keymap.set("n", '<leader>gd', gs.diffthis, { buffer = bufnr, desc = "Git: diff current file" })
        vim.keymap.set("n", '<leader>gp', gs.preview_hunk, { buffer = bufnr, desc = "Git: preview hunk" })
      end
    }
  },
}

return {
  {
    'tpope/vim-fugitive',
    config = function()
      require('keymaps').nnoremap("<leader>gb", "<cmd>Git blame<cr>", { desc = "Git: blame" })
    end
  },
  {
    'TimUntersberger/neogit',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local neogit = require('neogit')
      neogit.setup()
      require('keymaps').nnoremap("<leader>gg", function() neogit.open({ kind = "split_above" }) end,
        { desc = "Git: Show status pane" })
    end,
  },
  {
    -- TESTING:
    -- requires libgit2 installed (brew install libgit2)
    'SuperBo/fugit2.nvim',
    opts = {},
    dependencies = {
      'MunifTanjim/nui.nvim',
      'nvim-tree/nvim-web-devicons',
      'nvim-lua/plenary.nvim',
      {
        'chrisgrieser/nvim-tinygit', -- optional: for Github PR view
        dependencies = { 'stevearc/dressing.nvim' }
      },
      'sindrets/diffview.nvim' -- optional: for Diffview
    },
    cmd = { 'Fugit2', 'Fugit2Graph' },
    keys = {
      { '<leader>F', mode = 'n', '<cmd>Fugit2<cr>' }
    }
  },
  {
    'sindrets/diffview.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    -- only load this plugin on the following commands
    cmd = { 'DiffviewOpen', 'DiffviewFileHistory', 'DiffViewLog' },
    config = function()
      require("diffview").setup({
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
      })
    end
  },
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require("pluginconfig.gitsigns")
    end
  },
}

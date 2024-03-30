-----------------
-- Git
-----------------
local GitSigns = {}
function GitSigns.setup()
  local icons = require("icons")

  require('gitsigns').setup {
    signs                        = {
      add          = { hl = 'GitSignsAdd', text = icons.git.GitAdd, numhl = 'GitSignsAddNr', linehl = 'GitSignsAddLn' },
      change       = { hl = 'GitSignsChange', text = icons.git.GitChange, numhl = 'GitSignsChangeNr',
        linehl = 'GitSignsChangeLn' },
      delete       = { hl = 'GitSignsDelete', text = icons.git.GitDelete, numhl = 'GitSignsDeleteNr',
        linehl = 'GitSignsDeleteLn' },
      topdelete    = { hl = 'GitSignsDelete', text = icons.git.GitTopDelete, numhl = 'GitSignsDeleteNr',
        linehl = 'GitSignsDeleteLn' },
      changedelete = { hl = 'GitSignsChange', text = icons.git.GitChangeDelete, numhl = 'GitSignsChangeNr',
        linehl = 'GitSignsChangeLn' },
    },
    signcolumn                   = true,  -- Toggle with `:Gitsigns toggle_signs`
    numhl                        = false, -- Toggle with `:Gitsigns toggle_numhl`
    linehl                       = false, -- Toggle with `:Gitsigns toggle_linehl`
    word_diff                    = false, -- Toggle with `:Gitsigns toggle_word_diff`
    watch_gitdir                 = {
      interval = 1000,
      follow_files = true
    },
    attach_to_untracked          = true,
    current_line_blame           = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
    current_line_blame_opts      = {
      virt_text = true,
      virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
      delay = 1000,
      ignore_whitespace = false,
    },
    current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
    sign_priority                = 6,
    update_debounce              = 100,
    status_formatter             = nil, -- Use default
    max_file_length              = 40000,
    preview_config               = {
      -- Options passed to nvim_open_win
      border = 'single',
      style = 'minimal',
      relative = 'cursor',
      row = 1,
      col = 1
    },
    yadm                         = {
      enable = false
    },

    -- Key mappings
    on_attach                    = function(bufnr)
      local gs = package.loaded.gitsigns
      local nnoremap = require('keymaps').nnoremap

      -- Navigation
      nnoremap(']c', function()
        if vim.wo.diff then return ']c' end
        vim.schedule(function()
          gs.next_hunk({ preview = false })
        end)
        return '<Ignore>'
      end, { expr = true, buffer = bufnr, desc = "Git: go to next hunk" })

      nnoremap('[c', function()
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
      nnoremap('<leader>gd', gs.diffthis, { buffer = bufnr, desc = "Git: diff current file" })
      nnoremap('<leader>gp', gs.preview_hunk, { buffer = bufnr, desc = "Git: preview hunk" })
    end
  }
end

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
      GitSigns.setup()
    end
  },
}

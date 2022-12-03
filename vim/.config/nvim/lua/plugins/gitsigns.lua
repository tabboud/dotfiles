local icons = require("icons")

require('gitsigns').setup {
  signs                        = {
    add          = { hl = 'GitSignsAdd', text = icons.git.GitSignsAdd, numhl = 'GitSignsAddNr', linehl = 'GitSignsAddLn' },
    change       = { hl = 'GitSignsChange', text = icons.git.GitSignsChange, numhl = 'GitSignsChangeNr',
      linehl = 'GitSignsChangeLn' },
    delete       = { hl = 'GitSignsDelete', text = icons.git.GitSignsDelete, numhl = 'GitSignsDeleteNr',
      linehl = 'GitSignsDeleteLn' },
    topdelete    = { hl = 'GitSignsDelete', text = icons.git.GitSignsTopDelete, numhl = 'GitSignsDeleteNr',
      linehl = 'GitSignsDeleteLn' },
    changedelete = { hl = 'GitSignsChange', text = icons.git.GitSignsChangedDelete, numhl = 'GitSignsChangeNr',
      linehl = 'GitSignsChangeLn' },
  },
  signcolumn                   = true, -- Toggle with `:Gitsigns toggle_signs`
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
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns
    local nnoremap = require('keymaps').nnoremap

    -- Navigation
    nnoremap(']c', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function()
        gs.next_hunk({ preview = true })
      end)
      return '<Ignore>'
    end, { expr = true, buffer = bufnr, desc = "Git: go to next hunk" })

    nnoremap('[c', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function()
        gs.prev_hunk({ preview = true })
      end)
      return '<Ignore>'
    end, { expr = true, buffer = bufnr, desc = "Git: go to previous hunk" })

    -- Actions
    -- Using a different prefix rather than "g" since that conflicts with
    -- some of the "g" native vim commands and subsequent remaps for lspconfig/telescope
    nnoremap('<leader>gb', gs.toggle_current_line_blame, { buffer = bufnr, desc = "Git: Toggle current line blame" })
    nnoremap('<leader>gd', gs.diffthis, { buffer = bufnr, desc = "Git: diff current file" })
    nnoremap('<leader>gp', gs.preview_hunk, { buffer = bufnr, desc = "Git: preview hunk" })
  end
}

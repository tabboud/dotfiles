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
    row = 0,
    col = 1
  },
  yadm                         = {
    enable = false
  },

  -- Key mappings
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, { expr = true, desc = "Git: go to next hunk" })

    map('n', '[c', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, { expr = true, desc = "Git: go to previous hunk" })

    -- Actions
    -- Using a different prefix rather than "g" since that conflicts with
    -- some of the "g" native vim commands and subsequent remaps for lspconfig/telescope
    map('n', '<leader>hb', gs.toggle_current_line_blame, { buffer = true, desc = "Git: Toggle current line blame" })
    map('n', '<leader>hd', gs.diffthis, { buffer = true, desc = "Git: diff current file" })
    map('n', '<leader>hp', gs.preview_hunk, { buffer = true, desc = "Git: preview hunk" })
  end
}

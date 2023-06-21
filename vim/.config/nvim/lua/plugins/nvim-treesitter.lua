require 'nvim-treesitter.configs'.setup({
  -- list of available parsers
  ensure_installed = {
    'go',
    'help',
    'json',
    'lua',
    'markdown',
    'markdown_inline',
    'vim',
    'yaml',
  },

  highlight = {
    -- false disables the entire extension
    enable = true,
  },

  -- requires 'nvim-treesitter/nvim-treesitter-textobjects'
  -- textobjects = {
  --   select = {
  --     enable = true,
  --     lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
  --     keymaps = {
  --       -- You can use the capture groups defined in textobjects.scm
  --       ['aa'] = '@parameter.outer',
  --       ['ia'] = '@parameter.inner',
  --       ['af'] = '@function.outer',
  --       ['if'] = '@function.inner',
  --       ['ac'] = '@class.outer',
  --       ['ic'] = '@class.inner',
  --       ["iB"] = "@block.inner",
  --       ["aB"] = "@block.outer",
  --     },
  --   },
  --   move = {
  --     enable = true,
  --     set_jumps = true, -- whether to set jumps in the jumplist
  --     goto_next_start = {
  --       [']]'] = '@function.outer',
  --     },
  --     goto_next_end = {
  --       [']['] = '@function.outer',
  --     },
  --     goto_previous_start = {
  --       ['[['] = '@function.outer',
  --     },
  --     goto_previous_end = {
  --       ['[]'] = '@function.outer',
  --     },
  --   },
  --   swap = {
  --     enable = true,
  --     swap_next = {
  --       ['<leader>sn'] = '@parameter.inner',
  --     },
  --     swap_previous = {
  --       ['<leader>sp'] = '@parameter.inner',
  --     },
  --   },
  -- },
})

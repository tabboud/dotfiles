return {
  'tpope/vim-surround',   -- Add surroundings (quotes, parenthesis, etc)
  'Raimondi/delimitMate', -- Match parenthesis and quotes
  'airblade/vim-rooter',  -- Auto cd to root of git repo
  'ntpeters/vim-better-whitespace',
  'kevinhwang91/nvim-bqf',
  {
    'famiu/bufdelete.nvim',
    config = function()
      require('keymaps').nnoremap("<C-c>", function()
        require('bufdelete').bufdelete(0, false)
      end, { desc = "Buffer: Delete" })
    end
  },
  {
    'tpope/vim-commentary',
    config = function()
      require('keymaps').noremap({ 'n', 'v' }, '<leader>/', '<cmd>Commentary<cr>', { desc = "Toggle comment" })
    end
  },
  {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup({})
    end
  },
  -- save my last cursor position
  {
    "ethanholz/nvim-lastplace",
    config = function()
      require("nvim-lastplace").setup({
        lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
        lastplace_ignore_filetype = { "gitcommit", "gitrebase", "svn", "hgcommit" },
        lastplace_open_folds = true
      })
    end,
  },
  {
    "Shatur/neovim-session-manager",
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local config = require('session_manager.config')
      require("session_manager").setup({
        autoload_mode = config.AutoloadMode.Disabled,
      })
    end,
  },
}

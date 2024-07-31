return {
  'tpope/vim-surround',  -- Add surroundings (quotes, parenthesis, etc)
  -- 'Raimondi/delimitMate', -- Match parenthesis and quotes
  'airblade/vim-rooter', -- Auto cd to root of git repo
  -- 'ntpeters/vim-better-whitespace',
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

      require('keymaps').nnoremap('<leader>sl', '<cmd>SessionManager load_current_dir_session<CR>',
        { desc = "Load current dir session" })
    end,
  },
  {
    "NvChad/nvterm",
    config = function()
      require("nvterm").setup()
      require('keymaps').nnoremap('<leader><space>', function()
        return require("nvterm.terminal").toggle "horizontal"
      end, { desc = "Toggle terminal" })
    end,
  },
  {
    'akinsho/toggleterm.nvim',
    enabled = false,
    version = 'v2.*',
    config = true,
  },
}

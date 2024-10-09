return {
  'tpope/vim-surround',  -- Add surroundings (quotes, parenthesis, etc)
  -- 'Raimondi/delimitMate', -- Match parenthesis and quotes
  'airblade/vim-rooter', -- Auto cd to root of git repo
  -- 'ntpeters/vim-better-whitespace',
  'kevinhwang91/nvim-bqf',
  {
    'famiu/bufdelete.nvim',
    config = function()
      vim.keymap.set("n", "<C-c>", function()
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

      vim.keymap.set("n", '<leader>sl', '<cmd>SessionManager load_current_dir_session<CR>',
        { desc = "Load current dir session" })
    end,
  },
  {
    "NvChad/nvterm",
    config = function()
      require("nvterm").setup()
      vim.keymap.set("n", '<leader><space>', function()
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
  {
    'echasnovski/mini.pairs',
    opts = {
      modes = { insert = true, command = true, terminal = false },
      -- skip autopair when next character is one of these
      skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
      -- skip autopair when the cursor is inside these treesitter nodes
      skip_ts = { "string" },
      -- skip autopair when next character is closing pair
      -- and there are more closing pairs than opening pairs
      skip_unbalanced = true,
      -- better deal with markdown code blocks
      markdown = true,
    },
    config = function(_, opts)
      require('mini.pairs').setup()
    end,
    version = false
  },
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("fzf-lua").setup({})
    end
  }
}

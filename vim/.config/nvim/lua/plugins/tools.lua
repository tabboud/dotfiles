return {
  'tpope/vim-surround',  -- Add surroundings (quotes, parenthesis, etc)
  'airblade/vim-rooter', -- Auto cd to root of git repo
  'kevinhwang91/nvim-bqf',
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
    'echasnovski/mini.nvim',
    version = '*',
    config = function()
      require('mini.files').setup()
      require('mini.pairs').setup({
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
      })
    end,
  },
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("fzf-lua").setup({
        winopts = {
          split = "belowright new"
        },
      })
    end
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      terminal = { enabled = true },
      bufdelete = { enabled = true },
      statuscolumn = { enabled = false },
      indent = {
        -- char = "▏",
      },
      input = {
        enabled = true,
        win = {
          keys = {
            -- ESC drops back to normal mode instead of cancel by default
            i_esc = { "<esc>", "stopinsert", mode = "i" },
          },
        }
      },
    },
    keys = {
      { "<c-/>", function() Snacks.terminal() end,         desc = "Toggle Terminal" },
      { "<c-_>", function() Snacks.terminal() end,         desc = "which_key_ignore" },
      { "<c-c>", function() Snacks.bufdelete.delete() end, desc = "delete buffer" },
    }
  }
}

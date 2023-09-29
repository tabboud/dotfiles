-- plugins.lua
-- All plugin definitions and references to configuration.

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--single-branch",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.runtimepath:prepend(lazypath)

require('lazy').setup({
  -----------------
  -- Theme / Tools
  -----------------
  { 'tpope/vim-surround' },   -- Add surroundings (quotes, parenthesis, etc)
  { 'Raimondi/delimitMate' }, -- Match parenthesis and quotes
  { 'ntpeters/vim-better-whitespace' },
  { 'airblade/vim-rooter' },  -- Auto cd to root of git repo
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-lua/lsp-status.nvim' },
    config = function()
      require("plugins.lualine")
    end
  },
  {
    'akinsho/bufferline.nvim',
    version = "v3.*",
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require("plugins.bufferline")
    end
  },
  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      'MunifTanjim/nui.nvim',
    },
    keys = {
      { "<leader>k", "<cmd>Neotree toggle<cr>", desc = "NeoTree" },
      { "<leader>f", "<cmd>Neotree reveal<cr>", desc = "NeoTree" },
    },
    config = function()
      require("plugins.neo-tree")
    end
  },
  {
    enabled = true,
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
      require("plugins.indent-blankline").setup()
    end,
  },
  {
    'qpkorr/vim-bufkill', -- Bring sanity to closing buffers
    config = function()
      require('keymaps').nnoremap("<c-c>", "<cmd>BD<cr>", { desc = "Buffer: Delete" })
    end
  },
  {
    'tpope/vim-commentary', -- Toggle comments like sublime
    config = function()
      require('keymaps').noremap({ 'n', 'v' }, '<leader>/', '<cmd>Commentary<cr>', { desc = "Toggle comment" })
    end
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
  -- TODO: Group keys with tool prefix
  -- TODO: Conditionally add keymaps based on current buffer (ex: Go tests and toggle tests only for Go files)
  {
    enabled = false,
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup({})
    end
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("plugins.todo-comments")
    end,
    keys = {
      { "]t",         function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
      { "[t",         function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
      { "<leader>xt", "<cmd>TodoTrouble<cr>",                              desc = "Todo (Trouble)" },
      { "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>",      desc = "Todo/Fix/Fixme (Trouble)" },
      { "<leader>st", "<cmd>TodoTelescope<cr>",                            desc = "Todo" },
      { "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>",    desc = "Todo/Fix/Fixme" },
    },
  },
  {
    "simrat39/symbols-outline.nvim",
    config = function()
      require("symbols-outline").setup()
    end
  },
  {
    "stevearc/aerial.nvim",
    config = function()
      require('aerial').setup()
    end
  },
  {
    'Bekaboo/deadcolumn.nvim'
  },
  {
    'echasnovski/mini.colors',
    version = false,
    config = function()
      require('mini.colors').setup()
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

  ----------------
  -- DAP / Testing
  ----------------
  {
    'mfussenegger/nvim-dap',
    ft = { 'go' },
    config = function()
      require("plugins.dap").setup()
    end,
    dependencies = {
      'leoluz/nvim-dap-go',
      'rcarriga/nvim-dap-ui',
      'theHamsta/nvim-dap-virtual-text',
    },
  },
  {
    "nvim-neotest/neotest",
    ft = { 'go' },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      -- Go test adapter
      "nvim-neotest/neotest-go",
    },
    config = function()
      require("plugins.neotest")
    end
  },

  -----------------
  -- Git
  -----------------
  {
    'tpope/vim-fugitive',
    config = function()
      require('keymaps').nnoremap("<leader>gb", "<cmd>Git blame<cr>", { desc = "Git: blame" })
      require('keymaps').nnoremap("<leader>gg", "<cmd>Git<cr>", { desc = "Git: Show status pane" })
    end
  },
  {
    'sindrets/diffview.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    -- only load this plugin on the following commands
    cmd = { 'DiffviewOpen', 'DiffviewFileHistory', 'DiffViewLog' },
  },
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require("plugins.gitsigns")
    end
  },

  -----------------
  -- Languages
  -----------------
  -- Markdown syntax and previewer via glow
  { 'plasticboy/vim-markdown',            ft = { 'markdown' } },
  { "ellisonleao/glow.nvim",              config = true,                        cmd = "Glow" },
  { "rhysd/vim-go-impl",                  ft = { 'go' } },

  -----------------
  -- Color Schemes
  -----------------
  { "briones-gabriel/darcula-solid.nvim", dependencies = { "rktjmp/lush.nvim" } },
  { 'mcchrish/zenbones.nvim',             dependencies = { 'rktjmp/lush.nvim' } },
  { 'projekt0n/github-nvim-theme' },

  -----------------
  -- Treesitter
  -----------------
  {
    'nvim-treesitter/nvim-treesitter',
    config = function()
      require("plugins.nvim-treesitter")
    end
  },

  -----------------
  -- LSP
  -----------------
  {
    'neovim/nvim-lspconfig',
    config = function()
      require("plugins.lsp")
    end,
    dependencies = {
      -- Automatically install LSPs/tools to stdpath
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",

      -- Better UI for hover, code-actions, and diagnostics
      "glepnir/lspsaga.nvim",

      -- Show current code context in the winbar
      "SmiteshP/nvim-navic",

      -- Get LSP loading status in the status bar
      "nvim-lua/lsp-status.nvim",
      "mrded/nvim-lsp-notify"
    },
  },
  -- Provides a small window to show diagnostics, telescope results, etc.
  {
    "folke/trouble.nvim",
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require("trouble").setup {}
    end
  },
  {
    -- TODO: Re-enable after fixing nvim-notify startup errors
    enabled = false,
    'mrded/nvim-lsp-notify',
    dependencies = { 'rcarriga/nvim-notify' },
    config = function()
      require('lsp-notify').setup({
        notify = require('notify'),
      })
    end
  },
  {
    'rcarriga/nvim-notify',
    config = function()
      vim.opt.termguicolors = true
      require("notify").setup({
        background_colour = "#000000",
      })
    end
  },

  ----------------
  -- Completion
  ----------------
  {
    'hrsh7th/nvim-cmp',
    config = function()
      require("plugins/cmp")
    end,
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
    },
  },
  {
    'L3MON4D3/LuaSnip',
    version = 'v1.*',
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
  },

  -----------------
  -- Telescope
  -----------------
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    config = function()
      require("plugins.telescope").setup()
    end
  },
})

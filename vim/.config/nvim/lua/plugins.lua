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
  { 'tpope/vim-surround' }, -- Add surroundings (quotes, parenthesis, etc)
  { 'Raimondi/delimitMate' }, -- Match parenthesis and quotes
  { 'ntpeters/vim-better-whitespace' },
  { 'airblade/vim-rooter' }, -- Auto cd to root of git repo
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-lua/lsp-status.nvim' },
    config = function()
      require("plugins.lualine")
    end
  },
  {
    'akinsho/bufferline.nvim',
    tag = "v3.1.0",
    dependencies = 'kyazdani42/nvim-web-devicons',
    config = function()
      require("plugins.bufferline")
    end
  },
  {
    'nvim-tree/nvim-tree.lua',
    tag = 'nightly',
    config = function()
      require("plugins.nvim-tree")
    end
  },
  {
    "lukas-reineke/indent-blankline.nvim",
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
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup({})
    end
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
      { 'leoluz/nvim-dap-go' },
      { 'rcarriga/nvim-dap-ui', dependencies = { 'mfussenegger/nvim-dap' } },
      { 'theHamsta/nvim-dap-virtual-text' },
    },
  },
  {
    "nvim-neotest/neotest",
    enabled = true,
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
    end
  },
  {
    'TimUntersberger/neogit',
    dependencies = 'nvim-lua/plenary.nvim'
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
  { 'plasticboy/vim-markdown', ft = { 'markdown' } },

  -----------------
  -- Color Schemes
  -----------------
  { 'chiendo97/intellij.vim' },
  { 'doums/darcula' },
  { "briones-gabriel/darcula-solid.nvim", dependencies = "rktjmp/lush.nvim" },
  { 'mcchrish/zenbones.nvim', dependencies = 'rktjmp/lush.nvim' },

  -----------------
  -- Treesitter
  -----------------
  -- d in syntax highlighting and other syntax related plugins
  {
    'nvim-treesitter/nvim-treesitter',
    -- enabled = false,
    -- build = function() require("nvim-treesitter.install").update { with_sync = true } end,
    config = function()
      require("plugins.nvim-treesitter")
    end
  },

  -----------------
  -- LSP
  -----------------
  {
    "williamboman/mason.nvim",
    config = function()
      require("plugins.mason").setup()
    end,
    dependencies = {
      -- Automatically install LSPs/tools to stdpath
      { "williamboman/mason-lspconfig.nvim" },
      { 'WhoIsSethDaniel/mason-tool-installer.nvim' }
    }
  },
  {
    'neovim/nvim-lspconfig',
    config = function()
      require("plugins.lspconfig")
    end,
    -- Only load this after mason-lspconfig since lspconfig installs
    -- happen via mason, but server config happens here.
    -- after = "mason-lspconfig.nvim"
  },
  -- Show current code context in the winbar
  {
    "SmiteshP/nvim-navic",
    dependencies = {
      { "neovim/nvim-lspconfig" },
    },
    config = function()
      -- add in the winbar extension after loading
      vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
    end
  },
  -- Provides a small window to show diagnostics, telescope results, etc.
  {
    "folke/trouble.nvim",
    dependencies = {
      { "kyazdani42/nvim-web-devicons" },
    },
    config = function()
      require("trouble").setup {}
    end
  },
  -- Provides lsp renames with a popup window
  {
    'glepnir/lspsaga.nvim',
    branch = 'main',
    config = function()
      require('plugins.lspsaga').setup()
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
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-cmdline' },
      { 'hrsh7th/cmp-nvim-lsp-signature-help' },
      { 'L3MON4D3/LuaSnip', tag = 'v1.1.0' },
      { 'saadparwaiz1/cmp_luasnip' },
    },
  },
  -- Snippet sources
  { "rafamadriz/friendly-snippets" },

  -----------------
  -- Telescope
  -----------------
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
    },
    config = function()
      require("plugins.telescope").setup()
    end
  },
})

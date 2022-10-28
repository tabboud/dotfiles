local fn = vim.fn

-- ensure_packer is installed at the install_path.
local ensure_packer = function()
  local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  ----------------
  -- LSP Setup
  ----------------
  use { "williamboman/mason-lspconfig.nvim" }
  use {
    "williamboman/mason.nvim",
    config = function()
      require("plugins/mason").setup()
    end,
  }

  use 'ntpeters/vim-better-whitespace'
  use 'airblade/vim-rooter' -- Auto cd to root of git repo
  use {
    'qpkorr/vim-bufkill', -- Bring sanity to closing buffers
    config = function()
      vim.keymap.set("n", "<C-c>", ":BD<cr>", { noremap = false, silent = true })
    end
  }
  use {
    'tpope/vim-commentary', -- Toggle comments like sublime
    config = function()
      vim.keymap.set("", "<leader>/", ":Commentary<cr>", { noremap = false, silent = true })
    end
  }

  ----------------
  -- Appearence
  ----------------
  use 'tpope/vim-surround' -- Add surroundings (quotes, parenthesis, etc)
  use 'ryanoasis/vim-devicons' -- Icons
  use 'Raimondi/delimitMate' -- Match parenthesis and quotes
  use {
    'nvim-lualine/lualine.nvim',
    config = function()
      require("plugins/lualine")
    end
  }
  use {
    'akinsho/bufferline.nvim',
    tag = "v3.*",
    requires = 'kyazdani42/nvim-web-devicons',
    config = function()
      require("plugins/bufferline")
    end
  }
  use {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require("plugins/indent-blankline").setup()
    end,
  }

  ----------------
  -- Git
  ----------------
  use 'tpope/vim-fugitive'
  use {
    'sindrets/diffview.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    -- only load this plugin on the following commands
    cmd = { 'DiffviewOpen', 'DiffviewFileHistory', 'DiffViewLog' }
  }
  use {
    'lewis6991/gitsigns.nvim',
    config = function()
      require("plugins/gitsigns")
    end
  }

  ----------------
  -- Languages
  ----------------
  use { 'plasticboy/vim-markdown', ft = { 'markdown' } }
  -- Add go-imports plugin since nvim LSP with gopls, does not yet support it
  --  ref: https://github.com/neovim/nvim-lspconfig/issues/115
  use { 'mattn/vim-goimports', ft = { 'go' } }
  use { 'mattn/vim-goimpl', ft = { 'go' } }

  ----------------
  -- Color Schemes
  ----------------
  use 'chiendo97/intellij.vim'
  use 'doums/darcula'
  use 'shaunsingh/solarized.nvim'
  use {
    'mcchrish/zenbones.nvim',
    requires = { 'rktjmp/lush.nvim' },
  }

  ----------------
  -- File Tree
  ----------------
  use {
    'nvim-tree/nvim-tree.lua',
    requires = { 'nvim-tree/nvim-web-devicons' },
    tag = 'nightly',
    config = function()
      require("plugins.nvim-tree")
    end
  }

  ----------------
  -- Treesitter
  ----------------
  -- Used in syntax highlighting and other syntax related plugins
  use {
    'nvim-treesitter/nvim-treesitter',
    run = 'TSUpdate',
    config = function()
      require("plugins/nvim-treesitter")
    end
  }

  ----------------
  -- Snippets
  ----------------
  use 'hrsh7th/vim-vsnip'
  use 'hrsh7th/vim-vsnip-integ'
  use 'hrsh7th/cmp-vsnip'

  ----------------
  -- LSP
  ----------------
  use {
    'neovim/nvim-lspconfig',
    -- nvim-cmp source for LSP client
    requires = {
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'ray-x/lsp_signature.nvim' }
    },
    config = function()
      require("plugins/lspconfig")
    end
  }
  -- Extensions to built-in LSP, for example, providing type inlay hints
  use 'nvim-lua/lsp_extensions.nvim'

  -- autocomplete with nvim-cmp
  use {
    'hrsh7th/nvim-cmp',
    config = function()
      require("plugins/cmp")
    end
  }
  -- nvim-cmp sources
  use { 'hrsh7th/cmp-nvim-lsp' }
  use { 'hrsh7th/cmp-buffer' }

  -- Show signatures when editing
  use 'ray-x/lsp_signature.nvim'

  -- Provides lsp renames with a popup window
  use {
    'glepnir/lspsaga.nvim',
    branch = 'main',
    config = function()
      require('plugins/lsp-saga').setup()
    end
  }

  -- Provides status of LSP starting up
  use {
    'j-hui/fidget.nvim',
    config = function()
      require("fidget").setup {}
    end
  }
  ----------------
  -- Telescope
  ----------------
  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      { 'nvim-lua/plenary.nvim' },
      -- Provide dynamic args to grep/rg
      { 'nvim-telescope/telescope-live-grep-args.nvim' },
    },
    config = function()
      require("plugins/telescope").setup()
    end
  }

  -- Automatically set up your configuration after cloning packer.nvim
  if packer_bootstrap then
    require('packer').sync()
  end
end)

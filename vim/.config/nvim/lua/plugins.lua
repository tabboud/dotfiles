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
  use { 'wbthomason/packer.nvim' }
  use { "lewis6991/impatient.nvim" }

  -----------------
  -- Theme / Tools
  -----------------
  use { 'tpope/vim-surround' } -- Add surroundings (quotes, parenthesis, etc)
  use { 'Raimondi/delimitMate' } -- Match parenthesis and quotes
  use { 'ntpeters/vim-better-whitespace' }
  use { 'airblade/vim-rooter' } -- Auto cd to root of git repo
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
    'nvim-tree/nvim-tree.lua',
    requires = { 'nvim-tree/nvim-web-devicons' },
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    tag = 'nightly',
    config = function()
      require("plugins.nvim-tree")
    end
  }
  use {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require("plugins/indent-blankline").setup()
    end,
  }
  use {
    'qpkorr/vim-bufkill', -- Bring sanity to closing buffers
    config = function()
      require('keymaps').nnoremap("<c-c>", "<cmd>BD<cr>", { desc = "Buffer: Delete" })
    end
  }
  use {
    'tpope/vim-commentary', -- Toggle comments like sublime
    config = function()
      require('keymaps').noremap({ 'n', 'v' }, '<leader>/', '<cmd>Commentary<cr>', { desc = "Toggle comment" })
    end
  }
  use {
    "NvChad/nvterm",
    config = function()
      require("nvterm").setup()
    end,
  }
  -- TODO: Group keys with tool prefix
  -- TODO: Conditionally add keymaps based on current buffer (ex: Go tests and toggle tests only for Go files)
  use {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup({})
    end
  }

  ----------------
  -- DAP / Testing
  ----------------
  use {
    'mfussenegger/nvim-dap',
    config = function()
      require("plugins/dap").setup()
    end
  }
  use { 'leoluz/nvim-dap-go' }
  use { 'rcarriga/nvim-dap-ui', requires = { 'mfussenegger/nvim-dap' } }
  use { 'theHamsta/nvim-dap-virtual-text' }
  use { 'vim-test/vim-test', disable = true }
  use {
    "nvim-neotest/neotest",
    disable = false,
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      -- Go test adapter
      "nvim-neotest/neotest-go",
    },
    config = function()
      require("plugins/neotest")
    end
  }

  -----------------
  -- Git
  -----------------
  use {
    'tpope/vim-fugitive',
    config = function()
      require('keymaps').nnoremap("<leader>gb", "<cmd>Git blame<cr>", { desc = "Git: blame" })
    end
  }
  use {
    'sindrets/diffview.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    -- only load this plugin on the following commands
    cmd = { 'DiffviewOpen', 'DiffviewFileHistory', 'DiffViewLog' },
  }
  use {
    'lewis6991/gitsigns.nvim',
    config = function()
      require("plugins/gitsigns")
    end
  }

  -----------------
  -- Languages
  -----------------
  use { 'plasticboy/vim-markdown', ft = { 'markdown' } }

  -----------------
  -- Color Schemes
  -----------------
  use { 'chiendo97/intellij.vim' }
  use { 'doums/darcula' }
  use { "briones-gabriel/darcula-solid.nvim", requires = "rktjmp/lush.nvim" }
  use { 'mcchrish/zenbones.nvim', requires = { 'rktjmp/lush.nvim' },
  }

  -----------------
  -- Treesitter
  -----------------
  -- Used in syntax highlighting and other syntax related plugins
  use {
    'nvim-treesitter/nvim-treesitter',
    run = 'TSUpdate',
    config = function()
      require("plugins/nvim-treesitter")
    end
  }

  -----------------
  -- LSP
  -----------------
  use {
    "williamboman/mason.nvim",
    config = function()
      require("plugins/mason").setup()
    end,
    requires = {
      { 'WhoIsSethDaniel/mason-tool-installer.nvim' },
      { "williamboman/mason-lspconfig.nvim" }
    }
  }
  use { "williamboman/mason-lspconfig.nvim" }
  use { 'WhoIsSethDaniel/mason-tool-installer.nvim' }
  use {
    'neovim/nvim-lspconfig',
    config = function()
      require("plugins/lspconfig")
    end,
    -- Only load this after mason-lspconfig since lspconfig installs
    -- happen via mason, but server config happens here.
    after = "mason-lspconfig.nvim"
  }
  -- Extensions to built-in LSP, for example, providing type inlay hints
  use { 'nvim-lua/lsp_extensions.nvim' }
  -- Show current code context in the winbar
  use {
    "SmiteshP/nvim-navic",
    requires = "neovim/nvim-lspconfig",
    config = function()
      -- add in the winbar extension after loading
      vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
    end
  }
  -- Provides a small window to show diagnostics, telescope results, etc.
  use {
    "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require("trouble").setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end
  }
  -- Provides lsp renames with a popup window
  use {
    'glepnir/lspsaga.nvim',
    branch = 'main',
    config = function()
      require('plugins/lspsaga').setup()
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
  -- Completion
  ----------------
  use {
    'hrsh7th/nvim-cmp',
    config = function()
      require("plugins/cmp")
    end,
    requires = {
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-cmdline' },
      { 'hrsh7th/cmp-nvim-lsp-signature-help' },
      { 'L3MON4D3/LuaSnip' },
    },
  }
  -- nvim-cmp sources/snippets
  use { 'hrsh7th/cmp-nvim-lsp' }
  use { 'hrsh7th/cmp-buffer' }
  use { 'hrsh7th/cmp-cmdline' }
  use { 'hrsh7th/cmp-nvim-lsp-signature-help' }
  use { "rafamadriz/friendly-snippets" }
  use { "L3MON4D3/LuaSnip", tag = "v1.*" }
  use { "saadparwaiz1/cmp_luasnip", after = "LuaSnip" }

  -----------------
  -- Telescope
  -----------------
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

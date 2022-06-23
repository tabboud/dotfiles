local vim = vim
local call = vim.call
local fn = vim.fn

-- Plugins
local Plug = fn['plug#']

call('plug#begin', '~/.nvim/plugged')

Plug 'ap/vim-buftabline'
Plug 'tpope/vim-commentary'     -- Toggle comments like sublime
Plug 'airblade/vim-gitgutter'   -- Git gutter
Plug 'tpope/vim-fugitive'       -- Git for vim
Plug 'tpope/vim-surround'       -- Add surroundings (quotes, parenthesis, etc)
Plug 'ryanoasis/vim-devicons'   -- Icons
Plug 'Raimondi/delimitMate'     -- Match parenthesis and quotes
Plug 'qpkorr/vim-bufkill'       -- Bring sanity to closing buffers
Plug 'ntpeters/vim-better-whitespace'
Plug('scrooloose/nerdtree', {on = 'NERDTreeToggle'})
Plug('junegunn/fzf', { ['do'] = fn['fzf#install'] })
Plug 'junegunn/fzf.vim'
Plug 'airblade/vim-rooter'      -- Auto cd to root of git repo

-- Languages
Plug('plasticboy/vim-markdown', {['for'] = 'markdown'})
-- Add go-imports plugin since nvim LSP with gopls, does not yet support it
--  ref: https://github.com/neovim/nvim-lspconfig/issues/115
Plug('mattn/vim-goimports', { ['for'] = 'go'})
Plug('mattn/vim-goimpl', { ['for'] = 'go'})

-- Colorthemes
Plug('chriskempson/tomorrow-theme', { ['rtp'] = 'vim/' })
Plug 'chiendo97/intellij.vim'
Plug 'ellisonleao/gruvbox.nvim'
Plug 'doums/darcula'
Plug 'shaunsingh/solarized.nvim'

-- snippets
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'
Plug 'hrsh7th/cmp-vsnip'

Plug('nvim-treesitter/nvim-treesitter', {['do'] = fn['TSUpdate']})
-- Plug 'nvim-treesitter/playground'

-- Extensions to built-in LSP, for example, providing type inlay hints
Plug 'nvim-lua/lsp_extensions.nvim'

-- Auto-complete with nvim-cmp
Plug('hrsh7th/nvim-cmp', { ['branch'] = 'main'})
Plug('hrsh7th/cmp-nvim-lsp', { ['branch'] = 'main'})
Plug('hrsh7th/cmp-buffer', { ['branch'] = 'main'})
Plug('hrsh7th/cmp-cmdline', { ['branch'] = 'main'})
Plug 'neovim/nvim-lspconfig'

-- Use fzf with nvim-lspconfig (equivalent to using telescope)
Plug('ojroques/nvim-lspfuzzy', { ['branch'] = 'main'})

-- Telescope
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

-- Lua-line (replacement for lightline)
Plug('nvim-lualine/lualine.nvim')

-- Tagbar replacement
-- Plug 'simrat39/symbols-outline.nvim'

-- Show signatures when editing
Plug 'ray-x/lsp_signature.nvim'

call('plug#end')

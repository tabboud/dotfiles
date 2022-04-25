local vim = vim
local call = vim.call
local fn = vim.fn

-- Plugins
local Plug = fn['plug#']

call('plug#begin', '~/.nvim/plugged')

Plug 'itchyny/lightline.vim'
Plug 'ap/vim-buftabline'
Plug 'ervandew/supertab'
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
Plug 'mattn/vim-goimpl'     -- Generate interface implementations for Go
Plug('plasticboy/vim-markdown', {['for'] = 'markdown'})
Plug('rust-lang/rust.vim', { ['for'] = 'rust'})

-- Colorthemes
Plug('chriskempson/tomorrow-theme', { ['rtp'] = 'vim/' })
Plug 'chiendo97/intellij.vim'

-- Add go-imports plugin since nvim LSP with gopls, does not yet support it
--  ref: https://github.com/neovim/nvim-lspconfig/issues/115
Plug('mattn/vim-goimports', { ['for'] = 'go'})

-- snippets
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'

Plug('nvim-treesitter/nvim-treesitter', {['do'] = fn['TSUpdate']})

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

-- luatree - replacement for NERDTree
-- Plug 'kyazdani42/nvim-tree.lua'

-- Tagbar alternative
Plug 'liuchengxu/vista.vim'
-- Plug 'simrat39/symbols-outline.nvim'

call('plug#end')

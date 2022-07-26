local vim = vim
local call = vim.call
local fn = vim.fn

-- Plugins
local Plug = fn['plug#']

call('plug#begin', '~/.nvim/plugged')

Plug 'tpope/vim-commentary'     -- Toggle comments like sublime
-- Plug 'airblade/vim-gitgutter'   -- Git gutter (disabled while testing gitsigns for nvim)
Plug 'tpope/vim-fugitive'       -- Git for vim
Plug 'tpope/vim-surround'       -- Add surroundings (quotes, parenthesis, etc)
Plug 'ryanoasis/vim-devicons'   -- Icons
Plug 'Raimondi/delimitMate'     -- Match parenthesis and quotes
Plug 'qpkorr/vim-bufkill'       -- Bring sanity to closing buffers
Plug 'ntpeters/vim-better-whitespace'
Plug('scrooloose/nerdtree', {on = 'NERDTreeToggle'})
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
-- testing colorschemes
Plug 'rktjmp/lush.nvim'         -- required for zenbones below
Plug 'mcchrish/zenbones.nvim'   -- collection of minimal colorschemes (forestbones for light themes)
Plug('catppuccin/nvim', { ['as'] = 'catppuccin'})

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

-- Telescope
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
-- Telescope Extensions
Plug 'nvim-telescope/telescope-live-grep-args.nvim'     -- Provide dynamic args to grep/rg

-- Lua-line (replacement for lightline)
Plug('nvim-lualine/lualine.nvim')

-- Tagbar replacement
-- Plug 'simrat39/symbols-outline.nvim'

-- Show signatures when editing
Plug 'ray-x/lsp_signature.nvim'

-- Git gitter signs with inline blame highlights
Plug('lewis6991/gitsigns.nvim')
Plug('akinsho/bufferline.nvim', { ['tag'] = 'v2.*' })

-- lsp-saga provides lsp renames with a popup window
Plug('glepnir/lspsaga.nvim', { ['branch'] = 'main'})

call('plug#end')

" Auto install vim-plug if it's not installed
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.vim/bundle')

Plug 'itchyny/lightline.vim'
Plug 'ap/vim-buftabline'
Plug 'ervandew/supertab'
Plug 'tpope/vim-commentary'     " Toggle comments like sublime
Plug 'airblade/vim-gitgutter'   " Git gutter
Plug 'tpope/vim-fugitive'       " Git for vim
Plug 'tpope/vim-rhubarb'        " Adds GH support for vim-fugitive :GBrowse to navigate to a file on GH from vim
Plug 'ryanoasis/vim-devicons'   " Icons
Plug 'Raimondi/delimitMate'     " Match parenthesis and quotes
Plug 'majutsushi/tagbar'        " Tags side bar browser
Plug 'mhinz/vim-startify'
Plug 'qpkorr/vim-bufkill'       " Bring sanity to closing buffers
Plug 'scrooloose/nerdtree',  { 'on': 'NERDTreeToggle'}
Plug 'ntpeters/vim-better-whitespace'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-unimpaired'

" Languages
if !has('nvim')         " Not supported in NVIM
    Plug 'govim/govim', {'for': ['go'], 'branch': 'main'}
endif
Plug 'mattn/vim-goimpl'     " Generate interface implementations for Go
Plug 'plasticboy/vim-markdown', {'for': ['markdown']}
Plug 'cespare/vim-toml', {'for': ['toml']}
Plug 'rust-lang/rust.vim', {'for': ['rust']}

" Colorthemes
Plug 'chriskempson/tomorrow-theme', { 'rtp': 'vim/' }
Plug 'fatih/molokai'
Plug 'rakr/vim-one'
Plug 'chiendo97/intellij.vim'
Plug 'JaySandhu/xcode-vim'
Plug 'morhetz/gruvbox'
Plug 'sonph/onehalf', {'rtp': 'vim'}
Plug 'NLKNguyen/papercolor-theme'

" Collection of common configurations for the Nvim LSP client
if has('nvim')
    Plug 'neovim/nvim-lspconfig'

" Extensions to built-in LSP, for example, providing type inlay hints
    Plug 'nvim-lua/lsp_extensions.nvim'

" Autocompletion framework for built-in LSP

    " Add go-imports plugin since nvim LSP with gopls, does not yet support it
    " ref: https://github.com/neovim/nvim-lspconfig/issues/115
    Plug 'mattn/vim-goimports', {'for': ['go']}

    " bufferline
    " Plug 'akinsho/nvim-bufferline.lua'

    " snippets
    Plug 'hrsh7th/vim-vsnip'
    Plug 'hrsh7th/vim-vsnip-integ'

    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

    " Auto-complete with nvim-cmp
    Plug 'neovim/nvim-lspconfig'
    Plug 'hrsh7th/nvim-cmp'
    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'hrsh7th/cmp-buffer'
    Plug 'hrsh7th/cmp-path'
    Plug 'hrsh7th/cmp-cmdline'
endif

Plug 'benwainwright/fzf-project'

call plug#end()

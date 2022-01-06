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
Plug 'ryanoasis/vim-devicons'   " Icons
Plug 'Raimondi/delimitMate'     " Match parenthesis and quotes
Plug 'majutsushi/tagbar'        " Tags side bar browser
Plug 'qpkorr/vim-bufkill'       " Bring sanity to closing buffers
Plug 'scrooloose/nerdtree',  { 'on': 'NERDTreeToggle'}
Plug 'ntpeters/vim-better-whitespace'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Languages
Plug 'mattn/vim-goimpl'     " Generate interface implementations for Go
Plug 'plasticboy/vim-markdown', {'for': ['markdown']}
Plug 'cespare/vim-toml', {'for': ['toml']}
Plug 'rust-lang/rust.vim', {'for': ['rust']}

" Colorthemes
Plug 'chriskempson/tomorrow-theme', { 'rtp': 'vim/' }
Plug 'chiendo97/intellij.vim'
Plug 'NLKNguyen/papercolor-theme'
Plug 'EdenEast/nightfox.nvim', {'branch': 'main'}

if has('nvim')
    " Add go-imports plugin since nvim LSP with gopls, does not yet support it
    " ref: https://github.com/neovim/nvim-lspconfig/issues/115
    Plug 'mattn/vim-goimports', {'for': ['go']}

    " snippets
    Plug 'hrsh7th/vim-vsnip'
    Plug 'hrsh7th/vim-vsnip-integ'

    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

    " Extensions to built-in LSP, for example, providing type inlay hints
    Plug 'nvim-lua/lsp_extensions.nvim'

    " Auto-complete with nvim-cmp
    Plug 'hrsh7th/nvim-cmp', {'branch': 'main'}
    Plug 'hrsh7th/cmp-nvim-lsp', {'branch': 'main'}
    Plug 'hrsh7th/cmp-buffer', {'branch': 'main'}
    Plug 'hrsh7th/cmp-cmdline', {'branch': 'main'}
    Plug 'neovim/nvim-lspconfig'

    " Use fzf with nvim-lspconfig (equivalent to using telescope)
    Plug 'ojroques/nvim-lspfuzzy', {'branch': 'main'}
endif

call plug#end()

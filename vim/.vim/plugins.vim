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
Plug 'mhinz/vim-startify'
Plug 'qpkorr/vim-bufkill'       " Bring sanity to closing buffers
Plug 'scrooloose/nerdtree',  { 'on': 'NERDTreeToggle'}
Plug 'ntpeters/vim-better-whitespace'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-unimpaired'

" Languages
Plug 'fatih/vim-go', {'for': ['go']}    " Loads only when editing go code
Plug 'plasticboy/vim-markdown', {'for': ['markdown']}
Plug 'cespare/vim-toml', {'for': ['toml']}
Plug 'rust-lang/rust.vim', {'for': ['rust']}
Plug 'autozimu/LanguageClient-neovim', {'branch': 'next','do': 'bash install.sh'}

" Colorthemes
Plug 'chriskempson/tomorrow-theme', { 'rtp': 'vim/' }
Plug 'Lokaltog/vim-monotone'
Plug 'andreypopp/vim-colors-plain'
Plug 'fatih/molokai'
Plug 'rakr/vim-one'
Plug 'ajgrf/parchment'
Plug 'chiendo97/intellij.vim'
Plug 'JaySandhu/xcode-vim'
Plug 'morhetz/gruvbox'

" Autocompletion
" Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Plug 'prabirshrestha/async.vim'
" Plug 'prabirshrestha/vim-lsp'
" Plug 'mattn/vim-lsp-settings'

" Plug 'Shougo/deoplete.nvim'
" Plug 'lighttiger2505/deoplete-vim-lsp'

call plug#end()

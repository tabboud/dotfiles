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

" Languages
Plug 'fatih/vim-go', {'for': ['go']}    " Loads only when editing go code
Plug 'plasticboy/vim-markdown', {'for': ['markdown']}
Plug 'cespare/vim-toml', {'for': ['toml']}
Plug 'rust-lang/rust.vim', {'for': ['rust']}

" Only load fzf when we are in the terminal
" Load ctrlp when we are in a gui vim
Plug 'junegunn/fzf', has('gui_running') ? { 'on': [] } : { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim', has('gui_running') ? { 'on': [] } : {}
Plug 'ctrlpvim/ctrlp.vim', has('gui_running') ? {} : { 'on': [] }

" Colorthemes
Plug 'chriskempson/tomorrow-theme', { 'rtp': 'vim/' }
Plug 'Lokaltog/vim-monotone'
Plug 'andreypopp/vim-colors-plain'

call plug#end()

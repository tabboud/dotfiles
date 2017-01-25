" Auto install vim-plug if it's not installed
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.vim/bundle')

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ervandew/supertab'
Plug 'tpope/vim-commentary'     " Toggle comments like sublime
" Plug 'tpope/vim-surround'       " Quickly change surrounding quotations
" Plug 'tpope/vim-speeddating'    " use ctrl-A ctrl-X to increment dates and times
" Plug 'tpope/vim-obsession'      " Save a session for the current state of vim
Plug 'tpope/vim-fugitive'      " Git commands
Plug 'airblade/vim-gitgutter'   " Git gitter
Plug 'ryanoasis/vim-devicons'   " Icons
Plug 'Raimondi/delimitMate'     " Match parenthesis and quotes
Plug 'majutsushi/tagbar'        " Tags side bar browser
Plug 'mhinz/vim-startify'
Plug 'toyamarinyon/vim-swift', {'for': ['swift']}       " Loads only when editing swift code
Plug 'fatih/vim-go', {'for': ['go']}                    " Loads only when editing go code
Plug 'jpalardy/vim-slime'                               " Send commands to a repl on another tmux pane
Plug 'qpkorr/vim-bufkill'       " Bring sanity to closing buffers
Plug 'scrooloose/nerdtree',  { 'on': 'NERDTreeToggle'}
" Only load fzf when we are in the terminal
" Load ctrlp when we are in a gui vim
Plug 'junegunn/fzf', has('gui_running') ? { 'on': [] } : { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim', has('gui_running') ? { 'on': [] } : {}
Plug 'ctrlpvim/ctrlp.vim', has('gui_running') ? {} : { 'on': [] }
Plug 'kchmck/vim-coffee-script' ", {'for': ['coffeescript']}

" Async Autocomplete (Only works with nvim)
Plug 'Shougo/deoplete.nvim'
Plug 'zchee/deoplete-go', { 'do': 'make', 'for': ['go']}       " Go autocomplete
Plug 'zchee/deoplete-jedi', {'for': 'python'}                      " Python autocomplete

" Colorthemes
Plug 'chriskempson/tomorrow-theme', { 'rtp': 'vim/' }

call plug#end()

" Auto install vim-plug if it's not installed
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.vim/bundle')

" Plug 'ctrlpvim/ctrlp.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'w0rp/ale'                 " Asynchronous linting engine
Plug 'ervandew/supertab'
Plug 'tpope/vim-commentary'     " Toggle comments like sublime
Plug 'tpope/vim-surround'       " Quickly change surrounding quotations
Plug 'tpope/vim-speeddating'    " use ctrl-A ctrl-X to increment dates and times
Plug 'tpope/vim-obsession'      " Save a session for the current state of vim
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
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" Colorthemes
Plug 'junegunn/seoul256.vim'
Plug 'morhetz/gruvbox'
Plug 'chriskempson/tomorrow-theme', { 'rtp': 'vim/' }
Plug 'chriskempson/base16-vim'

call plug#end()

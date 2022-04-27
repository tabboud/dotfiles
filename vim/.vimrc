" Minimal vimrc in case neovim is not installed

" Section Settings {{{
set background=dark
colorscheme default

set autoindent                  " automatically set indent of new line
set autoread                    " detect when a file is changed
set backspace=indent,eol,start  " make backspace behave in a sane manner
set clipboard=unnamed
set completeopt+=longest,noinsert   " noinsert forces the autocomplete to not fill the first argument
set confirm         " prompt to save, rather than flag an error
set expandtab
set hidden          " current buffer can be put into background
set hlsearch
set ignorecase      " case insensitive searching
set incsearch       " set incremental search, like modern browsers
set laststatus=2    " show the satus line all the time
set lazyredraw      " don't redraw while executing macros
set linebreak       " set soft wrapping
set nobackup
set nocompatible
set noerrorbells
set nomodeline      " disable to prevent errors on certain text (vim:, ex:, ...)
set noshowmode      " don't show which mode disabled for PowerLine
set noswapfile
set nowritebackup
set number          " show line numbers
set relativenumber  " show relative line numbers
set ruler           " show the cursor position all the time
set scrolloff=8     " set 8 lines to the cursors - when moving vertical
set shiftwidth=4    " number of spaces to use for indent and unindent
set showcmd         " show incomplete commands
set showmatch       " show matching braces
set smartcase       " case-sensitive, if expresson contains a capital letter
set smartindent
set softtabstop=4   " edit as if the tabs are 4 characters wide
set t_Co=256        " Explicitly tell vim that the terminal supports 256 colors
set tabstop=4       " the visible width of tabs
set textwidth=120
set ttyfast         " faster redrawing
set updatetime=100  " wait 2 seconds before updating (this is for gitgutter and govim)
set visualbell
set wildmenu        " enhanced command line completion
set wildmode=list:longest           " complete files like a shell
if has('vim_starting')
    set encoding=utf-8
endif

" }}}

" Section Mappings {{{

" set a map leader for more key combos
let mapleader = "\<Space>"
let g:mapleader = "\<Space>"
nmap <leader>w :w<cr>
nmap <leader>q :q<cr>
map q: :q                       " Stop the window from popping up
noremap Q <NOP>     " disable Ex mode

nmap <leader>n :set nowrap!<cr>

" Change how you move across splits
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Copy file to a split
map <silent> <C-h> :call WinMove('h')<cr>
map <silent> <C-j> :call WinMove('j')<cr>
map <silent> <C-k> :call WinMove('k')<cr>
map <silent> <C-l> :call WinMove('l')<cr>

" Clear highlighting
noremap <CR> :noh<CR><CR>

" scroll the viewport faster
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>

" moving up and down work as you would expect
nnoremap <silent> j gj
nnoremap <silent> k gk
nnoremap <silent> ^ g^
nnoremap <silent> $ g$

" Faster buffer switching
map gn :bn<cr>
map gp :bp<cr>
map gd :bd<cr>

" }}}

" Section Functions {{{

" Window movement shortcuts
" move to the window in the direction shown, or create a new window
function! WinMove(key)
    let t:curwin = winnr()
    exec "wincmd ".a:key
    if (t:curwin == winnr())
        if (match(a:key,'[jk]'))
            wincmd v
        else
            wincmd s
        endif
        exec "wincmd ".a:key
    endif
endfunction

" }}}

" vim:foldmethod=marker:foldlevel=0

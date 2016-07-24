call plug#begin('~/.config/plugged')

" Colorschemes
Plug 'chriskempson/base16-vim'
Plug 'chriskempson/tomorrow-theme', {'rtp': 'vim/'}

" utilities
Plug 'ctrlpvim/ctrlp.vim'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle'}
Plug 'Raimondi/delimitMate'   " Complete quotes, parens, etc.
Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ervandew/supertab'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'       " Git for vim
Plug 'tpope/vim-commentary'     " Toggle comments like sublime
Plug 'ryanoasis/vim-devicons'   " icons for vim
Plug 'majutsushi/tagbar'        " Ctags side bar
Plug 'mhinz/vim-startify'       " Start screen for vim

" Language Specific
"Plug 'davidhalter/jedi-vim', { 'for': 'python'} 


call plug#end() 
""""""""""""
" GENERAL
""""""""""""
set nocompatible " not compatible with vi
set autoread " detect when a file is changed

" make backspace behave in a sane manner
set backspace=indent,eol,start

" set a map leader for more key combos
let mapleader = "\<Space>"
let g:mapleader = "\<Space>"

set history=100     " change history to 100
set textwidth=80

" Tab control
set tabstop=4       " the visible width of tabs
set softtabstop=4   " edit as if the tabs are 4 characters wide
set shiftwidth=4    " number of spaces to use for indent and unindent
set expandtab

" Enable the mouse
if has('mouse')
    set mouse=a
endif

" Use the system clipboard (doesn't work with neovim)
"set clipboard=unnamed

" faster redrawing
"set ttyfast

" toggle invisible characters
"set invlist
set listchars=tab:▸\ ,eol:¬,trail:⋅,extends:❯,precedes:❮
highlight SpecialKey ctermbg=none " make the highlighting of tabs less annoying
set showbreak=↪

" code folding settings
set foldmethod=syntax " fold based on indent
set foldcolumn=1
set foldnestmax=10 " deepest fold is 10 levels
set nofoldenable " don't fold by default
set foldlevel=1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => User Interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set so=8 " set 8 lines to the cursors - when moving vertical
set wildmenu " enhanced command line completion
set hidden " current buffer can be put into background
set showcmd " show incomplete commands
set noshowmode " don't show which mode disabled for PowerLine
set wildmode=list:longest " complete files like a shell
set scrolloff=8 " lines of text around cursor
set shell=$SHELL
set cmdheight=1 " command bar height
set ruler   " show the cursor position all the time
set modeline
" Cursorline on by default
set cursorline

" Put these in an autocmd group, so that we can delete them easily.
augroup vimrcEx
    au!
    " For all text files set 'textwidth' to 78 characters.
    autocmd FileType text setlocal textwidth=78
    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid or when inside an event handler
    " (happens when dropping a file on gvim).
    " Also don't do it when the mark is in the first line, that is the default
    " position when opening a file.
    autocmd BufReadPost *
                \ if line("'\"") > 1 && line("'\"") <= line("$") |
                \   exe "normal! g`\"" |
                \ endif
augroup END

set title " set terminal title

" Searching
set ignorecase          " case insensitive searching
set smartcase           " case-sensitive if expresson contains a capital letter
set hlsearch
set incsearch           " set incremental search, like modern browsers
set nolazyredraw        " don't redraw while executing macros
" bind K to grep word under cursor
nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR><CR>
" bind \ (backward slash) to grep shortcut
command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
nnoremap \ :Ag<SPACE>
noremap <CR> :noh<CR><CR>

set showmatch " show matching braces
set mat=2 " how many tenths of a second to blink

" error bells
set noerrorbells
set visualbell
set tm=500

" switch syntax highlighting on
syntax on

" Set syntax highlighting for various filetypes
au BufNewFile,BufRead *.ns set syntax=tcl

if has('vim_starting')
    set encoding=utf-8
endif

let base16colorspace=256  " Access colors present in 256 colorspace"
set t_Co=256 " Explicitly tell vim that the terminal supports 256 colors"
" Set background and theme (environment variables - see .zshrc)
set background=dark
colorscheme Tomorrow-Night-Eighties

" Delete trailing whitespace on write. "
" autocmd FileType c,cpp,python,markdown autocmd BufWritePre <buffer> :%s/\s\+$//e

set number              " show line numbers
set relativenumber      " show relative line numbers

"set wrap               " turn on line wrapping
"set wrapmargin=8       " wrap lines when coming within n characters from side
set linebreak           " set soft wrapping
set showbreak=…         " show ellipsis at breaking

set autoindent " automatically set indent of new line
set smartindent

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups, and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nobackup
set nowritebackup
set noswapfile

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => StatusLine
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set laststatus=2 " show the satus line all the time

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" toggle paste mode (avoids autoindent)
set pastetoggle=<F8>

" toggle paste mode
map <leader>v :set paste!<cr>

" remap esc
inoremap jj <esc>

" remove extra whitespace
nmap <leader><space> :%s/\s\+$<cr>

" Go to next/previous buffer
nmap <silent> <leader>bn :bn<cr>
nmap <silent> <leader>bp :bp<cr>
" Kill the buffer
nmap <silent> <leader>bd :bd<cr>

" shortcut to save (even in insert mode)
nmap <leader>w :w<cr>
" imap <leader>w <esc>:w<cr>

" shortcut to quit
nmap <leader>q :q<cr>

" disable Ex mode
noremap Q <NOP>

" disable macros
"map q <NOP>

" Toggle invisible characters
nmap <leader>l :set list!<cr>

" Toggle comments
map <leader>/ :Commentary<cr>

" Change how you move across splits
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Center the screen after next search
nnoremap n nzz
nnoremap N Nzz

" Sublime stle indentation
"vmap <c-]> >gv " Can't map c-] in terminal vim
"vmap <c-[> <gv
" Textmate style indentation
vmap <leader>[ <gv
vmap <leader>] >gv
nmap <leader>[ <<
nmap <leader>] >>


" edit vim plugins
if has('nvim')
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
    let $NVIM_TUI_ENABLE_CURSOR_SHAPE = 1
    map <leader>evp :e! ~/.config/nvim/init.vim<cr>
    map <leader>ev :e! ~/.config/nvim/init.vim<cr>
else
    map <leader>evp :e! ~/.vim/plugins.vim<cr>
    map <leader>ev :e! ~/.vimrc<cr>
endif
" edit gitconfig
map <leader>eg :e! ~/.gitconfig<cr>

" clear highlighted search
" noremap <space> :set hlsearch! hlsearch?<cr>

" activate spell-checking alternatives
nmap ;s :set invspell spelllang=en<cr>

" enable . command in visual mode
vnoremap . :normal .<cr>

" Copy file to a split
map <silent> <C-h> :call WinMove('h')<cr>
map <silent> <C-j> :call WinMove('j')<cr>
map <silent> <C-k> :call WinMove('k')<cr>
map <silent> <C-l> :call WinMove('l')<cr>

" scroll the viewport faster
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>

" moving up and down work as you would expect
nnoremap <silent> j gj
nnoremap <silent> k gk
nnoremap <silent> ^ g^
nnoremap <silent> $ g$

" search for word under the cursor
nnoremap <leader>/ "fyiw :/<c-r>f<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Toggle bitween relative and aboslute line-numbers "
nnoremap <F6> :call ToggleNumbers()<cr>

function! ToggleNumbers()
    if &relativenumber
        set norelativenumber
        set number
    else
        set relativenumber
    endif
endfunction


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


" smart tab completion
function! Smart_TabComplete()
    let line = getline('.')                         " current line

    let substr = strpart(line, -1, col('.')+1)      " from the start of the current
    " line to one character right
    " of the cursor
    let substr = matchstr(substr, '[^ \t]*$')       " word till cursor
    if (strlen(substr)==0)                          " nothing to match on empty string
        return '\<tab>'
    endif
    let has_period = match(substr, '\.') != -1      " position of period, if any
    let has_slash = match(substr, '\/') != -1       " position of slash, if any
    if (!has_period && !has_slash)
        return '\<C-X>\<C-P>'                         " existing text matching
    elseif ( has_slash )
        return '\<C-X>\<C-F>'                         " file matching
    else
        return '\<C-X>\<C-O>'                         " plugin matching
    endif
endfunction


function! TrimWhiteSpace()
    %s/\s\+$//e
endfunction


" The Silver Searcher
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" close NERDTree after a file is opened
let g:NERDTreeQuitOnOpen=0
" show hidden files in NERDTree
let NERDTreeShowHidden=1
" Toggle NERDTree
nmap <silent> <leader>k :NERDTreeToggle<cr>
" expand to the path of the file in the current buffer
nmap <silent> <leader>y :NERDTreeFind<cr>

" Toggle Tagbar
nmap <silent> <leader>d :TagbarToggle<cr>

" airline options
let g:airline_powerline_fonts=1
let g:airline_left_sep=''
let g:airline_right_sep=''
let g:airline_theme='tomorrow'
let g:airline#extensions#tabline#enabled = 1        " Enable the list of buffers
let g:airline#extensions#tabline#fnamemod = ':t'    " Show just the filename

let g:SuperTabCrMapping = 0

" map fuzzyfinder (CtrlP) plugin
nmap <silent> <leader>r :CtrlPBuffer<cr>
nmap <silent> <leader>p :CtrlP<cr>
let g:ctrlp_map='<leader>t'
let g:ctrlp_dotfiles=1
let g:ctrlp_working_path_mode = 'ra'

" CtrlP ignore patterns
" let g:ctrlp_custom_ignore = {
"             \ 'dir': '\.git$\|node_modules$\|bower_components$\|\.hg$\|\.svn$',
"             \ 'file': '\.exe$\|\.so$'
"             \ }
" only show files that are not ignored by git
" let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']

" search the nearest ancestor that contains .git, .hg, .svn
let g:ctrlp_working_path_mode = 2


" Settings for MacVim
if (has("gui_running"))
    set guioptions=egmrt
    set guifont=Souce\ Code\ Pro:h13
    set background=dark
    colorscheme Tomorrow-Night-Eighties
    let g:airline_left_sep=''
    let g:airline_right_sep=''
    let g:airline_powerline_fonts=1
    let g:airline_theme='base16'
endif
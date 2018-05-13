source $HOME/.vim/plugins.vim

" Section General {{{
set nocompatible    " not compatible with vi
set autoread        " detect when a file is changed

" make backspace behave in a sane manner
set backspace=indent,eol,start

set history=100     " change history to 100
set textwidth=120

" }}}

" Section User Interface {{{

" Tab control
set tabstop=4       " the visible width of tabs
set softtabstop=4   " edit as if the tabs are 4 characters wide
set shiftwidth=4    " number of spaces to use for indent and unindent
set expandtab

" Enable the mouse
if has('mouse')
    set mouse=a
endif

" Use the system clipboard
set clipboard=unnamed

" faster redrawing
set ttyfast

" toggle invisible characters
set listchars=tab:▸\ ,eol:¬,trail:⋅,extends:❯,precedes:❮
" make the highlighting of tabs and other non-text less annoying
highlight SpecialKey ctermbg=none ctermfg=8
highlight NonText ctermbg=none ctermfg=8
" highlight conflicts
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'
" Highlight red when over the length
highlight OverLength ctermbg=red ctermfg=white guibg=#592929
match OverLength /\%91v.\+/
set showbreak=↪

" code folding settings
set foldmethod=indent " fold based on indent
set foldcolumn=1
set foldnestmax=10 " deepest fold is 10 levels
set nofoldenable " don't fold by default
set foldlevel=99

set scrolloff=8 " set 8 lines to the cursors - when moving vertical
set wildmenu " enhanced command line completion
set hidden " current buffer can be put into background
set showcmd " show incomplete commands
set noshowmode " don't show which mode disabled for PowerLine
set wildmode=list:longest " complete files like a shell
set shell=$SHELL
set cmdheight=1 " command bar height
set ruler   " show the cursor position all the time
set modeline
set title " set terminal title
set lazyredraw        " don't redraw while executing macros
set cursorcolumn
" set cursorline

" Searching
set ignorecase          " case insensitive searching
set smartcase           " case-sensitive if expresson contains a capital letter
set hlsearch
set incsearch           " set incremental search, like modern browsers
" set nowrapscan          " stop at the top/end when searching, i.e. dont wrap

set showmatch " show matching braces
set mat=2 " how many tenths of a second to blink

" error bells
set noerrorbells
set visualbell
set tm=500

if has('vim_starting')
    set encoding=utf-8
endif

" Coloring
set t_Co=256 " Explicitly tell vim that the terminal supports 256 colors"

if &term =~ '256color'
    " disable background color erase
    set t_ut=
endif

" enable 24 bit color support if supported
if (has('mac') && empty($TMUX) && has("termguicolors"))
    set termguicolors
endif

syntax on

" set the colorscheme based on terminal background for base16-shell
if filereadable(expand("~/.vimrc_background"))
    let base16colorspace=256
    source $HOME/.vimrc_background
else
    colorscheme Tomorrow-Night-Eighties
endif

set number              " show line numbers
set relativenumber      " show relative line numbers
set linebreak           " set soft wrapping
set showbreak=…         " show ellipsis at breaking
set autoindent " automatically set indent of new line
set smartindent
set nobackup
set nowritebackup
set noswapfile
set laststatus=2 " show the satus line all the time
set updatetime=2000 " wait 2 seconds before updating (this is for gitgutter)

" }}}

" Section Mappings {{{

" set a map leader for more key combos
let mapleader = "\<Space>"
let g:mapleader = "\<Space>"

" remap esc
inoremap jk <esc>

" Stop the window from popping up
map q: :q

" toggle paste mode
map <leader>v :set paste!<cr>

" Copy the entire buffer
map <Leader>a :%y+<CR>

" shortcut to save
nmap <leader>w :w<cr>

" shortcut to quit
nmap <leader>q :q<cr>

" disable Ex mode
noremap Q <NOP>

" Toggle invisible characters
nmap <leader>l :set list!<cr>

" Toggle comments (must highlight first)
map <leader>/ :Commentary<cr>

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

" Textmate style indentation
vmap <leader>[ <gv
vmap <leader>] >gv
nmap <leader>[ <<
nmap <leader>] >>

" Center the screen after next search
nnoremap n nzz
nnoremap N Nzz

" Center the screen after moving to next function
nnoremap ]] ]]zz
nnoremap [[ [[zz

" edit ~/.vimrc
map <leader>ev :e! ~/.vimrc<cr>
" edit vim plugins
map <leader>evp :e! ~/.vim/plugins.vim<cr>
" edit gitconfig
map <leader>eg :e! ~/.gitconfig<cr>

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

" search for word under the cursor
" nnoremap <leader>/ "fyiw :/<c-r>f<cr>

" Delete a buffer in a split window, but dont close the split
" TODO: Write a mapping for this
" $ :bp|bd#

" Faster buffer switching
map gn :bn<cr>
map gp :bp<cr>
map gd :bd<cr>  

" Search a visual selection by pressing <Alt-/>
vnoremap ÷ <Esc>/\%V

" Copy relative path of current file
noremap <silent> <F4> :let @+=expand("%")<CR>

" Preview markdown buffer in internet via bcat and pandoc
" nmap <leader>vv :!pandoc -t html --smart  % \|bcat<cr><cr>

" Add a check mark
nnoremap <leader>t i<C-k>OK<Esc>

" }}}

" Section AutoGroups {{{

" file type specific settings
augroup configgroup
    autocmd!

    " Set syntax highlighting for various filetypes
    au BufNewFile,BufRead *.ns set syntax=tcl
    au BufNewFile,BufRead *.macro set syntax=groovy
    au BufNewFile,BufRead *.mesa set syntax=groovy

    " automatically resize panes on resize
    autocmd VimResized * exe 'normal! \<c-w>='
    " autocmd BufWritePost .vimrc,.vimrc.local,init.vim source %

    autocmd BufNewFile,BufReadPost *.md set filetype=markdown

    autocmd BufNewFile,BufRead,BufWrite *.md syntax match Comment /\%^---\_.\{-}---$/

augroup END

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

" Insert a ✓ with leader-t only in Markdown files
autocmd FileType markdown nnoremap <buffer> <leader>t i<C-k>OK<Esc>

" Set the right tab settings for yml filers
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType yml setlocal ts=2 sts=2 sw=2 expandtab

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

function! InGitRepo()
    let cmd = 'git ls-files'
    let output = system(cmd)
    if !v:shell_error
        return 1 " In a git repo
    else
        return 0 " not in a git repo
    endif
endfunction

" Format json inside vim (can use python or jq)
com -bang FormatJSON %!python -m json.tool
" com -bang FormatJSON %!jq '.'

" }}}

" Section Plugins {{{

" Vim Startify
" set the session directory
let g:startify_session_dir = '$HOME/.vim/session'

" Vim-Bufkill
map <C-c> :BD<cr>

" NERDTree Settings
let NERDTreeShowHidden=1
" Toggle NERDTree
nmap <silent> <leader>k :NERDTreeToggle<cr>
" Find current file
nmap <silent> <leader>f :NERDTreeFind<cr>

" Airline Options
let g:airline_powerline_fonts=1
let g:airline_theme='base16_eighties'
let g:airline#extensions#tabline#enabled = 1        " Enable the list of buffers
let g:airline#extensions#tabline#fnamemod = ':t'    " Show just the filename

let g:SuperTabCrMapping = 0

" Tagbar Settings
let g:tagbar_ctags_bin='/usr/local/Cellar/ctags/5.8_1/bin/ctags'  " Set the path for exhuberant_ctags
" Toggle TagBar
nmap <silent> <leader>d :TagbarToggle<cr>

" Vim-Go Settings
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_fields = 1
let g:go_highlight_types = 1
"let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
" Automatically import packages on save
let g:go_fmt_command = "goimports"
"let g:go_list_type = "quickfix"
" Enable experimental so that folds are not closed
let g:go_fmt_experimental = 1
let g:go_fmt_fail_silently = 0
let g:go_autodetect_gopath = 1
let g:go_term_enabled = 1

" CtrlP & FZF Settings
if (has("gui_running"))
    nmap <silent> <leader>r :CtrlPBuffer<cr>
    nmap <silent> <leader>p :CtrlP<cr>
    let g:ctrlp_map='<leader>t'
    let g:ctrlp_dotfiles=1
    let g:ctrlp_working_path_mode = 'ra'
    " only show files that are not ignored by git
    let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']
    " search the nearest ancestor that contains .git, .hg, .svn
    let g:ctrlp_working_path_mode = 2
else
    " FZF Settings
    let g:fzf_layout = { 'down': '~25%' }

    nmap <silent> <leader>p :GFiles<cr>
    " TODO: This only works if we start out in a git project
    " if InGitRepo()
    "     " if in a git project, use :GFiles
    "     nmap <silent> <leader>p :GFiles<cr>
    " else
    "     " otherwise, use :FZF
    "     nmap <silent> <leader>p :FZF<cr>
    " endif

    nmap <silent> <leader>r :Buffers<cr>

    " Insert mode completion
    imap <c-x><c-k> <plug>(fzf-complete-word)
    imap <c-x><c-f> <plug>(fzf-complete-path)
    " imap <c-x><c-j> <plug>(fzf-complete-file-ag)
    imap <c-x><c-l> <plug>(fzf-complete-line)

    " Augmenting Ag command using fzf#vim#with_preview function
    "   * fzf#vim#with_preview([[options], preview window, [toggle keys...]])
    "   * Preview script requires Ruby
    "   * Install Highlight or CodeRay to enable syntax highlighting
    "
    "   :Ag  - Start fzf with hidden preview window that can be enabled with "?" key
    "   :Ag! - Start fzf in fullscreen and display the preview window above
    autocmd VimEnter * command! -bang -nargs=* Ag
      \ call fzf#vim#ag(<q-args>,
      \                 <bang>0 ? fzf#vim#with_preview('up:60%')
      \                         : fzf#vim#with_preview('right:50%:hidden', '?'),
      \                 <bang>0)
endif



" Vim-Slime Settings
let g:slime_target = "tmux"
let g:slime_paste_file = "$HOME/.slime_paste"

" lightline configs
let g:lightline = {
    \ 'colorscheme': 'jellybeans',
    \ }

" Vim-livedown (markdown previewer)
let g:livemark_browser = "chrome"

" Night-and-Day Settings
" let hour = strftime("%H") " Set the background light from 7am to 7pm
" if 7 <= hour && hour < 19
"   set background=light
" else " Set to dark from 7pm to 7am
"   set background=dark
" endif
" colorscheme solarized " Use the awesome solarized color scheme
" DONT USE THESE
" let g:nd_themes = [
"   \ ['4:00',  'Tomorrow-Night-Eighties', 'light' ],
"   \ ['11:00', 'base16-solarized-light', 'light' ],
"   \ ['18:00', 'base16-solarized-light', 'dark'  ],
"   \ ]

" }}}

" Section MacVim {{{
if (has("gui_running"))
    set guioptions=egmrt
    set background=dark
    set guifont=Sauce\ Code\ Pro\ Nerd\ Font\ Complete:h14
    colorscheme Tomorrow-Night-Eighties
    " let g:airline_left_sep=''
    " let g:airline_right_sep=''
    let g:airline_powerline_fonts=1
    let g:airline_theme='base16_eighties'
endif
" }}}

" Section Neovim {{{
if (has("nvim"))
    " switch cursor to line when in insert mode, and block when not
    set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
      \,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
      \,sm:block-blinkwait175-blinkoff150-blinkon175
    " use ESC to go back to normal mode from terminal
    tnoremap <Esc> <C-\><C-n>
    " Switch panes easier with Alt+{h,j,k,l} when in terminal and normal mode
    tnoremap <A-h> <C-\><C-n><C-w>h
    tnoremap <A-j> <C-\><C-n><C-w>j
    tnoremap <A-k> <C-\><C-n><C-w>k
    tnoremap <A-l> <C-\><C-n><C-w>l
    nnoremap <A-h> <C-w>h
    nnoremap <A-j> <C-w>j
    nnoremap <A-k> <C-w>k
    nnoremap <A-l> <C-w>l

    " deoplete settings
	let g:deoplete#enable_at_startup = 1
	let g:deoplete#ignore_sources = {}
	let g:deoplete#ignore_sources._ = ['buffer', 'member', 'tag', 'file', 'neosnippet']
	let g:deoplete#sources#go#sort_class = ['func', 'type', 'var', 'const']
	let g:deoplete#sources#go#align_class = 1

    " Use partial fuzzy matches like YouCompleteMe
    call deoplete#custom#set('_', 'matchers', ['matcher_fuzzy'])
    call deoplete#custom#set('_', 'converters', ['converter_remove_paren'])
    call deoplete#custom#set('_', 'disabled_syntaxes', ['Comment', 'String'])

    " don't show the preview window for deoplete
    set completeopt-=preview
    " Scroll down
    let g:SuperTabDefaultCompletionType = "<c-n>"

    " incremental searching
    set icm=nosplit
endif
" }}}

" vim:foldmethod=marker:foldlevel=0

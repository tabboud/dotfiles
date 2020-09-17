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

set scrolloff=8     " set 8 lines to the cursors - when moving vertical
set wildmenu        " enhanced command line completion
set hidden          " current buffer can be put into background
set showcmd         " show incomplete commands
set noshowmode      " don't show which mode disabled for PowerLine
set confirm         " prompt to save, rather than flag an error
set shell=$SHELL
set cmdheight=1     " command bar height
set ruler           " show the cursor position all the time
set nomodeline      " disable to prevent errors on certain text (vim:, ex:, ...)
set title           " set terminal title
set lazyredraw      " don't redraw while executing macros
set wildmode=list:longest " complete files like a shell
" set completeopt+=popup,longest,menuone
set completeopt=longest,menuone

" Searching
set ignorecase      " case insensitive searching
set smartcase       " case-sensitive, if expresson contains a capital letter
set incsearch       " set incremental search, like modern browsers
set hlsearch

set showmatch       " show matching braces
set mat=2           " how many tenths of a second to blink

" error bells
set noerrorbells
set visualbell
set tm=500

if has('vim_starting')
    set encoding=utf-8
endif

" Coloring
if &term =~ '256color'
    " disable background color erase
    set t_ut=
endif
set synmaxcol=120           " disable  syntax highlighting after 120 columns
set colorcolumn=120         " Draw a vertical line at 120 characters
syntax sync minlines=256    " start highlighting from 256 lines backwards
set re=1                    " use explicit old regexpengine, which seems to be faster
set background=dark
colorscheme default
set t_Co=256            " Explicitly tell vim that the terminal supports 256 colors
set number              " show line numbers
set relativenumber      " show relative line numbers
set linebreak           " set soft wrapping
set showbreak=…         " show ellipsis at breaking
set autoindent          " automatically set indent of new line
set smartindent
set nobackup
set nowritebackup
set noswapfile
set laststatus=2        " show the satus line all the time
set updatetime=2000     " wait 2 seconds before updating (this is for gitgutter)

" }}}

" Section Mappings {{{

" set a map leader for more key combos
let mapleader = "\<Space>"
let g:mapleader = "\<Space>"

" remap esc
inoremap kj <esc>

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

" Toggle wrapping
nmap <leader>n :set nowrap!<cr>

" Toggle comments (must highlight first)
map <leader>/ :Commentary<cr>

" Insert current time as a markdown header
map <leader>D :put =strftime('# %a %Y-%m-%d %H:%M:%S%z')<CR>

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
nnoremap n nzzzv
nnoremap N Nzzzv

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

" Faster buffer switching
map gn :bn<cr>
map gp :bp<cr>
map gd :bd<cr>

" Search a visual selection by pressing <Alt-/>
vnoremap ÷ <Esc>/\%V

" Copy relative path of current file
noremap <silent> <F4> :let @+=expand("%")<CR>

" }}}

" Section AutoGroups {{{

" file type specific settings
augroup configgroup
    autocmd!

    " automatically resize panes on resize
    autocmd VimResized * exe 'normal! \<c-w>='
    " autocmd BufWritePost .vimrc,.vimrc.local,init.vim source %

    autocmd BufNewFile,BufReadPost *.md set filetype=markdown
    autocmd FileType *.md setlocal ts=2 sts=2 sw=2 expandtab cuc

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

" Set the right tab settings and cursorcolumn for yml files
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab cuc
autocmd FileType yml setlocal ts=2 sts=2 sw=2 expandtab cuc

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

" Format json inside vim (can use python or jq)
com -bang FormatJSON %!python -m json.tool
" com -bang FormatJSON %!jq '.'

" Visual Mode */# from Scrooloose {{{
function! s:VSetSearch()
  let temp = @@
  norm! gvy
  let @/ = '\V' . substitute(escape(@@, '\'), '\n', '\\n', 'g')
  let @@ = temp
endfunction

vnoremap * :<c-u>call <sid>vsetsearch()<cr>//<cr><c-o>
vnoremap # :<c-u>call <sid>vsetsearch()<cr>??<cr><c-o>

" create a go doc comment based on the word under the cursor
function! s:create_go_doc_comment()
  norm "zyiw
  execute ":put! z"
  execute ":norm I// \<Esc>$"
endfunction
nnoremap <leader>ui :<C-u>call <SID>create_go_doc_comment()<CR>

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

" Auto track the current buffer in NERDTree
function! AutoNTFinder()
    if !exists('g:NERDTree')
        return
    endif
    if g:NERDTree.IsOpen() && &buftype == ''
        let l:winnr = winnr()
        let l:altwinnr = winnr('#')

        :NERDTreeFind

        execute l:altwinnr . 'wincmd w'
        execute l:winnr . 'wincmd w'
    endif
endfunction

" Toggle NERDTree window position
function! ToggleNERDTreeWinPos()
    let l:pos = get(g:, 'NERDTreeWinPos', 'default')
    if pos ==# "left"
        let g:NERDTreeWinPos="right"
    else
        let g:NERDTreeWinPos="left"
    endif
endfunction
nnoremap <leader>c :call ToggleNERDTreeWinPos()<CR>

" Disabled auto finding
" autocmd BufEnter * call AutoNTFinder()

let g:SuperTabCrMapping = 0

" Tagbar Settings
let g:tagbar_ctags_bin='/usr/local/Cellar/ctags/5.8_1/bin/ctags'  " Set the path for exhuberant_ctags
" Toggle TagBar
nmap <silent> <leader>d :TagbarToggle<cr>

" Tagbar settings for go
let g:tagbar_type_go = {
    \ 'ctagstype' : 'go',
    \ 'kinds'     : [
        \ 'p:package',
        \ 'i:imports:1',
        \ 'c:constants',
        \ 'v:variables',
        \ 't:types',
        \ 'n:interfaces',
        \ 'w:fields',
        \ 'e:embedded',
        \ 'm:methods',
        \ 'r:constructor',
        \ 'f:functions'
    \ ],
    \ 'sro' : '.',
    \ 'kind2scope' : {
        \ 't' : 'ctype',
        \ 'n' : 'ntype'
    \ },
    \ 'scope2kind' : {
        \ 'ctype' : 't',
        \ 'ntype' : 'n'
    \ },
    \ 'ctagsbin'  : 'gotags',
    \ 'ctagsargs' : '-sort -silent'
\ }

"" Vim-Go Settings
let g:go_fmt_fail_silently = 1
let g:go_fmt_command = "goimports"
" let g:go_autodetect_gopath = 1
let g:go_term_enabled = 1
let g:go_list_type = "quickfix"
let g:go_auto_type_info = 1 " show type information
" use lisp-case for :GoAddTags
let g:go_addtags_transform = 'lispcase'
let g:go_fmt_experimental = 1       " Dont collapse folds on save

" freezing during save. see (https://github.com/fatih/vim-go/issues/144)
let g:syntastic_go_checkers = ['golint', 'govet', 'errcheck']

" highlights
let g:go_highlight_array_whitespace_error = 0
let g:go_highlight_build_constraints = 0
let g:go_highlight_extra_types = 0
let g:go_highlight_space_tab_error = 0
let g:go_highlight_trailing_whitespace_error = 0
let g:go_highlight_fields       = 0
let g:go_highlight_functions    = 0
let g:go_highlight_methods      = 0
let g:go_highlight_operators    = 0
let g:go_highlight_types        = 0

augroup go
  autocmd!

  " Show a list of interfaces which is implemented by the type under your cursor
  autocmd FileType go nmap <Leader>s <Plug>(go-implements)

  " Open alternate files (i.e. the xxx_test.go file from the xxx.go file)
  autocmd Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
  autocmd Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
  autocmd Filetype go command! -bang AS call go#alternate#Switch(<bang>0, 'split')

  " autocomplete on .
  autocmd filetype go inoremap <buffer> . .<C-x><C-o>
augroup END

" FZF Settings
let g:fzf_layout = { 'down': '~25%' }

" custom :GFiles call to ignore the vendor directory
command! MyGFiles call fzf#run(fzf#wrap({'source': 'git ls-files --exclude-standard --cached --others | grep -v vendor/'}))
nmap <silent> <leader>p :MyGFiles<cr>
" nmap <silent> <leader>p :GFiles<cr>

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

" lightline configs
let g:lightline = {
    \ 'colorscheme': 'jellybeans',
    \ }

" }}}

" Section MacVim {{{
if (has("gui_running"))
    set guioptions=egmrt
    set background=dark
    colorscheme Tomorrow-Night-Eighties
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

    " Scroll down
    let g:SuperTabDefaultCompletionType = "<c-n>"

    " incremental searching
    set icm=nosplit
endif
" }}}

" vim:foldmethod=marker:foldlevel=0

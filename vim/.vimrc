source $HOME/.vim/plugins.vim

" Section General {{{
set nocompatible
set autoread                    " detect when a file is changed
set backspace=indent,eol,start  " make backspace behave in a sane manner
set history=100
set textwidth=120

" }}}

" Section User Interface {{{
set tabstop=4       " the visible width of tabs
set softtabstop=4   " edit as if the tabs are 4 characters wide
set shiftwidth=4    " number of spaces to use for indent and unindent
set expandtab

if has('mouse')
    set mouse=a
endif
if !has('nvim')
    set ttymouse=sgr    " Set ttymouse to get hover working in the terminal
    set balloondelay=250
endif


" toggle invisible characters
set listchars=tab:▸\ ,eol:¬,trail:⋅,extends:❯,precedes:❮
highlight SpecialKey ctermbg=none ctermfg=8
highlight NonText ctermbg=none ctermfg=8
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'    " highlight conflicts
" Highlight red when over the length
highlight OverLength ctermbg=red ctermfg=white guibg=#592929
match OverLength /\%91v.\+/
set showbreak=↪

" code folding settings
set foldmethod=indent   " fold based on indent
set foldcolumn=1
set foldnestmax=10      " deepest fold is 10 levels
set nofoldenable        " don't fold by default
set foldlevel=99

set clipboard=unnamed
set ttyfast         " faster redrawing
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
set noerrorbells
set visualbell
set tm=500
set lazyredraw      " don't redraw while executing macros
set wildmode=list:longest           " complete files like a shell
set completeopt+=longest,noinsert   " noinsert forces the autocomplete to not fill the first argument
" Suggestion: show info for completion candidates in a popup menu
if has("patch-8.1.1904")
    set completeopt+=popup,menuone
endif

set ignorecase      " case insensitive searching
set smartcase       " case-sensitive, if expresson contains a capital letter
set incsearch       " set incremental search, like modern browsers
set hlsearch
set showmatch       " show matching braces
set mat=2           " how many tenths of a second to blink

if has('vim_starting')
    set encoding=utf-8
endif

" Coloring
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif
" The BAT_THEME is used in coloring the fzf preview window.
" Trigger the change if colorscheme is called (must come before our colorscheme below)
augroup update_bat_theme
    autocmd!
    autocmd colorscheme * call ToggleBatEnvVar()
augroup end
function ToggleBatEnvVar()
    if (&background == "light")
        let $BAT_THEME='gruvbox-light'
    else
        let $BAT_THEME=''
    endif
endfunction
set background=light
colorscheme intellij

set synmaxcol=120           " disable  syntax highlighting after 120 columns
set colorcolumn=120         " Draw a vertical line at 120 characters
syntax sync minlines=256    " start highlighting from 256 lines backwards
set re=0                " Use the newer regex engine so syntax highlighting doesn't get messed up
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
set updatetime=100     " wait 2 seconds before updating (this is for gitgutter and govim)
set cursorline
" set cursorcolumn
" Suggestion: Turn on the sign column so you can see error marks on lines
" where there are quickfix errors. Some users who already show line number
" might prefer to instead have the signs shown in the number column; in which
" set signcolumn=number
" set signcolumn=auto:2-9     " draw signcolumn when there are signs to display and resize to largest width
set signcolumn=auto

" }}}

" Section Mappings {{{

" Snippets
" Insert a TODO line by typing "todo<space>"
iabbrev todo // TODO(tabboud):

" set a map leader for more key combos
let mapleader = "\<Space>"
let g:mapleader = "\<Space>"

inoremap kj <esc>

map <leader>v :set paste!<cr>   " toggle paste mode
map <Leader>a :%y+<CR>          " Copy the entire buffer
nmap <leader>w :w<cr>
nmap <leader>q :q<cr>
map q: :q                       " Stop the window from popping up
noremap Q <NOP>     " disable Ex mode

nmap <leader>l :set list!<cr>
nmap <leader>n :set nowrap!<cr>
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

augroup ymlConfig
    autocmd!
    " Set the right tab settings and cursorcolumn for yml files
    autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab cuc
    autocmd FileType yml setlocal ts=2 sts=2 sw=2 expandtab cuc
augroup END

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

" }}}

" Section Plugins {{{
function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

" command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)
" Allow passing optional flags into the Rg command.
"   Example: :Rg myterm -g '*.md'
command! -bang -nargs=* RG
  \ call fzf#vim#grep(
  \ "rg --column --line-number --no-heading --color=always --smart-case " .
  \ <q-args>, 1, fzf#vim#with_preview(), <bang>0)

" Vim-Bufkill
map <C-c> :BD<cr>

" NERDTree Settings
let NERDTreeShowHidden=1
nmap <silent> <leader>k :NERDTreeToggle<cr>
nmap <silent> <leader>f :NERDTreeFind<cr>
" Close NERDTree if it's the last window open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif


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
" autocmd BufEnter * call AutoNTFinder()

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

let g:SuperTabCrMapping = 0

" Tagbar Settings
let g:tagbar_ctags_bin='/usr/local/Cellar/ctags/5.8_2/bin/ctags'  " Set the path for exhuberant_ctags
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

" FZF Settings
" Launch fzf in a terminal buffer
" let g:fzf_layout = { 'down': '~25%' }
" Use the following to launch fzf in a popup window
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }

" custom :GFiles call to ignore the vendor directory
command! MyGFiles call fzf#run(fzf#wrap({'source': 'git ls-files --exclude-standard --cached --others | grep -v vendor/'}))
nmap <silent> <leader>p :MyGFiles<cr>
nmap <silent> <leader>r :Buffers<cr>
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-l> <plug>(fzf-complete-line)

" lightline configs
let g:lightline = {
    \ 'colorscheme': 'jellybeans',
    \ }

" }}}

" Section MacVim {{{
if (has("gui_running"))
    set guioptions=egmrt
    set background=light
    colorscheme intellij
    let g:airline_powerline_fonts=1
    let g:airline_theme='base16_eighties'
    set guifont=JetBrainsMonoNerdFontComplete-Regular:h14
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

    " Enable go-imports when using the NVIM LSP
    let g:goimports = 1

    " Configure and use Neovim lua plugins/settings
    " See the cooresponding files in $HOME/.config/nvim/lua
lua << EOF
    require("plugins/cmp")
    require("plugins/lspconfig")
    require("plugins/lspfuzzy")
EOF

endif

" Go specific settings
source $HOME/.vim/go/alternate.vim
source $HOME/.vim/go/textobj.vim
source $HOME/.vim/go/tags.vim
source $HOME/.vim/go/util.vim
source $HOME/.vim/go/path.vim
source $HOME/.vim/go/config.vim
source $HOME/.vim/go/fillstruct.vim
source $HOME/.vim/go/cmd.vim
" source $HOME/.vim/go/statusline.vim
source $HOME/.vim/go/tool.vim
source $HOME/.vim/go/list.vim
source $HOME/.vim/go/fillstruct.vim
command! -nargs=0 GoFillStruct call go#fillstruct#FillStruct()
command! -nargs=0 GoAlt call go#alternate#Switch(0, '')

" setup ]] and [[ to jump between functions in Go
" Remap ]] and [[ to jump betweeen functions as they are useless in Go
" nnoremap <buffer> <silent> ]] :<c-u>call go#textobj#FunctionJump('n', 'next')<cr>
" nnoremap <buffer> <silent> [[ :<c-u>call go#textobj#FunctionJump('n', 'prev')<cr>

" onoremap <buffer> <silent> ]] :<c-u>call go#textobj#FunctionJump('o', 'next')<cr>
" onoremap <buffer> <silent> [[ :<c-u>call go#textobj#FunctionJump('o', 'prev')<cr>

" xnoremap <buffer> <silent> ]] :<c-u>call go#textobj#FunctionJump('v', 'next')<cr>
" xnoremap <buffer> <silent> [[ :<c-u>call go#textobj#FunctionJump('v', 'prev')<cr>

" }}}

" vim:foldmethod=marker:foldlevel=0

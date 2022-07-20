" Auto-install vim-plug if it doesn't exist
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
" Load all plugins
lua require('plugins')

" Section Settings {{{
set textwidth=120
set tabstop=4       " the visible width of tabs
set softtabstop=4   " edit as if the tabs are 4 characters wide
set shiftwidth=4    " number of spaces to use for indent and unindent
set expandtab

" toggle invisible characters
set listchars=tab:▸\ ,eol:¬,trail:⋅,extends:❯,precedes:❮
set showbreak=↪

" code folding settings
" set foldmethod=indent   " fold based on indent
" set foldcolumn=1
" set foldnestmax=10      " deepest fold is 10 levels
" set nofoldenable        " don't fold by default
" set foldlevel=99

" TODO(tabboud): Use nvim_treesitter#foldexpr() for syntax aware folding
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()

set mouse=a
set clipboard=unnamed
set scrolloff=8     " set 8 lines to the cursors - when moving vertical
set noshowmode      " don't show which mode disabled for PowerLine
set confirm         " prompt to save, rather than flag an error
set shell=$SHELL
set cmdheight=1     " command bar height
set modeline        " Enable modeline to get per-file settings (i.e. # vim:syntax=bash)
set visualbell
set tm=500
set lazyredraw      " don't redraw while executing macros
set wildmode=list:longest           " complete files like a shell
set completeopt+=longest,noinsert   " noinsert forces the autocomplete to not fill the first argument
set ignorecase      " case insensitive searching
set smartcase       " case-sensitive, if expresson contains a capital letter
set showmatch       " show matching braces
set mat=2           " how many tenths of a second to blink
set cursorline      " Enable the cursorline

" Coloring
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

set background=light
colorscheme forestbones

set synmaxcol=120           " disable  syntax highlighting after 120 columns
set colorcolumn=120         " Draw a vertical line at 120 characters
syntax sync minlines=256    " start highlighting from 256 lines backwards
set re=0                " Use the newer regex engine so syntax highlighting doesn't get messed up
set t_Co=256            " Explicitly tell vim that the terminal supports 256 colors
set number              " show line numbers
set relativenumber      " show relative line numbers
set nowrap              " Don't wrap lines by default
set linebreak           " set soft wrapping
set showbreak=…         " show ellipsis at breaking
set autoindent          " automatically set indent of new line
set smartindent
set nobackup
set nowritebackup
set noswapfile
set laststatus=2        " show the satus line all the time
set updatetime=100      " wait 2 seconds before updating (this is for gitgutter and govim)
set signcolumn=yes      " Always show the sign column

" }}}

" Section Mappings {{{

" Snippets
" Insert a TODO line by typing "todo<space>"
iabbrev todo // TODO(tabboud):
iabbrev tda // TDA:

" set a map leader for more key combos
let mapleader = "\<Space>"
let g:mapleader = "\<Space>"

map <leader>v :set paste!<cr>   " toggle paste mode
map <Leader>a :%y+<CR>          " Copy the entire buffer
nmap <leader>w :w<cr>
nmap <leader>q :q<cr>
map q: :q                       " Stop the window from popping up
noremap Q <NOP>     " disable Ex mode

nmap <leader>l :set list!<cr>
nmap <leader>n :set nowrap!<cr>
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

" Yank until end of line (i.e. make 'Y' act like 'D')
nnoremap Y y$

" Center the screen after next search
nnoremap n nzzzv
nnoremap N Nzzzv

" Center the screen after moving to next function

" nnoremap ]] ]]zz
" nnoremap [[ [[zz

" edit ~/.vimrc
map <leader>ev :e! $MYVIMRC<cr>
" edit vim plugins
map <leader>evp :e! ~/.config/nvim/lua/plugins/init.lua<cr>
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

" Copy relative path of current file
noremap <silent> <F4> :let @+=expand("%")<CR>

" Open current buffer in a new tab (mimicking full screen mode)
noremap tt :tab split<CR>

" Search visually selected text by pressing "//"
vnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR>

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
    autocmd BufRead,BufNewFile .gitconfig.local setfiletype gitconfig

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

" Open all folds when opening a buffer or file
" This is required when using treesitter to enforce code folding
" since folds are closed by default
autocmd BufReadPost,FileReadPost * normal zR
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

" Visual Mode */# from Scrooloose
function! s:VSetSearch()
  let temp = @@
  norm! gvy
  let @/ = '\V' . substitute(escape(@@, '\'), '\n', '\\n', 'g')
  let @@ = temp
endfunction

vnoremap * :<c-u>call <sid>vsetsearch()<cr>//<cr><c-o>
vnoremap # :<c-u>call <sid>vsetsearch()<cr>??<cr><c-o>

" Jump to next/prev function
nnoremap ]] :call search("^func")<cr>
nnoremap [[ :call search("^func", "b")<cr>

" }}}

" Section Plugins {{{

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
" Enable auto tracking
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

" vista tagbar settings
" Executive used when opening vista sidebar without specifying it.
" See all the avaliable executives via `:echo g:vista#executives`.
let g:vista_default_executive = 'nvim_lsp'
let g:vista#renderer#enable_icon = 1

" Telescope settings
" Use custom theme with no preview
nmap <silent> <leader><Enter> :Telescope buffers theme=dropdown previewer=false<cr>
nmap <silent> <leader>p :Telescope find_files theme=dropdown previewer=false<cr>
" Use ivy for the above settings
" nmap <silent> <leader><Enter> <cmd>lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown({previewer = false }))<cr>
" nmap <silent> <leader>p <cmd>lua require('telescope.builtin').find_files(require('telescope.themes').get_ivy())<cr>

" LSP commands - These supercede the ones defined in lspconfig.lua
nmap <silent> g0 :Telescope lsp_document_symbols<cr>
" Find all implementations
nmap <leader>gi :Telescope lsp_implementations theme=dropdown<cr>
" Find all implementations excluding test/mock files
nmap gi <cmd>lua require('telescope.builtin').lsp_implementations({file_ignore_patterns = { "%_test.go", "%_mocks.go" }, theme=dropdown })<cr>
" nmap gi <cmd>lua require('telescope.builtin').lsp_implementations(require('telescope.themes').get_ivy({file_ignore_patterns = { "%_test.go", "%_mocks.go" }}))<cr>

" Find all references
nmap <leader>gr <cmd>lua require('telescope.builtin').lsp_references()<cr>
" Find all references excluding test files
nmap gr <cmd>lua require('telescope.builtin').lsp_references({file_ignore_patterns = { "%_test.go", "%_mocks.go" }, theme=dropdown })<cr>

" Example showing how to use the ivy theme (or any theme).
" the 'get_xxx' functions return a map that can be used to set the picker options as well
" nmap gr <cmd>lua require('telescope.builtin').lsp_references(require('telescope.themes').get_ivy({file_ignore_patterns = { "%_test.go", "%_mocks.go" }, include_declaration = false, previewer = false }))<cr>


" }}}

" Section Neovim {{{
" switch cursor to line when in insert mode, and block when not
set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
  \,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
  \,sm:block-blinkwait175-blinkoff150-blinkon175

" Enable go-imports when using the NVIM LSP
let g:goimports = 1

" Configure and use Neovim lua plugins/settings
" See the cooresponding files in $HOME/.config/nvim/lua
lua << EOF
    require("plugins/cmp")
    require("plugins/lspconfig")
    require("plugins/nvim-treesitter")
    require("plugins/telescope")
    require("plugins/lualine")
    require("plugins/symbols-outline")
    require("plugins/gitsigns")
    require("plugins/bufferline")

    -- Go specific functions
    require("go/alternate")
EOF

" Go specific commands
command! -nargs=0 GoAlt call v:lua.Switch()

" Quickly jump to alternate Go file
map <leader>t <cmd>GoAlt<cr>

" Easily close nvim terminal with esc
tnoremap <Esc> <C-\><C-n>

" }}}

" vim:foldmethod=marker:foldlevel=1

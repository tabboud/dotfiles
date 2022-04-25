local vim = vim
local g = vim.g
local set = vim.opt
local cmd = vim.cmd

-- set leader to space
g.mapleader = " "

opt.textwidth = 120

set.tabstop = 4
set.softtabstop=4
set.shiftwidth=4
set.expandtab=true


opt.termguicolors=true
opt.mouse = 'c' -- turn off mouse
opt.clipboard='unnamedplus' -- always default to system clipboard
opt.autoread=true -- autoread files when they change
opt.number = true -- line numbers
opt.wrap = false -- turn off word wrap
opt.background='dark' -- highlight Normal ctermbg=None
opt.autoindent=true -- turn on autoindent
opt.timeout=true -- turn on timeout
opt.timeoutlen=1000 -- set timeout to 1000
opt.smarttab=true -- turn on smarttab
opt.incsearch=true -- turn on incremental search
opt.inccommand='nosplit'-- turn on incremental substitution
opt.laststatus=2 -- always turn on status bar
opt.ruler=true -- show ruler on page
opt.relativenumber=true -- set relative line numbers
opt.display=(opt.display + 'lastline') -- include as much as possible of the line on the screen
opt.autoread=true -- automatically detect changes to files
opt.sessionoptions=(opt.sessionoptions - 'options')
opt.viewoptions=(opt.viewoptions - 'option')

opt.foldmethod='expr'
opt.foldexpr='nvim_treesitter#foldexpr()'

opt.list = true
opt.listchars:append("eol:↴")

-- tabs to 4 spaces

-- set bash like file autocompletion
opt.wildmode='longest,list,full'
opt.wildmenu=true

cmd('filetype plugin indent on')

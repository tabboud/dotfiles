" Vundle Plugins
set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let vundle manage vundle
Plugin 'gmarik/Vundle.vim'

" utilities
Plugin 'kien/ctrlp.vim'
Plugin 'scrooloose/nerdtree'
"Plugin 'mileszs/ack.vim'
Plugin 'bling/vim-airline'
Plugin 'scrooloose/syntastic'
Plugin 'ervandew/supertab'
"Plugin 'groenewege/vim-less'
"Plugin 'klen/python-mode'
"Plugin 'fatih/vim-go'
"Plugin 'tclem/vim-arduino'
Plugin 'tpope/vim-fugitive'     " Git for vim
Plugin 'tpope/vim-commentary'   " Toggle comments like sublime
Plugin 'tpope/vim-surround'     " Quickly change surrounding quotations
Plugin 'airblade/vim-gitgutter' " Git gitter
Plugin 'ryanoasis/vim-devicons' " Icons
Plugin 'majutsushi/tagbar.git'
Plugin 'mhinz/vim-startify'
Plugin 'chriskempson/tomorrow-theme', { 'rtp': 'vim/' }

call vundle#end()
filetype plugin indent on

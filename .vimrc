" Common
set nocompatible
syntax enable
filetype plugin indent on

" Mouse
set mouse=a

" Indent
set autoindent
set smartindent
set expandtab
set softtabstop=4
set shiftwidth=4

" Line numbers
set number
set relativenumber

" Search
set path+=**
set hlsearch

" Display all matching files when we tab complete
set wildmenu

" Ctags generation
command! MakeTags !ctags -R .


" Common
set nocompatible
syntax enable
filetype plugin on

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

" Path for deep search
set path+=**

" Display all matching files when we tab complete
set wildmenu

" Ctags generation
command! MakeTags !ctags -R .


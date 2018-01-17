" Common
set nocompatible
syntax enable
filetype plugin indent on
set autowrite

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

" Set a new leader key
let mapleader=","

" Shortcuts
map <C-n> :cnext<CR>
map <C-m> :cprevious<CR>
map <leader>nn :NERDTreeToggle<CR>
nnoremap <leader>a :cclose<CR>
autocmd FileType go nmap <leader>b  <Plug>(go-build)
autocmd FileType go nmap <leader>r  <Plug>(go-run)

" Golang settings
let g:go_fmt_command="goimports"


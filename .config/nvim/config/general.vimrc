" Set this. Airline will handle the rest.
"let g:airline#extensions#ale#enabled = 1

set nocompatible            " disable compatibility to old-time vi
set showmatch               " show matching brackets.
"set ignorecase              " case insensitive matching
set mouse=v                 " middle-click paste with mouse
set hlsearch                " highlight search results
set tabstop=2 
set softtabstop=0 
set expandtab 
set shiftwidth=2 
set smarttab
set autoindent              " indent a new line the same amount as the line just typed
set number                  " add line numbers
set wildmode=longest,list   " get bash-like tab completions
filetype plugin indent on   " allows auto-indenting depending on file type
syntax on                   " syntax highlighting

set encoding=utf-8
set fileencoding=utf-8

set background=dark
set termguicolors
let g:quantum_italics=1

autocmd FileType json syntax match Comment +\/\/.\+$+
"autocmd vimenter * NERDTree

"dikiaap/minimalist colorscheme
set t_Co=256
syntax on
colorscheme minimalist

set list
set listchars=tab:>-

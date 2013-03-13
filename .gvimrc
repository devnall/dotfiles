" .gvimrc file
"
" Maintainer: Drew Nall <devnall@gmail.com>
" Last change: 2013 March 10

" Set some helpful variables
set nocompatible    " Use vim functionality
set encoding=utf-8	" Use UTF-8 everywhere
set history=256     " Number of items to remember in history
set autoread        " If file is changed outside of vim (and hasn't been modified in vim), automatically pull in changes
set timeoutlen=250	" Time to wait after ESC (default causes and annoying delay)
set clipboard+=unnamed	" Yanks go to OS clipboard
set pastetoggle=<F10>	" Toggle between paste and normal: for 'safer' pasting from keyboard
set tags=./tags;$HOME	" Walk directory tree up to $HOME looking for tags

set modeline

" Backup
set nowritebackup
set nobackup
set directory=$HOME/.gvim/tmp//,. " Keep swap files in one place

" Buffers
set hidden " The current buffer can be put to the background without writing to disk

" Match and search
set hlsearch		" Highlight search results
set ignorecase		" Case insensitive searching...
set smartcase		" But case sensitive if there's 1+ capital letter
set incsearch		" Do incremental searching

" Make it pretty by defining color scheme and other visual niceties
set background=dark	" Set background light/dark
colorscheme solarized	" Set color scheme 
set guifont=Menlo:h13	" Font family and size
set number		" Line numbers
set antialias		" MacVim smooth fonts
set guioptions-=T	" Turn off MacVim toolbars
set guioptions-=L
set guioptions-=r

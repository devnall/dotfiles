" vimrc file
"

set nocompatible " be iMproved, required
filetype off

" Set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" Alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" Brief Vundle help
" :PluginList         - lists configured plugins
" :PluginInstall      - installs plugins
" :PluginUpdate       - update installed plugins
" :PluginSearch foo   - searches for foo; append `!` to refresh local cache
" :PluginClean        - confirms removal of unused plugins; append `!` to auto-approve
"
" See `:h vundle` for more details or wiki for FAQ

" Bundles go here:
" See the Vundle readme for different supported plugin formats
" Keep plugin calls between vundle#begin and vundle#end

" Let Vundle manage Vundle. Required!
Plugin 'gmarik/Vundle.vim'

" Github repo bundles
Plugin 'altercation/vim-colors-solarized'
Plugin 'mhartington/oceanic-next'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'scrooloose/syntastic'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/nerdcommenter'
Plugin 'Raimondi/delimitMate'
Plugin 'plasticboy/vim-markdown'
Plugin 'tpope/vim-git'
Plugin 'tpope/vim-repeat'
Plugin 'rizzatti/dash.vim'
Plugin 'mileszs/ack.vim'
"Plugin 'kien/ctrlp.vim'
Plugin 'ekalinin/Dockerfile.vim'
"Plugin 'hashivim/vim-terraform'
Plugin 'tmux-plugins/vim-tmux'
Plugin 'Markdown'
Plugin 'git.zip'
Plugin 'groovy.vim'
Plugin 'junegunn/fzf.vim'
Plugin 'vim-ruby/vim-ruby'

" Stuff to try out
"Plugin 'tpope/vim-fugitive'
"Plugin 'airblade/vim-gitgutter'
"Plugin 'godlygeek/tabular'
"Plugin 'tpope/vim-surround'
"Plugin 'tpope/vim-speeddating'
"Plugin 'ervandew/supertab'
"Plugin 'vim-scripts/YankRing.vim'
"Plugin 'vim-quickrun'
"Plugin 'gist-vim'
"Plugin 'townk/vim-autoclose'
"Plugin 'lokaltog/vim-easymotion'
"Plugin 'jmcantrell/vim-virtualenv'

" non-github repos
" Bundle "ZoomWin"
" noremap MLocalLeader o :ZoomWin<CR>
" vnoremap <LocalLeader>o <C-C>:ZoomWin<CR>
" inoremap <LocalLeader>o <C-O>:ZoomWin<CR>
" noremap <C-W>+o :ZoomWin<CR>
"
" Bundle "tComment"
" nnoremap // :TComment<CR>
" vnoremap // :TComment<CR>
"
"let g:CommandTMatchWindowAtTop=1   " Show window at top

" Plugins no longer used but may need in future
"Plugin 'rizzatti/dash.vim'
"Plugin 'puppetlabs/puppet-syntax-vim'
"Plugin 'ajf/puppet-vim'
"Plugin 'dougireton/vim-chef'

" All Plugins must be added before the following line
call vundle#end()

filetype plugin indent on
" To ignore plugin indent change, instead use:
"filetype plugin on

" Add fzf to runtime path
set rtp+=~/homebrew/opt/fzf

" Formatting
set fo+=o		" Insert current comment leader after hitting 'o' or 'O' in Normal mode
set fo-=r		" Do not automatically insert a comment leader after an enter
set fo-=t		" Do not auto-wrap text using textwidth (doesn't apply to comments)

set nowrap		    " Don't wrap lines
set textwidth=0		" Don't wrap lines by default
set wildmode=longest,list	" At the CLI, complete longest common string, then list alternatives
set backspace=indent,eol,start	" Allow backspacing over everything in insert mode
set tabstop=2		  " Set the defaul tabstop
set softtabstop=2
set shiftwidth=2	" Set the default shift width for indents
set expandtab		  " Make tabs into spaces (set by tabstop)
set smarttab		  " Smarter tab levels
set autoindent
set cindent
set cinoptions=:s,ps,ts,cs
set cinwords=if,else,while,do,for,switch,case
set hlsearch
set autoread
set timeoutlen=250

syntax enable		  " Enable syntax highlighting

set nobackup      " don't backup files
set nowritebackup " don't write backup files either
set noswapfile    " don't create swap files

" Visual
set number		    " Turn on line numbers
set showmatch		  " Show matching brackets
set matchtime=5		" Bracket blinking
set visualbell		" Turn on visual bell
set noerrorbells	" No noise
set laststatus=2	" Always show status line
set ruler		      " Show the cursor position
set showcmd		    " Display incomplete commands
set shortmess=atI	" Shorten messages
set nolist		    " Display unprintable characters F12 - switches
set listchars=tab:·\ ,eol:¶,trail:·,extends:»,precedes:«	" Unprintable char mappings

" Folding
set foldenable		" Turn on folding
set foldmethod=marker	" Fold on the marker
set foldlevel=100	" Don't autofold anything (can still fold manually)
set foldopen=block,hor,mark,percent,quickfix,tag	" Define  movements which open folds

" Lots of terminal emulators handle the mouse just fine, so find out if it's
" supported and, if so, enable it. Also, hide mouse when not using it.
if has ('mouse')
	set mouse=a
	set mousehide
endif

" Splits
"
" New splits appear below/right
set splitbelow
set splitright

set title		" Set the terminal title

set clipboard=unnamed

" Command and Auto commands
"
" Auto commands
au BufRead,BufNewFile {*.md,*.mkd,*.markdown}	set ft=markdown
au BufRead,BufNewFile {COMMIT_EDITMSG}		set ft=gitcommit
au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | execute "normal g'\"" | endif		" Restore position in file

" Key mappings
map <silent> <F12> :set invlist<CR>	" Show/hide hidden characters

" Only do this part when compiled with support for autocommands
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72, 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters, wrap at whitespace.
  autocmd FileType text setlocal textwidth=78
  autocmd FileType text setlocal nolist wrap linebreak breakat&vim

  " .markdown and .md are markdown files
""  au! BufRead,BufNewFile *.markdown set filetype=mkd
""  au! BufRead,BufNewFile *.md set filetype=mkd
  autocmd FileType markdown setlocal textwidth=78
  autocmd FileType markdown setlocal nolist wrap linebreak breakat&vim

  " Open NERDTree automatically when vim starts with no file specified
  autocmd StdinReadPre * let s:std_in=1
  autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

  " Close vim automatically if NERDTree is the only window left open
  autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif


  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
	\ | wincmd p | diffthis
endif

" Key bindings
let mapleader = ","
map <F2> :NERDTreeToggle<CR>
map <C-n> :NERDTreeToggle<CR>
"map <F3> :CommandT<CR>
imap jj <Esc>	" jj instead of escape in insert mode
nnoremap <space> :nohlsearch<CR>/<BS>	      " space unhighlights search results
"autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" Allow saving of files as sudo when I forgot to start vim w/ sudo
cmap W!! w !sudo tee > /dev/null %

" Enable format on save for terraform files
let g:terraform_align=1
let g:terraform_fmt_on_save=1

" Make it pretty by defining color scheme and other visual niceties
"set background=dark
"colors ir_black
"
"set background=dark

call togglebg#map("<F5>")

" Fake 256 colors for OSX Terminal.app
if ! has("gui_running")
  set t_Co=256
  set background=dark
else
  set background=light
endif

let g:solarized_termtrans = 1
colorscheme solarized
"colorscheme OceanicNext

" vim-airline statusline config
let g:airline_left_sep=''
let g:airline_right_sep=''
let g:airline_detect_modified=1
let g:airline_detect_paste=1
let g:airline_detect_crypt=1
let g:airline_detect_iminsert=0
let g:airline_inactive_collapse=1
"let g:airline_theme='papercolor'
let g:airline_powerline_fonts=1
let g:airline#extenstions#syntastic#enabled=1
"let g:airline#extensions#whitespace#show_message = 1
let g:airline_theme='oceanicnext'
"let g:oceanic_next_terminal_bold = 1
"let g:oceanic_next_terminal_italic = 1

" Syntastic config
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_aggregate_errors = 1    "show all errors from all defined checkers

let g:syntastic_sh_checkers = ['shellcheck']
let g:syntastic_chef_checkers = ['foodcritic']
let g:syntastic_Dockerfile_checkers = ['dockerfile_lint']
let g:syntastic_JSON_checkers = ['jsonlint']
let g:syntastic_Markdown_checkers = ['mdl', 'proselint']
let g:syntastic_yaml_checkers = ['yamllint']
" End Syntastic config

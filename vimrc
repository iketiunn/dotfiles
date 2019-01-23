" Check Vundle is installed or not
filetype off
    
" Install vim-plug if not installed yet
if empty(glob("~/.vim/autoload/plug.vim")) 
    echo "Installing vim-plug.."
    echo ""
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dir https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

call plug#begin('~/.vim/plugged')

" Theme/Status bar
Plug '0w0/xoria256.vim'
Plug 'itchyny/lightline.vim'
  set laststatus=2
  set noshowmode
  let g:lightline = {
    \ 'colorscheme': 'wombat',
    \ 'active': {
    \   'left': [['mode', 'paste'], ['filename', 'modified']],
    \   'right': [['lineinfo'], ['percent'], ['readonly', 'linter_warnings', 'linter_errors', 'linter_ok']]
    \ },
    \ 'component_expand': {
    \   'linter_warnings': 'LightlineLinterWarnings',
    \   'linter_errors': 'LightlineLinterErrors',
    \   'linter_ok': 'LightlineLinterOK'
    \ },
    \ 'component_type': {
    \   'readonly': 'error',
    \   'linter_warnings': 'warning',
    \   'linter_errors': 'error'
    \ },
    \ }
" Utils
Plug 'Yggdroot/LeaderF', { 'do': './install.sh' } " Fuzzy finder
  let g:Lf_ShortcutF = '<C-P>'
  let g:Lf_CommandMap = {'<C-K>': ['<Up>'], '<C-J>': ['<Down>']}
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
  map <C-n> :NERDTreeToggle<CR>
  let g:NERDTreeNodeDelimiter = "\u00a0" " Fix ^G
  let NERDTreeShowLineNumbers=1
  let NERDTreeAutoCenter=1
  let NERDTreeShowHidden=1
  let NERDTreeIgnore=['\~$','\.swp']
Plug 'Xuyuanp/nerdtree-git-plugin'
  let g:NERDTreeIndicatorMapCustom = {
    \ "Modified"  : "✹",
    \ "Staged"    : "✚",
    \ "Untracked" : "✭",
    \ "Renamed"   : "➜",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "✖",
    \ "Dirty"     : "✗",
    \ "Clean"     : "✔︎",
    \ "Unknown"   : "?"
    \ }
" Multiple languages hightlight supports
Plug 'sheerun/vim-polyglot'
" Git support 
"Plug 'tpope/vim-fugitive'
"Plug 'airblade/vim-gitgutter'

call plug#end()

" Basic setting
colorscheme xoria256
syntax on
"set t_Co=256
set guioptions-=T " Removes top toolbar
set guioptions-=r " Removes right hand scroll bar
set go-=L " Removes left hand scroll bar
set linespace=15
set nowrap                      " don't wrap lines
" Set default tab behavior
set tabstop=2                   " a tab is four spaces
set softtabstop=2               " when hitting <BS>, pretend like a tab is removed, even if spaces
set shiftwidth=2                " number of spaces to use for autoindenting
set expandtab                   " expand tabs by default (overloadable per file type later)
set tags=tags
set shiftround                  " use multiple of shiftwidth when indenting with '<' and '>'
set backspace=indent,eol,start  " allow backspacing over everything in insert mode
set autoindent                  " always set autoindenting on
set copyindent                  " copy the previous indentation on autoindenting
set number                      " always show line numbers
set ignorecase                  " ignore case when searching
set smartcase                   " ignore case if search pattern is all lowercase,
set timeout timeoutlen=200 ttimeoutlen=100
set visualbell           " don't beep
set noerrorbells         " don't beep
set autowrite  " Save on buffer switch
set autoread   " Autorefreshing when file changed
" Currenlly cursorline cause laggy on the scroll
"set cursorline
"set signcolumn=yes
" Swap files
set backupdir=~/.vim/backup
set directory=~/.vim/swap

" Key mapping
let mapleader = ","
let g:mapleader = ","
" Fast saves
nmap <leader>w :w!<cr>
" Fast quit
nmap <leader>q :q!<cr>
" Fast page down
nmap <leader>f <C-F><cr>
" Fast page up
nmap <leader>b <C-B><cr>

" Easy escaping to normal model
imap jk <esc>
" Fast add semicolon at end of line
imap <leader>; <esc>A;<cr>

" Auto change directory to match current file
nnoremap ,cd :cd %:p:h<CR>:pwd<CR>

" Quickly go forward or backward to buffer
nmap <leader>] :bn<cr> 
nmap <leader>[ :bp<cr>

" Disable auto comment on next line
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Put these lines at the very end of your vimrc file.
" Load all plugins now.
" Plugins need to be added to runtimepath before helptags can be generated.
packloadall
" Load all of the helptags now, after plugins have been loaded.
" All messages and errors will be ignored.
silent! helptags ALL

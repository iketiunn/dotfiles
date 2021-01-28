set nocompatible
" Check Vundle is installed or not
filetype plugin on

" Install vim-plug if not installed yet
if empty(glob("~/.vim/autoload/plug.vim"))
    echo "Installing vim-plug.."
    echo ""
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dir https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif
if has('nvim')
  let s:user_dir = stdpath('config')
else
  let s:user_dir = has('win32') ? expand('~/vimfiles') : expand('~/.vim')
endif

call plug#begin('~/.vim/plugged')

" Theme/Status bar
Plug 'flazz/vim-colorschemes'
Plug 'marcopaganini/termschool-vim-theme'
Plug 'itchyny/lightline.vim'
  set laststatus=2
  set noshowmode
  Plug 'maximbaz/lightline-ale'
    let g:lightline = {}
    let g:lightline.colorscheme = 'wombat'
    let g:lightline.component_expand = {
      \  'linter_checking': 'lightline#ale#checking',
      \  'linter_warnings': 'lightline#ale#warnings',
      \  'linter_errors': 'lightline#ale#errors',
      \  'linter_ok': 'lightline#ale#ok',
      \ }
    let g:lightline.component_type = {
      \     'linter_checking': 'left',
      \     'linter_warnings': 'warning',
      \     'linter_errors': 'error',
      \     'linter_ok': 'left',
      \ }
    " Somehow it's not working, disable now
    let g:lightline.active = { 'right': [[ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_ok' ]] }
" Utils
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
  function! ToggleNERDTree()
    if g:NERDTree.IsOpen()
      NERDTreeToggle
    elseif @% == ""
      NERDTreeToggle
    else
      NERDTreeFind
    endif
  endfun
  map <C-n> :call ToggleNERDTree()<CR>
  " Setup icons
  let g:NERDTreeNodeDelimiter = "\u00a0" " Fix ^G
  let NERDTreeShowLineNumbers=1
  let NERDTreeAutoCenter=1
  let NERDTreeShowHidden=1
  let NERDTreeIgnore=['\~$','\.swp']
  let g:NERDTreeGitStatusIndicatorMapCustom = {
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
  " open a NERDTree automatically when vim starts up if no files were specified
  autocmd StdinReadPre * let s:std_in=1
  autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" Fuzz search
set rtp+=~/.vim/plugged/fzf
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
  let g:fzf_layout = { 'down': '~40%' }
  nnoremap <silent> <C-P> :Files <cr>
" Multiple languages hightlight supports
Plug 'sheerun/vim-polyglot', { 'tag': 'v4.4.3' }
  " Prisma
  Plug 'pantharshit00/vim-prisma'
  " Markdown
  Plug 'godlygeek/tabular'
  Plug 'plasticboy/vim-markdown'
    let g:vim_markdown_folding_disabled = 1
    let g:vim_markdown_new_list_item_indent = 0
    setlocal formatoptions=tqlnrc
    set comments=b:>
    " Fix Markdown indent
    setlocal indentexpr=

" Git support
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'


" TODO Which key
  " nnoremap <silent> <leader> :WhichKey "<Space>"<CR>
  "set timeoutlen=500
" Syntax checker
Plug 'w0rp/ale'
  " Setup elixir-ls with ale
  Plug 'GrzegorzKozub/vim-elixirls', { 'do': ':ElixirLsCompileSync' }
  let g:ale_elixir_elixir_ls_release = s:user_dir . '/plugins/vim-elixirls/elixir-ls/release'
  " https://github.com/JakeBecker/elixir-ls/issues/54
  let g:ale_elixir_elixir_ls_config = { 'elixirLS': { 'dialyzerEnabled': v:false } }
  let g:ale_sign_error = '✖'
  let g:ale_sign_warning = '✹'
  let g:ale_fixers = {
    \  '*': ['remove_trailing_lines', 'trim_whitespace'],
    \  'elixir': ['mix_format'],
    \  'javascript': ['prettier'],
    \  'typescript': ['prettier'],
    \  'css': ['prettier'],
    \}
  let g:ale_linters = {
    \  'elixir': ['credo', 'elixir-ls'],
    \  'javascript': [''],
    \  'typescript': [''],
    \  'dockerfile': ['dockerfile_lint'],
    \}
  let g:ale_linters_explicit = 1
  let g:ale_lint_on_save = 1
  let g:ale_fix_on_save = 1
" coc - Auto compelete
Plug 'neoclide/coc.nvim', {'branch': 'release'}
  let g:coc_global_extensions = [
    \  'coc-elixir',
    \  'coc-tslint-plugin', 'coc-tsserver',
    \  'coc-emmet', 'coc-css', 'coc-html',
    \  'coc-json', 'coc-yank', 'coc-prettier'
    \]
  " if hidden is not set, TextEdit might fail.
  set hidden
  " Some servers have issues with backup files, see #649
  set nobackup
  set nowritebackup
  " Better display for messages
  set cmdheight=2
  " You will have bad experience for diagnostic messages when it's default 4000.
  set updatetime=300
  " don't give |ins-completion-menu| messages.
  set shortmess+=c
  " Use tab for trigger completion with characters ahead and navigate.
  " Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
  inoremap <silent><expr> <TAB>
        \ pumvisible() ? "\<C-n>" :
        \ <SID>check_back_space() ? "\<TAB>" :
        \ coc#refresh()
  inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
  function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
  endfunction
  " Use <c-space> to trigger completion.
  inoremap <silent><expr> <C-SPACE> coc#refresh()
  " Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
  " Coc only does snippet and additional edit on confirm.
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
  " Or use `complete_info` if your vim support it, like:
  " inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
  " Remap keys for gotos
  nmap <silent> gd <Plug>(coc-definition)
  nmap <silent> gy <Plug>(coc-type-definition)
  nmap <silent> gi <Plug>(coc-implementation)
  nmap <silent> gr <Plug>(coc-references)
  " Go back
  nmap <silent> gb <C-O>
  " Use K to show documentation in preview window
  nnoremap <silent> K :call <SID>show_documentation()<CR>

  function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
      execute 'h '.expand('<cword>')
    else
      call CocAction('doHover')
    endif
  endfunction
  " Highlight symbol under cursor on CursorHold
  autocmd CursorHold * silent call CocActionAsync('highlight')
  " Remap for rename current word
  nmap <leader>rn <Plug>(coc-rename)
  " Remap for format selected region
  xmap <leader>f  <Plug>(coc-format-selected)
  augroup mygroup
    autocmd!
    " Setup formatexpr specified filetype(s).
    autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
    " Update signature help on jump placeholder
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
  augroup end
  " Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
  xmap <leader>a  <Plug>(coc-codeaction-selected)
  nmap <leader>a  <Plug>(coc-codeaction-selected)
  " Remap for do codeAction of current line
  nmap <leader>ac  <Plug>(coc-codeaction)
  " Fix autofix problem of current line
  nmap <leader>qf  <Plug>(coc-fix-current)
  " Create mappings for function text object, requires document symbols feature of languageserver.
  xmap if <Plug>(coc-funcobj-i)
  xmap af <Plug>(coc-funcobj-a)
  omap if <Plug>(coc-funcobj-i)
  omap af <Plug>(coc-funcobj-a)
  " Use <C-d> for select selections ranges, needs server support, like: coc-tsserver, coc-python
  nmap <silent> <C-d> <Plug>(coc-range-select)
  xmap <silent> <C-d> <Plug>(coc-range-select)
  " Use `:Format` to format current buffer
  command! -nargs=0 Format :call CocAction('format')
  " Use `:Fold` to fold current buffer
  command! -nargs=? Fold :call     CocAction('fold', <f-args>)
  " use `:OR` for organize import of current buffer
  command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')
  " Add status line support, for integration with other plugin, checkout `:h coc-status`
  set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
" End of vim-plug
call plug#end()

set showcmd
" Spell checking
  set nospell
  " Toggle spelling
  nnoremap <slient> <leader>s :set spell!<cr>
  set complete+=kspell " Turning on word completion
" Basic setting
  " Theme
  set termguicolors
  set background=dark
  colorscheme janah
  " ColorScheme change ( janah )
syntax on
set signcolumn=yes " Keep signcolumn alway on
highlight clear SignColumn " Make clear cloro on signcolumn
set guioptions-=T " Removes top toolbar
set guioptions-=r " Removes right hand scroll bar
set go-=L " Removes left hand scroll bar
set linespace=15
set nowrap                      " don't wrap lines
set tags=tags
" Set default tab behavior
  " Indent
  set tabstop=2                   " a tab is four spaces
  set softtabstop=2               " when hitting <BS>, pretend like a tab is removed, even if spaces
  set shiftwidth=2                " number of spaces to use for autoindenting
  set expandtab                   " expand tabs by default (overloadable per file type later)
  set autoindent                  " always set autoindenting on
  set smartindent
  set copyindent                  " copy the previous indentation on autoindenting
set shiftround                  " use multiple of shiftwidth when indenting with '<' and '>'
set backspace=indent,eol,start  " allow backspacing over everything in insert mode
set number                      " always show line numbers
set ignorecase                  " ignore case when searching
set smartcase                   " ignore case if search pattern is all lowercase,
set timeout timeoutlen=200 ttimeoutlen=100
set visualbell           " don't beep
set noerrorbells         " don't beep
set autowrite  " Save on buffer switch
set autoread   " Autorefreshing when file changed
set completeopt+=noinsert
" Swap files
set backupdir=~/.vim/backup
set directory=~/.vim/swap

" Key mapping
  let mapleader = ","
  let g:mapleader = ","
  nmap <leader>/ :noh<cr> " Clear highlight
  nmap <leader>w :w!<cr> " Fast saves
  nmap <leader>q :q!<cr> " Fast quit
  nmap <leader>f <C-F><cr> " Fast page down
  nmap <leader>b <C-B><cr> " Fast page up
  imap jk <esc><esc>:w<cr> " Easy escaping to normal model
  imap <leader>; <esc>A;<cr> " Fast add semicolon at end of line
  nnoremap ,cd :cd %:p:h<CR>:pwd<CR> " Auto change directory to match current file
  nmap <leader>] :bn<cr> " Quickly go forward to buffer
  nmap <leader>[ :bp<cr> " Quickly go backward to buffer
" Disable auto comment on next line
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Fix json highlight
autocmd FileType json syntax match Comment +\/\/.\+$+

" Fix osx terminal mapping issue
imap <C-@> <C-SPACE>
vmap <C-@> <C-SPACE>
cmap <C-@> <C-SPACE>

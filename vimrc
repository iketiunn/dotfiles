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

" Pre setup vars
let g:ale_disable_lsp = 1 " Disable ale lsp in favor of coc

" Theme/Status bar
Plug 'flazz/vim-colorschemes'
Plug 'sainnhe/everforest'
Plug 'Mofiqul/vscode.nvim'
Plug 'nvim-lualine/lualine.nvim'

" File explorer
Plug 'kyazdani42/nvim-tree.lua'

" Fuzz search
set rtp+=~/.vim/plugged/fzf
Plug '/usr/local/opt/fzf' " brew installed fzf
Plug 'junegunn/fzf.vim'
  let g:fzf_layout = { 'down': '~40%' }
  nnoremap <silent> <C-P> :Files <cr>
" Multiple languages hightlight supports
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" GUI
Plug 'kyazdani42/nvim-web-devicons' " you'll need font-jetbrains-mono-nerd-font or similar fonts
Plug 'akinsho/bufferline.nvim', { 'tag': 'v2.*' }

" Utils
Plug 'windwp/nvim-autopairs'
Plug 'windwp/nvim-ts-autotag'
Plug 'lewis6991/gitsigns.nvim'
Plug 'folke/trouble.nvim'
Plug 'nvim-lua/plenary.nvim' " Some plugin's deps

" Code intelligence
"" nvim-cmp Basic
 " nvim-lsp setup helper
Plug 'williamboman/mason.nvim' " lsp setup helper
Plug 'williamboman/mason-lspconfig.nvim' " lsp setup helper
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'github/copilot.vim'
"" snippet
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
Plug 'rafamadriz/friendly-snippets'
"" Utils
Plug 'glepnir/lspsaga.nvim', { 'branch': 'main' }
"" Diagnostics, code actions
Plug 'jose-elias-alvarez/null-ls.nvim'
call plug#end()

" Simple setup
lua <<EOF
  local c = require('vscode.colors')
  require('vscode').setup({
    transparent = true,
    disable_nvimtree_bg = true,
  })
  require('lualine').setup {
    options = {
      theme = 'vscode'
    }
  }
  require("nvim-autopairs").setup()
  require('nvim-ts-autotag').setup()
  require('gitsigns').setup()
  require("trouble").setup()
  require("nvim-treesitter.configs").setup({
    ensure_installed = { "typescript", "tsx", "elixir", "html", "css", "astro" },
    auto_install = true,
    highlight = { enable = true }
  })
  require('lspsaga').init_lsp_saga()
    local keymap = vim.keymap.set
    keymap("n", "gh", "<cmd>Lspsaga lsp_finder<CR>", { silent = true })  -- Find reference, use <C-t> to jump back
    keymap({"n","v"}, "g.", "<cmd>Lspsaga code_action<CR>", { silent = true }) -- Code action
    keymap("n", "gr", "<cmd>Lspsaga rename<CR>", { silent = true }) -- Rename
    keymap("n", "gd", "<cmd>Lspsaga peek_definition<CR>", { silent = true }) -- Go Definition, use <C-t> to jump back
    keymap("n", "K", "<cmd>Lspsaga hover_doc<CR>", { silent = true })

    -- For copilot
    vim.g.copilot_node_command = "/usr/local/opt/node@16/bin/node"
EOF

" nvim-tree
lua <<EOF
  -- disable netrw at the very start of your init.lua (strongly advised)
  vim.g.loaded = 1
  vim.g.loaded_netrwPlugin = 1
  local keymap = vim.keymap.set

  require("nvim-tree").setup()
  keymap("n", "<C-b>", "<cmd>NvimTreeToggle<CR>", {noremap = true, silent = true})
EOF


" bufferline
lua <<EOF
  vim.opt.termguicolors = true -- same as "set termguicolors"
  require("bufferline").setup({
    options = {
      offsets = {
        {
          filetype = "NvimTree",
          text = "File Explorer",
          highlight = "Directory",
          text_align = "left"
        }  
      }
    }
  })
EOF

" nvim-cmp Setups
set completeopt=menu,menuone,noselect
lua <<EOF
  -- Set up nvim-lsp
  require("mason").setup({
    automatic_installation = true, -- automatically detect which servers to install (based on which servers are set up via lspconfig)
    ui = {
      icons = {
        server_installed = "✓",
        server_pending = "➜",
        server_uninstalled = "✗"
      }
    }
  })
  require('mason-lspconfig').setup{
    ensure_installed = { "tsserver", "tailwindcss", "astro" }
  }
  require('lspconfig')['tsserver'].setup{
    on_attach = on_attach,
    filetypes = { "typescript", "typescriptreact", "typescript.tsx", "javascript", "javascriptreact", "javascript.jsx" },
    flags = lsp_flags,
  }
  require('lspconfig')['tailwindcss'].setup{}
  require('lspconfig')['astro'].setup{}
  require('lspconfig')['solidity'].setup{}
  
  -- Set up nvim-cmp.
  local cmp = require'cmp'
  
  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
      end,
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip'    }, -- For vsnip users.
    },
    {
      { name = 'buffer'   },
    })
  })
EOF

lua <<EOF
null_ls = require("null-ls")
null_ls.setup({
    sources = {
        --null_ls.builtins.diagnostics.vale,
        null_ls.builtins.formatting.json_tool,
        null_ls.builtins.formatting.prettierd,
    },
    on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = augroup,
                buffer = bufnr,
                callback = function()
                    -- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
                    -- before 0.8 use vim.lsp.buf.formatting_sync()
                    vim.lsp.buf.format({ bufnr = bufnr }) 
                end,
            })
        end
    end,
})
EOF


set showcmd
set complete+=kspell " Turning on word completion
" Basic setting
set number
"set relativenumber " Might laggy on low end pc
" Theme
set t_Co=256
syntax on
" sing column
set signcolumn=yes " Keep signcolumn alway on
highlight SignColumn guibg=NONE
highlight GitSignsAdd guifg=green " Changed depends on theme
highlight GitSignsChange guifg=yellow
highlight Comment  guifg=darkgray
highlight Number  guifg=darkgray
highlight LineNr guifg=#FAF9DB
highlight CursorLineNr guifg=white
set synmaxcol=120
set guioptions-=T " Removes top toolbar
set guioptions-=r " Removes right hand scroll bar
set go-=L " Removes left hand scroll bar
set linespace=15
set nowrap                      " don't wrap lines
set tags=tags
" Indent
set tabstop=2                   " a tab is 2 spaces
set softtabstop=2               " when hitting <BS>, pretend like a tab is removed, even if spaces
set shiftwidth=2                " number of spaces to use for autoindenting
set expandtab                   " expand tabs by default (overloadable per file type later)
set autoindent                  " always set autoindenting on
filetype plugin indent on
set copyindent                  " copy the previous indentation on autoindenting

set shiftround                  " use multiple of shiftwidth when indenting with '<' and '>'
set backspace=indent,eol,start  " allow backspacing over everything in insert mode
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
nmap <leader>d <C-d><cr> " Fast page down
nmap <leader>u <C-u><cr> " Fast page up
nmap <leader>b <C-b><cr> " File Explorer
imap jk <esc><esc>:w<cr> " Easy escaping to normal model
imap <leader>; <esc>A;<cr> " Fast add semicolon at end of line
nnoremap ,cd :cd %:p:h<CR>:pwd<CR> " Auto change directory to match current file
nmap <leader>] :bn<cr> " Quickly go forward to buffer
nmap <leader>[ :bp<cr> " Quickly go backward to buffer
" Disable auto comment on next line
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
" Fix json highlight
autocmd FileType json syntax match Comment +\/\/.\+$+
autocmd BufRead,BufEnter *.astro set filetype=astro " Fix astro highlight

" trouble.nvim
nnoremap <leader>, <cmd>TroubleToggle<cr>

" Fix osx terminal mapping issue
imap <C-@> <C-SPACE>
vmap <C-@> <C-SPACE>
cmap <C-@> <C-SPACE>
" Origin C-c didn't 100% equal to Esc
imap <C-c> <Esc>


set nocompatible

" Automagically install `vim-plug` if it does not exist
if empty(glob('~/.vim/autoload/plug.vim'))
	silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
				\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
  Plug 'dracula/vim', { 'as': 'dracula' }
	Plug 'tomtom/tcomment_vim'
  Plug 'mxw/vim-jsx'
  Plug 'pangloss/vim-javascript'
  Plug 'elzr/vim-json'
	Plug 'tpope/vim-fugitive'
	Plug 'tpope/vim-surround'
	Plug 'tpope/vim-repeat'
	Plug 'ntpeters/vim-better-whitespace'
	Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
	Plug 'preservim/nerdtree'
  Plug 'neoclide/coc.nvim', { 'branch': 'release' }
	Plug 'junegunn/fzf', { 'do': './install --bin' }
	Plug 'junegunn/fzf.vim'
	Plug 'mhinz/vim-grepper'
	" linter
	Plug 'dense-analysis/ale'
	" typescript plugins
	Plug 'Quramy/tsuquyomi'
	Plug 'HerringtonDarkholme/yats.vim'
	Plug 'leafgarland/typescript-vim'
	if has('nvim')
		Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
	endif
call plug#end()

colorscheme dracula
filetype plugin indent on
syntax on

" Hybrid - relative lines with the current line number instead of 0
" turn hybrid line numbers on
set number relativenumber
set nu rnu
set ruler
set smarttab
set ignorecase smartcase
set autoindent
set backspace=indent,eol,start
set incsearch
set hlsearch
" Display real tabs as 2 spaces
set tabstop=2
set shiftwidth=2
" Fold based on indent
set foldmethod=indent
set foldnestmax=10
set nofoldenable
set foldlevel=2

" Whitespace settings
let g:better_whitespace_enabled=1
let g:strip_whitespace_on_save=1
let g:strip_whitespace_confirm=0
let g:show_spaces_that_precede_tabs=1

" ale linter settings
let b:ale_linters = {'javascript': ['eslint']}
" Lint only on enter and save
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0

" use ripgrep
set grepprg=rg

" tried using this for syntax highlighting for ts and it may or may not work
set re=0

" Use tabs for json files too
" au FileType json setl sw=2 sts=2 et
" Use 2 spaces for terraform files
au FileType tf setl sw=2 sts=2 et

" Start NERDTree when Vim is started without file arguments.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif

" Don't syntax highlight for super long columns
set synmaxcol=250

" tcomment
runtime bundles/tplugin_vim/macros/tplugin.vim

" prettier
let g:prettier#exec_cmd_path = "~/dev/zeus/node_modules/prettier/bin-prettier.js"

" keybinds
let mapleader = ','

" use semicolon instead of colon
nnoremap ; :
" use kj as esc in insert mode, you'll have to wait after inserting k if you want to type j
" afterwards
inoremap kj <Esc>

" remap j and k to go up and down visual lines as opposed to physical lines in
" the code. gj and gk will now do what j and k used to do
nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k

" map easier swapping between split panes
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

nnoremap <C-n> :NERDTreeToggle %<CR>
" Use ctrl + p to use `fzf`. `GFiles` excludes anything in
" `.gitignore`
nnoremap <C-P> :GFiles<cr>

" create tab shortcut
nnoremap <C-T> :tabnew<cr>

"coc mappings
nmap <leader>gd <Plug>(coc-definition)
nmap <leader>gv :vsp<Plug>(coc-definition)
nmap <leader>gr <Plug>(coc-references)

" use <tab> for trigger completion and navigate to the next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()
inoremap <silent><expr> <S-Tab>
      \ pumvisible() ? "\<C-p>" :
      \ <SID>check_back_space() ? "\<S-Tab>" :
      \ coc#refresh()

" remap close window and split pane so we use , instead of <C-W>
nnoremap <leader>c <C-W>c
nnoremap <leader>v <C-W>v

" prettier keybinds
nmap <leader>py <Plug>(Prettier)
nmap <leader>pp <Plug>(PrettierPartial)
nmap <leader>pf <Plug>(PrettierFragment)

" vim-grepper
let g:grepper={}
let g:grepper.tools=["rg"]

xmap gr <plug>(GrepperOperator)

" After searching for text, press this mapping to do a project wide find and
" replace. It's similar to <leader>r except this one applies to all matches
" across all files instead of just the current file.
nnoremap <leader>R
  \ :let @s='\<'.expand('<cword>').'\>'<CR>
  \ :Grepper -cword -noprompt<CR>
  \ :cfdo %s/<C-r>s// \| update
  \<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>


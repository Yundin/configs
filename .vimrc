set nocompatible

set encoding=utf-8

syntax enable
set showmatch " Show matching braces

set autoindent 
set smartindent 
set number
set relativenumber

set mouse=n

" Filename on bottom
set laststatus=2

" xml support
runtime macros/matchit.vim
filetype plugin indent on
set runtimepath^=~/.vim/ftplugin/

" Tabs to spaces
set tabstop=4 shiftwidth=4 expandtab

" Completion in command-mode
set wildmenu
set wildmode=list:longest

" Autoclose ( and {
inoremap (( ()<Esc>i
inoremap () ()
inoremap {{ {  }<Esc>hi
inoremap {<CR> {<CR>}<Esc>O<Tab>

" Disable arrows
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>
vnoremap <Down> <Nop>
vnoremap <Left> <Nop>
vnoremap <Right> <Nop>
vnoremap <Up> <Nop>

" Search improvements
set ignorecase
set smartcase
set incsearch

" Highlight current line
set cursorline

" Sane splits
set splitright
set splitbelow

" Permanent undo
set undodir=~/.vimdid
set undofile

" <C-j> to escape
" nnoremap <C-j> <Esc>
" inoremap <C-j> <Esc>
" vnoremap <C-j> <Esc>
" snoremap <C-j> <Esc>
" xnoremap <C-j> <Esc>
" cnoremap <C-j> <Esc>
" onoremap <C-j> <Esc>
" lnoremap <C-j> <Esc>
" tnoremap <C-j> <Esc>

" Move by displaying line
nnoremap j gj
nnoremap k gk

" Scheme
let g:molokai_original = 1
let g:rehash256 = 1
colorscheme molokai

" CtrlP
nnoremap <C-e> :CtrlPMRU<CR>
nnoremap <C-h> :CtrlPTag<cr>

" Bottom bar
set noshowmode
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'component_function': {
      \   'mode': 'LightlineMode',
      \ },
      \ 'active' : {
		    \ 'right': [ [ 'lineinfo' ],
		    \            [ 'percent' ],
		    \            [ 'fileencoding', 'filetype' ] ]
      \ },
      \ }
function! LightlineMode()
    return g:ctrlp_lines == [] ? lightline#mode() : 'CtrlP'
endfunction

" Search tags in parent dirs
set tags=tags;/

" Leader
let mapleader = ","

" JavaDoc
let g:javadoc_path = "/Users/vladislavyundin/Documents/Java/docs/api"

" Wordmotion
let g:wordmotion_prefix = '<Leader>'

" LaTex auto compile
autocmd BufWritePost *.tex :!xelatex -interaction=nonstopmode %

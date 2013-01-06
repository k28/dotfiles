" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

set tabstop=4
set shiftwidth=4
set backupdir=/tmp

set laststatus=2
set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8P

set number
set wildmenu wildmode=list:full

set tags+=.tags;

" search
set ignorecase
set smartcase
set hlsearch
nmap <Esc><Esc> :nohlsearch<CR><Esc>

" search visual mode words
vnoremap <silent> * "vy/\V<C-r>=substitute(escape(@v,'\/'),"\n",'\\n','g')<CR><CR>

" yunk replace word
nnoremap <silent> ciy ciw<C-r>0<ESC>
nnoremap <silent> cy   ce<C-r>0<ESC>
vnoremap <silent> cy   c<C-r>0<ESC>

" command line emacs key maps
:cnoremap <C-a> <Home>
:cnoremap <C-e> <End>
:cnoremap <C-f> <Right>
:cnoremap <C-b> <Left>
:cnoremap <C-w> <S-Right>
":cnoremap <C-b> <S-Left>
:cnoremap <C-d> <Del>

" visual mode
" <, > indent
vnoremap < <bv
vnoremap > >bv
" yank 1line without new line.
vnoremap v $h

" for Dumbbuf plugin
let g:dumbbuf_hotkey=';;'

" allow backspacing over everything in insert mode
set backspace=indent,eol,start
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif
else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" file types
au BufRead,BufNewFile *.mm	set filetype=objc

" Vundle Settings -------------
filetype off
set rtp+=~/.vim/bundle/vundle
call vundle#rc()

" Vundle managed plugins
Bundle 'gmarik/vundle'
Bundle 'Shougo/unite.vim'
Bundle 'thinca/vim-quickrun'
Bundle 'msanders/snipmate.vim'
Bundle 'mileszs/ack.vim'
Bundle 'tyru/DumbBuf.vim'
Bundle 'vim-scripts/sh.vim'
Bundle 'tpope/vim-surround'
Bundle 'a.vim'
Bundle 'cocoa.vim'
" github Bundle 'name/foo.vim'
" www.vim.org Bundle 'bar.vim'

filetype plugin indent on
" ----- Vundle Settings End -----

" syntax highlite
syntax on

" a.vim addition
let g:alternateExtensions_h = "c,cpp,cxx,cc,CC,m,mm"
let g:alternateExtensions_m = "h"
let g:alternateExtensions_mm = "h,hpp"

" vim-quickrun option
let g:quickrun_config={'*': {'split': ''}}
set splitbelow
set splitright

" load plugins
if filereadable(expand('$VIMRUNTIME/macros/matchit.vim'))
	source $VIMRUNTIME/macros/matchit.vim
	:let b:match_words = "if:endif"
endif

if filereadable(expand('~/.vimrc.local'))
	source ~/.vimrc.local
endif

" TOhtml options
let html_no_pre = 1
let html_use_css = 1
let html_number_lines = 0
command! -nargs=0 Ehtml call <SID>Ehtml()
function! s:Ehtml()
	let a:myscheme = g:colors_name
	colorscheme default
	TOhtml
	execute "colorscheme " . a:myscheme
endfunction "Ehtml()


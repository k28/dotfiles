if has ('gui_macvim')
	set antialias
	set lines=90 columns=130
	set guioptions-=T "disable GUI Toolbar
	set showtabline=2
	set guifont=Monaco:h13
	set background=light
	colorscheme desert
    set textwidth=0
    set imdisable
    set noimdisableactivate
endif

if has("win32") || has("win64")
    set guioptions+=a
endif
" if gvimrc, do not use ctrlp caching
let g:ctrlp_use_caching = 0

nnoremap <Up> <C-w>+
nnoremap <Down> <C-w>-
nnoremap <Left> <C-w><
nnoremap <Right> <C-w>>
" MacVimでテキスト変換がおかしいのでこれを記述しておく
inoremap <Left> <Left>
inoremap <Right> <Right>
inoremap <Up> <Up>
inoremap <Down> <Down>

if has("win32") || has("win64")
    set guioptions+=a
else
    inoremap ¥ \
    inoremap \ ¥
    nnoremap ¥ \
    nnoremap \ ¥
    vnoremap ¥ \
    vnoremap \ ¥
    cnoremap ¥ \
    cnoremap \ ¥
endif

nnoremap <silent> <Leader>g :OverCommandLine<CR>%s/¥<<C-r><C-w>¥>//g<Left><Left>

if filereadable(expand('~/.gvimrc.local'))
	source ~/.gvimrc.local
endif


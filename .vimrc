" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.

set nocompatible

" <C-u> this delete all command mode input. eg.) :hogehoge<C-u> -> :

set encoding=utf-8
set fileencodings=utf-8,ucs-bom,iso-2022-jp-3,iso-2022-jp,eucjp-ms,euc-jisx0213,euc-jp,sjis,cp932,utf-8

set tabstop=4
set shiftwidth=4
set textwidth=0
set expandtab
set foldmethod=marker

if has("win32") || has("win64")
	set nobackup
else
	let s:bkdir=join([$HOME,'/.vim_backup'], "")
	if !isdirectory(s:bkdir)
		call mkdir(s:bkdir, "p")
	endif

	let &backupdir=s:bkdir
    " Create swap file at tmp directory,
    let s:swap_tmp_dir = join([$HOME, '/.vim_swap'], "")
    if !isdirectory(s:swap_tmp_dir)
        call mkdir(s:swap_tmp_dir, "p")
    endif
    "set directory=expand(s:swap_tmp_dir),~/tmp//,/var/tmp//,/tmp//,.
    execute ":set directory=" . s:swap_tmp_dir . "//,~/tmp,/var/tmp,/tmp//,."
endif

" do not create *.un~
set noundofile

set laststatus=2
if has("win32") || has("win64")
    let &statusline = '%<%f %m%r%h%w[%{(&fenc!=""?&fenc:&enc)}][%{&ff}]%y%=%l,%c%V%10P'
else
    let &statusline = '%<%f %m%r%h%w[%{(&fenc!=""?&fenc:&enc)}][%{&ff}]%y%{cfi#format("[%s]", "[no function]")}%=%l,%c%V%10P%{strftime("[%H:%M]")}'
endif
" 関数名を取ってくる処理が関数の外の場合に遅いのでやめる
let &statusline = '%<%f %m%r%h%w[%{(&fenc!=""?&fenc:&enc)}][%{&ff}]%y%=%l,%c%V%10P%{strftime("[%H:%M]")}'

set number
set wildmenu wildmode=list:full

" When a tag file name starts with './', the '.' is replaced with the path of the current file.
" And keep going one directory up all the way to the root folder.
set tags=./.tags;

" Auto reload settings
set autoread
augroup vimrc-checktime
	autocmd!
	autocmd VimEnter,WinEnter,TabEnter,Syntax * checktime
augroup END

" formatoptions
augroup vimrc-formatoptions
	autocmd!
	"autocmd FileType * setlocal formatoptions-=ro
augroup END

" color scheme
colorscheme desert

" Show ZENKAKU
scriptencoding utf-8

augroup highlightIdegraphicSpace
	autocmd!
	autocmd Colorscheme * highlight IdeographicSpace cterm=underline ctermfg=red gui=underline guifg=red
	autocmd VimEnter,WinEnter,Syntax * match IdeographicSpace /　/
augroup END

" register / marks
"nnoremap <Space>m :<C-u>marks<CR>
nnoremap <Space>r :<C-u>registers<CR>
nnoremap <Space>m :<C-u>SearchCurrentWordCaller<CR>

" search
set ignorecase
set smartcase
set hlsearch
cnoremap <expr> /
			\getcmdtype() == '/' ? '\/' : '/'
cnoremap <expr> ?
			\getcmdtype() == '/' ? '\?' : '?'

" nohlsearch, close preview window.
nnoremap <ESC><ESC> :nohlsearch<CR><C-w><C-z><ESC>

" search visual mode words
vnoremap <silent> * "vy/\V<C-r>=substitute(escape(@v,'\/'),"\n",'\\n','g')<CR><CR>
nnoremap <Space>f :SearchCurrentWord<CR>

" close quickfix
nnoremap <Space>c :<C-u>ccl<CR>

" change :grep to ack
if executable('ack')
	set grepprg=ack\ -H\ --nocolor\ --nogroup\ --nocolumn
	nnoremap <Space>g :<C-u>grep<Space>''<Left>
	nnoremap <Space>i :<C-u>grep<Space>-i<Space>''<Left>
else
	nnoremap <Space>g :<C-u>grep<Space>-Ir<Space>''<Space>*<Left><Left><Left>
	nnoremap <Space>i :<C-u>grep<Space>-iIr<Space>''<Space>*<Left><Left><Left>
endif

" use tags-and-searched easy
"nnoremap t <Nop>
"nnoremap tt <C-]>
"nnoremap tj :<C-u>tag<CR>
"nnoremap tk :<C-u>pop<CR>
"nnoremap tl :<C-u>tags<CR>

" seal arrow
if !has('gui_macvim')
nnoremap <Up> <C-w>+
nnoremap <Down> <C-w>-
nnoremap <Left> <C-w><
nnoremap <Right> <C-w>>

inoremap <Up> <NOP>
inoremap <Down> <NOP>
inoremap <Left> <NOP>
inoremap <Right> <NOP>
inoremap <C-b> <Esc><Esc>bi
else
" Leaderを "¥" に変更する
let mapleader = "¥"
endif

" yunk replace word
nnoremap <silent> ciy ciw<C-r>0<ESC>
nnoremap <silent> cy   ce<C-r>0<ESC>
vnoremap <silent> cy   c<C-r>0<ESC>

" exchange ; and :
nnoremap ; :
nnoremap : ;
vnoremap ; :
vnoremap : ;

" help
nnoremap <C-h> :<C-u>help<Space>
set helplang=en

" crags
nnoremap <C-]> g<C-]>

" command line emacs key maps
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-f> <Right>
cnoremap <C-b> <Left>
cnoremap <C-k> <Up>

" visual mode
" <, > indent
vnoremap < <gv
vnoremap > >gv

" insert mode
inoremap <silent> <C-a> <ESC>I
inoremap <silent> <C-e> <ESC>$a
inoremap <silent> <C-f> <ESC>la
inoremap <silent> <C-j> <ESC>/([^()]*)<CR>v%g<C-h>
inoremap {} {}<Left>
inoremap [] []<Left>
" inoremap () ()<Left> "使いづらいのでこれは無効にする
inoremap "" ""<Left>
" inoremap <> <><Left> "使いづらいので無効にする
"inoremap <C-c> /*  */<Left><Left><Left>


" yank 1line without new line.
vnoremap v $h

" allow backspacing over everything in insert mode
set backspace=indent,eol,start
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

"Cursor line
set cursorline

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

"set autoindent		" always set autoindenting on

endif " has("autocmd")

" Do not show the new window when omunicompletion.
" set completeopt-=preview

" show QuickFix automatically
au QuickfixCmdPost make,grep,grepadd,vimgrep,helpgrep copen
au QuickfixCmdPost l* lopen

" file types
au BufRead,BufNewFile *.mm	set filetype=objc
au BufRead,BufNewFile *.md set filetype=markdown

" Edit in Hex mode when the Binary modee
augroup BinaryXXD
    autocmd!
    autocmd BufReadPre *.bin let &binary = 1
    autocmd BufReadPost * if &binary | silent %!xxd -g 1
    autocmd BufReadPost * set ft=xxd | endif
    autocmd BufWritePre * if &binary | %!xxd -r
    autocmd BufWritePre * endif
    autocmd BufWritePost * if &binary | silent %!xxd -g 1
    autocmd BufWritePost * set nomod | endif
augroup END

" reload this file
command! ReloadVimrc source $MYVIMRC

" netrw.vim
" always tree style
let g:netrw_liststyle = 3
" do not show .files
"let g:netrw_list_hide = '\(^\|\s\s\)\zs\.\S\+'
" Set vertical window size to 75%
let g:netrw_size=75


" NeoBunle Settings -------------
"filetype off
"if has("win32") || has("win64")
"	set rtp+=~/.vim/bundle/vundle/
"	call vundle#rc('~/vimfiles/bundle')
"else
"	set rtp+=~/.vim/bundle/vundle
"	call vundle#rc()
"endif

if has('vim_starting')
    set nocompatible               " Be iMproved
    set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#begin(expand('~/.vim/bundle/'))

NeoBundleFetch 'Shougo/neobundle.vim'

" Vundle managed plugins
NeoBundle 'gmarik/vundle'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/unite-outline'
NeoBundle 'Shougo/vimproc', {
      \ 'build' : {
      \     'windows' : 'make -f make_mingw32.mak',
      \     'cygwin' : 'make -f make_cygwin.mak',
      \     'mac' : 'make -f make_mac.mak',
      \     'unix' : 'make -f make_unix.mak',
      \    },
      \ }
NeoBundle 'Shougo/vimfiler.vim'
NeoBundle 'Shougo/neomru.vim'
NeoBundle 'Shougo/vimshell.vim'
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'msanders/snipmate.vim'
NeoBundle 'mileszs/ack.vim'
NeoBundle 'tyru/DumbBuf.vim'
NeoBundle 'vim-scripts/sh.vim'
NeoBundle 'tpope/vim-surround'
NeoBundle 'thinca/vim-qfreplace'
NeoBundle 'kien/ctrlp.vim'
NeoBundle 'a.vim'
NeoBundle 'cocoa.vim'
NeoBundle 'taglist.vim'
NeoBundle 'sudo.vim'
NeoBundle 'EnhCommentify.vim'
NeoBundle 'vim-scripts/camelcasemotion'
if executable('lua')
NeoBundle 'Shougo/neocomplete.git'
else
NeoBundle 'Shougo/neocomplcache.git'
endif
NeoBundle 'tanabe/ToggleCase-vim'
NeoBundle 'osyo-manga/vim-over'
if has("unix")
	let s:uname = system("uname")
	if s:uname == "Darwin\n"
        NeoBundle 'Rip-Rip/clang_complete.git'
        "NeoBundle 'tokorom/clang_complete-getopts-ios.git'
		NeoBundle 'SirVer/ultisnips'
		"NeoBundle 'Shougo/neosnippet.vim'
		NeoBundle 'thinca/vim-fontzoom'
		NeoBundle 'vim-jp/vimdoc-ja'
		"NeoBundle 'Keithbsmiley/swift.vim'
		NeoBundle 'toyamarinyon/vim-swift'
        NeoBundle 'thinca/vim-ref'
    elseif s:uname == "Linux\n"
	endif
" For JavaScript
"NeoBundle 'marijnh/tern_for_vim'
" Installした後に npm install する必要がある
endif
" for html
NeoBundle 'mattn/emmet-vim'
"NeoBundle 'open-browser.vim'
NeoBundle 'mattn/webapi-vim'
NeoBundle 'hail2u/vim-css3-syntax'
"NeoBundle 'othree/html5.vim' " https://github.com/vim-jp/issues/issues/584のためよばない
NeoBundle 'pangloss/vim-javascript'
"NeoBundle 'kchmck/vim-coffee-script'

" For Java
"NeoBundle 'vim-scripts/javacomplete'
NeoBundle 'yuratomo/java-api-complete'
NeoBundle 'yuratomo/java-api-javax'
NeoBundle 'yuratomo/java-api-org'
NeoBundle 'yuratomo/java-api-sun'
NeoBundle 'yuratomo/java-api-servlet2.3'
NeoBundle 'yuratomo/java-api-android'
NeoBundle 'yuratomo/java-api-junit'
NeoBundle 'vim-scripts/TagHighlight'
NeoBundle 'kamichidu/vim-unite-javaimport', {
            \ 'depends' :[
            \ 'kamichidu/vim-javaclasspath',
            \],
            \}

" for vimscript-help
NeoBundle 'mattn/learn-vimscript.git'

" for PHP
NeoBundle 'joonty/vdebug'

" for Markdown
NeoBundle 'tpope/vim-markdown'
NeoBundle 'h1mesuke/vim-alignta'
NeoBundle 'kannokanno/previm'

NeoBundle 'k28/evervim'
NeoBundle 'glidenote/memolist.vim'
" github NeoBundle 'name/foo.vim'
" www.vim.org NeoBundle 'bar.vim'

call neobundle#end()
filetype plugin indent on
NeoBundleCheck

" ----- Vundle Settings End -----

" syntax highlite
if !exists("g:syntax_on")
	syntax enable
endif

let java_highlight_all = 1
let java_highlight_functions = "style"
let java_allow_cpp_keywords = 1

" a.vim addition
let g:alternateExtensions_h = "c,cpp,cxx,cc,CC,m,mm"
let g:alternateExtensions_m = "h"
let g:alternateExtensions_mm = "h,hpp"

" vim-quickrun option
let g:quickrun_config={'*': {'split': ''}}
set splitright

" unite.vim settings
nnoremap <silent> ;; :OpenFileSearchCom<CR>
"noremap ;; :Unite buffer<CR>
"noremap ;; :Unite -start-insert eclipseSrcFiles<CR>
command! -nargs=* OpenFileSearchCom call <SID>OpenFileSearch()
function! s:OpenFileSearch()
    if &filetype == "java"
        :Unite -start-insert eclipseSrcFiles
    elseif &filetype == "objc" || &filetype == "objcpp"
        :Unite -start-insert cocoaSrcFiles
    else
        :Unite buffer
    endif
endfunction

" EnhCommentify settings
function! EnhCommentifyCallback(ft)
	if a:ft == 'objc'
		let b:ECcommentOpen = '//'
		let b:ECcommentClose = ''
	endif
endfunction
let g:EnhCommentifyCallbackExists = 'Yes'

let g:clang_complete_getopts_ios_sdk_directory = '/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator8.2.sdk/'
let g:clang_library_path = '/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib'

" for vimfiler plugin
command! -nargs=0 OpenVimfilerAsIDE :VimFiler -split -simple -winwidth=35 -no-quit

" for taglist plugin
let Tlist_Ctags_Cmd = "$HOME/bin/ctags"
let Tlist_Show_One_File = 1
let Tlist_Use_Right_Window = 1
let Tlist_Exit_OnlyWindow = 1
nnoremap <silent> <leader>l :TlistToggle<CR>
let tlist_objc_settings = 'objc;P:protocols;i:interfaces;I:implementations;M:instance methods;C:implementation methods;Z:protocol methods'
 
" for Dumbbuf plugin
let g:dumbbuf_hotkey=''

" neocomplcache
if !exists('g:neocomplcache_force_omni_patterns')
	let g:neocomplcache_force_omni_patterns = {}
endif
let g:neocomplcache_force_overwrite_completefunc = 1
let g:neocomplcache_force_omni_patterns.c =
			\ '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplcache_force_omni_patterns.cpp =
			\ '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
let g:neocomplcache_force_omni_patterns.objc =
			\ '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplcache_force_omni_patterns.objcpp =
			\ '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

" ctrlp settings
let g:ctrlp_use_migemo = 1
let g:ctrlp_clear_cache_on_exit = 1   " 終了時キャッシュをクリアする
let g:ctrlp_mruf_max            = 500 " MRUの最大記録数
let g:ctrlp_open_new_file       = 1   " 新規ファイル作成時にタブで開く
let g:ctrlp_switch_buffer       = 0   " すでに開かれている時にもその場所で開く
let g:ctrlp_regexp = 1 " regexp mode

" neocomplcache plugin
let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_enable_smart_case = 1
let g:neocomplcache_enable_camel_case_completion = 0
let g:neocomplcache_enable_underbar_completion = 1
let g:neocomplcache_min_syntax_length = 3
" for neocomplcache and clang_complete settings
let g:neocomplcache_force_overwrite_completefunc = 1
if !exists("g:neocomplcache_force_omni_patterns")
	let g:neocomplcache_force_omni_patterns = {}
endif
let g:neocomplcache_force_omni_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|::'

" neocomplete
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#enable_camel_case_completion = 0
let g:neocomplete#disable_auto_complete = 1
let g:neocomplete#min_keyword_length = 3
" for neocomplete and clang_complete settings
let g:neocomplete#force_overwrite_completefunc = 1
if !exists('g:neocomplete#force_omni_patterns')
    let g:neocomplete#force_omni_patterns = {}
endif
let g:neocomplete#force_overwrite_completefunc = 1
let g:neocomplete#force_omni_patterns.c =
            \ '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplete#force_omni_patterns.cpp =
            \ '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
let g:neocomplete#force_omni_patterns.objc =
            \ '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplete#force_omni_patterns.objcpp =
            \ '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
let g:clang_complete_auto = 0
let g:clang_complete_select = 0
let g:clang_use_library = 1

let g:clang_snippets = 1
let g:clang_snippets_engine = 'ultisnips'
" clang_completeで追加されたジャンプ機能が不完全なので,無効にするために,他のキーを割り当てる
let g:clang_jumpto_declaration_key = '<C-1>'
let g:clang_jumpto_back_key = '<C-2>'

" previm
" TODO 環境によってブラウザをかえる必要がある
let g:previm_open_cmd = 'open -a "Google Chrome"'

" memolist
let g:memolist_memo_suffix = 'md'
let g:memolist_path = '~/Dropbox/Documents/memo/posts'
let g:memolist_templete_dir_path = '~/Dropbox/Documents/memo'

command! -nargs=* MemoListTitleSearch call <SID>MemoListTitleSearch()
function! s:MemoListTitleSearch()
    execute ":CtrlP " . g:memolist_path
endfunction

" php {{{
let php_sql_query = 1
let php_baselib = 1
let php_htmlInStrings = 1
let php_noShortTags = 1
let php_parent_error_close = 1
" }}}

" html5 {{{
"let g:html5_event_handler_attributes_complete = 1
"let g:html5_rdfa_attributes_complete = 1
"let g:html5_microdata_attributes_complete = 1
"let g:html5_aria_attributes_complete = 1
" }}}

" vim-over {{{

" launch vim-over
" [s]ubstitute + [l]ine, [f]ile, [m]ethod
nnoremap <silent> <Leader>sl :OverCommandLine<CR>s/
nnoremap <silent> <Leader>sf :OverCommandLine<CR>%s/
nnoremap <silent> <Leader>sm V[mo]M:OverCommandLine<CR>s/

" replace word under cursor
nnoremap <silent> <Leader>g :OverCommandLine<CR>%s/\<<C-r><C-w>\>//g<Left><Left>
"vnoremap <silent> <Leader>g y:OverCommandLine<CR>%s/<C-r>"//g<Left><Left>
vnoremap <silent> <Leader>g :OverCommandLine<CR>s//g<Left><Left>

" }}}

" for javacomplete {{{
"augroup vimrc-javacomplete
"    autocmd!
"    autocmd FileType java :setlocal omnifunc=javacomplete#Complete
"    autocmd FileType java :setlocal completefunc=javacomplete#CompleteParamsInfo
"augroup END "}}}

" for java-api-complete {{{
augroup java-api-complete
    autocmd!
    autocmd FileType java :setlocal omnifunc=javaapi#complete
    " autocmd FileType java :JavaApiLoadFromTag "これやると遅くなる
    autocmd CompleteDone *.java call javaapi#showRef()
augroup END
let g:javaapi#delay_dirs = [
  \ 'java-api-javax',
  \ 'java-api-org',
  \ 'java-api-sun',
  \ 'java-api-servlet2.3',
  \ 'java-api-android',
  \ ]

" }}}

" for jcommenter {{{
augroup jcommenter
    autocmd!
    if filereadable(expand('$VIMRUNTIME/macros/jcommenter.vim'))
        autocmd FileType java source $VIMRUNTIME/macros/jcommenter.vim
        autocmd FileType java nnoremap <C-c> :call JCommentWriter()<CR>
    endif
augroup END
" }}}

" unite settings " {{{
"}}}

" evervim {{{
nnoremap <silent> <Space>el :<C-u>EvervimNotebookList<CR>
nnoremap <silent> <Space>ecr :<C-u>EvervimCreateNote<CR>
nnoremap <silent> <Space>es :EvervimSearchByQuery<Space>''<Left>
" }}}

" load plugins
if filereadable(expand('$VIMRUNTIME/macros/matchit.vim'))
	source $VIMRUNTIME/macros/matchit.vim
	:let b:match_words = "if:endif"
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

" Insert Current Date to Last of line
command! -nargs=0 InsertCurrentDate call <SID>InsertCurrentDate()
function! s:InsertCurrentDate()
	execute ":normal A" . strftime("%Y.%m.%d")
endfunction "InsertCurrentDate

" Update Current line date to current date
command! -nargs=0 UpdateCurrentDate call <SID>UpdateCurrentDate()
function! s:UpdateCurrentDate()
	let s:line=getline('.')
	if s:line =~ "[0-9][0-9][0-9][0-9]\\.[0-9][0-9]\\.[0-9][0-9]"
		let newDate=strftime("%Y\\.%m\\.%d")
		let s:line = substitute(s:line, "[0-9][0-9][0-9][0-9]\\.[0-9][0-9]\\.[0-9][0-9]", newDate, "")
		call setline('.', s:line)
	elseif s:line =~ "[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]"
		let newDate=strftime("%Y-%m-%d")
		let s:line = substitute(s:line, "[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]", newDate, "")
		call setline('.', s:line)
	elseif s:line =~ "[0-9][0-9][0-9][0-9]/[0-9][0-9]/[0-9][0-9]"
		let newDate=strftime("%Y/%m/%d")
		let s:line = substitute(s:line, "[0-9][0-9][0-9][0-9]/[0-9][0-9]/[0-9][0-9]", newDate, "")
		call setline('.', s:line)
	elseif s:line =~ "[0-9][0-9][0-9][0-9]年[0-9][0-9]月[0-9][0-9]日"
		let newDate=strftime("%Y年%m月%d日")
		let s:line = substitute(s:line, "[0-9][0-9][0-9][0-9]年[0-9][0-9]月[0-9][0-9]日", newDate, "")
		call setline('.', s:line)
	endif
endfunction! "UpdateCurrentDate

" Locad all current headers
command! -nargs=0 LoadCurrentHeaders call <SID>LoadCurrentHeaders()
function! s:LoadCurrentHeaders()
	execute ":args ./**/*.h"
endfunction "LoadCurrentHeaders

" Search Current words
command! -nargs=* SearchCurrentWord call <SID>SearchCurrentWord()
function! s:SearchCurrentWord()
	let wordUnderCursor = expand("<cword>")
	if executable('ack')
		execute ':Ack ''\b' . wordUnderCursor . '\b'''
	elseif executable('grep')
		execute ":grep -rI " . wordUnderCursor "./"
	else
		echo "command not support"
	endif
endfunction "SearchCurrentWord

" Search current word caller
command! -nargs=* SearchCurrentWordCaller call <SID>SearchCurrentWordCaller()
function! s:SearchCurrentWordCaller()
	let wordUnderCursor = expand("<cword>")
	if executable('ack')
		if &filetype == "objc" || &filetype == "objcpp"
            let xcode_project_path = <SID>XCodeProjectDir()
			execute ":Ack " . "'" . '^(?!.*-).*' . wordUnderCursor . ".*" ."'" . ' ' . xcode_project_path
		elseif &filetype == "java"
			execute ":Ack " . "'" . '^(?!.*(void|private|public|protected)).*' . wordUnderCursor . "\\s*\\(.*\\)'"
		else
			echo "Command not support for this filetype[" + &filetype + "]"
		endif
	elseif executable('grep')
		echo "Command not support for vimgrep. Please insatall ack."
	else
		echo "Command not support. Please install ack."
	endif
endfunction "SearchCurrentWordCaller

" Search current method
command! -nargs=* SearchCurrentMethod call <SID>SearchCurrentWordMethod()
function! s:SearchCurrentWordMethod()
	let wordUnderCursor = expand("<cword>")
	if executable('ack')
		if &filetype == "objc"
			execute ":Ack " . "'" . "^-\\s?\\(\\w+\\)\\s?" . wordUnderCursor . "'"
		elseif &filetype == "java"
			execute ":Ack " . "'" . '(private|public|protected)\s+(\w+)\s+' . wordUnderCursor . "\\s*\\(.*\\)'"
		else
			echo "Command not support for this filetype[" + &filetype + "]"
		endif
	elseif executable('grep')
		echo "Command not support for vimgrep. Please insatall ack."
	else
		echo "Command not support. Please install ack."
	endif
endfunction "SearchCurrentMethod

" Find current word header
command! -nargs=* FindCurrentWordHeader call <SID>FindCurrentWordHeader()
function! s:FindCurrentWordHeader()
	let wordUnderCursor = expand("<cword>")
	let wordUnderCursor = join([wordUnderCursor,".h"],'')
	execute ":find " . wordUnderCursor
endfunction "FindCurrentWordHeader

command! -nargs=* OpenCurrentFileAsNewTabe call <SID>OpenCurrentFileAsNewTabe()
function! s:OpenCurrentFileAsNewTabe()
	let current_file_name = expand("%")
	execute ":tabnew " . current_file_name
endfunction

" Return comment string this is not used.
function! s:CommentStr()
	" get the current file type

	if &filetype == "vim"
		return "\""
	elseif &filetype == "perl"
		return "#"
	endif

	return "\/\/"
endfunction "CommentStr

" Append Comment to current selected lines, this is not used.
command! -nargs=* -range ToggleCommentToCurrentLines :<line1>,<line2>call <SID>ToggleCommentToCurrentLines()
function! s:ToggleCommentToCurrentLines() range
	let firstLine = getline(a:firstline)
	let commentStr = s:CommentStr()
	let commentMatche = "^" . commentStr
	let retMatch = matchstr(firstLine, commentMatche)
	if retMatch == ""
		" Append comment to all line header
		let index = a:firstline
		while index <= a:lastline
			let line = getline(index)
			let newLine = commentStr . line
			call setline(index, newLine)
			let index=index+1
		endwhile
	else
		" Remove all comment from all line header
		let index = a:firstline
		while index <= a:lastline
			let line = getline(index)
			let comment = matchstr(line, commentMatche)
			if comment != ""
				let newLine = substitute(line, commentMatche, "", "")
				call setline(index, newLine)
			endif
			let index=index+1
		endwhile
	endif
endfunction
"nnoremap \c :<C-u>ToggleCommentToCurrentLines<Return>
"vnoremap \c :ToggleCommentToCurrentLines<Return>

" toggle @(number) to @"number" "{{{
command! -nargs=* ToggleNSStringNSNumber call <SID>ToggleNSStringNSNumber()
function! s:ToggleNSStringNSNumber()
	let s:line = getline('.')
	if s:line =~ '@"\s*-\=[0-9]*\s*"'
		execute ':s/@"\s*\(-\=[0-9]*\)\s*"/@(\1)/g'
	elseif s:line =~ '@(\s*-\=[0-9]*\s*)'
		execute ':s/@(\s*\(-\=[0-9]*\)\s*)/@"\1"/g'
	endif
	unlet s:line
endfunction "}}}

" Create Directory if it not exist
augroup vimrc-auto-mkdir  " {{{
	autocmd!
	autocmd BufWritePre * call s:auto_mkdir(expand('<afile>:p:h'), v:cmdbang)
	function! s:auto_mkdir(dir, force)  " {{{
		if !isdirectory(a:dir) && (a:force ||
					\    input(printf('"%s" does not exist. Create? [y/N]', a:dir)) =~? '^y\%[es]$')
			call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
		endif
	endfunction  " }}}
augroup END  " }}}

" Reload Files
augroup vimrc-checktime
	autocmd!
	autocmd WinEnter * checktime
augroup END

" Scouter
function! Scouter(file, ...)
	let pat = '^\s*$\|^\s*"'
	let lines = readfile(a:file)
	if !a:0 || !a:1
		let lines = split(substitute(join(lines, "\n"), '\n\s*\\', '', 'g'), "\n")
	endif
	return len(filter(lines,'v:val !~ pat'))
endfunction
command! -bar -bang -nargs=? -complete=file Scouter
			\        echo Scouter(empty(<q-args>) ? $MYVIMRC : expand(<q-args>), <bang>0)
command! -bar -bang -nargs=? -complete=file GScouter
			\        echo Scouter(empty(<q-args>) ? $MYGVIMRC : expand(<q-args>), <bang>0)

" Load current path .localvimrc
augroup load-local-vimrc
	autocmd!
	autocmd BufNewFile,BufReadPost * call s:LoadLocalVimrc(expand('<afile>:p:h'))
augroup END

function! s:LoadLocalVimrc(loc)
	let s:local_vimrc_filename = '.localvimrc'
    let files = findfile(s:local_vimrc_filename, escape(a:loc, '').';', -1)
	for i in reverse(filter(files, 'filereadable(v:val)'))
		source `=i`
	endfor
endfunction

" Show all mapping in Unite.
command! -nargs=* ShowAllMappingInUnite call <SID>ShowAllMappingInUnite()
function! s:ShowAllMappingInUnite()
	exec ":Unite output:map|map!|lmap"
endfunction!

" for vim script test " {{{
command! -nargs=* -range Hogehoge :<line1>,<line2>call <SID>Hogehoge()
function! s:Hogehoge() range
	let funcname = ''
	let func_name_pattern = '\C' . '\s*-\s*(\s*\w\+\s*)\s*\(\w\+\)\s*'
	let pattern = '\C' . '\(\w\+\)\s*:\s*('

	let index = a:firstline

	let funcname = get(matchlist(getline(index), func_name_pattern), 1, '')
	if funcname ==# ''
		echo "not match"
		return
	else
		echo "****" . funcname
	endif

	let match_count = match(getline(index), ':') + 1
	echo "match_count is [" . match_count . "]"
	while index <= a:lastline
		let line = getline(index)
		while 1
			echo index . ":" . match_count
			let match_name = get(matchlist(line, pattern, match_count), 1, '')
			echo index . ": match name is [" . match_name . "]"
			if match_name ==# ''
				break
			else
				let funcname = funcname . ':' . match_name
				let match_count = match(line, ':', match_count)
				echo index . ": match count is [" . match_count . "]"
				let match_count += 1
			endif
		endwhile
		let index = index + 1
		let match_count = 0
	endwhile

	echo funcname
endfunction
" }}}

" Escape Selected to SyntaxHighlighter " {{{
command! -nargs=* -range EscapeToSyntaxHighlighter :<line1>,<line2>call <SID>EscapeToSyntaxHighlighter()
function! s:EscapeToSyntaxHighlighter() range
	let s:firstLine = a:firstline
	let s:lastLine = a:lastline
	let brush = s:SyntaxHighlighterBrush()
	let prefixLine = '<pre class="brush: ' . brush . '; first-line: 1; highlight: [,] title="">'

	let index = s:firstLine
	while index <= s:lastLine
		let line = getline(index)
		let line = substitute(line, '&', '\&amp;', "g")
		let line = substitute(line, '>', '\&gt;', "g")
		let line = substitute(line, '<', '\&lt;', "g")
		let line = substitute(line, '"', '\&quot;', "g")

		if index == s:firstLine
			execute "normal " . s:firstLine . "Go\<Esc>"
			let s:lastLine += 1
			let newLine = [prefixLine, line]
			call setline(index, newLine)
		elseif index == s:lastLine
			let newLine = [line, "</pre>"]
			execute "normal " . s:lastLine . "Go\<Esc>"
			call setline(index, newLine)
		else
			call setline(index, line)
		endif

		let index += 1
	endwhile

	if brush =~ 'unknown'
		echo "Warnning!! Brush is unknown"
	endif
endfunction
" }}}

" return syntax highlighter brush " {{{
function! s:SyntaxHighlighterBrush()
	if &filetype == "objc"
		return "cpp"
	elseif &filetype == "perl"
		return "perl"
	elseif &filetype == "c"
		return "c"
	elseif &filetype == "java"
		return "java"
	elseif &filetype == "php"
		return "php"
	elseif &filetype == "text"
		return "plain"
	elseif &filetype == "shell"
		return "bash"
	else
		return "unknown"
	endif
endfunction
" }}}

" call at load
if has('vim_starting')
	call s:LoadLocalVimrc(expand('<afile>:p:h'))
endif

" Open junk file." {{{
command! -nargs=0 JunkFile call s:open_junk_file()
function! s:open_junk_file()
	let l:junk_dir = $HOME . '/.vim_junk' . strftime('/%Y/%m')
	if !isdirectory(l:junk_dir)
		call mkdir(l:junk_dir, 'p')
	endif

	let l:filename = input('Junk Code', l:junk_dir . strftime('/%Y-%m-%d-%H%M%S.'))
	if l:filename != ""
		execute 'edit' . l:filename
	endif
endfunction
" }}}

" Open daily report file." {{{
command! -nargs=0 DailyReport call s:open_daily_report()
function! s:open_daily_report()
	let l:daily_dir = $HOME . '/.vim_daily' . strftime('/%Y/%m')

	if !isdirectory(l:daily_dir)
		call mkdir(l:daily_dir, 'p')
	endif

	let l:filename = l:daily_dir . strftime('/%Y-%m-%d.txt')
	if l:filename != ""
		execute 'edit' . l:filename
	endif

    if ( filereadable(l:filename) )
        return
    endif

    let l:daily_templete_file = $HOME . "/.vim_daily/templete.txt"
    if filereadable( l:daily_templete_file )
        execute ':read ' l:daily_templete_file
        execute ':%s/{{__date__}}/' . strftime('%Y-%m-%d') . '/g'
    endif
endfunction
" }}}

" Open Astronomical observation " {{{
command! -nargs=0 AstronomicalObservationReport call s:open_astronomical_observation()
function! s:open_astronomical_observation()
	let l:astronomical_dir = $HOME . '/.vim_astronomical_observation' . strftime('/%Y/%m')
	if !isdirectory(l:astronomical_dir)
		call mkdir(l:astronomical_dir, 'p')
	endif

	let l:filename = input('Astronomical Obseb.', l:astronomical_dir . strftime('/%Y-%m-%d.txt'))
	if l:filename != ""
		execute 'edit' . l:filename
	endif
endfunction
" }}}

" Copy word to Clipboard. " {{{
command! -nargs=0 CopyWord2Clipboad call s:copy_word_to_clipboard()
function! s:copy_word_to_clipboard()
	normal "*yiw
endfunction
" }}}

" ChangeTabToPipeline. " {{{
command! -nargs=* -range ChangeTabToPipeline :<line1>,<line2>call s:change_tab_to_pipeline()
function! s:change_tab_to_pipeline() range
	let index = a:firstline
	while index <= a:lastline
		let s:line = getline(index)
		let s:line = substitute(s:line, "\t", "|", "g")
		let s:newLine = "|" . s:line . "|"
		call setline(index, s:newLine)
		let index = index + 1
	endwhile
endfunction
" }}}

" ChangePipelineToTab. " {{{
command! -nargs=* -range ChangePipelineToTab :<line1>,<line2>call s:change_pipeline_to_tab()
function! s:change_pipeline_to_tab() range
	let index = a:firstline
	while index <= a:lastline
		let s:line = getline(index)
		let s:line = substitute(s:line, "^|", "", "")
		let s:line = substitute(s:line, "|$", "", "")
		let s:line = substitute(s:line, "|", "\t", "g")
		call setline(index, s:line)
		let index = index + 1
	endwhile
endfunction
" }}}

" ChangeCurrentDirectoryToOpenFile {{{
command! -nargs=* CDCurrentFileDirectory call s:change_current_file_directory()
function! s:change_current_file_directory()
    execute 'lcd' fnameescape(expand('%:p:h'))
endfunction!
" }}}

" GrepFromJunkFiles {{{
command! -nargs=1 GrepFromJunkFiles call s:grep_from_junkfiles(<f-args>)
function! s:grep_from_junkfiles(word)
	if executable('ack')
		execute ':Ack ''' . a:word . ''' ~/.vim_junk/'
	elseif executable('grep')
        execute ":grep -rI " . a:word . "~/.vim_junk/"
	else
		echo "command not support"
	endif
endfunction!
" }}}

" Unite Source iosframeworks {{{
let g:unite_source_iosframeworks_frameworks_path =
			\"/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS8.1.sdk/System/Library/Frameworks"

let s:unite_source = {
			\'name':'iosframeworks',
			\}
let s:unite_source.hooks = {}

function! s:unite_source.hooks.on_init(args, context)
	let framework_path = g:unite_source_iosframeworks_frameworks_path . "/*/Headers/*.h"
	let filelist = glob(framework_path)
	let a:context.source__lines = split(filelist, "\n")
endfunction

function! s:unite_source.gather_candidates(args, context)
	return map(a:context.source__lines, '{"word" : fnamemodify(v:val, ":t"),
										\ "kind" : "jump_list",
										\ "action__path" : v:val ,
										\ "action__line" : 0 }')
endfunction

call unite#define_source(s:unite_source)

unlet s:unite_source
" }}}

" Unite Source androidSources "{{{
let g:unite_source_androidsources_src_path = ""

let s:unite_source = {
			\'name':'androidSources',
			\}
let s:unite_source.hooks = {}

function! s:unite_source.hooks.on_init(args, context)
	if g:unite_source_androidsources_src_path == ""
		let g:unite_source_androidsources_src_path = "/tmp"
	endif
	let src_path = g:unite_source_androidsources_src_path . "/**/*.java"
	let filelist = glob(src_path)
	let a:context.source__lines = split(filelist, "\n")
endfunction

function! s:unite_source.gather_candidates(args, context)
	return map(a:context.source__lines, '{"word" : fnamemodify(v:val, ":t"),
										\ "kind" : "jump_list",
										\ "action__path" : v:val ,
										\ "action__line" : 0 }')
endfunction

call unite#define_source(s:unite_source)

unlet s:unite_source
"}}}

" Unite Source eclipseSrcFiles" {{{
let g:unite_source_eclipsesrcfiles_src_path = ""

let s:unite_source = {
            \ 'name' : 'eclipseSrcFiles',
            \}
let s:unite_source.hooks = {}

function! s:unite_source.hooks.on_init(args, context)
    " Search .project contain folder
    let src_folder = 'src'
    let srcdir = finddir(src_folder, './')
    if srcdir == ''
        let srcdir = finddir(src_folder, './;')
    endif

    " Search Java sources
    if srcdir != ''
        let src_path = srcdir . "/**/*.java"
        let filelist = glob(src_path)
        let a:context.source__lines = split(filelist, "\n")
    endif
endfunction

function! s:unite_source.gather_candidates(args, context)
    return map(a:context.source__lines, '{"word" : fnamemodify(v:val, ":t"),
                                        \ "kind" : "jump_list",
                                        \ "action__path" : v:val ,
                                        \ "action__line" : 0 }')
endfunction

call unite#define_source(s:unite_source)

unlet s:unite_source
"}}}

" Unite Source cocoaSrcFiles" {{{
let g:unite_source_cocoasecfiles_src_path = ""

let s:unite_source = {
            \ 'name' : 'cocoaSrcFiles',
            \}
let s:unite_source.hooks = {}

function! s:unite_source.hooks.on_init(args, context)
    " Search .project contain folder
    let currentPath = <SID>XCodeProjectDir()

    " Search cocoa sources
    if currentPath != ''
        let src_path = "\"`find \"" . currentPath . "\" -name \"*.m\" -o -name \"*.h\" -o -name \"*.mm\"`\""
        let filelist = glob(src_path)
        let a:context.source__lines = split(filelist, "\n")
    endif
endfunction

function! s:unite_source.gather_candidates(args, context)
    return map(a:context.source__lines, '{"word" : fnamemodify(v:val, ":t"),
                                        \ "kind" : "jump_list",
                                        \ "action__path" : v:val ,
                                        \ "action__line" : 0 }')
endfunction

call unite#define_source(s:unite_source)

unlet s:unite_source
"}}}
"
" Unite Source change_link_directory" {{{
let g:unite_source_link_directory_path = "$HOME/link"

let s:unite_source = {
            \ 'name' : 'change_link_directory',
            \}
let s:unite_source.hooks = {}

function! s:unite_source.hooks.on_init(args, context)
        let src_path = g:unite_source_link_directory_path . "/*"
        let filelist = glob(src_path)
        let a:context.source__lines = split(filelist, "\n")
endfunction

function! s:unite_source.hooks.on_close(args, context)
        " load .localvimrc
        call s:LoadLocalVimrc(expand('%:p:h'))
endfunction

function! s:unite_source.gather_candidates(args, context)
    return map(a:context.source__lines, '{"word" : fnamemodify(v:val, ":t"),
                                        \ "kind" : "cdable",
                                        \ "action__directory" : v:val ,}')
endfunction

call unite#define_source(s:unite_source)
call unite#custom#default_action('source/change_link_directory/cdable' ,'lcd')
call unite#custom#alias('source/change_link_directory/narrow', 'cdable', 'lcd')

unlet s:unite_source
"}}}

function! s:load_file_firstline(filepath)
    let filename = fnamemodify(a:filepath, ":t")

    let list = readfile(a:filepath, '', 3)
    for line in list
        if  line != '[:graph:]' && strlen(line) > 0
            return line . " :" . filename
        endif
    endfor

    return filename
endfunction

" Unite Source Junkfile list "{{{
let g:unite_source_junk_file_src_path = ""

let s:unite_source = {
			\'name':'junkfile_titlesearch',
			\}
let s:unite_source.hooks = {}

function! s:unite_source.hooks.on_init(args, context)
    if g:unite_source_junk_file_src_path == ""
		let g:unite_source_junk_file_src_path = expand('~/.vim_junk')
    endif
    let src_path = g:unite_source_junk_file_src_path . "/**/*.md"
    let filelist = glob(src_path)
    let search_file_list = reverse(split(filelist, "\n"))

    let src_path = g:unite_source_junk_file_src_path . "/**/*.???"
    let filelist = glob(src_path)
    let search_file_list += reverse(split(filelist, "\n"))

    let a:context.source__lines = search_file_list
endfunction

function! s:unite_source.gather_candidates(args, context)
	return map(a:context.source__lines, '{"word" : s:load_file_firstline(v:val),
										\ "kind" : "jump_list",
										\ "action__path" : v:val ,
										\ "action__line" : 0 }')
endfunction

call unite#define_source(s:unite_source)

unlet s:unite_source
"}}}

" Unite Source DailyReport list "{{{
let g:unite_source_daily_report_src_path = ""

let s:unite_source = {
			\'name':'daily_report_title_search',
			\}
let s:unite_source.hooks = {}

function! s:unite_source.hooks.on_init(args, context)
    if g:unite_source_daily_report_src_path == ""
		let g:unite_source_daily_report_src_path = expand('~/.vim_daily')
    endif
    let src_path = g:unite_source_daily_report_src_path . "/**/*.txt"
    let filelist = glob(src_path)
    let a:context.source__lines = reverse(split(filelist, "\n"))
endfunction

function! s:unite_source.gather_candidates(args, context)
	return map(a:context.source__lines, '{"word" : fnamemodify(v:val, ":t"),
										\ "kind" : "jump_list",
										\ "action__path" : v:val ,
										\ "action__line" : 0 }')
endfunction

call unite#define_source(s:unite_source)

unlet s:unite_source
"}}}

" Unite Source Astronomical Observation list "{{{
let g:unite_source_astronomical_observation_src_path= ""

let s:unite_source = {
			\'name':'astronomical_observation_report_search',
			\}
let s:unite_source.hooks = {}

function! s:unite_source.hooks.on_init(args, context)
    if g:unite_source_astronomical_observation_src_path == ""
		let g:unite_source_astronomical_observation_src_path = expand('~/.vim_astronomical_observation')
    endif
    let src_path = g:unite_source_astronomical_observation_src_path . "/**/*.txt"
    let filelist = glob(src_path)
    let a:context.source__lines = reverse(split(filelist, "\n"))
endfunction

function! s:unite_source.gather_candidates(args, context)
	return map(a:context.source__lines, '{"word" : s:load_file_firstline(v:val),
										\ "kind" : "jump_list",
										\ "action__path" : v:val ,
										\ "action__line" : 0 }')
endfunction

call unite#define_source(s:unite_source)

unlet s:unite_source
"}}}

" swift playground test {{{
" copy MacOSX10.10 SDK from XCode6-Beta7
" append swift command path to $PATH
let g:swift_output_buffer_name="swift_result"
let g:swift_target="x86_64-apple-macosx10.10"
let g:swift_sdk_path="/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs//MacOSX10.10.sdk"
command! Swift :silent call Swift()
function! Swift()
    if &filetype != "swift"
        echo "This does not support file other than Swift."
        return
    endif

    if (!executable("swift"))
        echo "error: swift command is not executable, please check $PATH"
        return
    endif

    let s:current_file_path = shellescape(expand("%:p"))
    if (exists("g:swift_output_buffer_name"))
        if(bufexists(g:swift_output_buffer_name) > 0)
            let a:bufexists_flag = 1
        else
            let a:bufexists_flag = 0
        endif
    else
        let a:bufexists_flag = 0
    endif

    if (a:bufexists_flag)
        call Swift_SingletonBuffer(g:swift_output_buffer_nr, 1)
    else
        " Crerate new Scratch buffer
        vnew `=g:swift_output_buffer_name`
        let g:swift_output_buffer_nr = bufnr("%")
        setlocal nonumber
        setlocal buftype=nowrite
        setlocal noswapfile
        setlocal bufhidden=wipe
        setlocal nocursorline
    endif

    execute "%delete"
    let a:position = getpos(".")
    setlocal write
    let s:swift_exec_command = Swift_SwiftExecuteCommand(s:current_file_path)
    execute("r!" . s:swift_exec_command)
    setlocal readonly

endfunction

" return swift execute command
function! Swift_SwiftExecuteCommand(input_file_path)
    return "swift -target " . g:swift_target . " -sdk " . g:swift_sdk_path . " < " . a:input_file_path
endfunction

function! Swift_SingletonBuffer(bufnur, split)
    let winlist = Swift_FindWindowsByBufnur(a:bufnur)
    if empty(winlist)
        if a:split
            split
        endif
        exe "b " . bufnur
    else
        exe winlist[0] . "wincmd w"
    endif
endfunction

function! Swift_FindWindowsByBufnur(bufnur)
    return filter(range(1, winnr("$")), 'winbufnr(v:val)==' . a:bufnur)
endfunction

" }}}

" Search current file XCode project path {{{
function! s:XCodeProjectDir()
    let currentPath = fnamemodify(expand('%:p'), ":p:h")
    while 1
        let fileList = glob(currentPath . "/*\.xcodeproj")
        if fileList != ''
            break
        endif
        let currentPath = fnamemodify(currentPath, ":h")
        if currentPath == '/'
            break
        endif
    endwhile

    if currentPath == '/'
        let currentPath = fnamemodify(expand('%:p'), ":p:h")
    endif

    return currentPath
endfunction
"}}}

" Insert Table Header Line {{{
command! -nargs=* InsertTableHeaderLine call <SID>InsertTableHeaderLine()
function! s:InsertTableHeaderLine()
    let upper_line_str = getline(a:firstline - 1)
    " change multi-byte string to "++"
    let upper_line_str = substitute(upper_line_str, "[^[:alnum:] \|]", "++", "g")
    " echo upper_line_str
    let upper_line_num = strlen(upper_line_str)
    
    let index = 0
    let new_line = ""
    while index < upper_line_num
        let index_str = upper_line_str[index]
        if index_str == "|"
            let new_line = new_line . "|"
        else
            let new_line = new_line . "-"
        endif
        let index += 1
    endwhile
    " echo new_line
    call setline(a:firstline, new_line)
endfunction
" }}}

" 今後やりたい事
" カンマを挟んで前後を入れ替える関数が欲しい
" キャメルケースの移動を改善したい
"internal-variables 変数の種類について
" カーソールの下のメソッド一覧をみたい, できれば, 候補選択したい
" カーソル下のタグを新しいタブでジャンプして表示したい
" メソッド内の同じ名称を一括で書き換えられるようにしたい
" カーソル下の単語のヘッダーファイルを開きたい
" SearchCurrentWordCallerでワンライナーでcallしている部分が引っかからない
" daily_reportで次の日, 前の日を一発で開きたい

" load local settings
if filereadable(expand('~/.vimrc.local'))
	source ~/.vimrc.local
endif



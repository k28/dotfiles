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

if has("win32") || has("win64")
	set nobackup
else
	let s:bkdir=join([$HOME,'/.vim_backup'], "")
	if !isdirectory(s:bkdir)
		call mkdir(s:bkdir, "p")
	endif

	let &backupdir=s:bkdir
endif

set laststatus=2
let &statusline = '%<%f %m%r%h%w[%{(&fenc!=""?&fenc:&enc)}][%{&ff}]%y%{cfi#format("[%s]", "[no function]")}%=%l,%c%V%10P'
"let &statusline = '%<%f %m%r%h%w[%{(&fenc!=""?&fenc:&enc)}][%{&ff}]%y%=%l,%c%V%10P'

set number
set wildmenu wildmode=list:full

" When a tag file name starts with './', the '.' is replaced with the path of the current file.
" And keep going one directory up all the way to the root folder.
set tags=./.tags;/

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
nnoremap <Up> <C-w>+
nnoremap <Down> <C-w>-
nnoremap <Left> <C-w><
nnoremap <Right> <C-w>>

inoremap <Up> <NOP>
inoremap <Down> <NOP>
inoremap <Left> <NOP>
inoremap <Right> <NOP>
inoremap <C-b> <Esc><Esc>bi

" yunk replace word
nnoremap <silent> ciy ciw<C-r>0<ESC>
nnoremap <silent> cy   ce<C-r>0<ESC>
vnoremap <silent> cy   c<C-r>0<ESC>

" exchange ; and :
noremap ; :
noremap : ;

" help
nnoremap <C-h> :<C-u>help<Space>
set helplang=en

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

" reload this file
command! ReloadVimrc source $MYVIMRC

" netrw.vim
" always tree style
let g:netrw_liststyle = 3
" do not show .files
"let g:netrw_list_hide = '\(^\|\s\s\)\zs\.\S\+'

" Vundle Settings -------------
filetype off
if has("win32") || has("win64")
	set rtp+=~/vimfiles/bundle/vundle/
	call vundle#rc('~/vimfiles/bundle')
else
	set rtp+=~/.vim/bundle/vundle
	call vundle#rc()
endif

" Vundle managed plugins
Bundle 'gmarik/vundle'
Bundle 'Shougo/unite.vim'
Bundle 'Shougo/unite-outline'
Bundle 'Shougo/vimproc'
Bundle 'thinca/vim-quickrun'
Bundle 'msanders/snipmate.vim'
Bundle 'mileszs/ack.vim'
Bundle 'tyru/DumbBuf.vim'
Bundle 'vim-scripts/sh.vim'
Bundle 'tpope/vim-surround'
Bundle 'thinca/vim-qfreplace'
Bundle 'kien/ctrlp.vim'
Bundle 'a.vim'
Bundle 'cocoa.vim'
Bundle 'taglist.vim'
Bundle 'EnhCommentify.vim'
Bundle 'vim-scripts/camelcasemotion'
Bundle 'Shougo/neocomplcache.git'
Bundle 'tanabe/ToggleCase-vim'
Bundle 'osyo-manga/vim-over'
if has("unix")
	let s:uname = system("uname")
	if s:uname == "Darwin\n"
		Bundle 'tokorom/clang_complete.git'
		Bundle 'tokorom/clang_complete-getopts-ios.git'
		Bundle 'guns/ultisnips'
		Bundle 'thinca/vim-fontzoom'
		Bundle 'vim-jp/vimdoc-ja'
	endif
" For JavaScript
Bundle 'teramako/jscomplete-vim'
endif
" For Java
" Bundle 'vim-scripts/javacomplete'

" github Bundle 'name/foo.vim'
" www.vim.org Bundle 'bar.vim'

filetype plugin indent on
" ----- Vundle Settings End -----

" syntax highlite
if !exists("g:syntax_on")
	syntax enable
endif

" a.vim addition
let g:alternateExtensions_h = "c,cpp,cxx,cc,CC,m,mm"
let g:alternateExtensions_m = "h"
let g:alternateExtensions_mm = "h,hpp"

" vim-quickrun option
let g:quickrun_config={'*': {'split': ''}}
set splitright

" unite.vim settings
noremap ;; :Unite buffer<CR>

" EnhCommentify settings
function! EnhCommentifyCallback(ft)
	if a:ft == 'objc'
		let b:ECcommentOpen = '//'
		let b:ECcommentClose = ''
	endif
endfunction
let g:EnhCommentifyCallbackExists = 'Yes'

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

" vim-over {{{

" launch vim-over
nnoremap <silent> <Leader>f :OverCommandLine<CR>s/
nnoremap <silent> <Leader>m V[mo]M:OverCommandLine<CR>s/

" replace word under cursor
nnoremap <silent> <Leader>g :OverCommandLine<CR>%s/<C-r><C-w>//g<Left><Left>
vnoremap <silent> <Leader>g :OverCommandLine<CR>s/

" }}}

" for javacomplete {{{
augroup vimrc-javacomplete
autocmd FileType java :setlocal omnifunc=javacomplete#Complete
autocmd FileType java :setlocal completefunc=javacomplete#CompleteParamsInfo
augroup END "}}}

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
		if &filetype == "objc"
			execute ":Ack " . "'" . '^(?!.*-).*' . wordUnderCursor . ".*" ."'"
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

" for vim script test
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

" Escape Selected to SyntaxHighlighter
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

" return syntax highlighter brush
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

" Unite Source iosframeworks {{{
let g:unite_source_iosframeworks_frameworks_path =
			\"/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS7.0.sdk/System/Library/Frameworks"

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
		g:unite_source_androidsources_src_path = "/tmp"
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

" 今後やりたい事
" カンマを挟んで前後を入れ替える関数が欲しい
" キャメルケースの移動を改善したい
"internal-variables 変数の種類について
" カーソールの下のメソッド一覧をみたい, できれば, 候補選択したい
" カーソル下のタグを新しいタブでジャンプして表示したい
" メソッド内の同じ名称を一括で書き換えられるようにしたい

" load local settings
if filereadable(expand('~/.vimrc.local'))
	source ~/.vimrc.local
endif


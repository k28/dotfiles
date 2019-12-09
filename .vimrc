" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
" <C-u> this delete all command mode input. eg.) :hogehoge<C-u> -> :

scriptencoding utf-8

" color scheme
colorscheme desert
syntax on

" exchange ; and :
nnoremap ; :
nnoremap : ;
vnoremap ; :
vnoremap : ;

set encoding=utf-8
set fileencodings=utf-8,ucs-bom,iso-2022-jp-3,iso-2022-jp,eucjp-ms,euc-jisx0213,euc-jp,sjis,cp932,utf-8
set tabstop=4
set shiftwidth=4
set textwidth=0
set expandtab           " use space to insert TAB
set foldmethod=marker
set scrolloff=5
set number
" allow backspacing over everything in insert mode
set backspace=indent,eol,start
set history=50		" keep 50 lines of command line history
set ruler		    " show the cursor position all the time
set showcmd		    " display incomplete commands
set incsearch		" do incremental searching
set cursorline
set noundofile      " do not create *.un~
set laststatus=2
set wildmenu wildmode=list:full
"set isfname+=32     " open filenames containing spaces with gf

" Search settings
set ignorecase
set smartcase
set hlsearch

" yank word to * register
set clipboard+=unnamed

nnoremap / /\v
nnoremap ? ?\v

cnoremap <expr> /
			\getcmdtype() == '/' ? '\/' : '/'
cnoremap <expr> ?
			\getcmdtype() == '/' ? '\?' : '?'

" nohlsearch, close preview window.
nnoremap <ESC><ESC> :nohlsearch<CR><C-w><C-z><ESC>

" search visual mode words
vnoremap <silent> * "vy/\V<C-r>=substitute(escape(@v,'\/'),"\n",'\\n','g')<CR><CR>

" close quickfix
nnoremap <Space>c :<C-u>ccl<CR>

" change :grep to ack
if executable('ack')
	set grepprg=ack\ -H\ --nocolor\ --nogroup\ --nocolumn
	nnoremap <Space>g :<C-u>silent grep<Space>''<Left>
	nnoremap <Space>i :<C-u>silent grep<Space>-i<Space>''<Left>
else
	nnoremap <Space>g :<C-u>silent grep<Space>-Ir<Space>''<Space>*<Left><Left><Left>
	nnoremap <Space>i :<C-u>silent grep<Space>-iIr<Space>''<Space>*<Left><Left><Left>
endif

" reload this file
command! ReloadVimrc source $MYVIMRC
" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" yunk settings
" replace word
nnoremap <silent> ciy ciw<C-r>0<ESC>
nnoremap <silent> cy   ce<C-r>0<ESC>
vnoremap <silent> cy   c<C-r>0<ESC>
" yank 1line without new line.
vnoremap v $h

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
inoremap <C-b> <Esc><Esc>i
endif

" help settings
nnoremap <C-h> :<C-u>help<Space>
set helplang=en

" command line emacs key maps
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-k> <Up>
cnoremap <C-b> <LEFT>

" <, > indent
vnoremap < <gv
vnoremap > >gv

" insert mode settings
inoremap <silent> <C-a> <ESC>I
inoremap <silent> <C-e> <ESC>$a
inoremap <silent> <C-f> <ESC>la
inoremap <silent> <C-j> <ESC>/([^()]*)<CR>v%g<C-h>
inoremap {} {}<Left>
inoremap [] []<Left>
inoremap () ()<Left>
inoremap "" ""<Left>
inoremap <> <><Left>
"inoremap <C-c> /*  */<Left><Left><Left>
" C-@で直前の入力を入力してinsertモードを抜けるが使いにくいのでEscに割り当てる
inoremap <silent> <C-@> <ESC>

augroup vimrc
    autocmd!
    " show QuickFix automatically
    au QuickfixCmdPost make,grep,grepadd,vimgrep,helpgrep copen
    au QuickfixCmdPost l* lopen

    " file types
    au BufRead,BufNewFile *.md set filetype=markdown
augroup END


" Backup mode. {{{
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
" }}}

" Show ZENKAKU  {{{
scriptencoding utf-8
augroup highlightIdegraphicSpace
	autocmd!
	highlight IdeographicSpace cterm=underline ctermfg=red gui=underline guifg=red
	autocmd VimEnter,WinEnter,Syntax * match IdeographicSpace /　/
augroup END
" }}}

" Jump to the last known cursor position.   {{{
augroup jumpToTheLastKnownCursorPosition
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd! 
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif
augroup END
" }}}

" Edit in Hex mode when the Binary modee    {{{
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
" }}}

" Self defined functions {{{

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

" Load all current headers
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

" Open current file as new tabe
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

" Insert include guard to the current file. {{{
command! -nargs=0 IncGuard call IncludeGuard()
function! IncludeGuard()
    " Get current file name
    let file_name = fnamemodify(expand('%'), ':t')

    " To Uppercase and append the GURD
    let file_name = toupper(file_name)
    let included = substitute(file_name, '\.', '_', 'g').'_INCLUDED_'

    " Write to the file
    let res_head = '#ifndef '.included."\n#define ".included."\n\n"
    let res_foot = "\n".'#endif //'.included."\n"
    silent! execute '1s/^/\=res_head'
    silent! execute '$s/$/\=res_foot'
endfunction "}}}

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

" Escape Selected to MarkdownSyntaxHighlighter " {{{
command! -nargs=* -range EscapeToMarkdownSyntaxHighlighter :<line1>,<line2>call <SID>EscapeToMarkdownSyntaxHighlighter()
function! s:EscapeToMarkdownSyntaxHighlighter() range
	let s:firstLine = a:firstline
	let s:lastLine = a:lastline
	let prefixLine = ''

	let index = s:firstLine
	while index <= s:lastLine
		let line = getline(index)
		let line = substitute(line, '<', '\&lt;', "g")
        call setline(index, line)
		let index += 1
	endwhile
endfunction
" }}}

" Escape Selected to SyntaxHighlighter {{{
"
" Change selected range to Syntaxhighlighter
"
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
" }}}

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

command! -nargs=0 CopyFilePath2Clipboard call s:copy_file_path_to_clipbpard()
function! s:copy_file_path_to_clipbpard()
    let file_path = expand('%:p')
    let @* = file_path
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

" swift playground test {{{
" copy MacOSX10.10 SDK from XCode6-Beta7
" append swift command path to $PATH
let g:swift_output_buffer_name="swift_result"
let g:swift_target="x86_64-apple-macosx10.14"
let g:swift_sdk_path="/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.14.sdk"
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

" Convert VB Database parameters to MySQL Set format {{{
function! ConvertVBDBParamToMySQLFormat()
    " VBのDB実行時のパラメータをMySQLで追加可能なフォーマットに整形する
    " fairing format
    execute ':%s/〔\([^〕]\+\)〕/=''\1'';/g'
    " delete empty
    execute ':v/\S/d'
    " delete top spave
    execute ':%s/^ \+//'
    " insert top set=
    execute ':%s/^/set /'
endfunction
" }}}

" ----- Selft defined function END ----- }}}

" TODO
"
" Create "insert Markdown modeline" command
" <!-- vim:set ft=markdown ts=2 sw=2 sts=2: -->
"
" Copy2Clipboard
"

" Reload Files
augroup vimrc-checktime
	autocmd!
	autocmd WinEnter * checktime
augroup END

" load vim plugins
if filereadable(expand('~/dotfiles/.vimrc.plugins'))
    source ~/dotfiles/.vimrc.plugins
endif

" load local settings
if filereadable(expand('~/.vimrc.local'))
	source ~/.vimrc.local
endif

" folder specificc local settings
if filereadable(expand('.vimrc.local'))
	source .vimrc.local
endif

" Load current path .localvimrc {{{
function! s:LoadLocalVimrc(loc)
	let s:local_vimrc_filename = '.localvimrc'
    let files = findfile(s:local_vimrc_filename, escape(a:loc, '').';', -1)
	for i in reverse(filter(files, 'filereadable(v:val)'))
		source `=i`
	endfor
endfunction

augroup load-local-vimrc
	autocmd!
	autocmd BufNewFile,BufReadPost * call s:LoadLocalVimrc(expand('<afile>:p:h'))
augroup END

" call at load
if has('vim_starting')
    call s:LoadLocalVimrc(expand('<afile>:p:h'))
endif
" load current path localvimrc }}}


" make vim configure
" ./configure --enable-multibyte --enable-perlinterp --disable-selinux --enable-python3interp=yes --enable-luainterp=yes --enable-pythoninterp=yes


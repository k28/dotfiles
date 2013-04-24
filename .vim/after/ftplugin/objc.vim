

" --- clang_complete settings ---

let g:clang_auto_user_options = 'path, .clang_complete, ios'
"
" Disable auto completion, always <c-x> <c-o> to complete
let g:clang_complete_auto = 0
let g:clang_use_library = 1
let g:clang_periodic_quickfix = 0
let g:clang_close_preview = 1

" " For Objective-C, this needs to be active, otherwise multi-parameter
" methods won't be completed correctly
let g:clang_snippets = 1

" " Snipmate does not work anymore, ultisnips is the recommended plugin
let g:clang_snippets_engine = 'ultisnips'



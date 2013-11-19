

" --- clang_complete settings ---

let g:clang_auto_user_options = 'path, .clang_complete, ios'
"
" Disable auto completion, always <c-x> <c-o> to complete
let g:clang_complete_auto = 0
let g:clang_use_library = 1
let g:clang_periodic_quickfix = 0
let g:clang_close_preview = 1
let g:clang_complete_include_current_directory_recursively = 1

"let g:clang_complete_getopts_ios_sdk_directory = '/Applications/Xcode_5.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS7.0.sdk/'

" For Objective-C, this needs to be active, otherwise multi-parameter
" methods won't be completed correctly
let g:clang_snippets = 1

" Snipmate does not work anymore, ultisnips is the recommended plugin
let g:clang_snippets_engine = 'ultisnips'
"let g:clang_exec = '/bin/clang'
"let g:clang_library_path = '/usr/lib/libclang.dylib'


setlocal formatoptions-=r
setlocal formatoptions-=o


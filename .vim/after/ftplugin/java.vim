
set complete=.,w,b,u,t,i
noremap ;; :Unite -start-insert eclipseSrcFiles<CR>

" ignore class file
let g:ctrlp_custom_ignore = {
    \   'file': '\v.*\.class',
    \}


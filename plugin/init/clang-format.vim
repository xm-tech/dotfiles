let g:clang_format#style_options = {
            \ "AccessModifierOffset" : -4,
            \ "AllowShortIfStatementsOnASingleLine" : "true",
            \ "AlwaysBreakTemplateDeclarations" : "true",
            \ "Standard" : "C++11"}

autocmd FileType c,cpp,objc nnoremap <buffer><Leader>fc :<C-u>ClangFormat<CR>

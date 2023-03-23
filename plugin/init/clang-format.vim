" BasedOnStyle: LLVM
" IndentWidth: 8
" UseTab: Always
" BreakBeforeBraces: Attach
" AllowShortIfStatementsOnASingleLine: false
" IndentCaseLabels: false
let g:clang_format#style_options = {
      \ "BasedOnStyle": "LLVM",
      \ "IndentWidth": 8,
      \ "UseTab": "Always",
      \ "BreakBeforeBraces": "Attach",
      \ "IndentCaseLabels": "false",
      \ "AccessModifierOffset" : -4,
      \ "AllowShortIfStatementsOnASingleLine" : "true",
      \ "AlwaysBreakTemplateDeclarations" : "true",
      \ "Standard" : "C++11"}

autocmd FileType c,cpp,objc nnoremap <buffer><Leader>cf :<C-u>ClangFormat<CR>
autocmd FileType c,cpp,objc vnoremap <buffer><Leader>cf :<C-u>ClangFormat<CR>

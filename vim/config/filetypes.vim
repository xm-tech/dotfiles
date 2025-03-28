" =====================================================
" ===================== FILETYPE SETTINGS ======================

augroup filetypedetect
  command! -nargs=* -complete=help Help vertical belowright help <args>
  autocmd FileType help wincmd L

  " File type detection
  autocmd BufNewFile,BufRead .tmux.conf*,tmux.conf* setf tmux
  autocmd BufRead,BufNewFile *.gotmpl set filetype=gotexttmpl
  autocmd BufRead,BufNewFile *.puml setfiletype plantuml

  " Indentation settings
  autocmd BufNewFile,BufRead *.ino setlocal noet ts=4 sw=4 sts=4
  autocmd BufNewFile,BufRead *.txt setlocal noet ts=2 sw=2
  autocmd BufNewFile,BufRead *.md setlocal expandtab ts=2 sw=2
  autocmd BufNewFile,BufRead *.html setlocal noet ts=4 sw=4
  autocmd BufNewFile,BufRead *.vim setlocal expandtab shiftwidth=2 tabstop=2
  autocmd BufNewFile,BufRead *.sh setlocal expandtab shiftwidth=2 tabstop=2
  autocmd BufNewFile,BufRead *.proto setlocal expandtab shiftwidth=2 tabstop=2

  " Language specific settings
  autocmd FileType go setlocal noexpandtab tabstop=4 shiftwidth=4
  autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
  autocmd FileType json setlocal expandtab shiftwidth=2 tabstop=2
  autocmd FileType ruby setlocal expandtab shiftwidth=2 tabstop=2
  autocmd FileType make set noexpandtab shiftwidth=8 softtabstop=0
  autocmd FileType cs setlocal expandtab shiftwidth=4 tabstop=4 omnifunc=OmniSharp#Complete

  " Language specific mappings
  autocmd FileType c,cpp,objc nnoremap <buffer><Leader>cf :<C-u>ClangFormat<CR>
  autocmd FileType c,cpp,objc vnoremap <buffer><Leader>cf :ClangFormat<CR>
  autocmd FileType plantuml nnoremap <leader>r :!plantuml -tsvg %<CR>
augroup END

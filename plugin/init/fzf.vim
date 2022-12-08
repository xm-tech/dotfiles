
" ==================== FZF ====================
" let g:fzf_command_prefix = 'Fzf'
" let g:fzf_layout = { 'down': '~20%' }

" set wildmode=list:longest,list:full
" let $FZF_DEFAULT_COMMAND =  "find * -path '*/\.*' -prune -o -path 'node_modules/**' -prune -o -path 'target/**' -prune -o -path 'dist/**' -prune -o  -type f -print -o -type l -print 2> /dev/null"
" nnoremap <silent> <leader>e :FZF -m<CR>
" nnoremap <silent> <leader>b :FzfBuffers<CR>
" " work as 'ctrl shif f' in sublime, conflict with vim-go->def view , so change to ss
" nnoremap <silent> <leader>s :FzfAg<CR>

" ==================== The Silver Searcher ====================
" ag.vim
" if executable('ag')
"   let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git -g ""'
"   set grepprg=ag\ --nogroup\ --nocolor
" endif


" search 
" nmap <C-p> :FzfHistory<cr>
" imap <C-p> <esc>:<C-u>FzfHistory<cr>

" search across files in the current directory
" nmap <C-b> :FzfFiles<cr>
" imap <C-b> <esc>:<C-u>FzfFiles<cr>

" let g:rg_command = '
"       \ rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --color "always"
"       \ -g "*.{js,json,php,md,styl,jade,html,config,py,cpp,c,go,hs,rb,conf}"
"       \ -g "!{.git,node_modules,vendor}/*" '

" command! -bang -nargs=* Rg
"       \ call fzf#vim#grep(
"       \   'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
"       \   <bang>0 ? fzf#vim#with_preview('up:60%')
"       \           : fzf#vim#with_preview('right:50%:hidden', '?'),
"       \   <bang>0)

" command! -bang -nargs=* F call fzf#vim#grep(g:rg_command .shellescape(<q-args>), 1, <bang>0)


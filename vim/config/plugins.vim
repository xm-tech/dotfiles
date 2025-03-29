" =====================================================
" ===================== PLUGINS ======================

" Delayed loading of UltiSnips
augroup load_ultisnips
  autocmd!
  autocmd InsertEnter * call plug#load('ultisnips') | autocmd! load_ultisnips
augroup END

" ==================== coc.nvim =====================
" Limit the number of extensions to improve performance
let g:coc_global_extensions = [
      \ 'coc-json',
      \ 'coc-pyright',
      \ 'coc-go'
      \ ]

" Add command to load additional extensions on demand
command! LoadAllCocExtensions call s:LoadAllCocExtensions()
function! s:LoadAllCocExtensions()
  let g:coc_global_extensions = [
        \ 'coc-json',
        \ 'coc-pyright',
        \ 'coc-sh',
        \ 'coc-go',
        \ 'coc-lua',
        \ 'coc-tsserver',
        \ 'coc-clangd',
        \ 'coc-snippets']
  CocRestart
  echo "All coc extensions loaded"
endfunction

" FIXME replace c-space ==================== coc-browser ====================
" Use <c-space> to trigger completion
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-space> coc#refresh()
endif
" Make <CR> auto-select the first completion item
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"


" ==================== open-browser ====================
let g:netrw_nogx = 1 " disable netrw's gx mapping
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)

" ==================== Fugitive ====================
" 已移除 vim-fugitive 插件以提高性能
" 原有快捷键:
" vnoremap <leader>gb :Gblame<CR>
" nnoremap <leader>gb :Gblame<CR>
" nnoremap <leader>gd :Gvdiffsplit!<CR>
" nnoremap gdh :diffget //2<CR>
" nnoremap gdl :diffget //3<CR>

" ==================== delimitMate ====================
let g:delimitMate_expand_cr = 1   
let g:delimitMate_expand_space = 1    
let g:delimitMate_smart_quotes = 1    
let g:delimitMate_expand_inside_quotes = 0    
let g:delimitMate_smart_matchpairs = '^\%(\w\|\$\)'   


" ==================== UltiSnips ====================
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"  
let g:UltiSnipsJumpBackwardTrigger="<c-k>"

" ==================== vim-json ====================
let g:vim_json_syntax_conceal = 0

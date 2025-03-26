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
      \ 'coc-vimlsp',
      \ 'coc-pyright',
      \ 'coc-go'
      \ ]

" Add command to load additional extensions on demand
command! LoadAllCocExtensions call s:LoadAllCocExtensions()
function! s:LoadAllCocExtensions()
  let g:coc_global_extensions = [
        \ 'coc-json',
        \ 'coc-vimlsp',
        \ 'coc-pyright',
        \ 'coc-sh',
        \ 'coc-go',
        \ 'coc-lua',
        \ 'coc-tsserver',
        \ 'coc-clangd',
        \ 'coc-rust-analyzer',
        \ 'coc-snippets']
  CocRestart
  echo "All coc extensions loaded"
endfunction

" Use <c-space> to trigger completion
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent> <c-@> <c-r>=coc#refresh()<cr>
endif

" ==================== open-browser ====================
let g:netrw_nogx = 1 " disable netrw's gx mapping
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)

" ==================== Fugitive ====================
vnoremap <leader>gb :Gblame<CR>
nnoremap <leader>gb :Gblame<CR>

" Fugitive Conflict Resolution
nnoremap <leader>gd :Gvdiffsplit!<CR>
nnoremap gdh :diffget //2<CR>
nnoremap gdl :diffget //3<CR>

" ==================== delimitMate ====================
let g:delimitMate_expand_cr = 1   
let g:delimitMate_expand_space = 1    
let g:delimitMate_smart_quotes = 1    
let g:delimitMate_expand_inside_quotes = 0    
let g:delimitMate_smart_matchpairs = '^\%(\w\|\$\)'   

" Handle CR in popup menu
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<C-y>"

" ==================== vim-json ====================
let g:vim_json_syntax_conceal = 0

" ==================== Completion + Snippet ====================
let g:SuperTabDefaultCompletionType = "context"
let g:SuperTabContextTextOmniPrecedence = ['&omnifunc', '&completefunc']
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"  
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

" ================= omnisharp ======================
" 全局设置，但在 filetypes.vim 中会被文件类型特定设置覆盖
let g:OmniSharp_server_use_net6 = 1
let g:OmniSharp_highlighting = 0
let g:OmniSharp_selector_ui = 'fzf'
let g:OmniSharp_timeout = 5

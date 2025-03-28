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

" Add command to restart OmniSharp server
command! OmniSharpRestartServer :CocCommand omnisharp.restart

" Use <c-space> to trigger completion
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-space> coc#refresh()
endif

" ==================== OmniSharp-vim ====================
" macOS 上的 OmniSharp 设置
let g:OmniSharp_server_use_net6 = 1
let g:OmniSharp_server_use_mono = 1
let g:OmniSharp_timeout = 5
let g:OmniSharp_popup_position = 'peek'
let g:OmniSharp_popup_options = {
\ 'highlight': 'Normal',
\ 'padding': [0, 0, 0, 0],
\ 'border': [1]
\}
let g:OmniSharp_highlight_types = 2
let g:OmniSharp_selector_ui = 'fzf'
let g:OmniSharp_selector_findusages = 'fzf'
let g:OmniSharp_highlight_groups = {
\ 'ClassName': 'Function',
\ 'ParameterName': 'Normal',
\ 'InterfaceName': 'Type'
\}

" 启用自动补全
let g:OmniSharp_server_stdio = 1

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

" Tab completion
inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ "\<C-x>\<C-o>"
inoremap <expr><S-Tab> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Make <CR> auto-select the first completion item
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"

" ==================== UltiSnips ====================
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"  
let g:UltiSnipsJumpBackwardTrigger="<c-k>"

" ==================== vim-json ====================
let g:vim_json_syntax_conceal = 0


" ==================== OmniSharp Mappings ====================
augroup omnisharp_commands
  autocmd!

  autocmd FileType cs if exists('*OmniSharp#TypeLookup') |
        \ autocmd CursorHold *.cs call OmniSharp#TypeLookup() |
        \ elseif exists('*OmniSharp#TypeLookupWithoutDocumentation') |
        \ autocmd CursorHold *.cs call OmniSharp#TypeLookupWithoutDocumentation() |
        \ endif
  
  " Show type information automatically when the cursor stops moving
  " autocmd CursorHold *.cs call OmniSharp#TypeLookupWithoutDocumentation()
  
  " The following commands are contextual, based on the cursor position.
  autocmd FileType cs nnoremap <buffer> gd :OmniSharpGotoDefinition<CR>
  autocmd FileType cs nnoremap <buffer> <Leader>fi :OmniSharpFindImplementations<CR>
  autocmd FileType cs nnoremap <buffer> <Leader>fs :OmniSharpFindSymbol<CR>
  autocmd FileType cs nnoremap <buffer> <Leader>fu :OmniSharpFindUsages<CR>
  
  " Finds members in the current buffer
  autocmd FileType cs nnoremap <buffer> <Leader>fm :OmniSharpFindMembers<CR>
  
  " Cursor can be anywhere on the line containing an issue
  autocmd FileType cs nnoremap <buffer> <Leader>fx :OmniSharpFixUsings<CR>
  autocmd FileType cs nnoremap <buffer> <Leader>tt :OmniSharpTypeLookup<CR>
  autocmd FileType cs nnoremap <buffer> <Leader>dc :OmniSharpDocumentation<CR>
  autocmd FileType cs nnoremap <buffer> <Leader>cc :OmniSharpGlobalCodeCheck<CR>
  
  " Navigate up and down by method/property/field
  autocmd FileType cs nnoremap <buffer> <C-k> :OmniSharpNavigateUp<CR>
  autocmd FileType cs nnoremap <buffer> <C-j> :OmniSharpNavigateDown<CR>
  
  " Contextual code actions (uses fzf, CtrlP or unite.vim when available)
  autocmd FileType cs nnoremap <buffer> <Leader>ca :OmniSharpGetCodeActions<CR>
  
  " Run code actions with text selected in visual mode to extract method
  autocmd FileType cs xnoremap <buffer> <Leader>ca :call OmniSharp#GetCodeActions('visual')<CR>
  
  " Rename with dialog
  autocmd FileType cs nnoremap <buffer> <Leader>nm :OmniSharpRename<CR>
  
  " Rename without dialog - with cursor on the symbol to rename: `:Rename newname`
  autocmd FileType cs command! -nargs=1 Rename :call OmniSharp#RenameTo("<args>")
  
  " Force OmniSharp to reload the solution
  autocmd FileType cs nnoremap <buffer> <Leader>rs :OmniSharpRestartServer<CR>
  
  " Start the omnisharp server for the current solution
  autocmd FileType cs nnoremap <buffer> <Leader>ss :OmniSharpStartServer<CR>
  autocmd FileType cs nnoremap <buffer> <Leader>sp :OmniSharpStopServer<CR>
augroup END

" Enable snippet completion, requires completeopt-=preview
let g:OmniSharp_want_snippet = 0

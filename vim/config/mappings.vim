" =====================================================
" ===================== MAPPINGS ======================

" Space key does nothing
nnoremap <space> <Nop>

" Use leader-; for commands (instead of remapping ; directly)
nnoremap <leader>; :

" Quickfix shortcuts
map <C-n> :cn<CR>
map <C-m> :cp<CR>
nnoremap <leader>a :cclose<CR>

" Put quickfix window always to the bottom
augroup quickfix
  autocmd!
  autocmd FileType qf wincmd J
  autocmd FileType qf setlocal wrap
augroup END

" C# OmniSharp mappings
augroup omnisharp_commands
  autocmd!
  
  " Show type information automatically when the cursor stops moving
  autocmd CursorHold *.cs call OmniSharp#TypeLookupWithoutDocumentation()
  
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

" Enter automatically into the files directory
autocmd BufEnter * silent! lcd %:p:h

" Automatically resize screens to be equally the same
autocmd VimResized * wincmd =

" Fast saving and quitting
nnoremap <leader>w :w!<cr>
nnoremap <silent> <leader>q :q!<CR>

" Remove search highlight
function! s:clear_highlight()
  let @/ = ""
  if &filetype == 'go' && exists('*go#guru#ClearSameIds')
    call go#guru#ClearSameIds()
  endif
endfunction
nnoremap <silent> <leader><space> :<C-u>call <SID>clear_highlight()<CR>

" Echo the number under the cursor as binary
function! s:echoBinary()
  echo printf("%08b", expand('<cword>'))
endfunction
nnoremap <silent> gb :<C-u>call <SID>echoBinary()<CR>

" Close all but the current one
nnoremap <leader>o :only<CR>

" Split
noremap <Leader>h :<C-u>split<CR>
noremap <Leader>v :<C-u>vsplit<CR>

" Better split window switching
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Window resize can be done with mouse or native Vim commands
" e.g. :resize +5 or :vertical resize -5

" Print full path
map <s-f> :echo expand("%:p")<cr>

" Select all
map <C-a> ggVG$

" Maintain Visual Mode after shifting
vmap < <gv
vmap > >gv

" Move visual block
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Jump to the next '<++>' and edit it
map <leader><leader> <Esc>/<++><CR>:nohlsearch<CR>cf>

" Terminal settings
if has('terminal')
  " Kill job and close terminal window
  tnoremap <Leader>q <C-w><C-C><C-w>c<cr>

  " Switch to normal mode with esc
  tnoremap <Esc> <C-W>N

  " Mappings to move out from terminal to other views
  tnoremap <C-h> <C-w>h
  tnoremap <C-j> <C-w>j
  tnoremap <C-k> <C-w>k
  tnoremap <C-l> <C-w>l

  " Open terminal in vertical, horizontal and new tab
  nnoremap <leader>tv :vsplit<cr>:term ++curwin<CR>
  nnoremap <leader>ts :split<cr>:term ++curwin<CR>
  nnoremap <leader>tt :tabnew<cr>:term ++curwin<CR>

  tnoremap <leader>tv <C-w>:vsplit<cr>:term ++curwin<CR>
  tnoremap <leader>ts <C-w>:split<cr>:term ++curwin<CR>
  tnoremap <leader>tt <C-w>:tabnew<cr>:term ++curwin<CR>
endif

" Exit insert mode with jj
imap jj <Esc>

" Toggle spell checking
nnoremap <F6> :setlocal spell! spell?<CR>

" Center search results
nnoremap n nzzzv
nnoremap N Nzzzv

" Center screen when moving up/down
noremap <C-d> <C-d>zz
noremap <C-u> <C-u>zz

" Remap H and L to beginning and end of line
nnoremap H ^
nnoremap L $
vnoremap H ^
vnoremap L g_

" Act like D and C
nnoremap Y y$

" Don't show q: window
map q: :q

" Don't move on * (暂时禁用，可能导致卡顿)
" 此映射的功能：高亮当前单词但不移动光标位置
" 在某些情况下可能导致性能问题，特别是在大文件中
" nnoremap <silent> * :let stay_star_view = winsaveview()<cr>*:call winrestview(stay_star_view)<cr>
" 使用默认的 * 行为
nnoremap * *

" Search within visual selection
vnoremap / <Esc>/\%><C-R>=line("'<")-1<CR>l\%<<C-R>=line("'>")+1<CR>l
vnoremap ? <Esc>?\%><C-R>=line("'<")-1<CR>l\%<<C-R>=line("'>")+1<CR>l

" Time out on key codes but not mappings
if !has('gui_running')
  set timeout
  set ttimeout
  set timeoutlen=1000
  set ttimeoutlen=10
  augroup FastEscape
    autocmd!
    au InsertEnter * set timeoutlen=0
    au InsertLeave * set timeoutlen=1000
  augroup END
endif

" Visual Mode */# from Scrooloose
function! s:VSetSearch()
  let temp = @@
  norm! gvy
  let @/ = '\V' . substitute(escape(@@, '\'), '\n', '\\n', 'g')
  let @@ = temp
endfunction

vnoremap * :<C-u>call <SID>VSetSearch()<CR>//<CR><c-o>
vnoremap # :<C-u>call <SID>VSetSearch()<CR>??<CR><c-o>

" Create a go doc comment based on the word under the cursor
function! s:create_go_doc_comment()
  if &filetype != 'go'
    return
  endif
  norm "zyiw
  execute ":put! z"
  execute ":norm I// \<Esc>$"
endfunction
nnoremap <leader>ui :<C-u>call <SID>create_go_doc_comment()<CR>

" Insert mode movement
fun! Exec(cmd)
  exe a:cmd
  return ''
endf

inoremap <silent><c-f> <c-r>=Exec('norm! e')<cr>
inoremap <silent><c-b> <c-r>=Exec('norm! b')<cr>
inoremap <silent><c-l> <c-r>=Exec('norm! l')<cr>

" Press ` to change case
map ` ~

" Use K to show documentation in preview window (changed from ? to avoid conflict with search)
nnoremap K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif exists('*CocAction')
    call CocAction('doHover')
  endif
endfunction

" Save a file as root
noremap <leader>W :w !sudo tee % > /dev/null<CR>

" Add a shortcut to toggle performance mode
nnoremap <leader>tp :TogglePerformanceMode<CR>

" 紧急模式 - 当 Vim 卡顿时可以使用
nnoremap <leader>em :syntax off<CR>:let g:coc_enabled=0<CR>:set lazyredraw<CR>:set nocursorline<CR>:set nocursorcolumn<CR>:echo "紧急模式已启用"<CR>

" =====================================================
" ===================== MAPPINGS ======================

" Space key does nothing
nnoremap <space> <Nop>

" Use ; for commands
map ; :

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

" Better split window resize
map <silent><C-t>l :vertical resize +5<CR> 
map <silent><C-t>h :vertical resize -5<CR> 
map <silent><C-t>k :resize +5<CR> 
map <silent><C-t>j :resize -5<CR> 
map <silent><C-t>L :vertical resize +15<CR> 
map <silent><C-t>H :vertical resize -15<CR> 
map <silent><C-t>K :resize +15<CR> 
map <silent><C-t>J :resize -15<CR> 

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

" Don't move on *
nnoremap <silent> * :let stay_star_view = winsaveview()<cr>*:call winrestview(stay_star_view)<cr>

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

" Use ? to show documentation in preview window
nnoremap ? :call <SID>show_documentation()<CR>
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
nnoremap <F8> :TogglePerformanceMode<CR>

" 紧急模式 - 当 Vim 卡顿时可以使用
nnoremap <leader>em :syntax off<CR>:let g:coc_enabled=0<CR>:set lazyredraw<CR>:set nocursorline<CR>:set nocursorcolumn<CR>:echo "紧急模式已启用"<CR>

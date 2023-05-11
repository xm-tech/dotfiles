" 防止重复加载
" if get(s:, 'loaded', 0) != 0
" 	finish
" endif
" let s:loaded = 1


" source ~/vim/vim-init/init.vim

call plug#begin('~/.vim/plugged')

Plug 'AndrewRadev/splitjoin.vim'
Plug 'ConradIrwin/vim-bracketed-paste'
Plug 'Raimondi/delimitMate'
Plug 'SirVer/ultisnips'
Plug 'arthurxavierx/vim-caser'
Plug 'cespare/vim-toml'
Plug 'corylanou/vim-present', {'for' : 'present'}
Plug 'ekalinin/Dockerfile.vim', {'for' : 'Dockerfile'}
Plug 'elzr/vim-json', {'for' : 'json'}
Plug 'ervandew/supertab'
Plug 'fatih/molokai'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'fatih/vim-hclfmt'
Plug 'fatih/vim-nginx' , {'for' : 'nginx'}
Plug 'godlygeek/tabular'
Plug 'hashivim/vim-hashicorp-tools'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'
Plug 'mileszs/ack.vim'
Plug 'plasticboy/vim-markdown'
Plug 'roxma/vim-tmux-clipboard'
" Plug 'scrooloose/nerdtree'
" Plug 't9md/vim-choosewin'
Plug 'tmux-plugins/vim-tmux', {'for': 'tmux'}
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-eunuch'
" vim plugin for git
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-scriptease'
Plug 'tyru/open-browser.vim'
" Plug 'epmatsw/ag.vim'
Plug 'vim-scripts/indentpython.vim'

" Error checking
Plug 'w0rp/ale'

" Markdown
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install_sync()}, 'for' :['markdown', 'vim-plug'] }

" Use release branch (Recommend)
Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'ludovicchabant/vim-gutentags'
Plug 'skywind3000/gutentags_plus'
Plug 'skywind3000/vim-preview'

Plug 'Yggdroot/LeaderF', { 'do': ':LeaderfInstallCExtension' }

" directory viewer
Plug 'justinmk/vim-dirvish'

Plug 'rhysd/vim-clang-format'

Plug 'skywind3000/vim-cppman'

call plug#end()

"=====================================================
"===================== SETTINGS ======================

set nocompatible
filetype off
filetype plugin indent on

set ttyfast

if !has('nvim')
  set ttymouse=xterm2
  set ttyscroll=3
endif

set laststatus=2
set encoding=utf-8              " Set default encoding to UTF-8
set autoread                    " Automatically reread changed files without asking me anything
set autoindent                  
set backspace=indent,eol,start  " Makes backspace key more powerful.
set incsearch                   " Shows the match while typing
set hlsearch                    " Highlight found searches
set mouse=a                     "Enable mouse mode

set noerrorbells             " No beeps
set number                   " Show line numbers
set showcmd                  " Show me what I'm typing
set noswapfile               " Don't use swapfile
set nobackup                 " Don't create annoying backup files
set splitright               " Split vertical windows right to the current windows
set splitbelow               " Split horizontal windows below to the current windows
set autowrite                " Automatically save before :next, :make etc.
set hidden
set fileformats=unix,dos,mac " Prefer Unix over Windows over OS 9 formats
set noshowmatch              " Do not show matching brackets by flickering
set noshowmode               " We show the mode with airline or lightline
set ignorecase               " Search case insensitive...
set smartcase                " ... but not it begins with upper case 
set completeopt=menu,menuone
set nocursorcolumn           " speed up syntax highlighting
set nocursorline
set updatetime=300
set pumheight=10             " Completion window max size
set conceallevel=2           " Concealed text is completely hidden

set shortmess+=c   " Shut off completion messages
set belloff+=ctrlg " If Vim beeps during completion

set scrolloff=5
set lazyredraw

"http://stackoverflow.com/questions/20186975/vim-mac-how-to-copy-to-clipboard-without-pbcopy
set clipboard^=unnamed
set clipboard^=unnamedplus

" increase max memory to show syntax highlighting for large files 
set maxmempattern=20000

" define the cusor style
let &t_SI.="\e[5 q" "SI = INSERT mode
let &t_SR.="\e[4 q" "SR = REPLACE mode
let &t_EI.="\e[1 q" "EI = NORMAL mode (ELSE)

" ~/.viminfo needs to be writable and readable. Set oldfiles to 1000 last
" recently opened files, :FzfHistory uses it
set viminfo='1000

if has('persistent_undo')
  set undofile
  set undodir=~/.cache/vim
endif


" color
syntax enable
set t_Co=256
set background=dark
let g:molokai_original = 1
let g:rehash256 = 1
colorscheme molokai


augroup filetypedetect
  command! -nargs=* -complete=help Help vertical belowright help <args>
  autocmd FileType help wincmd L

  autocmd BufNewFile,BufRead .tmux.conf*,tmux.conf* setf tmux
  autocmd BufNewFile,BufRead .nginx.conf*,nginx.conf* setf nginx
  autocmd BufNewFile,BufRead *.hcl setf conf

  autocmd BufRead,BufNewFile *.gotmpl set filetype=gotexttmpl

  autocmd BufNewFile,BufRead *.ino setlocal noet ts=4 sw=4 sts=4
  autocmd BufNewFile,BufRead *.txt setlocal noet ts=2 sw=2
  autocmd BufNewFile,BufRead *.md setlocal expandtab ts=2 sw=2
  autocmd BufNewFile,BufRead *.html setlocal noet ts=4 sw=4
  autocmd BufNewFile,BufRead *.vim setlocal expandtab shiftwidth=2 tabstop=2
  autocmd BufNewFile,BufRead *.hcl setlocal expandtab shiftwidth=2 tabstop=2
  autocmd BufNewFile,BufRead *.sh setlocal expandtab shiftwidth=2 tabstop=2
  autocmd BufNewFile,BufRead *.proto setlocal expandtab shiftwidth=2 tabstop=2

  autocmd FileType go setlocal noexpandtab tabstop=4 shiftwidth=4
  " autocmd FileType c setlocal expandtab tabstop=4 shiftwidth=4
  " autocmd FileType yaml setlocal expandtab shiftwidth=2 tabstop=2

  autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
  autocmd FileType json setlocal expandtab shiftwidth=2 tabstop=2
  autocmd FileType ruby setlocal expandtab shiftwidth=2 tabstop=2
  autocmd FileType make set noexpandtab shiftwidth=8 softtabstop=0


  autocmd FileType c,cpp,objc nnoremap <buffer><Leader>cf :<C-u>ClangFormat<CR>
  autocmd FileType c,cpp,objc vnoremap <buffer><Leader>cf :ClangFormat<CR>

  " autocmd FileType c,cpp,*.h setlocal tabstop=4 shiftwidth=4 equalprg=clang-format 
augroup END

"=====================================================
"===================== STATUSLINE ====================

let s:modes = {
      \ 'n': 'NORMAL', 
      \ 'i': 'INSERT', 
      \ 'R': 'REPLACE', 
      \ 'v': 'VISUAL', 
      \ 'V': 'V-LINE', 
      \ "\<C-v>": 'V-BLOCK',
      \ 'c': 'COMMAND',
      \ 's': 'SELECT', 
      \ 'S': 'S-LINE', 
      \ "\<C-s>": 'S-BLOCK', 
      \ 't': 'TERMINAL'
      \}

let s:prev_mode = ""
function! StatusLineMode()
  let cur_mode = get(s:modes, mode(), '')

  " do not update higlight if the mode is the same
  if cur_mode == s:prev_mode
    return cur_mode
  endif

  if cur_mode == "NORMAL"
    exe 'hi! StatusLine ctermfg=236'
    exe 'hi! myModeColor cterm=bold ctermbg=148 ctermfg=22'
  elseif cur_mode == "INSERT"
    exe 'hi! myModeColor cterm=bold ctermbg=23 ctermfg=231'
  elseif cur_mode == "VISUAL" || cur_mode == "V-LINE" || cur_mode == "V_BLOCK"
    exe 'hi! StatusLine ctermfg=236'
    exe 'hi! myModeColor cterm=bold ctermbg=208 ctermfg=88'
  endif

  let s:prev_mode = cur_mode
  return cur_mode
endfunction

function! StatusLineFiletype()
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction

function! StatusLinePercent()
  return (100 * line('.') / line('$')) . '%'
endfunction

function! StatusLineLeftInfo()
"  let branch = fugitive#head()
"  let filename = '' != expand('%:t') ? expand('%:t') : '[No Name]'
"  if branch !=# ''
"    return printf("%s | %s", branch, filename)
"  endif
"  return filename
   return ''
endfunction

" make opacity
" exe 'hi Normal guibg=NONE ctermbg=NONE'
exe 'hi! myInfoColor ctermbg=240 ctermfg=252'

" start building our statusline
set statusline=

" mode with custom colors
set statusline+=%#myModeColor#
set statusline+=%{StatusLineMode()}               
set statusline+=%*

" left information bar (after mode)
set statusline+=%#myInfoColor#
set statusline+=\ %{StatusLineLeftInfo()}
set statusline+=\ %*

" go command status (requires vim-go)
set statusline+=%#goStatuslineColor#
set statusline+=%{go#statusline#Show()}
set statusline+=%*

" right section seperator
set statusline+=%=

" filetype, percentage, line number and column number
set statusline+=%#myInfoColor#
set statusline+=\ %{StatusLineFiletype()}\ %{StatusLinePercent()}\ %l:%v
set statusline+=\ %*

"=====================================================
"===================== MAPPINGS ======================

" This comes first, because we have mappings that depend on leader
" With a map leader it's possible to do extra key combinations
" i.e: <leader>w saves the current file

nnoremap <space> <Nop>
" let mapleader = " "

" let mapleader = ","
map ; :

" Some useful quickfix shortcuts for quickfix
map <C-n> :cn<CR>
map <C-m> :cp<CR>
map <C-p> :cp<CR>
nnoremap <leader>a :cclose<CR>

" put quickfix window always to the bottom
augroup quickfix
  autocmd!
  autocmd FileType qf wincmd J
  autocmd FileType qf setlocal wrap
augroup END

" Enter automatically into the files directory
autocmd BufEnter * silent! lcd %:p:h

" Automatically resize screens to be equally the same
autocmd VimResized * wincmd =

" Fast saving
nnoremap <leader>w :w!<cr>
nnoremap <silent> <leader>q :q!<CR>

" Center the screen
nnoremap <space> zz

" Remove search highlight
" nnoremap <leader><space> :nohlsearch<CR>
function! s:clear_highlight()
  let @/ = ""
  call go#guru#ClearSameIds()
endfunction
nnoremap <silent> <leader><space> :<C-u>call <SID>clear_highlight()<CR>

" echo the number under the cursor as binary, useful for bitwise operations
function! s:echoBinary()
  echo printf("%08b", expand('<cword>'))
endfunction
nnoremap <silent> gb :<C-u>call <SID>echoBinary()<CR>

" Source the current Vim file
" nnoremap <leader>pr :Runtime<CR>

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


" Print full path, %-current file name, :p-expand to fullpath
map <s-f> :echo expand("%:p")<cr>
" Select all
map <C-a> ggVG$

" Vmap for maintain Visual Mode after shifting > and <
vmap < <gv
vmap > >gv

" Move visual block
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" press <leader> twice to jump to the next '<++>' and edit it
map <leader><leader> <Esc>/<++><CR>:nohlsearch<CR>cf>

" macro
" nmap m q


" Terminal settings
if has('terminal')
  " Kill job and close terminal window
  tnoremap <Leader>q <C-w><C-C><C-w>c<cr>

  " switch to normal mode with esc
  tnoremap <Esc> <C-W>N

  " mappings to move out from terminal to other views
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

  " always start terminal in insert mode when I switch to it
  " NOTE(arslan): startinsert doesn't work in Terminal-normal mode.
  " autocmd WinEnter * if &buftype == 'terminal' | call feedkeys("i") | endif
endif

" Exit on j
imap jj <Esc>

" Source (reload configuration)
" nnoremap <F5> :!sh ./install.sh && source ~/.vimrc<CR>

nnoremap <F6> :setlocal spell! spell?<CR>
" Search mappings: These will make it so that going to the next one in a
" search will center on the line it's found in.
nnoremap n nzzzv
nnoremap N Nzzzv

" Same when moving up and down
noremap <C-d> <C-d>zz
noremap <C-u> <C-u>zz

" Remap H and L (top, bottom of screen to left and right end of line)
nnoremap H ^
nnoremap L $
vnoremap H ^
vnoremap L g_

" Act like D and C
nnoremap Y y$

" Do not show stupid q: window
map q: :q

" Don't move on * I'd use a function for this but Vim clobbers the last search
" when you're in a function so fuck it, practicality beats purity.
nnoremap <silent> * :let stay_star_view = winsaveview()<cr>*:call winrestview(stay_star_view)<cr>

" mimic the behavior of /%Vfoobar which searches within the previously
" selected visual selection
" while in search mode, pressing / will do this
vnoremap / <Esc>/\%><C-R>=line("'<")-1<CR>l\%<<C-R>=line("'>")+1<CR>l
vnoremap ? <Esc>?\%><C-R>=line("'<")-1<CR>l\%<<C-R>=line("'>")+1<CR>l

" Time out on key codes but not mappings.
" Basically this makes terminal Vim work sanely.
if !has('gui_running')
  set notimeout
  set ttimeout
  set ttimeoutlen=10
  augroup FastEscape
    autocmd!
    au InsertEnter * set timeoutlen=0
    au InsertLeave * set timeoutlen=1000
  augroup END
endif

" Visual Mode */# from Scrooloose {{{
function! s:VSetSearch()
  let temp = @@
  norm! gvy
  let @/ = '\V' . substitute(escape(@@, '\'), '\n', '\\n', 'g')
  let @@ = temp
endfunction

vnoremap * :<C-u>call <SID>VSetSearch()<CR>//<CR><c-o>
vnoremap # :<C-u>call <SID>VSetSearch()<CR>??<CR><c-o>

" create a go doc comment based on the word under the cursor
function! s:create_go_doc_comment()
  norm "zyiw
  execute ":put! z"
  execute ":norm I// \<Esc>$"
endfunction
nnoremap <leader>ui :<C-u>call <SID>create_go_doc_comment()<CR>



"===================== PLUGINS ======================
"
" ==================== coc.nvim =====================
let g:coc_global_extensions = [
      \ 'coc-json',
      \ 'coc-vimlsp',
      \ 'coc-cmake',
      \ 'coc-python',
      \ 'coc-pyright',
      \ 'coc-sh',
      \ 'coc-go',
      \ 'coc-lua',
      \ 'coc-jedi',
      \ 'coc-tsserver',
      \ 'coc-markdownlint',
      \ 'coc-sql',
      \ 'coc-clangd',
      \ 'coc-rust-analyzer',
      \ 'coc-snippets',
      \ 'coc-java',
      \ 'coc-docker']
" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  " inoremap <silent><expr> <c-@> coc#refresh()
  inoremap <silent> <c-@> <c-r>=coc#refresh()<cr>
endif

" ==================== open-browser ====================

" default netrw is not working anymore, switch to a custom plugin
" (open-browser.vim)  https://github.com/vim/vim/issues/4738
let g:netrw_nogx = 1 " disable netrw's gx mapping.
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

" imap <expr> <CR> pumvisible() ? "\<c-y>" : "<Plug>delimitMateCR"
" imap <expr> <CR> pumvisible() ? "\<c-y>" : "\<CR>"
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<C-y>"


" ==================== vim-json ====================
let g:vim_json_syntax_conceal = 0

" ==================== Completion + Snippet ====================
" Ultisnips has native support for SuperTab. SuperTab does omnicompletion by
" pressing tab. I like this better than autocompletion, but it's still fast.
let g:SuperTabDefaultCompletionType = "context"
let g:SuperTabContextTextOmniPrecedence = ['&omnifunc', '&completefunc']
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"  
let g:UltiSnipsJumpBackwardTrigger="<s-tab>" 



" ==================== Various other plugin settings ====================
" nmap  -  <Plug>(choosewin)

" Trigger a highlight in the appropriate direction when pressing these keys:
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

nmap <Leader>gi <Plug>(grammarous-open-info-window)
nmap <Leader>gc <Plug>(grammarous-close-info-window)
nmap <Leader>gf <Plug>(grammarous-fixit)

fun! Exec(cmd)
  exe a:cmd
  return ''
endf

" Insert模式下的<c-r> 键，本来是用于输入某个寄存器的内容，而= 寄存器又是一个比较特殊的存在，它不像其他寄存器，在输入完寄存器名之后，直接返回寄存器的值，而是等待用户输入某个表达式，eval这个表达式并返回值。
" move forward a word in insert mode while <c-f> was pressed
inoremap <silent><c-f> <c-r>=Exec('norm! e')<cr>
" move backward a word in insert mode while <c-b> was pressed
inoremap <silent><c-b> <c-r>=Exec('norm! b')<cr>
inoremap <silent><c-l> <c-r>=Exec('norm! l')<cr>
" inoremap <silent><c-h> <c-r>=Exec('norm! h')<cr>
" inoremap <silent><c-k> <c-r>=Exec('norm! k')<cr>
" inoremap <silent><c-j> <c-r>=Exec('norm! j')<cr>

" Press ` to change case instead of ~
map ` ~

" Use ? to show documentation in preview window
nnoremap ? :call <SID>show_documentation()<CR>
function! s:show_documentation()
	if (index(['vim','help'], &filetype) >= 0)
		execute 'h '.expand('<cword>')
	else
		call CocAction('doHover')
	endif
endfunction

" Save a file as root (,W)
noremap <leader>W :w !sudo tee % > /dev/null<CR>

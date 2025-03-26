" =====================================================
" ===================== PERFORMANCE OPTIMIZATIONS ======================

" Disable unnecessary features
set nobackup
set noswapfile
set nowritebackup

" Handle undofile settings - resolve conflict with basic.vim
" Disable undofile for normal files, but keep it for read-only files
if !&readonly && filewritable(expand("%"))
  set noundofile
else
  if has('persistent_undo')
    set undofile
    set undodir=~/.cache/vim
  endif
endif

" Use a more efficient regex engine
set regexpengine=1

" Optimize updatetime based on environment
if exists('$TMUX')
  set updatetime=1000
else
  set updatetime=300
endif

" Disable syntax highlighting for large files
autocmd BufWinEnter * if line2byte(line("$") + 1) > 500000 | syntax clear | endif

" Disable certain plugins for large files
autocmd BufReadPre * if getfsize(expand("%")) > 500000 | 
      \ let b:coc_enabled = 0 |
      \ set eventignore+=FileType |
      \ setlocal noswapfile noundofile noloadplugins |
      \ endif

" Optimize syntax highlighting
syntax sync minlines=64
set synmaxcol=128

" Disable certain features of coc.nvim that might cause slowdowns
let g:coc_disable_startup_warning = 1
let g:coc_filetype_map = {'markdown.mdx': 'markdown'}
let g:coc_node_args = ['--max-old-space-size=2048']

" Completely disable gutentags for better performance
let g:gutentags_enabled = 0
let g:gutentags_generate_on_new = 0
let g:gutentags_generate_on_missing = 0
let g:gutentags_generate_on_write = 0
let g:gutentags_generate_on_empty_buffer = 0
let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
let g:gutentags_ctags_exclude = [
      \ '*.git', '*.svg', '*.hg',
      \ 'build',
      \ 'dist',
      \ '*sites/*/files/*',
      \ 'bin',
      \ 'node_modules',
      \ 'bower_components',
      \ 'cache',
      \ 'compiled',
      \ 'docs',
      \ 'example',
      \ 'bundle',
      \ 'vendor',
      \ '*.md',
      \ '*-lock.json',
      \ '*.lock',
      \ '*bundle*.js',
      \ '*build*.js',
      \ '.*rc*',
      \ '*.json',
      \ '*.min.*',
      \ '*.map',
      \ '*.bak',
      \ '*.zip',
      \ '*.pyc',
      \ '*.class',
      \ '*.sln',
      \ '*.Master',
      \ '*.csproj',
      \ '*.tmp',
      \ '*.csproj.user',
      \ '*.cache',
      \ '*.pdb',
      \ 'tags*',
      \ 'cscope.*',
      \ '*.css',
      \ '*.less',
      \ '*.scss',
      \ '*.exe', '*.dll',
      \ '*.mp3', '*.ogg', '*.flac',
      \ '*.swp', '*.swo',
      \ '*.bmp', '*.gif', '*.ico', '*.jpg', '*.png',
      \ '*.rar', '*.zip', '*.tar', '*.tar.gz', '*.tar.xz', '*.tar.bz2',
      \ '*.pdf', '*.doc', '*.docx', '*.ppt', '*.pptx',
      \ ]

" Optimize LeaderF
let g:Lf_MruMaxFiles = 50
let g:Lf_UseVersionControlTool = 0
let g:Lf_UseMemoryCache = 0
let g:Lf_UseCache = 0
let g:Lf_MaxCount = 1000

" Disable certain vim-go features that might be slow
let g:go_highlight_types = 0
let g:go_highlight_fields = 0
let g:go_highlight_functions = 0
let g:go_highlight_function_calls = 0
let g:go_highlight_operators = 0
let g:go_highlight_extra_types = 0
let g:go_highlight_build_constraints = 0
let g:go_highlight_generate_tags = 0
let g:go_auto_type_info = 0
let g:go_auto_sameids = 0

" Disable markdown folding which can be slow
let g:vim_markdown_folding_disabled = 1

" tmux specific optimizations - avoid duplicate settings with basic.vim
if exists('$TMUX')
  " Only set ttymouse if not already set in basic.vim
  if !exists('&ttymouse')
    set ttymouse=xterm2
  endif
  
  set ttimeoutlen=10
  set lazyredraw
  set nomodeline
  set noshowcmd
  
  " Disable certain visual effects in tmux
  set nocursorline
  set nocursorcolumn
  set norelativenumber
endif

" Add command to quickly disable features when vim becomes slow
command! LightMode call s:EnableLightMode()
function! s:EnableLightMode()
  let g:coc_enabled = 0
  syntax off
  set lazyredraw
  set nocursorline
  set nocursorcolumn
  set norelativenumber
  set noshowcmd
  set noruler
  set noincsearch
  set complete-=i
  set complete-=t
  set foldmethod=manual
  echo "Light mode enabled - performance optimized"
endfunction

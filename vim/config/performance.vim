" =====================================================
" ===================== PERFORMANCE OPTIMIZATIONS ======================

" Disable unnecessary features
set nobackup
set noswapfile
set noundofile
set nowritebackup

" Reduce updatetime for faster response
set updatetime=300

" Disable syntax highlighting for large files
autocmd BufWinEnter * if line2byte(line("$") + 1) > 1000000 | syntax clear | endif

" Disable certain plugins for large files
autocmd BufReadPre * if getfsize(expand("%")) > 1000000 | let b:coc_enabled = 0 | endif

" Optimize syntax highlighting
syntax sync minlines=256
set synmaxcol=200

" Disable certain features of coc.nvim that might cause slowdowns
let g:coc_disable_startup_warning = 1
let g:coc_filetype_map = {'markdown.mdx': 'markdown'}

" Disable gutentags for large projects
let g:gutentags_enabled = 1
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
let g:Lf_MruMaxFiles = 100
let g:Lf_UseVersionControlTool = 0
let g:Lf_UseMemoryCache = 0
let g:Lf_UseCache = 0

" Disable certain vim-go features that might be slow
let g:go_highlight_types = 0
let g:go_highlight_fields = 0
let g:go_highlight_functions = 0
let g:go_highlight_function_calls = 0
let g:go_highlight_operators = 0
let g:go_highlight_extra_types = 0
let g:go_highlight_build_constraints = 0
let g:go_highlight_generate_tags = 0

" Disable markdown folding which can be slow
let g:vim_markdown_folding_disabled = 1

" tmux specific optimizations
if exists('$TMUX')
  " Optimize terminal settings in tmux
  set ttymouse=xterm2
  set ttimeoutlen=10
  set lazyredraw
  
  " Disable certain visual effects in tmux
  set nocursorline
  set nocursorcolumn
  set norelativenumber
  
  " Increase updatetime in tmux to reduce screen updates
  set updatetime=1000
endif

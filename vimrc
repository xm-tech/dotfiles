" =================================================================
" ===================== MODULAR VIM CONFIGURATION ======================
" =================================================================

" Initialize plugin system
call plug#begin('~/.vim/plugged')

" Editing and navigation
Plug 'AndrewRadev/splitjoin.vim'
Plug 'ConradIrwin/vim-bracketed-paste'
Plug 'Raimondi/delimitMate'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-repeat'

" Completion and snippets
Plug 'SirVer/ultisnips', {'on': []}
Plug 'ervandew/supertab'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Language support - use lazy loading for most plugins
Plug 'fatih/vim-go', {'for': 'go', 'do': ':GoUpdateBinaries'}
Plug 'elzr/vim-json', {'for': 'json'}
Plug 'plasticboy/vim-markdown', {'for': 'markdown'}
Plug 'vim-scripts/indentpython.vim', {'for': 'python'}
Plug 'tmux-plugins/vim-tmux', {'for': 'tmux'}
Plug 'ekalinin/Dockerfile.vim', {'for': 'Dockerfile'}
Plug 'rhysd/vim-clang-format', {'for': ['c', 'cpp', 'objc']}
Plug 'skywind3000/vim-cppman', {'for': ['c', 'cpp']}

" Text manipulation
Plug 'arthurxavierx/vim-caser', {'on': ['Camelcase', 'Snakecase', 'Kebabcase', 'Pascalcase']}
Plug 'godlygeek/tabular', {'on': 'Tabularize'}

" Git integration
" Plug 'tpope/vim-fugitive', {'on': ['Git', 'Gblame', 'Gvdiffsplit']} " 已移除以提高性能

" File navigation and search
Plug 'Yggdroot/LeaderF', {'do': ':LeaderfInstallCExtension'}
Plug 'justinmk/vim-dirvish'
" Plug 'mileszs/ack.vim', {'on': 'Ack'} " 已移除，使用 LeaderF 替代

" Markdown preview
Plug 'iamcco/markdown-preview.nvim', {'do': { -> mkdp#util#install_sync()}, 'for': ['markdown', 'md']}

" Misc
Plug 'corylanou/vim-present', {'for': 'present'}
Plug 'fatih/molokai'
Plug 'roxma/vim-tmux-clipboard'
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'tpope/vim-scriptease', {'for': 'vim'}
Plug 'tyru/open-browser.vim', {'on': '<Plug>(openbrowser-smart-search)'}

" Tags - load gutentags only when explicitly requested
Plug 'ludovicchabant/vim-gutentags', {'on': ['GutentagsToggleEnabled']}
Plug 'skywind3000/gutentags_plus', {'on': ['GutentagsToggleEnabled']}
Plug 'skywind3000/vim-preview', {'on': 'PreviewTag'}

call plug#end()

" Load performance.vim first to ensure optimizations are applied before other settings
source ~/.vim/config/performance.vim

" Then load other modular configuration files
source ~/.vim/config/basic.vim
source ~/.vim/config/filetypes.vim
source ~/.vim/config/statusline.vim
source ~/.vim/config/mappings.vim
source ~/.vim/config/plugins.vim

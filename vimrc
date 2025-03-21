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

" Language support
Plug 'fatih/vim-go', {'for': 'go', 'do': ':GoUpdateBinaries'}
Plug 'fatih/vim-hclfmt', {'for': 'hcl'}
Plug 'fatih/vim-nginx', {'for': 'nginx'}
Plug 'cespare/vim-toml', {'for': 'toml'}
Plug 'elzr/vim-json', {'for': 'json'}
Plug 'plasticboy/vim-markdown', {'for': 'markdown'}
Plug 'vim-scripts/indentpython.vim', {'for': 'python'}
Plug 'tmux-plugins/vim-tmux', {'for': 'tmux'}
Plug 'ekalinin/Dockerfile.vim', {'for': 'Dockerfile'}
Plug 'hashivim/vim-hashicorp-tools', {'for': ['terraform', 'hcl', 'vagrant']}
Plug 'rhysd/vim-clang-format', {'for': ['c', 'cpp', 'objc']}
Plug 'skywind3000/vim-cppman', {'for': ['c', 'cpp']}

" Text manipulation
Plug 'arthurxavierx/vim-caser', {'on': ['Camelcase', 'Snakecase', 'Kebabcase', 'Pascalcase']}
Plug 'godlygeek/tabular', {'on': 'Tabularize'}

" Git integration
Plug 'tpope/vim-fugitive', {'on': ['Git', 'Gblame', 'Gvdiffsplit']}

" File navigation and search
Plug 'Yggdroot/LeaderF', {'do': ':LeaderfInstallCExtension'}
Plug 'justinmk/vim-dirvish'
Plug 'mileszs/ack.vim', {'on': 'Ack'}

" Markdown preview
Plug 'iamcco/markdown-preview.nvim', {'do': { -> mkdp#util#install_sync()}, 'for': ['markdown', 'vim-plug']}

" Misc
Plug 'corylanou/vim-present', {'for': 'present'}
Plug 'fatih/molokai'
Plug 'roxma/vim-tmux-clipboard'
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'tpope/vim-scriptease', {'for': 'vim'}
Plug 'tyru/open-browser.vim', {'on': '<Plug>(openbrowser-smart-search)'}

" Tags
Plug 'ludovicchabant/vim-gutentags'
Plug 'skywind3000/gutentags_plus'
Plug 'skywind3000/vim-preview', {'on': 'PreviewTag'}

call plug#end()

" Load modular configuration files
source ~/.vim/config/basic.vim
source ~/.vim/config/filetypes.vim
source ~/.vim/config/statusline.vim
source ~/.vim/config/mappings.vim
source ~/.vim/config/plugins.vim
source ~/.vim/config/performance.vim

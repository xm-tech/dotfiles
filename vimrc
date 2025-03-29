" =================================================================
" ===================== 模块化 VIM 配置 ===========================
" =================================================================

" 初始化插件系统
call plug#begin('~/.vim/plugged')

" 编辑和导航相关插件
" 在单行和多行表达式之间切换
Plug 'AndrewRadev/splitjoin.vim'
" 智能粘贴模式，避免缩进混乱
Plug 'ConradIrwin/vim-bracketed-paste'
" 自动补全括号、引号等配对符号
Plug 'Raimondi/delimitMate'
" 快速注释/取消注释代码
Plug 'tpope/vim-commentary'
" Unix 命令集成（如 :Rename, :SudoWrite 等）
Plug 'tpope/vim-eunuch'
" 增强 . 命令，使其支持插件操作重复
Plug 'tpope/vim-repeat'

" 代码补全和代码片段
" 代码片段引擎，按需加载
Plug 'SirVer/ultisnips', {'on': []}
" 智能代码补全引擎，LSP 客户端
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" 语言支持 - 大多数插件使用懒加载提高性能
" Go 语言支持
Plug 'fatih/vim-go', {'for': 'go', 'do': ':GoUpdateBinaries'}
" JSON 文件支持
Plug 'elzr/vim-json', {'for': 'json'}
" Markdown 支持
Plug 'plasticboy/vim-markdown', {'for': 'markdown'}
" Python 缩进支持
Plug 'vim-scripts/indentpython.vim', {'for': 'python'}
" tmux 配置文件语法支持
Plug 'tmux-plugins/vim-tmux', {'for': 'tmux'}
" Dockerfile 语法支持
Plug 'ekalinin/Dockerfile.vim', {'for': 'Dockerfile'}
" C/C++ 代码格式化
Plug 'rhysd/vim-clang-format', {'for': ['c', 'cpp', 'objc']}
" C++ 文档查询
Plug 'skywind3000/vim-cppman', {'for': ['c', 'cpp']}

" 文本处理
" 命名风格转换
Plug 'arthurxavierx/vim-caser', {'on': ['Camelcase', 'Snakecase', 'Kebabcase', 'Pascalcase']}
" 文本对齐工具
Plug 'godlygeek/tabular', {'on': 'Tabularize'}

" 文件导航和搜索
" 模糊查找器，快速搜索文件/缓冲区/标签等
Plug 'Yggdroot/LeaderF', {'do': ':LeaderfInstallCExtension'}
" 简洁的文件浏览器
Plug 'justinmk/vim-dirvish'

" Markdown 预览
" 实时预览 Markdown
Plug 'iamcco/markdown-preview.nvim', {'do': { -> mkdp#util#install_sync()}, 'for': ['markdown', 'md']}

" 其他功能
" molokai 配色方案
Plug 'fatih/molokai'
" vim 和 tmux 之间的剪贴板共享
Plug 'roxma/vim-tmux-clipboard'
" vim 脚本开发辅助工具
Plug 'tpope/vim-scriptease', {'for': 'vim'}
" 在浏览器中打开 URL
Plug 'tyru/open-browser.vim', {'on': '<Plug>(openbrowser-smart-search)'}

" 标签管理 - 仅在明确请求时加载 gutentags
" 自动管理标签文件
Plug 'ludovicchabant/vim-gutentags', {'on': ['GutentagsToggleEnabled']}
" gutentags 增强
Plug 'skywind3000/gutentags_plus', {'on': ['GutentagsToggleEnabled']}
" 预览标签
Plug 'skywind3000/vim-preview', {'on': 'PreviewTag'}


call plug#end()

" 加载模块化配置文件（按正确顺序）
" 基础设置
source ~/.vim/config/basic.vim
" 性能优化设置
source ~/.vim/config/performance.vim
" 文件类型特定设置
source ~/.vim/config/filetypes.vim
" 状态栏配置
source ~/.vim/config/statusline.vim
" 键盘映射设置
source ~/.vim/config/mappings.vim
" 插件特定配置
source ~/.vim/config/plugins.vim

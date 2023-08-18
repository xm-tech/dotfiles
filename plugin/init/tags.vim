" =================== ctags =====================
" 设置标签tags
set tags=./.tags;,.tags
"设置根据打开文件自动更换目录
"set autochdir

" gutentags 搜索工程目录的标志，当前文件路径向上递归直到碰到这些文件/目录名
let g:gutentags_project_root = ['.git', '.hg', '.project', '.root']
" 所生成的数据文件的名称
let g:gutentags_ctags_tagfile = '.tags'

" 同时开启 ctags 和 gtags 支持：
let g:gutentags_modules = []
if executable('ctags')
    let g:gutentags_modules += ['ctags']
endif
if executable('gtags-cscope') && executable('gtags')
    let g:gutentags_modules += ['gtags_cscope']
endif

" 将自动生成的 ctags/gtags 文件全部放入 ~/.cache/tags 目录中，避免污染工程目录
let s:vim_tags = expand('~/.cache/tags')
let g:gutentags_cache_dir = s:vim_tags
" 检测 ~/.cache/tags 不存在就新建 "
if !isdirectory(s:vim_tags)
   silent! call mkdir(s:vim_tags, 'p')
endif

" 配置 ctags 的参数
let g:gutentags_ctags_extra_args = ['--fields=+niazSl']
let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
let g:gutentags_ctags_extra_args += ['--c-kinds=+px']

" Get ctags version
let g:ctags_version = system('ctags --version')[0:8]

" 如果使用 universal ctags 需要增加下面一行
if g:ctags_version == "Universal"
  let g:gutentags_ctags_extra_args += ['--extras=+q', '--output-format=e-ctags']
endif

" 禁用 gutentags 自动加载 gtags 数据库的行为
let g:gutentags_auto_add_gtags_cscope = 0
"Change focus to quickfix window after search (optional).
let g:gutentags_plus_switch = 1
"Enable advanced commands: GutentagsToggleTrace, etc.
let g:gutentags_define_advanced_commands = 1
let g:gutentags_trace = 0


" 告诉 gtags 默认 C/C++/Java 等六种原生支持的代码直接使用 gtags 本地分析器，而其他语言使用 pygments 模块
let $GTAGSLABEL = 'native-pygments'
" let $GTAGSCONF = '/usr/local/etc/gtags.conf'
" let $GTAGSCONF = '/opt/homebrew/etc/gtags.conf'
" GTAGS_CONF_PATH should be defined in .zsh_private
let $GTAGSCONF = $GTAGS_CONF_PATH

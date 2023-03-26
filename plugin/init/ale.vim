
" ==================== ale ====================
" let b:ale_linters = [] "['pylint']
let g:ale_linters = {'c': ['clang'], 'cpp': ['clang', 'g++'], 'python': ['pylint']}
" let b:ale_fixers = ['autopep8', 'yapf']
let g:get_cflags_return_value = '-std=c11'
let g:ale_python_pylint_options = "--extension-pkg-whitelist=pygame"

let g:ackprg = 'ag --vimgrep --smart-case'                                                   

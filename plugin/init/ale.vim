
" ==================== ale ====================
let b:ale_linters = [] "['pylint']
" let b:ale_fixers = ['autopep8', 'yapf']
let g:ale_python_pylint_options = "--extension-pkg-whitelist=pygame"

let g:ackprg = 'ag --vimgrep --smart-case'                                                   

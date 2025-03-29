
" 状态行日志系统
let g:status_log_enabled = 1 " 启用状态行日志
let g:status_log_timeout = 5 " 日志显示时间 (秒)
let g:status_log_history = [] " 日志历史记录
let g:status_log_max_history = 100 " 最大历史记录数
let g:status_log_current = '' " 当前显示的日志
let g:status_log_timer = -1 " 日志清除计时器

" 状态行日志函数
function! StatusLineLog(msg, ...)
  if !g:status_log_enabled
    return
  endif

  " 获取可选的日志级别 (默认为 INFO)
  let l:level = a:0 > 0 ? a:1 : 'INFO'
  let l:prefix = '[' . l:level . ']'

  " 格式化日志消息
  let g:status_log_current = l:prefix . a:msg

  " 添加到历史记录
  call add(g:status_log_history, strftime('%H:%M:%S') . ' ' . g:status_log_current)

  " 限制历史记录大小
  if len(g:status_log_history) > g:status_log_max_history
    let g:status_log_history = g:status_log_history[-g:status_log_max_history:]
  endif

  " 取消之前的计时器 (如果存在)
  if g:status_log_timer != -1
    call timer_stop(g:status_log_timer)
  endif

  " 设置新的计时器来清除日志
  let g:status_log_timer = timer_start(g:status_log_timeout * 1000, 'ClearStatusLineLog')

  " 刷新状态行
  redrawstatus

endfunction

" 清除状态行日志
function! ClearStatusLineLog(timer_id)
  let g:status_log_current = ''
  let g:status_log_timer = -1
  redrawstatus
endfunction

" 定义查看日志历史的命令
command! -nargs=0 LogHistory call s:ShowLogHistory()

function! s:ShowLogHistory()
  if empty(g:status_log_history)
    echo "日志历史为空"
    return
  endif

  " 创建新缓冲区显示日志
  new
  setlocal buftype=nofile bufhidden=wipe noswapfile nowrap
  setlocal filetype=log

  " 添加日志内容
  call append(0, ['=== Vim 日志历史 ===', ''])
  call append(2, g:status_log_history)

  " 移动到顶部
  normal! gg
endfunction

" 定义启用/禁用状态行日志的命令
command! LogEnable let g:status_log_enabled = 1 | echo "状态行日志已启用"
command! LogDisable let g:status_log_enabled = 0 | echo "状态行日志已禁用"

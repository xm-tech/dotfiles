" 解决 tmux 面板间文件刷新的问题

" 智能文件刷新函数
function! SmartCheckTime()
  call StatusLineLog("SmartCheckTime, reload curfile")
  " 暂存当前光标位置
  let l:save_cursor = getpos(".")
  " 检查并刷新文件(若被外部修改，则会重新加载)
  silent! checktime
  " 恢复光标位置
  call setpos(".", l:save_cursor)
endfunction

" 设置自动刷新
if has('autocmd')
  augroup AutoReloadFile
    autocmd!
    " 基本事件: 窗口获得焦点或缓冲区进入时, 为什么FocusGained,BufEnter 好像没有触发
    autocmd FocusGained,BufEnter * silent! call SmartCheckTime()
    " 如何添加执行日志
  augroup END
endif

" 在默认状态行中添加日志显示
set statusline+=%=%{exists('g:status_log_current')?'\ '.g:status_log_current.'\ ':''}

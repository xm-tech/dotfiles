" Vim 执行日志系统配置
" 作者: maxiongmiao
" 最后更新: 2025-04-01
" 修复: 解决日志系统停止工作的问题

" 日志文件路径设置
let g:vim_log_dir = expand('~/.vim/logs')
let g:vim_log_file = g:vim_log_dir . '/vim_' . strftime('%Y%m%d_%H%M%S') . '.log'
let g:vim_debug_mode = 0
let g:vim_log_level = 4  " 0=关闭, 1=错误, 2=警告, 3=信息, 4=调试
let g:vim_log_max_size = 1024 * 1024  " 1MB
let g:vim_log_initialized = 0

" 确保日志目录存在
if !isdirectory(g:vim_log_dir)
  silent! call mkdir(g:vim_log_dir, 'p')
endif

" 日志级别常量
let s:LOG_LEVEL_OFF = 0
let s:LOG_LEVEL_ERROR = 1
let s:LOG_LEVEL_WARN = 2
let s:LOG_LEVEL_INFO = 3
let s:LOG_LEVEL_DEBUG = 4

" 日志级别名称
let s:log_level_names = ['OFF', 'ERROR', 'WARN', 'INFO', 'DEBUG']

" 确保日志文件可写
function! s:EnsureLogFileWritable()
  if filewritable(g:vim_log_file) != 1
    " 尝试创建文件
    call writefile([''], g:vim_log_file)
    if filewritable(g:vim_log_file) != 1
      let g:vim_log_level = 0  " 禁用日志
      echom "警告: 无法写入日志文件，日志系统已禁用"
      return 0
    endif
  endif
  return 1
endfunction

" 日志轮转 - 当日志文件超过一定大小时创建新文件
function! s:RotateLogFileIfNeeded()
  if filereadable(g:vim_log_file) && getfsize(g:vim_log_file) > g:vim_log_max_size
    let l:old_log = g:vim_log_file
    let g:vim_log_file = g:vim_log_dir . '/vim_' . strftime('%Y%m%d_%H%M%S') . '.log'
    call s:LogMessage(s:LOG_LEVEL_INFO, '日志文件已轮转，旧文件: ' . l:old_log)
    return 1
  endif
  return 0
endfunction

" 日志函数 - 改进版本，确保每次都能写入
function! s:LogMessage(level, message)
  " 检查日志级别
  if g:vim_log_level < a:level
    return
  endif
  
  " 检查日志文件大小并在需要时轮转
  call s:RotateLogFileIfNeeded()
  
  " 确保日志文件可写
  if !s:EnsureLogFileWritable()
    return
  endif
  
  " 创建日志条目
  let l:timestamp = strftime('%Y-%m-%d %H:%M:%S')
  let l:level_name = s:log_level_names[a:level]
  let l:log_entry = l:timestamp . ' [' . l:level_name . '] ' . a:message
  
  " 写入日志文件 - 使用追加模式
  try
    call writefile([l:log_entry], g:vim_log_file, 'a')
    
    " 如果开启了调试模式，同时在命令行显示
    if g:vim_debug_mode
      echom l:log_entry
    endif
  catch
    " 如果写入失败，尝试重新创建日志文件
    let g:vim_log_file = g:vim_log_dir . '/vim_' . strftime('%Y%m%d_%H%M%S') . '_recovery.log'
    call writefile([l:timestamp . ' [ERROR] 日志系统恢复: 之前的日志写入失败'], g:vim_log_file, 'a')
    call writefile([l:log_entry], g:vim_log_file, 'a')
  endtry
endfunction

" 公开的日志接口
function! LogError(message)
  call s:LogMessage(s:LOG_LEVEL_ERROR, a:message)
endfunction

function! LogWarn(message)
  call s:LogMessage(s:LOG_LEVEL_WARN, a:message)
endfunction

function! LogInfo(message)
  call s:LogMessage(s:LOG_LEVEL_INFO, a:message)
endfunction

function! LogDebug(message)
  call s:LogMessage(s:LOG_LEVEL_DEBUG, a:message)
endfunction

" 记录启动时间
function! LogStartupTime()
  if exists('g:vim_start_time')
    let l:startup_time = reltimestr(reltime(g:vim_start_time))
    call LogInfo('Vim 启动耗时: ' . l:startup_time . ' 秒')
  else
    call LogInfo('Vim 启动时间未记录')
  endif
endfunction

" 记录插件加载时间
function! LogPluginLoadTime(plugin_name, start_time)
  let l:load_time = reltimestr(reltime(a:start_time))
  call LogDebug('插件加载: ' . a:plugin_name . ' 耗时 ' . l:load_time . ' 秒')
endfunction

" 记录命令执行时间
function! LogCommandTime(cmd, start_time)
  let l:exec_time = reltimestr(reltime(a:start_time))
  call LogDebug('命令执行: ' . a:cmd . ' 耗时 ' . l:exec_time . ' 秒')
endfunction

" 设置日志级别
function! SetLogLevel(level)
  if a:level >= s:LOG_LEVEL_OFF && a:level <= s:LOG_LEVEL_DEBUG
    let g:vim_log_level = a:level
    call LogInfo('日志级别设置为: ' . s:log_level_names[a:level])
    echo '日志级别设置为: ' . s:log_level_names[a:level]
  else
    echo '无效的日志级别. 有效值: 0-4'
  endif
endfunction

" 切换调试模式
function! ToggleDebugMode()
  let g:vim_debug_mode = !g:vim_debug_mode
  if g:vim_debug_mode
    call LogInfo('调试模式已开启')
    echo '调试模式: 开启'
  else
    call LogInfo('调试模式已关闭')
    echo '调试模式: 关闭'
  endif
endfunction

" 查看最新日志
function! ViewLatestLog()
  let l:log_files = split(glob(g:vim_log_dir . '/*.log'), '\n')
  if len(l:log_files) > 0
    " 按修改时间排序
    let l:sorted_files = sort(l:log_files, {a, b -> getftime(b) - getftime(a)})
    execute 'edit ' . l:sorted_files[0]
  else
    echo '没有找到日志文件'
  endif
endfunction

" 清理旧日志文件 (保留最近7天)
function! CleanupOldLogs()
  let l:log_files = split(glob(g:vim_log_dir . '/*.log'), '\n')
  let l:now = localtime()
  let l:one_week = 7 * 24 * 60 * 60  " 一周的秒数
  let l:deleted = 0
  
  for l:file in l:log_files
    if l:now - getftime(l:file) > l:one_week
      call delete(l:file)
      let l:deleted += 1
    endif
  endfor
  
  call LogInfo('已删除 ' . l:deleted . ' 个旧日志文件')
  echo '已删除 ' . l:deleted . ' 个旧日志文件'
endfunction

" 强制刷新日志缓冲区
function! FlushLogBuffer()
  call LogInfo('日志缓冲区已手动刷新')
  echo "日志已刷新"
endfunction

" 检查日志系统状态
function! CheckLoggingStatus()
  echo "日志系统状态:"
  echo "  日志级别: " . s:log_level_names[g:vim_log_level]
  echo "  调试模式: " . (g:vim_debug_mode ? "开启" : "关闭")
  echo "  日志文件: " . g:vim_log_file
  echo "  文件大小: " . (filereadable(g:vim_log_file) ? getfsize(g:vim_log_file) . " 字节" : "文件不存在")
  echo "  文件权限: " . (filewritable(g:vim_log_file) ? "可写" : "不可写")
  
  call LogInfo('日志系统状态已检查')
endfunction

" 命令定义
command! -nargs=1 SetLogLevel call SetLogLevel(<args>)
command! ToggleDebugMode call ToggleDebugMode()
command! ViewLatestLog call ViewLatestLog()
command! CleanupOldLogs call CleanupOldLogs()
command! -nargs=1 LogEvent call LogInfo(<q-args>)
command! FlushLog call FlushLogBuffer()
command! LoggingStatus call CheckLoggingStatus()

" 自动命令 - 记录重要事件
augroup vim_logging
  autocmd!
  autocmd VimEnter * call LogInfo('Vim 会话开始')
  autocmd VimLeave * call LogInfo('Vim 会话结束')
  autocmd BufReadPost * call LogDebug('打开文件: ' . expand('%:p'))
  autocmd BufWritePost * call LogDebug('保存文件: ' . expand('%:p'))
  " 添加更多事件监听
  autocmd CursorHold,CursorHoldI * call s:RotateLogFileIfNeeded()
  autocmd BufEnter * call LogDebug('进入缓冲区: ' . expand('%:p'))
  autocmd BufLeave * call LogDebug('离开缓冲区: ' . expand('%:p'))
  autocmd InsertEnter * call LogDebug('进入插入模式: ' . expand('%:p'))
  autocmd InsertLeave * call LogDebug('离开插入模式: ' . expand('%:p'))
augroup END

" 性能监控相关
" 记录命令执行时间的包装函数
function! LoggedCommand(cmd)
  let l:start = reltime()
  execute a:cmd
  call LogCommandTime(a:cmd, l:start)
endfunction

" 记录函数执行时间的包装函数
function! LoggedFunction(func, ...)
  let l:start = reltime()
  let l:result = call(a:func, a:000)
  call LogDebug('函数执行: ' . string(a:func) . ' 耗时 ' . reltimestr(reltime(l:start)) . ' 秒')
  return l:result
endfunction

" 记录当前内存使用情况
function! LogMemoryUsage()
  if exists('*getmemory')
    redir => l:mem_usage
    silent! call getmemory()
    redir END
    call LogInfo('内存使用: ' . trim(l:mem_usage))
  else
    call LogInfo('内存使用: 不支持 getmemory() 函数')
  endif
endfunction

" 定期记录系统状态
function! s:LogSystemStatus()
  call LogDebug('系统状态: ' . len(getbufinfo({'buflisted':1})) . ' 个缓冲区, ' . tabpagenr('$') . ' 个标签页')
  
  " 每10次调用记录一次内存使用情况
  if exists('s:status_counter')
    let s:status_counter += 1
  else
    let s:status_counter = 1
  endif
  
  if s:status_counter % 10 == 0
    call LogMemoryUsage()
  endif
endfunction

" 定期记录系统状态的自动命令
augroup vim_system_logging
  autocmd!
  autocmd CursorHold * call s:LogSystemStatus()
augroup END

" 初始化日志
if !g:vim_log_initialized
  call LogInfo('日志系统初始化完成，日志文件: ' . g:vim_log_file)
  let g:vim_log_initialized = 1
endif

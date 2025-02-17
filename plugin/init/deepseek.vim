" ~/.vim/plugin/deepseek.vim

" ========================
" 配置项（用户可自定义）
" ========================
if !exists('g:deepseek_api_endpoint')
  let g:deepseek_api_endpoint = 'https://api.deepseek.com/v1/chat/completions'
endif

if !exists('g:deepseek_api_key')
  " 优先从环境变量读取，避免明文存储密钥
  let g:deepseek_api_key = $DEEPSEEK_API_KEY
endif

" 结果窗口高度（默认占屏40%）
if !exists('g:deepseek_result_window_height')
  let g:deepseek_result_window_height = float2nr(&lines * 0.4)
endif

" 超时时间（秒）
if !exists('g:deepseek_timeout')
  let g:deepseek_timeout = 30
endif

" ========================
" 核心功能
" ========================
function! s:ValidateConfig() abort
  if empty(g:deepseek_api_key)
    echohl ErrorMsg
    echo "DeepSeek 错误: 未配置 API 密钥！请设置 g:deepseek_api_key 或环境变量 DEEPSEEK_API_KEY"
    echohl None
    return v:false
  endif

  if !executable('curl')
    echohl ErrorMsg
    echo "DeepSeek 错误: 需要 curl 支持，请先安装 curl"
    echohl None
    return v:false
  endif

  return v:true
endfunction

function! deepseek#Ask(prompt, ...) abort
  if !s:ValidateConfig() | return | endif

  " 可选上下文参数（如选中的代码）
  let l:context = get(a:, 1, '')

  " 构建完整提问内容
  let l:full_prompt = a:prompt
  if !empty(l:context)
    let l:full_prompt .= "\n\n上下文：\n" . l:context
  endif

  " 创建唯一请求ID（用于处理并行请求）
  let l:request_id = substitute(reltimestr(reltime()), '\.', '', 'g')

  " 准备请求数据
  let l:request_data = {
    \ 'model': 'deepseek-r1',
    \ 'messages': [{'role': 'user', 'content': l:full_prompt}],
    \ 'temperature': 0.7
  \ }

  " 启动异步任务
  let l:curl_cmd = [
    \ 'curl', '-sS', '-X', 'POST',
    \ '-H', 'Content-Type: application/json',
    \ '-H', 'Authorization: Bearer ' . g:deepseek_api_key,
    \ '--max-time', g:deepseek_timeout,
    \ g:deepseek_api_endpoint,
    \ '-d', json_encode(l:request_data)
  \ ]

  let l:job = job_start(l:curl_cmd, {
    \ 'out_cb': function('s:ResponseHandler', [l:request_id]),
    \ 'err_cb': function('s:ErrorHandler', [l:request_id]),
    \ 'exit_cb': function('s:Cleanup', [l:request_id]),
    \ 'noblock': 1
  \ })

  " 显示等待提示
  call s:CreateResultBuffer(l:request_id)
endfunction

" ========================
" 回调函数
" ========================
function! s:ResponseHandler(request_id, channel, msg) abort
  if !exists('s:responses[a:request_id]')
    let s:responses[a:request_id] = []
  endif
  call add(s:responses[a:request_id], a:msg)
endfunction

function! s:ErrorHandler(request_id, channel, msg) abort
  call s:UpdateResultBuffer(a:request_id, '错误: ' . a:msg, 'error')
endfunction

function! s:Cleanup(request_id, job, status) abort
  if exists('s:responses[a:request_id]')
    " 解析完整响应
    let l:response = json_decode(join(s:responses[a:request_id], ''))

    if type(l:response) == v:t_dict && has_key(l:response, 'choices')
      let l:content = l:response['choices'][0]['message']['content']
      call s:UpdateResultBuffer(a:request_id, l:content)
    else
      call s:UpdateResultBuffer(a:request_id, 'API 响应格式错误', 'error')
    endif

    unlet s:responses[a:request_id]
  endif
endfunction

" ========================
" 缓冲区管理
" ========================
function! s:CreateResultBuffer(request_id) abort
  " 创建临时缓冲区
  execute 'silent! keepalt' g:deepseek_result_window_height . 'split __DeepSeek__'
  setlocal buftype=nofile bufhidden=wipe nobuflisted
  setlocal filetype=markdown
  setlocal wrap

  " 显示等待提示
  call append(0, ['## DeepSeek 思考中...', ''])
  nnoremap <buffer> q :bwipeout<CR>

  " 记录缓冲区与请求的关联
  let s:result_buffers[a:request_id] = bufnr('%')
endfunction

function! s:UpdateResultBuffer(request_id, content, ...) abort
  let l:type = get(a:, 1, 'success')

  if has_key(s:result_buffers, a:request_id)
    let l:bufnr = s:result_buffers[a:request_id]
    if bufexists(l:bufnr)
      execute 'silent! buffer' l:bufnr
      setlocal modifiable
      %delete _

      " 格式化输出
      if l:type ==# 'error'
        call append(0, ['# ❌ 请求出错', '', a:content])
        setlocal syntax=vim
      else
        call append(0, split(a:content, '\n'))
        setlocal syntax=markdown
      endif

      setlocal nomodifiable
      execute 'normal! gg'
    endif
    unlet s:result_buffers[a:request_id]
  endif
endfunction

" ========================
" 用户命令与快捷键
" ========================
" 基础提问命令
command! -nargs=+ -complete=file DSAsk call deepseek#Ask(<q-args>)

" 解释当前选中的代码
vnoremap <silent> <leader>dse :<C-u>call deepseek#Ask("解释这段代码：", GetVisualSelection())<CR>

" 优化当前选中的代码
vnoremap <silent> <leader>dso :<C-u>call deepseek#Ask("优化这段代码：", GetVisualSelection())<CR>

" 获取选区内容
function! GetVisualSelection() abort
  let [l:lnum1, l:col1] = getpos("'<")[1:2]
  let [l:lnum2, l:col2] = getpos("'>")[1:2]
  let l:lines = getline(l:lnum1, l:lnum2)
  if len(l:lines) == 0 | return '' | endif
  let l:lines[-1] = l:lines[-1][: l:col2 - (&selection == 'inclusive' ? 1 : 2)]
  let l:lines[0] = l:lines[0][l:col1 - 1:]
  return join(l:lines, "\n")
endfunction

" ========================
" 初始化
" ========================
let s:responses = {}
let s:result_buffers = {}

" 自动加载检查
if exists('g:loaded_deepseek') | finish | endif
let g:loaded_deepseek = 1

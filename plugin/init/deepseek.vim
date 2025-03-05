vim9script

### [SOLID Principle Implementation] #######################################

### [Configuration Module] ################################################
const DEFAULT_CONFIG = {
    model: "deepseek-reasoner",
    max_tokens: 2048,
    temperature: 0.7,
    base_url: "https://api.deepseek.com/chat/completions",
    max_retries: 3,
    log_level: 4,
    log_file: expand('~/.vim/deepseek.log'),
    shortcuts: {
        inline_complete: '<Leader>dsl',
        generate_block: '<Leader>dg',
        explain_code:   '<Leader>de',
        refactor_code:  '<Leader>dr',
        chat_window:    '<Leader>dc'
    }
}

### [API客户端类修复] #####################################################
class DeepseekClient
    var _config: dict<any> = {} 
    var _retries: dict<number>
    var _requests: dict<dict<any>>
    var _response_buf: dict<string> = {}  # 新增：响应缓冲区

    def new(config: dict<any>)
        if empty(config.api_key)
            throw "必须设置 DEEPSEEK_API_KEY 环境变量"
        endif

        this._config = deepcopy(config)
        this._retries = {}
        this._requests = {}

        Log(4, "构造函数完成", typename(this), this._config.model)
        # return this
    enddef

    def Request(endpoint: string, prompt: string, Callback: func): void
        const req_id = sha256(prompt)[ : 8]
        Log(4, "注册回调", req_id, endpoint)
        this._requests[req_id] = {
            endpoint: endpoint,
            prompt: prompt,
            Callback: (res) => {
                Log(4, "回调执行开始", req_id)
                Callback(res)
                Log(4, "回调执行完成", req_id)
            }
        }
        this.DoRequest(req_id)
    enddef

    def DoRequest(req_id: string)
        this._retries[req_id] += 1
        final req_info = this._requests[req_id]
        Log(4, "发送请求", req_info.endpoint, this._retries[req_id])
        
        try
            final headers = [
                'Authorization: Bearer ' .. this._config.api_key,
                'Content-Type: application/json'
            ]
            
            final data = json_encode({
                model: this._config.model,
                messages: [{role: 'user', content: req_info.prompt}],
                temperature: this._config.temperature,
                max_tokens: this._config.max_tokens,
                stream: false  # 确保非流式响应
            })

            Log(4, "url:", this._config.base_url .. '/' .. req_info.endpoint)
            Log(4, "data:", data)

            # 使用 -o 将响应体输出到 stdout，-w 将状态码输出到 stderr
            job_start([
                'curl',
                '-sS',
                '-w', '%{http_code}',
                '-o', '/dev/stdout',
                '--stderr', '-',  # 将状态码输出到 stderr
                this._config.base_url .. '/' .. req_info.endpoint
            ] + mapnew(headers, (_, v) => '-H ' .. v) + ['-d', data],
            {
                'out_cb': (_, msg) => this.HandleResponse(req_id, msg),
                'err_cb': (_, msg) => this.HandleStatusCode(req_id, msg),  # 新增状态码处理
                'exit_cb': (_, code) => this.HandleExit(req_id, code)
            })

        catch
            Log(1, "请求初始化失败", v:exception)
        endtry
    enddef

    def HandleResponse(req_id: string, msg: string): void
        if !has_key(this._response_buf, req_id)
            this._response_buf[req_id] = ''
        endif
        this._response_buf[req_id] ..= msg

        const sep_pos = stridx(this._response_buf[req_id], '||HTTP_CODE||')
        if sep_pos != -1
            final response_body = strpart(this._response_buf[req_id], 0, sep_pos)
            final http_code = str2nr(strpart(this._response_buf[req_id], sep_pos + 13))

            remove(this._response_buf, req_id)

            if http_code != 200
                Log(1, "请求失败", req_id, "HTTP Code: " .. http_code)
                this._requests[req_id].Callback('')
                return
            endif

            try
                final res = json_decode(response_body)
                if type(res) != type({}) || !has_key(res, 'choices')
                    throw "无效响应格式"
                endif
                this._requests[req_id].Callback(res.choices[0].message.content)
            catch
                Log(1, "响应解析失败", v:exception, "内容: " .. response_body)
            endtry
        endif

    enddef

    # 判断 JSON 是否完整
    def IsJsonComplete(json_str: string): bool
        var stack: list<string> = []
        for char in split(json_str, '\zs')
            if char == '{' || char == '['
                stack->add(char == '{' ? '}' : ']')
            elseif char == '}' || char == ']'
                if stack->empty() || stack[-1] != char
                    return v:false
                endif
                stack->remove(-1)  # 改用 remove(-1)
            endif
        endfor
        return stack->empty()
    enddef

    def HandleStatusCode(req_id: string, msg: string): void
        # 提取状态码（curl 的 -w 输出）
        if msg =~ '^\d\+$'
            final status_code = str2nr(msg)
            if status_code != 200
                Log(2, "HTTP 错误", req_id, status_code)
                this.HandleError(req_id, "HTTP Status: " .. status_code)
            endif
        else
            Log(2, "CURL 错误输出", req_id, msg)
        endif
    enddef
   
    def HandleError(req_id: string, msg: string): void
        if this._retries[req_id] < this._config.max_retries
            Log(2, "重试请求", req_id, this._retries[req_id] + 1)
            this.DoRequest(req_id)
        else
            Log(1, "请求最终失败", req_id, msg)
            this._requests[req_id].Callback('')
            remove(this._retries, req_id)
            remove(this._requests, req_id)
        endif
    enddef

    def HandleExit(req_id: string, code: number): void
        if code != 0
            Log(2, "请求异常退出", req_id, code)
        endif
    enddef
endclass


### [UI Component (Single Responsibility)] #################################
class FloatingWindow
    def Show(content: string): void
        try
            if has('nvim')
                this.ShowNeovimWindow(content)
            else
                this.ShowVimWindow(content)
            endif
        catch
            Log(1, "窗口创建失败", v:exception)
        endtry
    enddef

    def ShowNeovimWindow(content: string): void
        final buf = nvim_create_buf(v:false, v:true)
        final lines = split(content, "\n")
        final opts = {
            relative: 'cursor',
            row: 2,
            col: 0,
            width: min([winwidth(0) - 4, 80]),
            height: min([len(lines) + 2, 15]),
            style: 'minimal',
            border: 'single'
        }
        final winid = nvim_open_win(buf, v:true, opts)
        setbufline(buf, 1, lines)
        autocmd WinLeave <buffer> ++once nvim_win_close(winid, v:true)
    enddef

    def ShowVimWindow(content: string): void
        pedit DeepSeek
        wincmd P
        setlocal buftype=nofile
        setline(1, split(content, "\n"))
    enddef

    def ShowLoading()
        if has('nvim')
            final buf = nvim_create_buf(v:false, v:true)
            nvim_buf_set_lines(buf, 0, -1, v:true, ['加载中 ⠋'])
            final opts = {
                relative: 'cursor',
                row: 1,
                col: 0,
                width: 10,
                height: 1,
                style: 'minimal'
            }
            self.winid = nvim_open_win(buf, v:true, opts)
            self._loading_timer = timer_start(100, (-> UpdateLoading()), {'repeat': -1})
        else
            echo "处理中..."
        endif
    enddef

    def UpdateLoading()
        if !nvim_win_is_valid(self.winid) | return | endif
        final frames = ['⠋', '⠙', '⠹', '⠸', '⠼', '⠴']
        final idx = (reltime()[1] / 1000000) % len(frames)
        nvim_buf_set_lines(nvim_win_get_buf(self.winid), 0, -1, v:true, ['加载中 ' .. frames[idx]])
    enddef

    def CloseLoading()
        if self._loading_timer != -1
            timer_stop(self._loading_timer)
            self._loading_timer = -1
        endif
        if nvim_win_is_valid(self.winid)
            nvim_win_close(self.winid, v:true)
        endif
    enddef

endclass

### [Script Scope Variables (严格格式)] ##################################
var client: DeepseekClient = null_object
var ui: FloatingWindow = null_object


### [延迟初始化逻辑] #####################################################
def InitUI()
    if ui is null_object
        ui = FloatingWindow.new()
    endif
enddef


### [Logger Module (Single Responsibility)] ###############################
def Log(level: number, msg: string, ...extra: list<any>): void
    final config = get(g:, 'deepseek_config', DEFAULT_CONFIG)
    if level > config.log_level | return | endif

    const LEVELS = ['', 'ERROR', 'WARN', 'INFO', 'DEBUG']
    final timestamp = strftime('%Y-%m-%d %H:%M:%S')
    final logMsg = printf("[%s][%s] %s %s",
        LEVELS[level],
        timestamp,
        msg,
        string(extra)
    )

    try
        if !empty(config.log_file)
            final logDir = fnamemodify(config.log_file, ':h')
            if !isdirectory(logDir)
                mkdir(logDir, 'p', 0o755)
            endif
            writefile([logMsg], config.log_file, 'a')
        endif
    catch
        echohl ErrorMsg
        echomsg "日志写入失败: " .. v:exception
        echohl None
    endtry

    if level <= 2
        echohl level == 1 ? 'ErrorMsg' : 'WarningMsg'
        echomsg logMsg
        echohl None
    endif
enddef

### [Dependency Inversion: Config Loader] ##################################
def LoadConfig(): dict<any>
    try
        final user_config = get(g:, 'deepseek_config', {})
        final merged = deepcopy(DEFAULT_CONFIG)
        extend(merged, user_config, 'force')
        
        # 配置验证
        merged.api_key = trim(getenv('DEEPSEEK_API_KEY') ?? '')
        if empty(merged.api_key)
            throw "DEEPSEEK_API_KEY 环境变量未设置"
        endif
        if merged.max_retries < 0 || merged.max_retries > 5
            throw "最大重试次数需在0-5之间"
        endif
        
        return merged
    catch
        Log(1, "配置加载失败", v:exception)
        return {}
        # throw v:exception
    endtry
enddef


### [Business Logic (Liskov Substitution)] #################################
def GetVisualSelection(): string
    try
        # 获取可视模式选择范围
        var start_pos = getpos("'<")
        var end_pos = getpos("'>")
        var sline = start_pos[1]
        var scol = start_pos[2]
        var eline = end_pos[1]
        var ecol = end_pos[2]

        # 处理多行文本
        var lines = getline(sline, eline)
        if empty(lines)
            return ''
        endif

        # 逐行裁剪文本
        var selected_lines = lines->mapnew((_, line, idx: number) => {
            if idx == 0
                # 首行从 scol 开始截取
                return line[scol - 1 : ]
            elseif idx == len(lines) - 1
                # 末行截取到 ecol 前
                return line[: ecol - (mode() ==# 'v' ? 1 : 2)]
            else
                return line
            endif
        })

        return join(selected_lines, "\n")
    catch
        Log(2, "获取选中文本失败", v:exception)
        return ''
    endtry
enddef

### [Feature Implementations] ##############################################
export def InlineComplete(): void
    if client is null_object
        Log(2, "服务未就绪")
        return
    endif
    client.Request('completions', getline('.'), (res) => feedkeys(res, 'ni'))
enddef


export def ExplainCode(): void
    InitUI()
    ui.ShowLoading()

    final code = GetVisualSelection()
    if empty(code)
        echohl ErrorMsg | echomsg "[Deepseek] 请先选择代码" | echohl None
        ui.CloseLoading()
        return
    endif
    
    client.Request('chat', "解释代码:\n" .. code, (res) => {
        ui.CloseLoading()
        if !empty(res)
            final formatted = "# 代码解释\n```" .. &filetype .. "\n" .. code .. "\n```\n" .. res
            ui.Show(formatted)
        endif
    })
enddef

### [补全功能实现] ######################################################
export def GenerateBlock(): void
    final desc = input("功能描述: ")
    client.Request('chat', desc, (res) => HandleResult(res, "生成代码块"))
enddef


def HandleResult(res: string, action: string): void
    if empty(res)
        echohl WarningMsg | echomsg $"[Deepseek] {action} 无结果" | echohl None
        return
    endif

    # 自动检测代码块
    if res =~ '```'
        ui.Show(res)
        echohl MoreMsg | echomsg $"[Deepseek] {action} 完成，按 q 关闭窗口" | echohl None
    else
        # 直接插入到缓冲区
        final saved_reg = @a
        @a = res
        execute "normal! \"ap"
        @a = saved_reg
        echohl MoreMsg | echomsg $"[Deepseek] {action} 已完成" | echohl None
    endif
enddef


export def RefactorCode(): void
    InitUI()
    final code = GetVisualSelection()
    if empty(code) | return | endif
    
    client.Request('chat', "重构代码:\n" .. code, (res) => {
        ui.Show("# 重构建议\n" .. res)
    })
enddef

export def OpenChatWindow(): void
    InitUI()
    final prompt = input("Chat with Deepseek: ")
    if empty(prompt) | return | endif
    
    client.Request('chat', prompt, (res) => {
        ui.Show("# Deepseek 回答\n" .. res)
    })
enddef


### [初始化流程强化] #################################################
def Initialize()
    try
        client = null_object
        ui = null_object

        final config = LoadConfig()
        client = DeepseekClient.new(config)
        
        # 延迟UI初始化
        # if ui is null_object
        #     ui = FloatingWindow.new()
        # endif
        InitUI()

        SetupKeymaps(config.shortcuts)
        Log(3, "系统初始化完成")
    catch
        Log(1, "初始化失败: " .. v:exception)
        # 确保失败后保持合法null类型
        client = null_object
        ui = null_object
    endtry
enddef


def SetupKeymaps(shortcuts: dict<string>): void
    final mappings = [
        # 原有映射
        { 'mode': 'i', 'key': shortcuts.inline_complete, 'cmd': 'InlineComplete' },
        { 'mode': 'x', 'key': shortcuts.explain_code,   'cmd': 'ExplainCode' },
        
        # 新增映射
        { 'mode': 'n', 'key': shortcuts.generate_block, 'cmd': 'GenerateBlock' },
        { 'mode': 'x', 'key': shortcuts.refactor_code,   'cmd': 'RefactorCode' },
        { 'mode': 'n', 'key': shortcuts.chat_window,     'cmd': 'OpenChatWindow' }
    ]

    for map in mappings
        # 修复模式标识符 (i/n/x 需要转换为正确的 map 命令)
        final map_cmd = map.mode == 'i' ? 'i' :
                      map.mode == 'n' ? 'n' :
                      'x'

        execute printf('%snoremap <silent> <script> %s <ScriptCmd>%s()<CR>',
                      map_cmd, map.key, map.cmd)
    endfor
    Log(4, "快捷键映射完成", shortcuts)
enddef

### [Main Entry Point] ##################################################
augroup DeepseekPlugin
    autocmd!
    autocmd VimEnter * Initialize()
augroup END

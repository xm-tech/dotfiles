vim9script

### [SOLID Principle Implementation] #######################################

### [Configuration Module] ################################################
const DEFAULT_CONFIG = {
    model: "deepseek-r1",
    max_tokens: 2048,
    temperature: 0.7,
    base_url: "https://api.deepseek.com/v1",
    max_retries: 3,
    log_level: 2,
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
        const req_id = sha256(prompt)[ :8 ]
        this._retries[req_id] = 0
        this._requests[req_id] = {
            endpoint: endpoint,
            prompt: prompt,
            Callback: Callback
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
                max_tokens: this._config.max_tokens
            })

            job_start(['curl', '-sS', this._config.base_url .. '/' .. req_info.endpoint] +
                      mapnew(headers, (_, v) => '-H ' .. v) +
                      ['-d', data],
                      {
                          'out_cb': (_, msg) => this.HandleResponse(req_id, msg),
                          'err_cb': (_, msg) => this.HandleError(req_id, msg),
                          'exit_cb': (_, code) => this.HandleExit(req_id, code)
                      })
        catch
            Log(1, "请求初始化失败", v:exception)
        endtry
    enddef

    def HandleResponse(req_id: string, msg: string): void
        try
            var res = json_decode(msg)
            if !has_key(res, 'choices')
                throw printf("无效响应格式: %s", string(res))
            endif
            this._requests[req_id].Callback(res.choices[0].message.content)
            Log(3, "请求成功", req_id)
        catch
            Log(1, "响应解析失败", v:exception, "原始内容: " .. msg)
        finally
            remove(this._retries, req_id)
            remove(this._requests, req_id)
        endtry
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
        let [_, sline, scol, _] = getpos("'<")
        let [_, eline, ecol, _] = getpos("'>")
        return join(getline(sline, eline)->map((i, l) => 
            i == 0 ? l[scol - 1 :] :
            i == eline - sline ? l[: ecol - 1] : l), "\n")
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
    InitUI()  # 确保UI已初始化

    final code = GetVisualSelection()
    if empty(code) | return | endif
    
    client.Request('chat', "解释代码:\n" .. code, (res) => {
        ui.Show("# 代码解释\n" .. res)
    })
enddef

### [补全功能实现] ######################################################
export def GenerateBlock(): void
    if client is null_object
        Log(2, "服务未就绪")
        return
    endif
    
    final code = input("输入功能描述: ")
    if empty(code) | return | endif

    client.Request('chat', "生成代码块:\n" .. code, (res) => {
        append('.', split(res, "\n"))
    })
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
        if ui is null_object
            ui = FloatingWindow.new()
        endif

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

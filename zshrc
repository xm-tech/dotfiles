# Amazon Q 预加载块。保持在文件顶部。
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh"

# 启用 Powerlevel10k 即时提示。应该保持在 ~/.zshrc 的顶部附近。
# 可能需要控制台输入（密码提示，[y/n]确认等）的初始化代码必须放在此块之上；其他内容可以放在下面。
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# 替换 Homebrew 核心仓库 - 使用异步加载方式以避免启动延迟
{
  export HOMEBREW_API_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles/api"
  export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles"
  export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.ustc.edu.cn/brew.git"
  export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.ustc.edu.cn/homebrew-core.git"
  export HOMEBREW_PIP_INDEX_URL="https://pypi.mirrors.ustc.edu.cn/simple"
  export HOMEBREW_INSTALL_FROM_API=1
  # 加速 ARM64 架构编译
  export HOMEBREW_FORCE_BREWED_CURL=1
  export HOMEBREW_NO_INSTALL_FROM_API=1
} &!

# 立即加载必要的交互式工具（这些工具对交互体验影响较大）
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh
[[ -f ~/.fzf-git.sh ]] && source ~/.fzf-git.sh

# 加载 zinit 插件管理器
[[ -r ~/.zinit-load.zsh ]] && source ~/.zinit-load.zsh

# 立即加载别名和函数（这些对交互式使用很重要）
[[ -r ~/.zsh_private ]] && source ~/.zsh_private
[[ -r ~/.aliases.zsh ]] && source ~/.aliases.zsh
[[ -r ~/.funcs.zsh ]] && source ~/.funcs.zsh
[[ -r ~/.git.zsh ]] && source ~/.git.zsh

# 设置 Go 环境变量（直接加载以确保立即生效）
export GO111MODULE=on
export GOPROXY=https://goproxy.cn,direct
export GOPRIVATE=qwy.com
export GOINSECURE=qwy.com
export GONOSUMDB=qwy.com
export GONOPROXY=qwy.com

# 异步加载不影响启动速度的其他配置文件
{
  
  # 设置可执行权限
  [[ -f ~/.cht.sh ]] && chmod +x ~/.cht.sh
  [[ -f ~/.ccls_load.sh ]] && chmod +x ~/.ccls_load.sh
  
  # 敏感信息应该放在私有文件中，这里仅作为示例
  # 建议将此行移至 ~/.zsh_private 文件
  # export DEEPSEEK_API_KEY="your-api-key-here"
  
  # git 自动补全
  autoload -U compinit; compinit -u
  
  # hub 别名设置
  which hub > /dev/null && eval "$(hub alias -s)"
} &!

# 延迟加载 z.lua（使用更高效的方式）
if [[ -f ~/.z.lua ]]; then
  # 直接加载 z.lua，但使用更高效的参数
  eval "$(lua ~/.z.lua --init zsh once enhanced)"
fi

# 延迟加载 pyenv（仅在需要时加载）
if which pyenv-virtualenv-init > /dev/null; then
  _load_pyenv() {
    eval "$(pyenv virtualenv-init -)"
  }
  # 在第一次使用 python 相关命令时加载
  python() {
    unfunction python
    _load_pyenv
    python "$@"
  }
  pip() {
    unfunction pip
    _load_pyenv
    pip "$@"
  }
  pyenv() {
    unfunction pyenv
    _load_pyenv
    pyenv "$@"
  }
fi

# 自定义提示符，运行 `p10k configure` 或编辑 ~/.p10k.zsh
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# 检查代理是否可用，再设置环境变量
if nc -z -w 2 127.0.0.1 1087 &>/dev/null; then
  export http_proxy=http://127.0.0.1:1087
  export https_proxy=http://127.0.0.1:1087
fi

# Amazon Q 后加载块。保持在文件底部。
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh"

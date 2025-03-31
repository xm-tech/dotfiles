# Amazon Q pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh"
# 设置 FUNCNEST 以避免嵌套函数调用过深的问题
FUNCNEST=500

# 启用 zprof 性能分析
# zmodload zsh/zprof

# 优化自动建议插件的性能
export ZSH_AUTOSUGGEST_MANUAL_REBIND=1  # 减少重新绑定的频率
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20  # 限制处理的缓冲区大小
export ZSH_AUTOSUGGEST_USE_ASYNC=1  # 确保使用异步模式

# Amazon Q 预加载块
# 设置关键环境变量
export GO111MODULE=on
export GOPROXY=https://goproxy.cn,direct
export GOPRIVATE=qwy.com
export GOINSECURE=qwy.com
export GONOSUMDB=qwy.com
export GONOPROXY=qwy.com

# 加载代理配置（从单独的文件中加载）
# [[ -f ~/.proxy.zsh ]] && source ~/.proxy.zsh

# 设置 Homebrew 环境变量
export HOMEBREW_API_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles/api"
export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles"
export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.ustc.edu.cn/brew.git"
export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.ustc.edu.cn/homebrew-core.git"
export HOMEBREW_PIP_INDEX_URL="https://pypi.mirrors.ustc.edu.cn/simple"
export HOMEBREW_INSTALL_FROM_API=1
export HOMEBREW_FORCE_BREWED_CURL=1

# dotnet cnf
export DOTNET_ROOT="/usr/local/share/dotnet"


# 临时禁用 zinit，使用基本的 zsh 配置
if [[ -f ~/.local/share/zinit/zinit.git/zinit.zsh ]]; then
  source ~/.local/share/zinit/zinit.git/zinit.zsh
#   
  # 加载 zinit 插件配置
  [[ -f ~/.zinit-load.zsh ]] && source ~/.zinit-load.zsh
fi

# 加载 z.lua
if [[ -f ~/.z.lua ]]; then
  eval "$(lua ~/.z.lua --init zsh once enhanced)"
fi

# 延迟加载 pyenv
if which pyenv-virtualenv-init > /dev/null; then
  _load_pyenv() {
    eval "$(pyenv virtualenv-init -)"
  }
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

# 异步加载其他配置
{
  # 设置可执行权限
  [[ -f ~/.cht.sh ]] && chmod +x ~/.cht.sh
  
  # hub 别名设置已移除，使用原生 git
} &!

# 优化 zsh 内置功能
{
  # 减少历史记录的处理开销
  HISTSIZE=5000
  SAVEHIST=5000
  setopt HIST_EXPIRE_DUPS_FIRST
  setopt HIST_IGNORE_ALL_DUPS
  setopt HIST_FIND_NO_DUPS
  setopt HIST_SAVE_NO_DUPS
  
  # 减少目录堆栈的开销
  DIRSTACKSIZE=5
  setopt AUTO_PUSHD
  setopt PUSHD_IGNORE_DUPS
  setopt PUSHD_SILENT
} &!

# 直接加载常用别名和函数，不通过 zinit
# [[ -f ~/.aliases.zsh ]] && source ~/.aliases.zsh
# [[ -f ~/.funcs.zsh ]] && source ~/.funcs.zsh
# [[ -f ~/.git.zsh ]] && source ~/.git.zsh
# [[ -f ~/.proxy.zsh ]] && source ~/.proxy.zsh

# Amazon Q 后加载块
# 保留 zprof 以便查看优化效果
# zprof

# Conda initialization has been moved to funcs.zsh
# Use the conda_init function when you need conda

# Amazon Q post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh"

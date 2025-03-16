# Amazon Q pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh"
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# 替换核心仓库
export HOMEBREW_API_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles/api"
export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles"
export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.ustc.edu.cn/brew.git"
export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.ustc.edu.cn/homebrew-core.git"
export HOMEBREW_PIP_INDEX_URL="https://pypi.mirrors.ustc.edu.cn/simple"
export HOMEBREW_INSTALL_FROM_API=1
# 加速 ARM64 架构编译
export HOMEBREW_FORCE_BREWED_CURL=1
export HOMEBREW_NO_INSTALL_FROM_API=1

# begin
[[ -r ~/.zsh_private ]] && source ~/.zsh_private
[[ -r ~/.aliases.zsh ]] && source ~/.aliases.zsh
[[ -r ~/.funcs.zsh ]] && source ~/.funcs.zsh
[[ -r ~/.antigen.zsh ]] && source ~/.antigen.zsh
[[ -r ~/.git.zsh ]] && source ~/.git.zsh
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh
[[ -f ~/.fzf-git.sh ]] && source ~/.fzf-git.sh
[[ -f ~/.cht.sh ]] && chmod +x ~/.cht.sh
[[ -f ~/.ccls_load.sh ]] && chmod +x ~/.ccls_load.sh
[[ -f ~/.z.lua ]] && eval "$(lua ~/.z.lua  --init zsh once enhanced)"
# use antigen to manage the zsh plugins
[[ -f ~/.antigen-load.zsh ]] && [[ -f ~/.antigen.zsh ]] && source ~/.antigen-load.zsh 
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi

export GO111MODULE=on
export GOPROXY=https://goproxy.cn,direct
export GOPRIVATE=qwy.com
export GOINSECURE=qwy.com
export GONOSUMDB=qwy.com
export GONOPROXY=qwy.com

# deepseek FIXME place in private file
export DEEPSEEK_API_KEY="sk-8106de4b845646d5aafb10ff3a1da961"

# fix fpath
# fpath=(/opt/homebrew/share/zsh/site-functions $fpath)

# git autocomplete supplied by zsh
autoload -U compinit; compinit -u

eval "$(hub alias -s)"

# Amazon Q post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh"

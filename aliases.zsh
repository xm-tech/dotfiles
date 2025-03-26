# ==================
# 	alias
# ==================
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias ~="cd ~"
alias -- -="cd -"
alias g=git
alias ga='git add'
alias gb='git branch'
alias gbr='git branch -r'
alias gbrv='git branch -r -v'
alias gbv='git branch -v'
alias gbvv='git branch -vv'
alias gc='git checkout'
alias gcb='git checkout -b'
alias gcm='git commit -m '
alias gcmb='git commit -m "build" '
# alias gd='git diff'
alias gd='git di'
alias gdc='git diff --cached'
# alias git=hub  # 已移除 hub 依赖，使用原生 git
alias gl='git log --all --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit --date=relative'
alias glp='gl -p'
alias gp='git push'
alias gpl='git pull'
alias gr='git remote'
alias grv='git remote -vv'
alias gs='git status -sb'
alias gm='git merge'
alias gmt='git mergetool'
alias gca='git commit --amend'
alias ls='ls -GpF'
alias l='ls -lh'
alias ll='ls -alGpF'
alias mvn-gen='sh ~/mvn-gen.sh'
alias of='open -a Finder ./'
alias run-help=man
alias vi='vim -p'
alias which-command=whence
# cd into git root dir
alias cdr='cd $(git rev-parse --show-toplevel)'
# show
alias duh='du -sh -h * .[^.]* 2> /dev/null | sort -h'
alias week='date +%v'
alias unixtime='date +%s'
alias sed='gsed'

# 轻量级 vim 模式，适用于大文件或性能受限环境
alias lvim='vim -c "LightMode"'

# 无插件模式的 vim，适用于极端情况
alias pvim='vim -u NONE'

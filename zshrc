# begin
[ -r ~/.zsh_private ] && source ~/.zsh_private
[ -r ~/.aliases.zsh ] && source ~/.aliases.zsh
[ -r ~/.funcs.zsh ] && source ~/.funcs.zsh
[ -r ~/.zplug.zsh ] && source ~/.zplug.zsh
[ -r ~/.git.zsh ] && source ~/.git.zsh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f /usr/local/etc/profile.d/fzf-git.sh ] && source /usr/local/etc/profile.d/fzf-git.sh
[ -f /usr/local/etc/profile.d/z.lua ] && eval "$(lua /usr/local/etc/profile.d/z.lua  --init zsh once enhanced)"

eval "$(jump shell)"
if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi

export PATH="/usr/local/opt/go@1.18/bin:$PATH"

export GO111MODULE=on
export GOPROXY=https://goproxy.cn

export PATH="/usr/local/opt/openjdk/bin:$PATH"
export PATH="$PATH:$(go env GOPATH)/bin"
export CPPFLAGS="-I/usr/local/opt/openjdk/include"
export PATH="/usr/local/sbin:$PATH"

eval "$(hub alias -s)"
# autoload -U compinit; compinit
# /usr/local/bin/git-tip

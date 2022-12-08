# begin
[ -r ~/.zsh_private ] && source ~/.zsh_private
[ -r ~/.aliases.zsh ] && source ~/.aliases.zsh
[ -r ~/.funcs.zsh ] && source ~/.funcs.zsh
[ -r ~/.zplug.zsh ] && source ~/.zplug.zsh
[ -r ~/.git.zsh ] && source ~/.git.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f ~/.fzf-git.sh ] && source ~/.fzf-git.sh
[ -f ~/.cht.sh ] && chmod +x ~/.cht.sh
[ -f ~/.z.lua ] && eval "$(lua ~/.z.lua  --init zsh once enhanced)"

if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi

export GO111MODULE=on
export GOPROXY=https://goproxy.cn

export PATH="/usr/local/opt/openjdk/bin:$PATH"
export PATH="$PATH:$(go env GOPATH)/bin"
export CPPFLAGS="-I/usr/local/opt/openjdk/include"
export PATH="/usr/local/sbin:$PATH"

eval "$(hub alias -s)"
# git autocomplete supplied by zsh
autoload -U compinit; compinit

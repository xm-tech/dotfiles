# Senstive functions which are not pushed to Github
# It contains GOPATH, some functions, aliases etc...
[ -r ~/.zsh_private ] && source ~/.zsh_private

[ -r ~/.aliases.zsh ] && source ~/.aliases.zsh

[ -r ~/.funcs.zsh ] && source ~/.funcs.zsh

## use vimdiff as default merge tool
git config --global merge.tool vimdiff
git config --global mergetool.prompt false
git config --global merge.conflictstyle diff3

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# [ -f /usr/local/etc/profile.d/z.sh ] && source /usr/local/etc/profile.d/z.sh
[ -f /usr/local/etc/profile.d/fzf-git.sh ] && source /usr/local/etc/profile.d/fzf-git.sh

[ -f /usr/local/etc/profile.d/z.lua ] && eval "$(lua /usr/local/etc/profile.d/z.lua  --init zsh once enhanced)"

# brew install jump
eval "$(jump shell)"
if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi

# export PATH="/usr/local/Cellar/go/1.18.4/bin:$PATH"
export PATH="/usr/local/opt/go@1.18/bin:$PATH"

export GO111MODULE=on
export GOPROXY=https://goproxy.cn
# export GOPROXY=https://goproxy.io
# set this env when your private module cannot be import
# export GOPRIVATE=github.com/xm-tech/go-demo

# export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
# export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
# export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"
# export PATH="/usr/local/sbin:$PATH"

export PATH="/usr/local/opt/openjdk/bin:$PATH"
export PATH="$PATH:$(go env GOPATH)/bin"
export CPPFLAGS="-I/usr/local/opt/openjdk/include"
export PATH="/usr/local/sbin:$PATH"



export ZPLUG_HOME=/usr/local/opt/zplug
source $ZPLUG_HOME/init.zsh


# zplug plugins
# zplug "romkatv/powerlevel10k", as:theme, depth:1
zplug 'zplug/zplug', hook-build:'zplug --self-manage'
# zplug "zsh-users/zsh-completions"
# zplug "zsh-users/zsh-history-substring-search"
zplug "zsh-users/zsh-autosuggestions"
# zplug "zdharma/fast-syntax-highlighting"
# zplug "zpm-zsh/ls"
# zplug "plugins/docker", from:oh-my-zsh
# zplug "plugins/composer", from:oh-my-zsh
# zplug "plugins/extract", from:oh-my-zsh
# zplug "lib/completion", from:oh-my-zsh
# zplug "plugins/sudo", from:oh-my-zsh
# zplug "b4b4r07/enhancd", use:init.sh

# Install packages that have not been installed yet
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    else
        echo
    fi
fi
zplug load

eval "$(hub alias -s)"
# autoload -U compinit; compinit
# /usr/local/bin/git-tip

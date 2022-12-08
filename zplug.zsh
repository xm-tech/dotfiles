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

export ZPLUG_HOME=/usr/local/opt/zplug
source $ZPLUG_HOME/init.zsh

# zplug plugins
zplug 'zplug/zplug', hook-build:'zplug --self-manage'
# zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-autosuggestions"

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

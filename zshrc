# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

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
export GOPROXY=https://goproxy.cn

# git autocomplete supplied by zsh
autoload -U compinit; compinit

eval "$(hub alias -s)"

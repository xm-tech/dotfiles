# 加载 zinit

if [[ -f ~/.local/share/zinit/zinit.git/zinit.zsh ]]; then
  source ~/.local/share/zinit/zinit.git/zinit.zsh
  autoload -Uz _zinit
  (( ${+_comps} )) && _comps[zinit]=_zinit
  
  # 快速加载 powerlevel10k 主题
  zinit ice depth=1
  zinit light romkatv/powerlevel10k
  
  # 延迟加载自动建议插件（按下键盘才加载）
  zinit ice wait lucid atload'_zsh_autosuggest_start'
  zinit light zsh-users/zsh-autosuggestions
  
  # 延迟加载语法高亮插件
  zinit ice wait lucid
  zinit light zdharma-continuum/fast-syntax-highlighting
fi

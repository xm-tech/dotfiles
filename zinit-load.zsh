# zinit 插件管理器配置文件

# 使用 Starship 提示工具
zinit ice as"command" from"gh-r" \
  atclone"./starship init zsh > init.zsh; ./starship completions zsh > _starship" \
  atpull"%atclone" src"init.zsh"
zinit light starship/starship

# 使用 turbo 模式延迟加载插件，并优化自动建议插件
zinit ice wait'2' lucid atload'_zsh_autosuggest_start'
zinit light zsh-users/zsh-autosuggestions

# 优化语法高亮插件
zinit ice wait'2' lucid
zinit light zdharma-continuum/fast-syntax-highlighting

# 延迟加载 fzf
[[ -f ~/.fzf.zsh ]] && {
  zinit ice wait'3' lucid
  zinit snippet ~/.fzf.zsh
}

# 延迟加载 fzf-git
[[ -f ~/.fzf-git.sh ]] && {
  zinit ice wait'3' lucid
  zinit snippet ~/.fzf-git.sh
}

# 延迟加载自动补全，并优化补全系统
zinit ice wait'3' lucid atinit'
  zstyle ":completion:*:commands" rehash 1
  zstyle ":completion:*" accept-exact "*(N)"
  zstyle ":completion:*" use-cache on
  zstyle ":completion:*" cache-path "$HOME/.zcompcache"
  zicompinit
  zicdreplay
'
# 注释掉 Oh-My-Zsh 的 git 插件，暂时不加载
# zinit snippet OMZP::git

# 延迟加载常用别名和函数
[[ -f ~/.aliases.zsh ]] && {
  zinit ice wait'2' lucid
  zinit snippet ~/.aliases.zsh
}

[[ -f ~/.funcs.zsh ]] && {
  zinit ice wait'2' lucid
  zinit snippet ~/.funcs.zsh
}

[[ -f ~/.git.zsh ]] && {
  zinit ice wait'2' lucid
  zinit snippet ~/.git.zsh
}

# 延迟加载私有配置
[[ -r ~/.zsh_private ]] && {
  zinit ice wait'2' lucid
  zinit snippet ~/.zsh_private
}


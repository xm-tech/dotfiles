# Vim 性能优化

## 问题
Vim 编辑器界面有时会卡住，特别是在处理大文件或使用某些插件时，在 tmux 环境下尤为明显。

## 解决方案
创建了专门的性能优化配置文件 `vim/config/performance.vim`，并在 `vimrc` 中加载它。同时优化了 tmux 配置以提高 Vim 在 tmux 中的性能。

### 主要优化内容

#### Vim 优化
1. 禁用不必要的功能（备份、交换文件、撤销文件）
2. 减少更新时间以获得更快的响应
3. 对大文件禁用语法高亮
4. 对大文件禁用某些插件
5. 优化语法高亮设置
6. 优化 coc.nvim 设置
7. 优化 gutentags 设置，减少不必要的标签生成
8. 优化 LeaderF 设置
9. 减少 vim-go 的高亮特性
10. 禁用 markdown 折叠功能
11. 使用更高效的正则引擎
12. 解决配置文件之间的冲突
13. 添加性能模式切换命令

#### tmux 环境下的 Vim 优化
1. 设置 `ttymouse=xterm2` 改善鼠标支持
2. 设置 `ttimeoutlen=10` 减少按键延迟
3. 启用 `lazyredraw` 减少屏幕重绘
4. 禁用光标行、光标列和相对行号
5. 在 tmux 中增加更新时间以减少屏幕更新频率

#### tmux 配置优化
1. 设置 `terminal-overrides` 以支持 256 色和真彩色
2. 设置 `escape-time 10` 减少 ESC 键延迟
3. 确保 `focus-events on` 已启用

## 使用方法
无需特殊操作，优化已集成到 Vim 和 tmux 配置中。如果仍然遇到性能问题，可以使用以下命令切换到性能模式：

```vim
:TogglePerformanceMode  " 切换性能模式
:LightMode              " 直接启用轻量模式
```

## 其他建议
- 对于非常大的文件，考虑使用 `vim -u NONE` 或 `vim --noplugin` 启动 Vim
- 使用 `:profile` 命令可以帮助识别导致性能问题的插件或设置
- 在 tmux 中使用 Vim 时，如果仍然遇到性能问题，可以尝试使用 Neovim 替代
- 使用 `:LoadAllCocExtensions` 命令按需加载所有 coc 扩展

## 最近优化
1. 解决了 undofile 设置冲突
2. 完全禁用了 gutentags 以提高性能
3. 减少了默认加载的 coc 扩展数量
4. 优化了 coc-settings.json 配置
5. 调整了插件加载顺序，确保性能优化先于其他设置应用
6. 添加了性能模式切换命令，方便在需要时快速禁用耗资源的功能

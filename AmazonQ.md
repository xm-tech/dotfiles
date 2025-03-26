# Vim 性能优化指南

## 问题背景
Vim 编辑器在以下情况可能会出现卡顿：
- 处理大型文件时
- 使用资源密集型插件时
- 在 tmux 环境下运行时

## 优化方案

### 核心优化
我们创建了专用的性能优化配置文件 `vim/config/performance.vim`，并在 `vimrc` 中加载它。同时优化了 tmux 配置以提高 Vim 在 tmux 中的性能。

#### Vim 核心优化
- ✅ 禁用不必要功能：备份文件、交换文件、撤销文件
- ✅ 减少更新时间提高响应速度
- ✅ 大文件自动禁用语法高亮
- ✅ 大文件自动禁用耗资源插件
- ✅ 使用更高效的正则引擎
- ✅ 解决配置文件间的冲突

#### 插件优化
- ✅ 优化 coc.nvim 设置
- ✅ 优化 gutentags 设置，减少标签生成
- ✅ 优化 LeaderF 设置
- ✅ 减少 vim-go 的高亮特性
- ✅ 禁用 markdown 折叠功能

#### tmux 环境优化
- ✅ 设置 `ttymouse=xterm2` 改善鼠标支持
- ✅ 设置 `ttimeoutlen=10` 减少按键延迟
- ✅ 启用 `lazyredraw` 减少屏幕重绘
- ✅ 禁用光标行、光标列和相对行号
- ✅ 增加更新时间减少屏幕刷新频率
- ✅ 设置 `terminal-overrides` 支持 256 色和真彩色
- ✅ 设置 `escape-time 10` 减少 ESC 键延迟
- ✅ 启用 `focus-events on`

## 使用指南

### 性能模式快捷键
| 快捷键/命令 | 功能 |
|------------|------|
| `<leader>tp` | 切换性能模式（禁用语法高亮和 coc） |
| `<leader>em` | 启用紧急模式（严重卡顿时使用） |
| `:TogglePerformanceMode` | 切换性能模式 |
| `:LightMode` | 直接启用轻量模式 |

### 特殊启动方式
- `lvim` - 启动轻量模式的 Vim
- `pvim` - 启动无插件的 Vim（极端情况使用）
- `vim -u NONE` - 不加载任何配置启动 Vim
- `vim --noplugin` - 不加载插件启动 Vim

### 性能调试技巧
- 使用 `:profile` 命令识别性能瓶颈
- 使用 `:LoadAllCocExtensions` 按需加载 coc 扩展

## 最近优化更新
1. 解决 undofile 设置冲突
2. 完全禁用 gutentags 提高性能
3. 减少默认加载的 coc 扩展数量
4. 优化 coc-settings.json 配置
5. 调整插件加载顺序，确保性能优化先于其他设置
6. 添加性能模式切换命令
7. 添加紧急模式快捷键 (`<leader>em`)
8. 添加轻量级启动别名 (lvim) 和无插件启动别名 (pvim)
9. 增强 LightMode 命令，禁用更多耗资源功能
10. 移除默认加载的 coc-vimlsp 和 coc-rust-analyzer
11. 将性能模式切换键从 F8 改为 `<leader>tp`，避免与 macOS 快捷键冲突
12. 移除 vim-fugitive 插件减少加载时间
13. 移除 ack.vim 插件及相关命令，使用 LeaderF 替代
14. 优化 starship 加载方式，使用本地缓存避免网络请求
15. 移除 hub 依赖，使用原生 git 命令

## 卡顿应急处理
如果 Vim 严重卡顿无法操作：
1. 按 `<leader>em` 启用紧急模式
2. 如无响应，在另一终端执行 `pkill -9 vim`
3. 在 tmux 中，按 `Ctrl-q`（tmux 前缀键）然后按 `x` 关闭窗格
4. 下次编辑同一文件时使用 `lvim` 或 `pvim`

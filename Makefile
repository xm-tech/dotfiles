# 定义通用变量
DOTFILES := $(PWD)                # 当前目录作为dotfiles目录
HOME_DIR := $(HOME)               # 用户主目录
CONFIG_DIR := $(HOME_DIR)/.config # 配置目录

# 需要在主目录创建符号链接的文件列表
# 移除了gitconfig, fzf-git.sh和z.lua，因为它们有特殊处理方式
DOT_FILES := vimrc bashrc zshrc tmux.conf tigrc aliases.zsh funcs.zsh \
             git.zsh p10k.zsh zinit-load.zsh \
             cht.sh ccls_load.sh fix_gh_contribution.sh

all: install  # 默认目标：执行安装

# 安装目标：创建目录、创建符号链接、设置git、创建hushlogin文件
install: create_dirs create_symlinks git_setup create_hushlogin

# 创建必要的目录结构
create_dirs:
	mkdir -p $(HOME_DIR)/.tmux                # 创建tmux配置目录
	mkdir -p $(HOME_DIR)/.vim/plugin          # 创建vim插件目录
	mkdir -p $(HOME_DIR)/.vim/autoload        # 创建vim自动加载目录
	mkdir -p $(CONFIG_DIR)                    # 创建通用配置目录
	cp -rf $(DOTFILES)/plugin/* $(HOME_DIR)/.vim/plugin/ # 复制vim插件

# 创建所有符号链接
create_symlinks: $(DOT_FILES:%=$(HOME_DIR)/.%) special_symlinks

# 创建特殊文件的符号链接
special_symlinks: $(HOME_DIR)/.gitconfig $(HOME_DIR)/.fzf-git.sh $(HOME_DIR)/.z.lua $(CONFIG_DIR)/starship.toml

# 为普通配置文件创建符号链接的通用规则
$(HOME_DIR)/.%: $(DOTFILES)/%
	test -f $@ || ln -s $< $@  # 如果目标不存在，则创建符号链接
	# $@ 表示目标文件（target），这里是 $(HOME_DIR)/.文件名
	# $< 表示第一个依赖项（prerequisite），这里是 $(DOTFILES)/文件名

# 为gitconfig创建符号链接
$(HOME_DIR)/.gitconfig: $(DOTFILES)/gitconfig-xm-tech
	test -f $@ || ln -s $< $@

# 为fzf-git.sh创建符号链接
$(HOME_DIR)/.fzf-git.sh: $(DOTFILES)/fzf-git.sh/fzf-git.sh
	test -f $@ || ln -s $< $@

# 为z.lua创建符号链接
$(HOME_DIR)/.z.lua: $(DOTFILES)/z.lua/z.lua
	test -f $@ || ln -s $< $@
	ln -sf $< $@  # 强制创建符号链接，即使已存在

# 为starship配置创建符号链接
$(CONFIG_DIR)/starship.toml: $(DOTFILES)/starship.toml
	test -f $@ || ln -s $< $@

# 设置git配置
git_setup:
	git submodule update --init --recursive  # 更新所有git子模块
	# 完成git设置
	git config --global commit.template $(DOTFILES)/git.commit.template  # 设置提交模板
	git config --global core.editor vim  # 设置git编辑器为vim

# 创建hushlogin文件（用于禁止登录信息显示）
create_hushlogin:
	touch $(HOME_DIR)/.hushlogin

# 导出Homebrew包列表
bundle_dump:
	brew bundle dump --force

# 安装Homebrew包
bundle:
	brew bundle 

# 更新coc-settings.json配置
coc_settings_up:
	cp -f coc-settings.json $(HOME_DIR)/.vim/coc-settings.json

# 重新加载zsh函数路径
reload_fpath:
	rm -f ~/.zcompdump || true
	compinit || true

# 修复githubusercontent访问问题
fix_ghusercontent:
	if ! grep -q "raw.githubusercontent.com" /etc/hosts; then \
		sudo sh -c 'echo "199.232.68.133 raw.githubusercontent.com" >> /etc/hosts'; \
	fi

# 安装vim-plug插件管理器
install_vim_plug:
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim || true

# 安装zinit插件管理器
install_zinit:
	mkdir -p "$(HOME_DIR)/.local/share/zinit" && chmod g-rwX "$(HOME_DIR)/.local/share/zinit"
	if [ ! -f "$(HOME_DIR)/.local/share/zinit/zinit.git/zinit.zsh" ]; then \
		git clone https://github.com/zdharma-continuum/zinit "$(HOME_DIR)/.local/share/zinit/zinit.git"; \
	fi

# 安装命令行代理设置
install_cli_sock_proxy:
	@echo "Adding proxy check to .zshrc"  # 添加代理检查到.zshrc
	@grep -q "nc -z -w 2 127.0.0.1 1087" $(HOME_DIR)/.zshrc || { \
		echo 'if nc -z -w 2 127.0.0.1 1087 &>/dev/null; then' >> $(HOME_DIR)/.zshrc; \
		echo '  export http_proxy=http://127.0.0.1:1087' >> $(HOME_DIR)/.zshrc; \
		echo '  export https_proxy=http://127.0.0.1:1087' >> $(HOME_DIR)/.zshrc; \
		echo 'fi' >> $(HOME_DIR)/.zshrc; \
		echo "Proxy settings added to .zshrc."; \
	}

# 初始化starship提示符
init_starship:
	mkdir -p $(CONFIG_DIR)
	ln -sf $(DOTFILES)/starship.toml $(CONFIG_DIR)/starship.toml
	
# 重新加载zsh配置
reload_zsh:
	@echo "To reload zsh configuration, please run: source ~/.zshrc"  # 提示用户如何重新加载zsh配置

# 清理所有创建的符号链接
clean:
	rm -f $(DOT_FILES:%=$(HOME_DIR)/.%)  # 删除普通配置文件的符号链接
	rm -f $(HOME_DIR)/.gitconfig         # 删除gitconfig符号链接
	rm -f $(HOME_DIR)/.fzf-git.sh        # 删除fzf-git.sh符号链接
	rm -f $(HOME_DIR)/.z.lua             # 删除z.lua符号链接
	rm -f $(CONFIG_DIR)/starship.toml    # 删除starship配置符号链接
	rm -f /usr/local/include/{luaconf.h,lauxlib.h,lua.hpp,lualib.h,lua.h}  # 删除lua头文件

# 声明伪目标（不创建实际文件的目标）
.PHONY: all clean install bundle bundle_dump create_dirs create_symlinks special_symlinks git_setup create_hushlogin fix_ghusercontent install_vim_plug install_zinit install_cli_sock_proxy init_starship reload_zsh

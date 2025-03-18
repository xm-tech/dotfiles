# 定义通用变量
DOTFILES := $(PWD)# 当前目录作为dotfiles目录
HOME_DIR := $(HOME)# 用户主目录
CONFIG_DIR := $(HOME_DIR)/.config# 配置目录
BACKUP_DIR := $(HOME_DIR)/.dotfiles_backup/$(shell date +%Y%m%d_%H%M%S)# 备份目录

# 需要在主目录创建符号链接的文件列表
# 移除了gitconfig, fzf-git.sh和z.lua，因为它们有特殊处理方式
DOT_FILES := vimrc bashrc zshrc tmux.conf tigrc aliases.zsh funcs.zsh \
             git.zsh p10k.zsh zinit-load.zsh \
             cht.sh ccls_load.sh fix_gh_contribution.sh

# 检查必要的命令是否存在
REQUIRED_COMMANDS := git curl vim nc

# 默认目标：执行安装
all: install

# 安装目标：创建目录、创建符号链接、设置git、创建hushlogin文件
install: check_deps create_dirs create_symlinks git_setup create_hushlogin

# 检查依赖
check_deps:
	@echo "Checking dependencies..."
	@for cmd in $(REQUIRED_COMMANDS); do \
		which $$cmd > /dev/null || { echo "Error: $$cmd is required but not installed."; exit 1; }; \
	done
	@echo "All dependencies satisfied."

# 创建必要的目录结构
create_dirs:
	@echo "Creating necessary directories..."
	mkdir -p $(HOME_DIR)/.tmux# 创建tmux配置目录
	mkdir -p $(HOME_DIR)/.vim/plugin# 创建vim插件目录
	mkdir -p $(HOME_DIR)/.vim/autoload# 创建vim自动加载目录
	mkdir -p $(CONFIG_DIR)# 创建通用配置目录
	mkdir -p $(BACKUP_DIR)# 创建备份目录
	cp -rf $(DOTFILES)/plugin/* $(HOME_DIR)/.vim/plugin/ # 复制vim插件

# 创建所有符号链接
create_symlinks: dot_symlinks special_symlinks

# 为普通配置文件创建符号链接
dot_symlinks:
	@echo "Creating symlinks for dotfiles..."
	@for file in $(DOT_FILES); do \
		if [ -f "$(HOME_DIR)/.$$file" ] && [ ! -L "$(HOME_DIR)/.$$file" ]; then \
			echo "Backing up existing $(HOME_DIR)/.$$file to $(BACKUP_DIR)/"; \
			mkdir -p "$(BACKUP_DIR)"; \
			cp "$(HOME_DIR)/.$$file" "$(BACKUP_DIR)/"; \
		fi; \
		ln -sf "$(DOTFILES)/$$file" "$(HOME_DIR)/.$$file"; \
		echo "Created symlink: $(HOME_DIR)/.$$file -> $(DOTFILES)/$$file"; \
	done

# 创建特殊文件的符号链接
special_symlinks:
	@echo "Creating symlinks for special files..."
	
	@# gitconfig
	@if [ -f "$(HOME_DIR)/.gitconfig" ] && [ ! -L "$(HOME_DIR)/.gitconfig" ]; then \
		echo "Backing up existing $(HOME_DIR)/.gitconfig to $(BACKUP_DIR)/"; \
		mkdir -p "$(BACKUP_DIR)"; \
		cp "$(HOME_DIR)/.gitconfig" "$(BACKUP_DIR)/"; \
	fi
	ln -sf "$(DOTFILES)/gitconfig-xm-tech" "$(HOME_DIR)/.gitconfig"
	@echo "Created symlink: $(HOME_DIR)/.gitconfig -> $(DOTFILES)/gitconfig-xm-tech"
	
	@# fzf-git.sh
	@if [ -f "$(HOME_DIR)/.fzf-git.sh" ] && [ ! -L "$(HOME_DIR)/.fzf-git.sh" ]; then \
		echo "Backing up existing $(HOME_DIR)/.fzf-git.sh to $(BACKUP_DIR)/"; \
		mkdir -p "$(BACKUP_DIR)"; \
		cp "$(HOME_DIR)/.fzf-git.sh" "$(BACKUP_DIR)/"; \
	fi
	ln -sf "$(DOTFILES)/fzf-git.sh/fzf-git.sh" "$(HOME_DIR)/.fzf-git.sh"
	@echo "Created symlink: $(HOME_DIR)/.fzf-git.sh -> $(DOTFILES)/fzf-git.sh/fzf-git.sh"
	
	@# z.lua
	@if [ -f "$(HOME_DIR)/.z.lua" ] && [ ! -L "$(HOME_DIR)/.z.lua" ]; then \
		echo "Backing up existing $(HOME_DIR)/.z.lua to $(BACKUP_DIR)/"; \
		mkdir -p "$(BACKUP_DIR)"; \
		cp "$(HOME_DIR)/.z.lua" "$(BACKUP_DIR)/"; \
	fi
	ln -sf "$(DOTFILES)/z.lua/z.lua" "$(HOME_DIR)/.z.lua"
	@echo "Created symlink: $(HOME_DIR)/.z.lua -> $(DOTFILES)/z.lua/z.lua"
	
	@# starship.toml
	@if [ -f "$(CONFIG_DIR)/starship.toml" ] && [ ! -L "$(CONFIG_DIR)/starship.toml" ]; then \
		echo "Backing up existing $(CONFIG_DIR)/starship.toml to $(BACKUP_DIR)/"; \
		mkdir -p "$(BACKUP_DIR)"; \
		cp "$(CONFIG_DIR)/starship.toml" "$(BACKUP_DIR)/"; \
	fi
	ln -sf "$(DOTFILES)/starship.toml" "$(CONFIG_DIR)/starship.toml"
	@echo "Created symlink: $(CONFIG_DIR)/starship.toml -> $(DOTFILES)/starship.toml"
	
	@# coc-settings.json
	@if [ -f "$(HOME_DIR)/.vim/coc-settings.json" ] && [ ! -L "$(HOME_DIR)/.vim/coc-settings.json" ]; then \
		echo "Backing up existing $(HOME_DIR)/.vim/coc-settings.json to $(BACKUP_DIR)/"; \
		mkdir -p "$(BACKUP_DIR)"; \
		cp "$(HOME_DIR)/.vim/coc-settings.json" "$(BACKUP_DIR)/"; \
	fi
	ln -sf "$(DOTFILES)/coc-settings.json" "$(HOME_DIR)/.vim/coc-settings.json"
	@echo "Created symlink: $(HOME_DIR)/.vim/coc-settings.json -> $(DOTFILES)/coc-settings.json"

# 设置git配置
git_setup:
	@echo "Setting up git configuration..."
	git submodule update --init --recursive || { echo "Error updating git submodules"; exit 1; }
	git config --global commit.template "$(DOTFILES)/git.commit.template"# 设置提交模板
	git config --global core.editor vim# 设置git编辑器为vim
	@echo "Git configuration complete."

# 创建hushlogin文件（用于禁止登录信息显示）
create_hushlogin:
	@echo "Creating .hushlogin file..."
	touch "$(HOME_DIR)/.hushlogin"

# 导出Homebrew包列表
bundle_dump:
	@echo "Dumping Homebrew packages to Brewfile..."
	brew bundle dump --force

# 安装Homebrew包
bundle:
	@echo "Installing packages from Brewfile..."
	brew bundle || { echo "Error installing packages"; exit 1; }

# 重新加载zsh函数路径
reload_fpath:
	@echo "Reloading zsh function path..."
	rm -f ~/.zcompdump || true
	compinit || true

# 修复githubusercontent访问问题
fix_ghusercontent:
	@echo "Checking GitHub raw content access..."
	if ! grep -q "raw.githubusercontent.com" /etc/hosts; then \
		echo "Adding raw.githubusercontent.com to /etc/hosts..."; \
		sudo sh -c 'echo "199.232.68.133 raw.githubusercontent.com" >> /etc/hosts'; \
		echo "Added raw.githubusercontent.com to /etc/hosts."; \
	else \
		echo "raw.githubusercontent.com already in /etc/hosts."; \
	fi

# 安装vim-plug插件管理器
install_vim_plug:
	@echo "Installing vim-plug..."
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim || \
		{ echo "Error downloading vim-plug. Trying alternative URL..."; \
		  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
		  https://cdn.jsdelivr.net/gh/junegunn/vim-plug/plug.vim || \
		  { echo "Failed to install vim-plug"; exit 1; }; \
		}
	@echo "vim-plug installed successfully."

# 安装zinit插件管理器
install_zinit:
	@echo "Installing zinit..."
	mkdir -p "$(HOME_DIR)/.local/share/zinit" && chmod g-rwX "$(HOME_DIR)/.local/share/zinit"
	if [ ! -f "$(HOME_DIR)/.local/share/zinit/zinit.git/zinit.zsh" ]; then \
		git clone https://github.com/zdharma-continuum/zinit "$(HOME_DIR)/.local/share/zinit/zinit.git" || \
		{ echo "Error cloning zinit. Trying alternative URL..."; \
		  git clone https://gitee.com/mirrors/zinit.git "$(HOME_DIR)/.local/share/zinit/zinit.git" || \
		  { echo "Failed to install zinit"; exit 1; }; \
		}; \
	else \
		echo "zinit already installed."; \
	fi

# 安装命令行代理设置
install_cli_sock_proxy:
	@echo "Setting up CLI proxy..."
	@if ! grep -q "nc -z -w 2 127.0.0.1 1087" "$(HOME_DIR)/.zshrc"; then \
		echo 'if nc -z -w 2 127.0.0.1 1087 &>/dev/null; then' >> "$(HOME_DIR)/.zshrc"; \
		echo '  export http_proxy=http://127.0.0.1:1087' >> "$(HOME_DIR)/.zshrc"; \
		echo '  export https_proxy=http://127.0.0.1:1087' >> "$(HOME_DIR)/.zshrc"; \
		echo 'fi' >> "$(HOME_DIR)/.zshrc"; \
		echo "Proxy settings added to .zshrc."; \
	else \
		echo "Proxy settings already exist in .zshrc."; \
	fi

# 初始化starship提示符
init_starship:
	@echo "Initializing starship prompt..."
	mkdir -p "$(CONFIG_DIR)"
	ln -sf "$(DOTFILES)/starship.toml" "$(CONFIG_DIR)/starship.toml"
	@echo "Starship prompt initialized."
	
# 重新加载zsh配置
reload_zsh:
	@echo "To reload zsh configuration, please run: source ~/.zshrc"

# 显示帮助信息
help:
	@echo "Available targets:"
	@echo "  all               - Default target, same as 'install'"
	@echo "  install           - Install all dotfiles and configurations"
	@echo "  check_deps        - Check for required dependencies"
	@echo "  create_dirs       - Create necessary directories"
	@echo "  create_symlinks   - Create symlinks for dotfiles"
	@echo "  git_setup         - Set up git configuration"
	@echo "  bundle            - Install packages from Brewfile"
	@echo "  bundle_dump       - Export Homebrew packages to Brewfile"
	@echo "  install_vim_plug  - Install vim-plug plugin manager"
	@echo "  install_zinit     - Install zinit plugin manager"
	@echo "  fix_ghusercontent - Fix GitHub raw content access"
	@echo "  init_starship     - Initialize starship prompt"
	@echo "  reload_zsh        - Instructions to reload zsh configuration"
	@echo "  clean             - Remove all created symlinks"

# 清理所有创建的符号链接
clean:
	@echo "Cleaning up symlinks..."
	@for file in $(DOT_FILES); do \
		rm -f "$(HOME_DIR)/.$$file"; \
		echo "Removed symlink: $(HOME_DIR)/.$$file"; \
	done
	rm -f "$(HOME_DIR)/.gitconfig"# 删除gitconfig符号链接
	rm -f "$(HOME_DIR)/.fzf-git.sh"# 删除fzf-git.sh符号链接
	rm -f "$(HOME_DIR)/.z.lua"# 删除z.lua符号链接
	rm -f "$(CONFIG_DIR)/starship.toml"# 删除starship配置符号链接
	rm -f "$(HOME_DIR)/.vim/coc-settings.json"# 删除coc-settings.json符号链接
	# rm -f /usr/local/include/{luaconf.h,lauxlib.h,lua.hpp,lualib.h,lua.h}# 删除lua头文件
	@echo "Cleanup complete."

# 声明伪目标（不创建实际文件的目标）
.PHONY: all clean install check_deps bundle bundle_dump create_dirs create_symlinks dot_symlinks special_symlinks git_setup create_hushlogin fix_ghusercontent install_vim_plug install_zinit install_cli_sock_proxy init_starship reload_zsh help

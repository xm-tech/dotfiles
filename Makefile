# =================================================================
# ===================== DOTFILES MAKEFILE ======================
# =================================================================

# 定义通用变量
DOTFILES := $(PWD)
HOME_DIR := $(HOME)
CONFIG_DIR := $(HOME_DIR)/.config
BACKUP_DIR := $(HOME_DIR)/.dotfiles_backup/$(shell date +%Y%m%d_%H%M%S)

# 需要在主目录创建符号链接的文件列表
# 移除了gitconfig, fzf-git.sh和z.lua，因为它们有特殊处理方式
DOT_FILES := vimrc bashrc zshrc tmux.conf tigrc aliases.zsh funcs.zsh \
             git.zsh zinit-load.zsh proxy.zsh \
             cht.sh ccls_load.sh fix_gh_contribution.sh

# 检查必要的命令是否存在
REQUIRED_COMMANDS := git curl vim nc

# =================================================================
# ===================== 主要目标 =================================
# =================================================================

# 默认目标：执行安装
all: install

# 安装目标：创建目录、创建符号链接、设置git、创建hushlogin文件、安装TPM
install: check_deps create_dirs create_symlinks git_setup create_hushlogin setup_vim_modular install_tmux_plugin_manager fix_submodules fix_submodules

# 清理所有创建的符号链接
clean: clean_vim_modular
	@echo "Cleaning up symlinks..."
	@for file in $(DOT_FILES); do \
		rm -f "$(HOME_DIR)/.$$file"; \
		echo "Removed symlink: $(HOME_DIR)/.$$file"; \
	done
	rm -f "$(HOME_DIR)/.gitconfig"
	rm -f "$(HOME_DIR)/.fzf-git.sh"
	rm -f "$(HOME_DIR)/.z.lua"
	rm -f "$(CONFIG_DIR)/starship.toml"
	rm -f "$(HOME_DIR)/.vim/coc-settings.json"
	@# 检查并删除可能存在的循环软链接
	@if [ -L "$(DOTFILES)/tmux/plugins/tpm/tpm" ]; then \
		echo "Removing circular symlink $(DOTFILES)/tmux/plugins/tpm/tpm"; \
		rm -f "$(DOTFILES)/tmux/plugins/tpm/tpm"; \
	fi
	rm -f "$(HOME_DIR)/.tmux/plugins/tpm"
	@echo "Removed symlink: $(HOME_DIR)/.tmux/plugins/tpm"
	# rm -f /usr/local/include/{luaconf.h,lauxlib.h,lua.hpp,lualib.h,lua.h}
	@echo "Cleanup complete."

# =================================================================
# ===================== 基础设置 =================================
# =================================================================

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
	mkdir -p $(HOME_DIR)/.tmux
	mkdir -p $(HOME_DIR)/.vim/plugin
	mkdir -p $(HOME_DIR)/.vim/autoload
	mkdir -p $(CONFIG_DIR)
	mkdir -p $(BACKUP_DIR)
	cp -rf $(DOTFILES)/plugin/* $(HOME_DIR)/.vim/plugin/

# 创建hushlogin文件（用于禁止登录信息显示）
create_hushlogin:
	@echo "Creating .hushlogin file..."
	touch "$(HOME_DIR)/.hushlogin"

# =================================================================
# ===================== 符号链接 =================================
# =================================================================

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

# =================================================================
# ===================== Git 配置 =================================
# =================================================================

# 设置git配置
git_setup:
	@echo "Setting up git configuration..."
	git submodule update --init --recursive || { echo "Error updating git submodules"; exit 1; }
	git config --global --unset-all commit.template || true
	git config --global commit.template "$(DOTFILES)/git.commit.template"
	git config --global --unset-all core.editor || true
	git config --global core.editor vim
	@echo "Git configuration complete."

# =================================================================
# ===================== Vim 配置 =================================
# =================================================================

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

# 设置vim模块化配置
setup_vim_modular:
	@echo "Setting up modular Vim configuration..."
	@mkdir -p $(HOME_DIR)/.vim/config
	@for file in basic.vim filetypes.vim statusline.vim mappings.vim plugins.vim performance.vim; do \
		if [ -f "$(HOME_DIR)/.vim/config/$$file" ] && [ ! -L "$(HOME_DIR)/.vim/config/$$file" ]; then \
			echo "Backing up existing $(HOME_DIR)/.vim/config/$$file to $(BACKUP_DIR)/"; \
			mkdir -p "$(BACKUP_DIR)/vim/config"; \
			cp "$(HOME_DIR)/.vim/config/$$file" "$(BACKUP_DIR)/vim/config/"; \
		fi; \
		ln -sf "$(DOTFILES)/vim/config/$$file" "$(HOME_DIR)/.vim/config/$$file"; \
		echo "Created symlink: $(HOME_DIR)/.vim/config/$$file -> $(DOTFILES)/vim/config/$$file"; \
	done
	@echo "Modular Vim configuration installed."

# 清理vim模块化配置
clean_vim_modular:
	@echo "Cleaning up modular Vim configuration..."
	@for file in basic.vim filetypes.vim statusline.vim mappings.vim plugins.vim performance.vim; do \
		rm -f "$(HOME_DIR)/.vim/config/$$file"; \
		echo "Removed symlink: $(HOME_DIR)/.vim/config/$$file"; \
	done
	@echo "Modular Vim configuration cleanup complete."

# =================================================================
# ===================== Tmux 配置 =================================
# =================================================================

# 安装 Tmux Plugin Manager (TPM)
install_tmux_plugin_manager:
	@echo "Installing Tmux Plugin Manager (TPM)..."
	@mkdir -p "$(DOTFILES)/tmux/plugins"
	@mkdir -p "$(HOME_DIR)/.tmux/plugins"
	@if [ ! -d "$(DOTFILES)/tmux/plugins/tpm" ]; then \
		git clone https://github.com/tmux-plugins/tpm "$(DOTFILES)/tmux/plugins/tpm" || \
		{ echo "Error cloning TPM. Trying alternative URL..."; \
		  git clone https://gitee.com/mirrors/tpm.git "$(DOTFILES)/tmux/plugins/tpm" || \
		  { echo "Failed to install TPM"; exit 1; }; \
		}; \
	fi
	@# 检查并删除可能存在的循环软链接
	@if [ -L "$(DOTFILES)/tmux/plugins/tpm/tpm" ]; then \
		echo "Removing circular symlink $(DOTFILES)/tmux/plugins/tpm/tpm"; \
		rm -f "$(DOTFILES)/tmux/plugins/tpm/tpm"; \
	fi
	@if [ -d "$(HOME_DIR)/.tmux/plugins/tpm" ] && [ ! -L "$(HOME_DIR)/.tmux/plugins/tpm" ]; then \
		echo "Backing up existing $(HOME_DIR)/.tmux/plugins/tpm to $(BACKUP_DIR)/"; \
		mkdir -p "$(BACKUP_DIR)/tmux/plugins"; \
		cp -r "$(HOME_DIR)/.tmux/plugins/tpm" "$(BACKUP_DIR)/tmux/plugins/"; \
		rm -rf "$(HOME_DIR)/.tmux/plugins/tpm"; \
	fi
	ln -sf "$(DOTFILES)/tmux/plugins/tpm" "$(HOME_DIR)/.tmux/plugins/tpm"
	@echo "TPM installed successfully."
	@echo "To install tmux plugins, start tmux and press prefix + I (capital I)."

# =================================================================
# ===================== Shell 配置 ================================
# =================================================================

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

# 初始化starship提示符
init_starship:
	@echo "Initializing starship prompt..."
	mkdir -p "$(CONFIG_DIR)"
	ln -sf "$(DOTFILES)/starship.toml" "$(CONFIG_DIR)/starship.toml"
	@echo "Starship prompt initialized."

# 重新加载zsh配置
reload_zsh:
	@echo "To reload zsh configuration, please run: source ~/.zshrc"

# 重新加载zsh函数路径
reload_fpath:
	@echo "Reloading zsh function path..."
	rm -f ~/.zcompdump || true
	compinit || true

# =================================================================
# ===================== 网络和工具 ================================
# =================================================================

# 检查并修复 git 子模块状态
fix_submodules:
	@echo "Checking and fixing git submodules..."
	@for submodule in $$(git submodule status | awk '{print $$2}'); do \
		echo "Checking $$submodule..."; \
		if [ -L "$$submodule/$$submodule" ]; then \
			echo "Removing circular symlink in $$submodule"; \
			rm -f "$$submodule/$$submodule"; \
		fi; \
	done
	git submodule deinit -f --all
	git submodule update --init --recursive
	@echo "Git submodules fixed."

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

# =================================================================
# ===================== Homebrew 包管理 ===========================
# =================================================================

# 导出Homebrew包列表
bundle_dump:
	@echo "Dumping Homebrew packages to Brewfile..."
	brew bundle dump --force

# 安装Homebrew包
bundle:
	@echo "Installing packages from Brewfile..."
	brew bundle || { echo "Error installing packages"; exit 1; }

# =================================================================
# ===================== 帮助信息 =================================
# =================================================================

# 定义颜色代码
BOLD := \033[1m
RESET := \033[0m
BLUE := \033[34m
GREEN := \033[32m
YELLOW := \033[33m
CYAN := \033[36m
MAGENTA := \033[35m
RED := \033[31m

# 显示帮助信息
help:
	@echo "$(BOLD)Available targets:$(RESET)"
	@echo ""
	@echo "$(BLUE)$(BOLD)主要目标:$(RESET)"
	@echo "  $(GREEN)all$(RESET)               - Default target, same as 'install'"
	@echo "  $(GREEN)install$(RESET)           - Install all dotfiles and configurations"
	@echo "  $(GREEN)clean$(RESET)             - Remove all created symlinks"
	@echo ""
	@echo "$(BLUE)$(BOLD)基础设置:$(RESET)"
	@echo "  $(GREEN)check_deps$(RESET)        - Check for required dependencies"
	@echo "  $(GREEN)create_dirs$(RESET)       - Create necessary directories"
	@echo "  $(GREEN)create_hushlogin$(RESET)  - Create .hushlogin file"
	@echo ""
	@echo "$(BLUE)$(BOLD)符号链接:$(RESET)"
	@echo "  $(GREEN)create_symlinks$(RESET)   - Create symlinks for dotfiles"
	@echo "  $(GREEN)dot_symlinks$(RESET)      - Create symlinks for regular dotfiles"
	@echo "  $(GREEN)special_symlinks$(RESET)  - Create symlinks for special files"
	@echo ""
	@echo "$(BLUE)$(BOLD)Git 配置:$(RESET)"
	@echo "  $(GREEN)git_setup$(RESET)         - Set up git configuration"
	@echo "  $(GREEN)fix_submodules$(RESET)    - Check and fix git submodules"
	@echo ""
	@echo "$(BLUE)$(BOLD)Vim 配置:$(RESET)"
	@echo "  $(GREEN)install_vim_plug$(RESET)  - Install vim-plug plugin manager"
	@echo "  $(GREEN)setup_vim_modular$(RESET) - Set up modular Vim configuration"
	@echo "  $(GREEN)clean_vim_modular$(RESET) - Remove modular Vim configuration symlinks"
	@echo ""
	@echo "$(BLUE)$(BOLD)Tmux 配置:$(RESET)"
	@echo "  $(GREEN)install_tmux_plugin_manager$(RESET) - Install Tmux Plugin Manager (TPM)"
	@echo ""
	@echo "$(BLUE)$(BOLD)Shell 配置:$(RESET)"
	@echo "  $(GREEN)install_zinit$(RESET)     - Install zinit plugin manager"
	@echo "  $(GREEN)init_starship$(RESET)     - Initialize starship prompt"
	@echo "  $(GREEN)reload_zsh$(RESET)        - Instructions to reload zsh configuration"
	@echo "  $(GREEN)reload_fpath$(RESET)      - Reload zsh function path"
	@echo ""
	@echo "$(BLUE)$(BOLD)网络和工具:$(RESET)"
	@echo "  $(GREEN)fix_ghusercontent$(RESET) - Fix GitHub raw content access"
	@echo ""
	@echo "$(BLUE)$(BOLD)Homebrew 包管理:$(RESET)"
	@echo "  $(GREEN)bundle$(RESET)            - Install packages from Brewfile"
	@echo "  $(GREEN)bundle_dump$(RESET)       - Export Homebrew packages to Brewfile"

# 声明伪目标（不创建实际文件的目标）
.PHONY: all clean install check_deps bundle bundle_dump create_dirs create_symlinks \
        dot_symlinks special_symlinks git_setup create_hushlogin fix_ghusercontent \
        install_vim_plug install_zinit init_starship \
        reload_zsh reload_fpath help setup_vim_modular clean_vim_modular \
        install_tmux_plugin_manager fix_submodules

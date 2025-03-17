# Define common variables
DOTFILES := $(PWD)
HOME_DIR := $(HOME)
CONFIG_DIR := $(HOME_DIR)/.config
ALACRITTY_DIR := $(CONFIG_DIR)/alacritty

# List of files to symlink in home directory
# Removed gitconfig, fzf-git.sh, and z.lua as they have special handling
DOT_FILES := vimrc bashrc zshrc tmux.conf tigrc aliases.zsh funcs.zsh \
             git.zsh p10k.zsh zinit-load.zsh \
             cht.sh ccls_load.sh fix_gh_contribution.sh

# Alacritty config files
ALACRITTY_FILES := alacritty.yml color.yml

all: install

install: create_dirs create_symlinks git_setup create_hushlogin

create_dirs:
	mkdir -p $(HOME_DIR)/.tmux
	mkdir -p $(HOME_DIR)/.vim/plugin
	mkdir -p $(HOME_DIR)/.vim/autoload
	mkdir -p $(ALACRITTY_DIR)
	mkdir -p $(CONFIG_DIR)
	cp -rf $(DOTFILES)/plugin/* $(HOME_DIR)/.vim/plugin/

create_symlinks: $(DOT_FILES:%=$(HOME_DIR)/.%) $(ALACRITTY_FILES:%=$(ALACRITTY_DIR)/%) special_symlinks

special_symlinks: $(HOME_DIR)/.gitconfig $(HOME_DIR)/.fzf-git.sh $(HOME_DIR)/.z.lua $(CONFIG_DIR)/starship.toml

$(HOME_DIR)/.%: $(DOTFILES)/%
	test -f $@ || ln -s $< $@

$(HOME_DIR)/.gitconfig: $(DOTFILES)/gitconfig-xm-tech
	test -f $@ || ln -s $< $@

$(HOME_DIR)/.fzf-git.sh: $(DOTFILES)/fzf-git.sh/fzf-git.sh
	test -f $@ || ln -s $< $@

$(HOME_DIR)/.z.lua: $(DOTFILES)/z.lua/z.lua
	test -f $@ || ln -s $< $@
	ln -sf $< $@

$(ALACRITTY_DIR)/%: $(DOTFILES)/%
	test -f $@ || ln -s $< $@

$(CONFIG_DIR)/starship.toml: $(DOTFILES)/starship.toml
	test -f $@ || ln -s $< $@

git_setup:
	git submodule update --init --recursive
	# Complete git setup
	git config --global commit.template $(DOTFILES)/git.commit.template
	git config --global core.editor vim

create_hushlogin:
	touch $(HOME_DIR)/.hushlogin

bundle_dump:
	brew bundle dump --force

bundle:
	brew bundle 

coc_settings_up:
	cp -f coc-settings.json $(HOME_DIR)/.vim/coc-settings.json

reload_fpath:
	rm -f ~/.zcompdump || true
	compinit || true

fix_ghusercontent:
	if ! grep -q "raw.githubusercontent.com" /etc/hosts; then \
		sudo sh -c 'echo "199.232.68.133 raw.githubusercontent.com" >> /etc/hosts'; \
	fi

install_vim_plug:
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim || true

install_zinit:
	mkdir -p "$(HOME_DIR)/.local/share/zinit" && chmod g-rwX "$(HOME_DIR)/.local/share/zinit"
	if [ ! -f "$(HOME_DIR)/.local/share/zinit/zinit.git/zinit.zsh" ]; then \
		git clone https://github.com/zdharma-continuum/zinit "$(HOME_DIR)/.local/share/zinit/zinit.git"; \
	fi

install_cli_sock_proxy:
	@echo "Adding proxy check to .zshrc"
	@grep -q "nc -z -w 2 127.0.0.1 1087" $(HOME_DIR)/.zshrc || { \
		echo 'if nc -z -w 2 127.0.0.1 1087 &>/dev/null; then' >> $(HOME_DIR)/.zshrc; \
		echo '  export http_proxy=http://127.0.0.1:1087' >> $(HOME_DIR)/.zshrc; \
		echo '  export https_proxy=http://127.0.0.1:1087' >> $(HOME_DIR)/.zshrc; \
		echo 'fi' >> $(HOME_DIR)/.zshrc; \
		echo "Proxy settings added to .zshrc."; \
	}

init_starship:
	mkdir -p $(CONFIG_DIR)
	ln -sf $(DOTFILES)/starship.toml $(CONFIG_DIR)/starship.toml
	
reload_zsh:
	@echo "To reload zsh configuration, please run: source ~/.zshrc"

clean:
	rm -f $(DOT_FILES:%=$(HOME_DIR)/.%)
	rm -f $(HOME_DIR)/.gitconfig
	rm -f $(HOME_DIR)/.fzf-git.sh
	rm -f $(HOME_DIR)/.z.lua
	rm -f $(ALACRITTY_FILES:%=$(ALACRITTY_DIR)/%)
	rm -f $(CONFIG_DIR)/starship.toml
	rm -f /usr/local/include/{luaconf.h,lauxlib.h,lua.hpp,lualib.h,lua.h}

.PHONY: all clean install bundle bundle_dump create_dirs create_symlinks special_symlinks git_setup create_hushlogin fix_ghusercontent install_vim_plug install_zinit install_cli_sock_proxy init_starship reload_zsh

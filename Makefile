# Define common variables
DOTFILES := $(PWD)
HOME_DIR := $(HOME)
CONFIG_DIR := $(HOME_DIR)/.config
ALACRITTY_DIR := $(CONFIG_DIR)/alacritty

# List of files to symlink in home directory
DOT_FILES := vimrc bashrc zshrc tmux.conf tigrc gitconfig aliases.zsh funcs.zsh \
             antigen.zsh antigen-load.zsh git.zsh fzf-git.sh p10k.zsh z.lua \
             cht.sh ccls_load.sh fix_gh_contribution.sh

# Alacritty config files
ALACRITTY_FILES := alacritty.yml color.yml

all: install

install: create_dirs create_symlinks git_setup create_hushlogin

create_dirs:
	mkdir -p $(HOME_DIR)/.tmux
	mkdir -p $(HOME_DIR)/.vim/plugin
	mkdir -p $(ALACRITTY_DIR)
	\cp -rf $(DOTFILES)/plugin/* $(HOME_DIR)/.vim/plugin/

create_symlinks: $(DOT_FILES:%=$(HOME_DIR)/.%) $(ALACRITTY_FILES:%=$(ALACRITTY_DIR)/%)

$(HOME_DIR)/.%: $(DOTFILES)/%
	[[ -f $@ ]] || ln -s $< $@

$(HOME_DIR)/.gitconfig: $(DOTFILES)/gitconfig-xm-tech
	[[ -f $@ ]] || ln -s $< $@

$(HOME_DIR)/.fzf-git.sh: $(DOTFILES)/fzf-git.sh/fzf-git.sh
	[[ -f $@ ]] || ln -s $< $@

$(HOME_DIR)/.z.lua: $(DOTFILES)/z.lua/z.lua
	[[ -f $@ ]] || ln -s $< $@

$(ALACRITTY_DIR)/%: $(DOTFILES)/%
	[[ -f $@ ]] || ln -s $< $@

git_setup:
	git submodule update --init --recursive
	echo "wait to fix"

create_hushlogin:
	touch $(HOME_DIR)/.hushlogin

bundle_dump:
	brew bundle dump --force

bundle:
	brew bundle 

coc_settings_up:
	\cp -f coc-settings.json $(HOME_DIR)/.vim/coc-settings.json

reload_fpath:
	- rm -f ~/.zcompdump && compinit	

fix_ghusercontent:
	- sudo sh -c 'echo "199.232.68.133 raw.githubusercontent.com" >> /etc/hosts'

install_vim_plug:
	- curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

install_cli_sock_proxy:
	- export http_proxy=http://127.0.0.1:1087;export https_proxy=http://127.0.0.1:1087;

clean:
	rm -f $(DOT_FILES:%=$(HOME_DIR)/.%)
	rm -f $(ALACRITTY_FILES:%=$(ALACRITTY_DIR)/%)
	rm -f /usr/local/include/{luaconf.h,lauxlib.h,lua.hpp,lualib.h,lua.h}

.PHONY: all clean install bundle bundle_dump create_dirs create_symlinks git_setup create_hushlogin fix_ghusercontent install_vim_plug install_cli_sock_proxy

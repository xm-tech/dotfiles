all: install

install:
	mkdir -p ~/.tmux
	mkdir -p ~/.vim/plugin && \cp -rf $(PWD)/plugin/* ~/.vim/plugin/
	mkdir -p ~/.config/alacritty

	[ -f ~/.vimrc ] || ln -s $(PWD)/vimrc ~/.vimrc
	[ -f ~/.bashrc ] || ln -s $(PWD)/bashrc ~/.bashrc
	[ -f ~/.zshrc ] || ln -s $(PWD)/zshrc ~/.zshrc
	[ -f ~/.tmux.conf ] || ln -s $(PWD)/tmuxconf ~/.tmux.conf
	[ -f ~/.tigrc ] || ln -s $(PWD)/tigrc ~/.tigrc
	[ -f ~/.gitconfig ] || ln -s $(PWD)/gitconfig-xm-tech ~/.gitconfig
	[ -f ~/.aliases.zsh ] || ln -s $(PWD)/aliases.zsh ~/.aliases.zsh
	[ -f ~/.funcs.zsh ] || ln -s $(PWD)/funcs.zsh ~/.funcs.zsh
	[ -f ~/.zplug.zsh ] || ln -s $(PWD)/zplug.zsh ~/.zplug.zsh
	[ -f ~/.git.zsh ] || ln -s $(PWD)/git.zsh ~/.git.zsh
	[ -f ~/.fzf-git.sh ] || ln -s $(PWD)/fzf-git.sh/fzf-git.sh ~/.fzf-git.sh
	[ -f ~/.z.lua ] || ln -s $(PWD)/z.lua/z.lua ~/.z.lua
	[ -f ~/.cht.sh ] || ln -s $(PWD)/cht.sh ~/.cht.sh
	[ -f ~/.fix_gh_contribution.sh ] || ln -s $(PWD)/fix_gh_contribution.sh ~/.fix_gh_contribution.sh
	[ -f ~/.config/alacritty/alacritty.yml ] || ln -s $(PWD)/alacritty.yml ~/.config/alacritty/alacritty.yml
	[ -f ~/.config/alacritty/color.yml ] || ln -s $(PWD)/color.yml ~/.config/alacritty/color.yml

	git submodule update --init --recursive

	# don't show last login message
	touch ~/.hushlogin

bundle_dump:
	brew bundle dump --force

bundle_install:
	brew bundle 

clean:
	rm -f ~/.vimrc 
	rm -f ~/.config/alacritty/alacritty.yml
	rm -f ~/.config/alacritty/color.yml
	rm -f ~/.bashrc
	rm -f ~/.zshrc
	rm -f ~/.tmux.conf
	rm -f ~/.tigrc
	rm -f ~/.gitconfig
	rm -f ~/.aliases.zsh
	rm -f ~/.funcs.zsh
	rm -f ~/.zplug.zsh
	rm -f ~/.git.zsh
	rm -f ~/.fzf-git.sh
	rm -f ~/.z.lua
	rm -f ~/.cht.sh
	rm -f ~/fix_gh_contribution.sh
	rm -f ~/.fix_gh_contribution.sh

.PHONY: all clean install

all: sync

sync:
	mkdir -p ~/.tmux
	mkdir -p ~/.vim/plugin && \cp -rf $(PWD)/plugin/* ~/.vim/plugin/
	mkdir -p ~/.config/alacritty

	[ -f ~/.config/alacritty/alacritty.yml  ] || ln -s $(PWD)/alacritty.yml ~/.config/alacritty/alacritty.yml
	[ -f ~/.config/alacritty/color.yml ] || ln -s $(PWD)/color.yml ~/.config/alacritty/color.yml
	[ -f ~/.vimrc  ] || ln -s $(PWD)/vimrc ~/.vimrc
	[ -f ~/.bashrc  ] || ln -s $(PWD)/bashrc ~/.bashrc
	[ -f ~/.zshrc  ] || ln -s $(PWD)/zshrc ~/.zshrc
	[ -f ~/.tmux.conf  ] || ln -s $(PWD)/tmuxconf ~/.tmux.conf
	[ -f ~/.tigrc  ] || ln -s $(PWD)/tigrc ~/.tigrc
	[ -f ~/.gitconfig  ] || ln -s $(PWD)/gitconfig-xm-tech ~/.gitconfig
	# [ -d ./z ] || git submodule add git@github.com:xm-tech/z.git
	# [ -f /usr/local/etc/profile.d/z.sh ] || ( mkdir -p /usr/local/etc/profile.d/ && ln -s $(PWD)/z/z.sh /usr/local/etc/profile.d/z.sh )
	# [ -d ./z.lua ] || git submodule add git@github.com:xm-tech/z.lua.git
	git submodule update --init --recursive
	[ -f /usr/local/etc/profile.d/z.lua ] || ( mkdir -p /usr/local/etc/profile.d/ && ln -s $(PWD)/z.lua/z.lua /usr/local/etc/profile.d/z.lua )
	# [ -d ./fzf-git.sh ] || git submodule add  git@github.com:xm-tech/fzf-git.sh.git
	[ -f /usr/local/etc/profile.d/fzf-git.sh ] || ( mkdir -p /usr/local/etc/profile.d/ && ln -s $(PWD)/fzf-git.sh/fzf-git.sh /usr/local/etc/profile.d/fzf-git.sh )
	[ -f ~/cht.sh ] || ln -s $(PWD)/cht.sh ~/cht.sh
	[ -f ~/fix_gh_contribution.sh ] || ln -s $(PWD)/fix_gh_contribution.sh ~/fix_gh_contribution.sh

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
	# rm -f /usr/local/etc/profile.d/z.sh
	rm -f /usr/local/etc/profile.d/z.lua
	rm -f /usr/local/etc/profile.d/fzf-git.sh
	rm -f ~/cht.sh
	rm -f ~/fix_gh_contribution.sh

.PHONY: all clean sync

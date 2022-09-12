all: sync

sync:
	mkdir -p ~/.config/alacritty

	[ -f ~/.config/alacritty/alacritty.yml  ] || ln -s $(PWD)/alacritty.yml ~/.config/alacritty/alacritty.yml
	[ -f ~/.vimrc  ] || ln -s $(PWD)/vimrc ~/.vimrc
	[ -f ~/.bashrc  ] || ln -s $(PWD)/bashrc ~/.bashrc
	[ -f ~/.zshrc  ] || ln -s $(PWD)/zshrc ~/.zshrc
	[ -f ~/.tmux.conf  ] || ln -s $(PWD)/tmuxconf ~/.tmux.conf
	[ -f ~/.tigrc  ] || ln -s $(PWD)/tigrc ~/.tigrc
	[ -f ~/.git-prompt.sh  ] || ln -s $(PWD)/git-prompt.sh ~/.git-prompt.sh
	[ -f ~/.gitconfig  ] || ln -s $(PWD)/gitconfig ~/.gitconfig
	# [ -f ~/.gitconfig-work  ] || ln -s $(PWD)/gitconfig-work ~/.gitconfig-work
	[ -f ~/.gitconfig-xm-tech  ] || ln -s $(PWD)/gitconfig-xm-tech ~/.gitconfig-xm-tech
	[ -f /usr/local/etc/profile.d/z.sh ] || ( mkdir -p /usr/local/etc/profile.d/ && ln -s $(PWD)/z.sh /usr/local/etc/profile.d/z.sh )
	mkdir -p ~/.vim/plugin && \cp -rf $(PWD)/plugin/* ~/.vim/plugin/
	[ -f ~/cht.sh ] || ln -s $(PWD)/cht.sh ~/cht.sh
	[ -f ~/fix_gh_contribution.sh ] || ln -s $(PWD)/fix_gh_contribution.sh ~/fix_gh_contribution.sh

	# don't show last login message
	touch ~/.hushlogin

clean:
	rm -f ~/.vimrc 
	rm -f ~/.config/alacritty/alacritty.yml
	rm -f ~/.bashrc
	rm -f ~/.zshrc
	rm -f ~/.tmux.conf
	rm -f ~/.tigrc
	rm -f ~/.git-prompt.sh
	rm -f ~/.gitconfig
	[ -f /usr/local/etc/profile.d/z.sh ] && rm -f /usr/local/etc/profile.d/z.sh
	rm -f ~/fix_gh_contribution.sh

.PHONY: all clean sync build run kill

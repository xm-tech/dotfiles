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
	rm -f ~/.agignore

.PHONY: all clean sync build run kill

# Senstive functions which are not pushed to Github
# It contains GOPATH, some functions, aliases etc...
[ -r ~/.zsh_private ] && source ~/.zsh_private

# ==================
# 	alias
# ==================
alias ..='cd ..'
alias g=git
alias ga='git add'
alias gb='git branch'
alias gbr='git branch -r'
alias gbrv='git branch -r -v'
alias gbv='git branch -v'
alias gbvv='git branch -vv'
alias gc='git checkout'
alias gcb='git checkout -b'
alias gcm='git commit -m '
alias gcmb='git commit -m "build" '
alias gd='git diff'
alias gdc='git diff --cached'
alias git=hub
alias gl='git log --all --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit --date=relative'
alias glp='gl -p'
alias gp='git push'
alias gpl='git pull'
alias gr='git remote'
alias grv='git remote -vv'
alias gs='git status -sb'
alias gm='git merge'
alias gmt='git mergetool'
alias gca='git commit --amend'
alias ls='ls -GpF'
alias l='ls -lh'
alias ll='ls -alGpF'
alias mvn-gen='sh ~/mvn-gen.sh'
alias of='open -a Finder ./'
alias run-help=man
alias vi='vim -p'
alias which-command=whence
# cd into git root dir
alias cdr='cd $(git rev-parse --show-toplevel)'
# show
alias duh='du -sh -h * .[^.]* 2> /dev/null | sort -h'

# ==================
# functions
# ==================
function kubelog(){
	if [ $# -ge 3 ]; then
		# $1:namespace, $2:podname, $3:linenum
		kubectl logs -n $1 $2 --tail $3 -f
		return
	fi
	## $1:podname, $2:linenum
	kubectl logs $1 --tail $2 -f
}

function kubeps(){
    if [ $# -gt 0 ]; then
	# $1: namespace
    	kubectl get pods -n $1 # -o wide
	return
    fi
    kubectl get pods # -o wide
}

function kubelogin(){
    if [ $# -gt 1 ]; then
	kubectl exec -n $1 -it $2 /bin/bash
	return
    fi
    pod_name=$1
    kubectl exec -it $pod_name /bin/bash
}

function kubedel(){
    if [ $# -gt 1 ]; then
	    kubectl delete pods -n $1 $2
	    return
    fi
    pod_name=$1
    kubectl delete pods $pod_name
}

function p16(){
    x=$1
    printf %x $x
}

## 推送新配置到远端
function gps(){
    branch_name=$1
    git push --set-upstream origin $branch_name
}

## use vimdiff as default merge tool
git config --global merge.tool vimdiff
git config --global mergetool.prompt false
git config --global merge.conflictstyle diff3

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f /usr/local/etc/profile.d/z.sh ] && . /usr/local/etc/profile.d/z.sh

# brew install jump
eval "$(jump shell)"
if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi

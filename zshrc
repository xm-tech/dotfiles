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
	    kubectl delete pods -n $1 $2 &
	    return
    fi
    pod_name=$1
    kubectl delete pods $pod_name &
}

function kubestop(){
    if [ $# -gt 1 ]; then
	    kubectl scale --replicas=0 deploy $1 -n $2
	    return
    fi
    pod_name=$1
    kubectl scale --replicas=0 deploy $pod_name
}

function p16(){
    print $(printf %x $1 | sed 's/%//g')
}

## 推送新配置到远端
function gps(){
    branch_name=$1
    git push --set-upstream origin $branch_name
}

function gt(){
    tag=$1
    comment=$2
    git tag -a ${tag} -m ${comment} && git push origin ${tag}
}

function gts(){
    tag = $1
    git show ${tag}
}

## revert git version to the special commit which would lost all commit after the ojbect commit
function grevert(){
    commitid=$1
    git reset --hard ${commitid}
    # git push -f
}

## hub
function fork(){
    hub fork --remote-name origin
}

## k8s: proxy of kubectl get svc
function kubesvc(){
    if [ $# -gt 0  ]; then
	kubectl get svc -n $1
   	return
    fi
    # else
    kubectl get svc
}

## 统计 git 代码贡献
function gcs(){
	git log | ag Author | awk '{a[$2]+=1}END{for (name in a) {print name, a[name]}}' | sort -nr -k 2
}

## cht.sh
function cht() {
	/bin/sh ~/cht.sh "$@"
}

function now(){
	date +%s
}

## convert unixtime into datetimestr
function u2t(){
	time_util u2t $1
}

## convert datetimestr into unixtime
function t2u(){
	time_util t2u $1
}

function zk(){
	addr=$1
	zkCli -server $addr
}

function mtr(){
	cd /usr/local/Cellar/mtr/0.95/sbin && sudo ./mtr $1
}

function ip(){
	sh /Users/maxiongmiao/shell/shell-demo/ip.sh
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

# export PATH="/usr/local/Cellar/go/1.18.4/bin:$PATH"
export PATH="/usr/local/opt/go@1.18/bin:$PATH"

export GO111MODULE=on
export GOPROXY=https://goproxy.cn

# export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
# export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
# export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"
# export PATH="/usr/local/sbin:$PATH"

export PATH="/usr/local/opt/openjdk/bin:$PATH"
export PATH="$PATH:$(go env GOPATH)/bin"
export CPPFLAGS="-I/usr/local/opt/openjdk/include"
export PATH="/usr/local/sbin:$PATH"

eval "$(hub alias -s)"

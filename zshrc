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
alias gplf='cd /Users/maxiongmiao/yalla/projects/FiberHall'
alias gr='git remote'
alias grv='git remote -vv'
alias gs='git status -sb'
alias gm='git merge'
alias gca='git commit --amend'
alias ls='ls -GpF'
alias l='ls -lh'
alias ll='ls -alGpF'
alias mvn-gen='sh ~/mvn-gen.sh'
alias of='open -a Finder ./'
alias run-help=man
alias ssh-me='ssh xm-tech@xm-tech.cn'
alias ssh-mrgl-aquarium-1='ssh root@47.98.229.128'
alias ssh-mrgl-aquarium-2='ssh root@47.98.208.206'
alias ssh-mrgl-bg-test='ssh root@sbconsole-focus.mosoga.net'
alias ssh-mrgl-farm-2='ssh root@47.97.168.154'
alias ssh-mrgl-farm-test='ssh root@47.99.84.30'
alias ssh-mrgl-focus-s0='ssh root@47.97.168.154'
alias ssh-mrgl-focus-s1='ssh root@47.99.45.29'
alias ssh-mrgl-focus-test='ssh root@47.96.234.40'
alias ssh-mrgl-focus-xm-test='ssh root@47.74.155.40'
alias ssh-mrgl-im='ssh root@47.99.32.14'
alias ssh-mrgl-lj_game-s1='ssh root@47.98.48.21'
alias ssh-mrgl-lj_game-s2='ssh root@47.98.56.216'
alias ssh-mrgl-log='ssh root@47.97.168.204'
alias ssh-mrgl-merger-game-1='ssh root@47.96.235.37'
alias ssh-mrgl-merger-game-2='ssh root@47.99.44.108'
alias ssh-mrgl-ranger='ssh root@47.96.232.246'
alias ssh-mrgl-s0='ssh root@101.37.146.242'
alias ssh-mrgl-test='ssh root@120.55.55.120'
alias ssh-mrgl-thanos-1='ssh root@47.110.144.231'
alias ssh-mrgl-thanos-2='ssh root@47.110.143.150'
alias ssh-mrgl-wechat-gate-1='ssh root@47.110.148.39'
alias ssh-mrgl-wechat-gate-2='ssh root@47.110.148.193'
alias ssh-mrgl-wenonm-1='ssh root@47.99.163.2'
alias ssh-mrgl-wenonm-2='ssh root@47.99.177.18'
alias vi='vim -p'
alias which-command=whence
# cd into git root dir
alias cdr='cd $(git rev-parse --show-toplevel)'
# show
alias duh='du -sh -h * .[^.]* 2> /dev/null | sort -h'

alias yalla-proj='cd /Users/maxiongmiao/yalla/projects'

export GOPATH=$HOME/go:$HOME/go/src/github.com/name5566/leafserver:$HOME/go/src/github.com/name5566/UnitySocketProtobuf3Demo/Server

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

function yalla_hall_cost(){
   cd ~/yalla/tools && sh hall_payload.sh $1 $2
}

function yalla_pro_find(){
    cd ~/yalla/tools && sh query_procedure.sh $1
}

function yalla_pro_view(){
    cd ~/yalla/tools && sh view_procedure.sh $1
}

function yalla_mysql(){
    cd ~/yalla/tools && sh yalla_mysql.sh $1 $2
}

function yalla_server(){
    cd ~/yalla/tools && ./conn_baoleiji $1
}

# for my op
function my_mysql(){
    cd ~/dockers/mariadb && sh mysql_conn.sh
}

function kubelog(){
    pid=$1
    line=$2
    kubectl logs $pid --tail $line  -f
}

function kubeps(){
    kubectl get pods
}

function kubelogin(){
    pod_name=$1
    kubectl exec -it $pod_name /bin/bash
}

function kubedel(){
    pod_name=$1
    kubectl delete pods $pod_name
}

# brew install jump
eval "$(jump shell)"
if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi
export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"
export LDFLAGS="-L/usr/local/opt/openssl@1.1/lib"
export CPPFLAGS="-I/usr/local/opt/openssl@1.1/include"
export PKG_CONFIG_PATH="/usr/local/opt/openssl@1.1/lib/pkgconfig"
export PATH="/usr/local/opt/python@3.8/bin:$PATH"
export PATH="/usr/local/Cellar/vim/8.2.0800/bin:$PATH"

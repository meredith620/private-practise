# /etc/skel/.bashrc
#
# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !


# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi


# Put your fun stuff here.

eval `dircolors -b`
#PS1='[\u@\h \W]\$ '

alias gti='git'
alias ls='ls --color=auto'
alias fgrep='fgrep --color'
alias grep='grep --color'
alias vim='vim --cmd "colorscheme ron
set encoding=utf-8
set fileencodings=utf-8,GB2312,cp936,gb18030,big5,euc-jp,euc-kr,latin1
set backspace=indent,eol,start
set sw=4
syntax enable
syntax on
set cin
set ts=4
set fo-=r
set smarttab
set cpt=.,w,b,u,t
set mouse=
set sm"'
alias vi='vim'

# system
ulimit -c unlimited

# envirenment
export JAVA_HOME=/opt/jdk8
export PATH=${PATH}:/sbin:/usr/sbin:${HOME}/bin:${JAVA_HOME}/bin
export LC_COLLATE="C"
export LC_CTYPE="zh_CN.UTF-8"
export DRI_PRIME=1

source /etc/bash/bashrc.d/git-completion.bash

# power shell
function _update_ps1() {
    PS1="$(~/powerline-shell.py --mode=compatible --cwd-mode=dironly $? 2> /dev/null)"
}

tclean(){
    find . -name "*~" -exec rm {} +
}

ts2date() {
    date '+%Y%m%d %H:%M:%S' -d@${1}
}

getrepos() {
    curl -X GET https://registry.hengshi.org/v2/_catalog
}

gettags() {
    local repo="$1"
    curl -X GET https://registry.hengshi.org/v2/${repo}/tags/list
}

gethash() {
    local repo="$1"
    local tag="$2"
    curl --header "Accept: application/vnd.docker.distribution.manifest.v2+json" -I -XGET  https://registry.hengshi.org/v2/${repo}/manifests/${tag}
}

delhashdata() {
    local repo="$1"
    local hash="$2"
    curl -I -X DELETE https://registry.hengshi.org/v2/${repo}/manifests/${hash}
}

# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export export KUBECONFIG=~/.kube/config

PG_HOME=${HOME}/workspace/meredith/opt/pgsql
MVN_HOME=${HOME}/workspace/meredith/apache-maven-3.5.3
PDFJAM_HOME=${HOME}/workspace/meredith/workspace/henglabs/pdfjam
ZOOM_HOME=${HOME}/workspace/meredith/opt/zoom
VSCODE_HOME=${HOME}/opt/VSCode-linux-x64
DBEAVER_HOME=${HOME}/workspace/meredith/opt/dbeaver
POSTMAN=${HOME}/workspace/meredith/opt/Postman
V2RAY_HOME=/usr/bin/v2ray
KUBECTX_HOME=${HOME}/workspace/meredith/opt/kubectx
#export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$ZOOM_HOME
export PATH=${PATH}:${PG_HOME}/bin:${MVN_HOME}/bin:${PDFJAM_HOME}/bin:${ZOOM_HOME}:${VSCODE_HOME}/bin:${DBEAVER_HOME}:${POSTMAN}:${V2RAY_HOME}
export LD_PRELOAD=/lib/libreadline.so.8 #for psql readline

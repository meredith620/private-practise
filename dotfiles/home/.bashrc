#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

eval `dircolors -b`
PS1='[\[\033[01;32m\]\u@\h \W\[\033[00m\]]\$ '

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

export LC_COLLATE="C"
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

sj() {
    host="$1"
    ssh -t $host "bash --rcfile ~/lvliang/.lvrc -i"
}

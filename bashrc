# .bashrc

# Source global definitions
#if [ -f /etc/bashrc ]; then
  #. /etc/bashrc
#fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

alias grep='grep --color=auto'
alias gse='grunt serve'
alias mkdir='mkdir -p'
alias rm='trash'
alias ls='ls -alh --color=auto'
alias nmcli='nmcli -p'

export EDITOR='vim'
export TERMINAL='urxvt256c-ml'
export GOPATH=~/go
export PATH=$PATH:/usr/local/go/bin

#vi mode esc timeout
export KEYTIMEOUT=1
bindkey -sM vicmd '^[' '^G'
bindkey -rM viins '^X'

source ~/.local.rc

###############################################################################
# Unused
###############################################################################

#Old prompt layout
#export PS1="\[$(tput setaf 245)\]\n\u@\h\[$(tput setaf 10)\]:\[$(tput setaf 67)\]\w\n\[$(tput setaf 7)\]\T\$ \[\e[0;0m\e[m\]"

#source ~/bin/tmuxinator.bash

#alias vim='gvim -v'

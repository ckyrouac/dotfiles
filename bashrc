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
alias v='vim'

export EDITOR='vim'
export TERMINAL='urxvt256c-ml'
export GOPATH=~/go
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:/home/chris/dev/ide/SqlWorkbenchJ
export PATH=$PATH:/usr/pgsql-9.3/bin

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

export HISTTIMEFORMAT="%T"
export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

# execute `ls` when no command entered
precmd() { 
  CUR_HIST=`history -t "%T" -1`
  if [[ $PRE_HIST == $CUR_HIST ]]; then
    ls
  fi
  PRE_HIST=$CUR_HIST
}

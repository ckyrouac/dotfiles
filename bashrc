# .bashrc

# Source global definitions
#if [ -f /etc/bashrc ]; then
  #. /etc/bashrc
#fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=
set -o vi

alias battery='acpitool -B'
alias grep='grep --color=auto'
alias gse='grunt serve'
alias mkdir='mkdir -p'
alias rm='trash'
alias ls='ls -alhH --color=auto'
alias nmcli='nmcli -p'
alias v='vim'
alias json='python -mjson.tool'
alias p='pgrep -fa'
alias viewimage='feh'
alias kc='kubectl'
function kcn {
    kubectl config set-context --current --namespace=$1
}
function kubecluster {
    kubectl config use-context $1
}
alias kcp='kubectl get pods'

export EDITOR='nvim'
export VISUAL='nvim'
export TERMINAL='urxvt256c-ml'
export GOPATH=~/projects/gopath
export PATH=$PATH:${GOPATH//://bin:}/bin
export PATH=$PATH:/home/chris/dev/ide/SqlWorkbenchJ
export PATH=$PATH:/usr/pgsql-9.3/bin
export PATH=$PATH:/home/chris/bin/minishift/minishift-1.34.2-linux-amd64
export PATH=$PATH:/home/chris/bin/crc
export PATH=$PATH:/usr/local/kubebuilder/bin
export PATH=$PATH:/home/chris/bin
#export PATH=$PATH:/home/chris/.rover/bin

#hack to fix clipboard in neovim
export WAYLAND_DISPLAY=wayland-0

#java
export JAVA_HOME=/home/chris/java-home
export PATH=$PATH:/home/chris/maven

#android
export PATH=$PATH:/home/chris/Android/Sdk/platform-tools

#openshift
# source oc_completion.sh

#vi mode esc timeout
export KEYTIMEOUT=1
#bindkey -sM vicmd '^[' '^G'
#bindkey -rM viins '^X'

#git
alias gro='git fetch origin && git rebase origin/master'
alias gnb='git checkout -b'

source ~/.local.rc

#projects
alias inventory='cd ~/projects/insights-host-inventory'
alias xjoin-operator='cd ~/projects/xjoin-operator'
alias cyndi='cd ~/projects/cyndi'
alias appsre='cd ~/projects/app-interface'

###############################################################################
# Unused
###############################################################################

#Old prompt layout
#export PS1="\[$(tput setaf 245)\]\n\u@\h\[$(tput setaf 10)\]:\[$(tput setaf 67)\]\w\n\[$(tput setaf 7)\]\T\$ \[\e[0;0m\e[m\]"

#source ~/bin/tmuxinator.bash

#alias vim='gvim -v'

export HISTTIMEFORMAT="%T"
export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
export PATH=$HOME/.node/bin:$PATH
export NODE_PATH=$HOME/.node/lib/node_modules:$NODE_PATH
export MANPATH="$HOME/.node/share/man:$MANPATH"  

export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# execute `ls` when no command entered
#precmd() { 
  #CUR_HIST=`history -t "%T" -1`
  #if [[ $PRE_HIST == $CUR_HIST ]]; then
    #ls
  #fi
  #PRE_HIST=$CUR_HIST
#}

#python
export PATH=$PATH:/home/chris/.local/bin
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi

#vim
alias vim='nvim'

#minikube dev env aliases
alias stop-clowder='kubectl scale --replicas=0 deployments/clowder-controller-manager -n clowder-system'
alias start-clowder='kubectl scale --replicas=1 deployments/clowder-controller-manager -n clowder-system'


#source <(oc completion zsh)

if [ -f `which powerline-daemon` ]; then
	powerline-daemon -q
	POWERLINE_BASH_CONTINUATION=1
	POWERLINE_BASH_SELECT=1
	. /usr/share/powerline/bash/powerline.sh
fi

#fzf
export FZF_TMUX=1
source ~/.vim/fzf-key-bindings.zsh

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/home/chris/.sdkman"
[[ -s "/home/chris/.sdkman/bin/sdkman-init.sh" ]] && source "/home/chris/.sdkman/bin/sdkman-init.sh"
#source "/home/chris/.rover/env"

. "$HOME/.cargo/env"

[[ -s "/home/chris/.gvm/scripts/gvm" ]] && source "/home/chris/.gvm/scripts/gvm"

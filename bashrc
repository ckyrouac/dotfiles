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

export KEYTIMEOUT=1

#git
alias gro='git fetch origin && git rebase origin/master'
alias gnb='git checkout -b'

source ~/.local.rc

export HISTTIMEFORMAT="%T"

#vim
alias vim='nvim'

#minikube dev env aliases
alias stop-clowder='kubectl scale --replicas=0 deployments/clowder-controller-manager -n clowder-system'
alias start-clowder='kubectl scale --replicas=1 deployments/clowder-controller-manager -n clowder-system'

if [ -f `which powerline-daemon` ]; then
	powerline-daemon -q
	POWERLINE_BASH_CONTINUATION=1
	POWERLINE_BASH_SELECT=1
	. /usr/share/powerline/bash/powerline.sh
fi

#fzf
export FZF_TMUX=1

# source ~/dotfiles/fzf.zsh
source ~/dotfiles/fzf-key-bindings.zsh

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/home/chris/.sdkman"
[[ -s "/home/chris/.sdkman/bin/sdkman-init.sh" ]] && source "/home/chris/.sdkman/bin/sdkman-init.sh"

. "$HOME/.cargo/env"

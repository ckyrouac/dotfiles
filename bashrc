# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
alias g='grep'
alias gse='grunt serve'
alias mkdir='mkdir -p'
alias rm='trash'
alias vim='gvim -v'
alias pydebug='python -S /home/chris/Downloads/Komodo-PythonRemoteDebugging-8.5.3-83298-linux-x86_64/pydbgp -d localhost:9000'
export PS1="\[$(tput setaf 245)\]\n\u@\h\[$(tput setaf 7)\]:\[$(tput setaf 67)\]\w\n\[$(tput setaf 7)\]\T\$ \[\e[0;0m\e[m\]"

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

export EDITOR='vim'

source ~/bin/tmuxinator.bash

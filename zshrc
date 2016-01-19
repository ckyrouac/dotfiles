#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

source ~/.bashrc

setopt extended_glob

# kill completion
zstyle ':completion:*:processes' command 'ps -au$USER' 
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;32'
# killall completion
zstyle ':completion:*:processes-names' command 'ps -e -o comm='

function set-prompt () {
        if [ $KEYMAP = vicmd ]; then
            echo -ne "\033]12;Yellow\007"
        else
            echo -ne "\033]12;Gray\007"
        fi
}

function zle-line-init zle-keymap-select {
    set-prompt
#    zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

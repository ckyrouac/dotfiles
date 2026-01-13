# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Add custom completions directory to fpath before prezto loads
fpath=(~/.config/zsh/completions $fpath)

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

export DISABLE_AUTO_TITLE='true'

source ~/.bashrc

setopt extended_glob

# kill completion
zstyle ':completion:*:processes' command 'ps -au$USER' 
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;32'
# killall completion
zstyle ':completion:*:processes-names' command 'ps -e -o comm='

function set-prompt () {
        case $KEYMAP in
            vicmd)
                echo -ne "\033]12;Yellow\007"
                ;;
            visual)
                echo -ne "\033]12;Blue\007"
                ;;
            *)
                echo -ne "\033]12;White\007"
                ;;
        esac
}

function zle-line-init zle-keymap-select {
    set-prompt
#    zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/home/chris/.sdkman"
[[ -s "/home/chris/.sdkman/bin/sdkman-init.sh" ]] && source "/home/chris/.sdkman/bin/sdkman-init.sh"


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export LIBVA_DRIVER_NAME=iHD



# if [ -n "$TOOLBOX_PATH" ]; then
#     alias podman='flatpak-spawn --host podman'
# fi

bindkey '' autosuggest-accept

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

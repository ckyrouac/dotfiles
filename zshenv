if [[ ( "$SHLVL" -eq 1 && ! -o LOGIN ) && -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprofile"
fi

export TERMINAL='st'
export EDITOR='nvim'
export VISUAL='nvim'

export PATH=$PATH:/home/chris/bin
export PATH=$PATH:/home/chris/dotfiles/bin
export PATH=$PATH:/usr/local/kubebuilder/bin

#java
export JAVA_HOME=/home/chris/java-home
export PATH=$PATH:/home/chris/maven

#android
export PATH=$PATH:/home/chris/Android/Sdk/platform-tools

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
export PATH=$HOME/.node/bin:$PATH
export NODE_PATH=$HOME/.node/lib/node_modules:$NODE_PATH
export MANPATH="$HOME/.node/share/man:$MANPATH"  

export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

#python
export PATH=$PATH:/home/chris/.local/bin
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi

#rust
. "$HOME/.cargo/env"

export TMT_VERBOSE=1

#golang
export GOPATH=~/projects/gopath
export PATH=$PATH:${GOPATH//://bin:}/bin
[[ -s "/home/chris/.gvm/scripts/gvm" ]] && source "/home/chris/.gvm/scripts/gvm"

#cuda
export PATH=$PATH:/usr/local/cuda-12.6/bin

#for hypr
export WAYLAND_DISPLAY=wayland-1

#podman machine
# export CONTAINER_CONNECTION="podman-machine-default-root"

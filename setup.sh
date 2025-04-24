#!/bin/bash
###############################################################################
# this was tested on fedora 39
###############################################################################
set -e

function usage () {
  echo -en "--------------------------------------------------------------------------------\n";
  echo -en "$HOME/dotfiles/setup.sh options\n";
  echo -en "--------------------------------------------------------------------------------\n";
  echo -en "-a : setup everything. Takes precedent over other flags. This is default.\n";
  echo -en "-v : setup vim.\n";
  echo -en "-z : setup zsh.\n";
  echo -en "-g : setup git.\n";
  echo -en "-t : setup alacritty terminal.\n";
  echo -en "-x : setup tmux.\n";
  echo -en "-d : setup gnome\n";
  echo -en "-p : setup programming languages\n";
  echo -en "-m : setup misc\n";
  echo -en "-u 'username' : git config --global user.name 'username'. \n";
  echo -en "-e 'email' : git config --global user.email 'email'. \n";
  echo -en "-h : display this message.\n";
}

function info_msg () {
  echo -en "\n********************************************************************************\n"
  echo -en "**** $1\n"
  echo -en "********************************************************************************\n\n"
}

function error () {
  usage;
  echo -en "\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n"
  echo -en "!!!! ERROR $1\n"
  echo -en "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n\n"
  exit 1;
}

function setup-gnome () {
  set +e
  rm -rf ~/.local/share/applications
  set -e
  ln -s ~/dotfiles/applications ~/.local/share

  set +e
  sudo rm -rf ~/.local/share/gnome-shell/extensions
  set -e
  sudo ln -s ~/dotfiles/gnome/extensions ~/.local/share/gnome-shell

  set +e
  mkdir -p ~/.config/run-or-raise
  rm ~/.config/run-or-raise/shortcuts.conf
  set -e
  ln -s ~/dotfiles/gnome/shortcuts.conf ~/.config/run-or-raise/shortcuts.conf

  # cp ~/dotfiles/bin/* ~/bin

  # dconf load -f /org/gnome/ < ~/dotfiles/gnome/gnome-backup.dconf
  info_msg "Done setting up Gnome"
}

function setup-nvim () {
  set +e
  rm -r ~/.config/nvim
  set -e
  ln -s ~/dotfiles/nvim ~/.config/nvim
}

function setup-zsh () {
  set +e
  mv ~/.bashrc ~/.bashrc.orig
  set -e
  ln -s ~/dotfiles/bashrc ~/.bashrc
  touch ~/.local.rc
  set +e
  mv ~/.zshrc ~/.zshrc.orig
  rm ~/.p10k.zsh
  set -e
  ln -s ~/dotfiles/zshrc ~/.zshrc
  ln -s ~/dotfiles/p10k.zsh ~/.p10k.zsh
  ~/dotfiles/setup.zsh
  chsh -s /usr/bin/zsh
}

function setup-git () {
  git config --global user.name "$USERNAME"
  git config --global user.email "$EMAIL"
  git config --global color.diff auto
  git config --global color.status auto
  git config --global core.excludesFile "$HOME/dotfiles/gitignore"

  #diff-so-fancy
  git config --global core.pager "diff-so-fancy | less --tabs=4 -RF"
  git config --global interactive.diffFilter "diff-so-fancy --patch"
  git config --global color.ui true
  git config --global color.diff-highlight.oldNormal    "red bold"
  git config --global color.diff-highlight.oldHighlight "red bold 52"
  git config --global color.diff-highlight.newNormal    "green bold"
  git config --global color.diff-highlight.newHighlight "green bold 22"
  git config --global color.diff.meta       "11"
  git config --global color.diff.frag       "magenta bold"
  git config --global color.diff.func       "146 bold"
  git config --global color.diff.commit     "yellow bold"
  git config --global color.diff.old        "red bold"
  git config --global color.diff.new        "green bold"
  git config --global color.diff.whitespace "red reverse"
}

function setup-terminal () {
  cd /usr/share/fonts
  sudo cp -r ~/dotfiles/fonts/UbuntuMono /usr/share/fonts
  sudo cp -r ~/dotfiles/fonts/JetBrainsMonoNerdFont /usr/share/fonts
  sudo fc-cache /usr/share/fonts

  set +e
  rm -rf ~/.config/alacritty
  ln -s ~/dotfiles/alacritty ~/.config/alacritty
  set -e
}

function setup-tmux () {
  set +e
  rm ~/.tmux.conf
  rm -rf ~/.tmux/plugins
  set -e

  ln -s ~/dotfiles/tmux.conf ~/.tmux.conf
  mkdir -p ~/.tmux/plugins
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  ~/.tmux/plugins/tpm/scripts/install_plugins.sh

  set +e
  tmux new-session -d -s terminal-dropdown
  tmux new-session -d -s terminal-devel
  rm -rf ~/.config/tmux-powerline
  set -e

  ln -s ~/dotfiles/tmux/tmux-powerline ~/.config
}

function setup-programming-languages () {
  #go
  if which go; then
    echo "go already installed"
  else
    echo "installing go"
    set +e
    rm -rf ~/.gvm
    set -e

    bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
    sed -i '$ d' /home/chris/.gvm/scripts/gvm-default
    source /home/chris/.gvm/scripts/gvm

    gvm install go1.4 -B
    gvm use go1.4
    export GOROOT_BOOTSTRAP=$GOROOT
    gvm install go1.17.13
    gvm use go1.17.13
    export GOROOT_BOOTSTRAP=$GOROOT
    gvm install go1.21.5
    gvm use go1.21.5 --default
  fi

  #rust
  if which rustc; then
    echo "rust already insatlled"
  else
    echo "installing rust"
    set +e
    rm /tmp/rustup.sh
    set -e
    curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf -o /tmp/rustup.sh
    chmod u+x /tmp/rustup.sh
    /tmp/rustup.sh -y
  fi

  if which rust-analyzer; then
    echo "rust-analyzer already installed"
  else
    git clone https://github.com/rust-lang/rust-analyzer.git /tmp/rust-analyzer && cd /tmp/rust-analyzer
    cargo xtask install --server
    cd ~/dotfiles
  fi

  #install neovide here for now since it depends on rust
  if which neovide; then
    echo "Neovide already installed"
  else
    echo "Installing neovide"
    cargo install --git https://github.com/neovide/neovide
  fi

  #node
  if which n; then
    echo "n already installed"
  else
    echo "Installing n (node version manager)"
    sudo dnf install npm -y
    sudo npm install -g n
    sudo dnf remove npm -y
    sudo n lts
  fi

  #python
  if which pyenv; then
    echo "pyenv already installed"
  else
    echo "installing pyenv and python"
    curl https://pyenv.run | bash
    pyenv install 3.12.1
    pyenv global 3.12.1
  fi

  #java
  if ls ~/.sdkman; then
    echo "sdkman already installed"
  else
    curl -s "https://get.sdkman.io" | bash
    source "/home/chris/.sdkman/bin/sdkman-init.sh"
    sdk install java 21.0.2-opensdk install java
  fi
}

# place for general setup tasks
function setup-misc () {
  set +e
  rm ~/.tigrc
  set -e
  ln -s ~/dotfiles/.tigrc ~/.tigrc

  #gitui
  set +e
  rm -rf ~/.config/gitui
  set -e
  ln -s ~/dotfiles/gitui ~/.config

  #lazygit
  set +e
  rm -rf ~/.config/lazygit
  set -e
  ln -s ~/dotfiles/lazygit ~/.config
}

while getopts u:e:agvzxcdrthspm flag; do
  case $flag in
    a) # setup all the things
      SETUP_ALL=true
      ;;
    g) # setup git
      SETUP_GIT=true
      ;;
    v) # setup vim
      SETUP_VIM=true
      ;;
    z) # setup zsh
      SETUP_ZSH=true
      ;;
    t) # setup rxvt terminal
      SETUP_TERMINAL=true
      ;;
    x) # setup tmux
      SETUP_TMUX=true
      ;;
    d) # setup tmux
      SETUP_GNOME=true
      ;;
    p) # setup programming languages
      SETUP_PROGRAMMING_LANGUAGES=true
      ;;
    m) # setup misc stuff
      SETUP_MISC=true
      ;;
    h) # help
      usage
      exit 1;
      ;;
    u) # git username
      USERNAME=$OPTARG;
      ;;
    e) # git email
      EMAIL=$OPTARG;
      ;;
    :)
      echo "Option -$OPTARG requires an argument."
      exit 1;
      ;;
    ?)
      echo "Invalid option: -$flag";
      exit 1;
      ;;
  esac
done

# info_msg "Installing deps"
# sudo dnf update -y
# sudo dnf install -y zsh neovim tig make automake gcc gcc-c++ kernel-devel powerline python3-neovim ripgrep lldb rust-lldb tldr fzf gitui shellcheck diff-so-fancy
# sudo dnf groupinstall -y "Development Tools" "Development Libraries"

if [ -z "$SETUP_VIM" ] && \
   [ -z "$SETUP_GIT" ] && \
   [ -z "$SETUP_ZSH" ] && \
   [ -z "$SETUP_TERMINAL" ] && \
   [ -z "$SETUP_TMUX" ] && \
   [ -z "$SETUP_GNOME" ] && \
   [ -z "$SETUP_PROGRAMMING_LANGUAGES" ] && \
   [ -z "$SETUP_MISC" ]; then
  info_msg "Defaulting to setup all"
  SETUP_ALL=true
fi

if { [ "$SETUP_GIT" = true ] || [ "$SETUP_ALL" = true ]; } && { [ -z "$USERNAME" ] || [ -z "$EMAIL" ]; }; then
  if git config --global user.name; then
    echo "Git user.name already defined"
  else
    error "Must provide -u 'username' and -e 'email' when setting up git";
  fi

  if git config --global user.email; then
    echo "Git user.email already defined"
  else
    error "Must provide -u 'username' and -e 'email' when setting up git";
  fi
fi


if { [ "$SETUP_VIM" = true ] || [ "$SETUP_ALL" = true ]; }; then
  info_msg "Setting up Neovim"
  setup-nvim
fi

if { [ "$SETUP_GIT" = true ] || [ "$SETUP_ALL" = true ]; }; then
  info_msg "Setting up git"
  setup-git
fi

if { [ "$SETUP_ZSH" = true ] || [ "$SETUP_ALL" = true ]; }; then
  info_msg "Setting up zsh"
  setup-zsh
fi

if { [ "$SETUP_TERMINAL" = true ] || [ "$SETUP_ALL" = true ]; }; then
  info_msg "Setting up alacritty terminal"
  setup-terminal
fi

if { [ "$SETUP_TMUX" = true ] || [ "$SETUP_ALL" = true ]; }; then
  info_msg "Setting up tmux"
  setup-tmux
fi

if { [ "$SETUP_GNOME" = true ] || [ "$SETUP_ALL" = true ]; }; then
  info_msg "Setting up gnome"
  setup-gnome
fi

if { [ "$SETUP_PROGRAMMING_LANGUAGES" = true ]; }; then
  info_msg "Setting up programming languages"
  setup-programming-languages
fi

if { [ "$SETUP_MISC" = true ] || [ "$SETUP_ALL" = true ]; }; then
  info_msg "Setting up misc"
  setup-misc
fi

info_msg "Done"

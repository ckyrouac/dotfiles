#!/bin/bash
###############################################################################
# this was tested on fedora 39
###############################################################################
set -e

function usage () {
  echo -en "--------------------------------------------------------------------------------\n";
  echo -en "~/.vim/setup.sh options\n";
  echo -en "--------------------------------------------------------------------------------\n";
  echo -en "-a : setup everything. Takes precedent over other flags. This is default.\n";
  echo -en "-v : setup vim.\n";
  echo -en "-z : setup zsh.\n";
  echo -en "-g : setup git.\n";
  echo -en "-t : setup st terminal.\n";
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
  ln -s ~/.vim/applications ~/.local/share

  set +e
  sudo rm -rf ~/.local/share/gnome-shell/extensions
  set -e
  sudo ln -s ~/.vim/gnome/extensions ~/.local/share/gnome-shell

  set +e
  mkdir -p ~/.config/run-or-raise
  rm ~/.config/run-or-raise/shortcuts.conf
  set -e
  ln -s ~/.vim/gnome/shortcuts.conf ~/.config/run-or-raise/shortcuts.conf

  cp ~/.vim/bin/* ~/bin

  dconf load -f /org/gnome/ < ~/.vim/gnome/gnome-backup.dconf
  info_msg "Done setting up Gnome"
}

function setup-nvim () {
  set +e
  rm -r ~/.config/nvim
  set -e
  ln -s ~/.vim/nvim ~/.config/nvim
}

function setup-zsh () {
  set +e
  mv ~/.bashrc ~/.bashrc.orig
  set -e
  ln -s ~/.vim/bashrc ~/.bashrc
  touch ~/.local.rc
  set +e
  mv ~/.zshrc ~/.zshrc.orig
  rm ~/.p10k.zsh
  set -e
  ln -s ~/.vim/zshrc ~/.zshrc
  ln -s ~/.vim/p10k.zsh ~/.p10k.zsh
  ~/.vim/setup.zsh
  chsh -s /usr/bin/zsh
}

function setup-git () {
  git config --global user.name $USERNAME
  git config --global user.email $EMAIL
  git config --global color.diff auto
  git config --global color.status auto
}

function setup-terminal () {
  cd /usr/share/fonts
  sudo cp -r ~/.vim/fonts/UbuntuMono /usr/share/fonts
  sudo fc-cache /usr/share/fonts

  set +e
  mkdir -p ~/bin
  cd ~/bin
  rm -rf ~/bin/st
  set -e

  git clone git@github.com:ckyrouac/st.git
  cd ~/bin/st
  sudo make clean install
  cd ~/.vim
}

function setup-tmux () {
  set +e
  rm ~/.tmux.conf
  rm -rf ~/.tmux/plugins
  set -e

  ln -s ~/.vim/tmux.conf ~/.tmux.conf
  mkdir -p ~/.tmux/plugins
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  ~/.tmux/plugins/tpm/scripts/install_plugins.sh

  set +e
  tmux new-session -d -s terminal-dropdown
  tmux new-session -d -s terminal-devel
  rm -rf ~/.config/tmux-powerline
  set -e

  ln -s ~/.vim/tmux/tmux-powerline ~/.config
}

function setup-programming-languages () {
  #go
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

  #rust
  set +e
  rm /tmp/rustup.sh
  set -e
  curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf -o /tmp/rustup.sh
  chmod u+x /tmp/rustup.sh
  /tmp/rustup.sh -y

  #install neovide here for now since it depends on rust
  cargo install --git https://github.com/neovide/neovide
}

# place for general setup tasks
function setup-misc () {
  set +e
  rm ~/.tigrc
  set -e
  ln -s ~/.vim/.tigrc ~/.tigrc

  #gitui
  set +e
  rm -rf ~/.config/gitui
  set -e
  ln -s ~/.vim/gitui ~/.config

  #lazygit
  set +e
  rm -rf ~/.config/lazygit
  set -e
  ln -s ~/.vim/lazygit ~/.config
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
    ?)
      echo "Invalid option: -$flag";
      exit 1;
      ;;
    :)
      echo "Option -$OPTARG requires an argument."
      exit 1;
      ;;
  esac
done

info_msg "Installing deps"
sudo yum update
sudo yum install -y htop the_silver_searcher fd-find zsh util-linux-user trash-cli dejavu-fonts-all tmux xclip neovim tig make automake gcc gcc-c++ kernel-devel xorg-x11-proto-devel libX11-devel fontconfig-devel libXft-devel powerline python3-neovim keepassxc ripgrep bison gnome-extensions-app google-chrome-stable lldb rust-lldb tldr fzf gitui libstdc++-static seahorse
sudo dnf groupinstall "Development Tools" "Development Libraries"

if ([ -z $SETUP_VIM ] && [ -z $SETUP_GIT ] && [ -z $SETUP_ZSH ] && [ -z $SETUP_TERMINAL ] && [ -z $SETUP_TMUX ] && [ -z $SETUP_GNOME ] && [ -z $SETUP_PROGRAMMING_LANGUAGES ] && [ -z $SETUP_MISC ]); then
  info_msg "Defaulting to setup all"
  SETUP_ALL=true
fi

if ([ "$SETUP_GIT" = true ] || [ "$SETUP_ALL" = true ]) && ([ -z "$USERNAME" ] || [ -z "$EMAIL" ]); then
  error "Must provide -u 'username' and -e 'email' when setting up git";
fi


if ([ "$SETUP_VIM" = true ] || [ "$SETUP_ALL" = true ]); then
  info_msg "Setting up Neovim"
  setup-nvim
fi

if ([ "$SETUP_GIT" = true ] || [ "$SETUP_ALL" = true ]); then
  info_msg "Setting up git"
  setup-git
fi

if ([ "$SETUP_ZSH" = true ] || [ "$SETUP_ALL" = true ]); then
  info_msg "Setting up zsh"
  setup-zsh
fi

if ([ "$SETUP_TERMINAL" = true ] || [ "$SETUP_ALL" = true ]); then
  info_msg "Setting up st terminal"
  setup-terminal
fi

if ([ "$SETUP_TMUX" = true ] || [ "$SETUP_ALL" = true ]); then
  info_msg "Setting up tmux"
  setup-tmux
fi

if ([ "$SETUP_GNOME" = true ] || [ "$SETUP_ALL" = true ]); then
  info_msg "Setting up gnome"
  setup-gnome
fi

if ([ "$SETUP_PROGRAMMING_LANGUAGES" = true ] || [ "$SETUP_ALL" = true ]); then
  info_msg "Setting up programming languages"
  setup-programming-languages
fi

if ([ "$SETUP_MISC" = true ] || [ "$SETUP_ALL" = true ]); then
  info_msg "Setting up misc"
  setup-misc
fi

info_msg "Done"

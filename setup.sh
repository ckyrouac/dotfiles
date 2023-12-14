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
  ln -s ~/.vim/applications ~/.local/share/applications

  set +e
  sudo rm -rf /usr/share/gnome-shell/extensions
  set -e
  sudo ln -s ~/.vim/gnome/extensions /usr/share/gnome-shell/extensions

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
  cd ~/.vim
  mkdir -p ~/.config/nvim
  set +e
  rm ~/.config/nvim/init.vim
  rm ~/.config/nvim/lazy-lock.json
  set -e
  ln -s ~/.vim/nvim_init.vim ~/.config/nvim/init.vim
  ln -s ~/.vim/nvim-lazy-lock.json ~/.config/nvim/lazy-lock.json
}

function setup-zsh () {
  set +e
  mv ~/.bashrc ~/.bashrc.orig
  set -e
  ln -s ~/.vim/bashrc ~/.bashrc
  touch ~/.local.rc
  set +e
  mv ~/.zshrc ~/.zshrc.orig
  set -e
  ln -s ~/.vim/zshrc ~/.zshrc
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
  git clone git://git.suckless.org/st
  set -e
  cd ~/bin/st

  set +e
  rm ~/bin/st/config.h
  set -e

  ln -s ~/.vim/st/config.h ~/bin/st/config.h

  sudo make clean install
  cd ~/.vim
}

function setup-tmux () {
  set +e
  rm ~/.tmux.conf
  ln -s ~/.vim/tmux.conf ~/.tmux.conf
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins
  set -e
  ~/.tmux/plugins/scripts/install_plugins.sh
  set +e
  rm -rf ~/.config/tmux-powerline
  tmux new-session -d -s terminal-dropdown
  tmux new-session -d -s terminal-devel
  set -e

  ln -s ~/.vim/tmux/tmux-powerline ~/.config
}

function setup-programming-languages () {
  #go
  set +e
  bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
  source /home/chris/.gvm/scripts/gvm
  set -e

  gvm install go1.4 -B
  gvm use go1.4
  export GOROOT_BOOTSTRAP=$GOROOT
  gvm install go1.17.13
  gvm use go1.17.13
  export GOROOT_BOOTSTRAP=$GOROOT
  gvm install go1.21.5
  gvm use go1.21.5 --default
}

while getopts u:e:agvzxcdrthsp flag; do
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
sudo yum install -y htop the_silver_searcher fd-find zsh util-linux-user trash-cli dejavu-fonts-all tmux xclip neovim tig make automake gcc gcc-c++ kernel-devel xorg-x11-proto-devel libX11-devel fontconfig-devel libXft-devel powerline python3-neovim keepassxc ripgrep bison

if ([ -z $SETUP_VIM ] && [ -z $SETUP_GIT ] && [ -z $SETUP_ZSH ] && [ -z $SETUP_TERMINAL ] && [ -z $SETUP_TMUX ] && [ -z $SETUP_GNOME ] && [ -z $SETUP_PROGRAMMING_LANGUAGES ]); then
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

info_msg "Done"

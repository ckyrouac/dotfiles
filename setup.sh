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
  echo -en "-t : setup rxvt terminal.\n";
  echo -en "-x : setup tmux.\n";
  echo -en "-d : setup gnome\n";
  echo -en "-u 'username' : git config --global user.name 'username'. \n";
  echo -en "-e 'email' : git config --global user.email 'email'. \n";
  echo -en "-h : display this message.\n";
}

function info_msg () {
  echo -en "\n********************************************************************************\n"
  echo -en "**** $1\n"
  echo -en "********************************************************************************\n\n"
}

DEPS_INSTALLED=false
function install-deps () {
  if ([ $DEPS_INSTALLED = false ]); then
      info_msg "Installing deps"
      sudo yum install -y python-devel cmake gcc-c++ autoconf make automake node npm htop kernel-devel the_silver_searcher fd-find libXau-devel.x86_64 libxcb-devel.x86_64 libXaw-devel.x86_64 libXcm-devel.x86_64 libxdo-devel.x86_64 libXres-devel.x86_64 libxnm-devel.x86_64	htop zsh util-linux-user trash-cli dejavu-fonts-all tmux xclip
  fi
  DEPS_INSTALLED=true
}

function setup-gnome () {
  set +e
  mv ~/.local/share/applications ~/.vim/applications
  rm ~/.local/share/applications
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
  info_msg "Done setting up Gnome"
}



function setup-nvim () {
  cd ~/.vim
  mv ~/.vimrc ~/.vimrc.orig
  ln -s ~/.vim/vimrc ~/.vimrc
  ln -s ~/.vim/nvim_init.vim ~/.config/nvim/init.vim
}

function setup-zsh () {
  mv ~/.bashrc ~/.bashrc.orig
  ln -s ~/.vim/bashrc ~/.bashrc
  touch ~/.local.rc
  mv ~/.zshrc ~/.zshrc.orig
  ln -s ~/.vim/zshrc ~/.zshrc
  ~/.vim/setup.zsh
  chsh -s /usr/bin/zsh
}

function setup-git () {
  sudo yum -y install tig
  git config --global user.name $USERNAME
  git config --global user.email $EMAIL
  git config --global color.diff auto
  git config --global color.status auto
}

function setup-terminal () {
  echo "Installing ubuntu-font-family..."
  cd /usr/share/fonts
  sudo wget http://font.ubuntu.com/download/ubuntu-font-family-0.83.zip
  sudo unzip ubuntu-font-family-0.83.zip
  sudo rm ubuntu-font-family-0.83.zip
  sudo cp ~/.vim/fonts/Ubuntu\ Mono\ derivative\ Powerline\ Plus\ Nerd\ File\ Types\ Mono.ttf /usr/share/fonts/ubuntu-font-family-0.83
  sudo fc-cache /usr/share/fonts
  echo "Done."

  mkdir -p ~/bin/st
  cd ~/bin/st
  git clone git://git.suckless.org/st
  cp ~/.vim/st/config.h ~/bin/st/config.h
  sudo yum install make automake gcc gcc-c++ kernel-devel xorg-x11-proto-devel libX11-devel fontconfig-devel libXft-devel
  sudo make clean install
}

function setup-tmux () {
  ln -s ~/.vim/tmux.conf ~/.tmux.conf
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins
}

while getopts u:e:agvzxcdrths flag; do
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

if ([ "$SETUP_GIT" = true ] || [ "$SETUP_ALL" = true ]) && ([ -z "$USERNAME" ] || [ -z "$EMAIL" ]); then
  info_msg -en "\n"
  info_msg -en "Must provide -u 'username' and -e 'email' when setting up git!\n"
  info_msg -en "\n"
  usage;
  exit 1;
fi

if ([ -z $SETUP_VIM ] && [ -z $SETUP_GIT ] && [ -z $SETUP_ZSH ] && [ -z $SETUP_TERMINAL ] && [ -z $SETUP_TMUX ] && [ -z $SETUP_GNOME ]); then
  info_msg "Defaulting to setup all"
  SETUP_ALL=true
  sudo yum update;
fi

if ([ "$SETUP_VIM" = true ] || [ "$SETUP_ALL" = true ]); then
  info_msg "Setting up vim"
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
  info_msg "Setting up rxvt terminal"
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

info_msg "Done"

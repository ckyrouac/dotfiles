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

function error () {
  usage;
  echo -en "\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n"
  echo -en "!!!! ERROR $1\n"
  echo -en "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n\n"
  exit 1;
}

info_msg "Installing deps"
sudo yum update
sudo yum install -y htop the_silver_searcher fd-find zsh util-linux-user trash-cli dejavu-fonts-all tmux xclip neovim tig make automake gcc gcc-c++ kernel-devel xorg-x11-proto-devel libX11-devel fontconfig-devel libXft-devel powerline python3-neovim keepassxc

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
  set +e
  mv ~/.vimrc ~/.vimrc.orig
  set -e
  ln -s ~/.vim/vimrc ~/.vimrc

  mkdir -p ~/.config/nvim
  set +e
  rm ~/.config/nvim/init.vim
  set -e
  ln -s ~/.vim/nvim_init.vim ~/.config/nvim/init.vim

  nvim --headless +PlugInstall +qall
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
  sudo cp ~/.vim/fonts/Ubuntu\ Mono\ derivative\ Powerline\ Plus\ Nerd\ File\ Types\ Mono.ttf /usr/share/fonts/ubuntu-font-family-0.83
  sudo fc-cache /usr/share/fonts

  set +e
  mkdir -p ~/bin
  cd ~/bin
  git clone git://git.suckless.org/st
  set -e
  cd ~/bin/st
  cp ~/.vim/st/config.h ~/bin/st/config.h
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

  ln -s ~/.vim/tmux/tmux-powerline ~/.config/tmux-powerline
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

if ([ -z $SETUP_VIM ] && [ -z $SETUP_GIT ] && [ -z $SETUP_ZSH ] && [ -z $SETUP_TERMINAL ] && [ -z $SETUP_TMUX ] && [ -z $SETUP_GNOME ]); then
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

info_msg "Done"

#!/bin/bash
###############################################################################
# this was tested on vanilla rhel6/7 and fedora 21/22
###############################################################################

function usage () {
  echo -en "--------------------------------------------------------------------------------\n";
  echo -en "~/.vim/setup.sh options\n";
  echo -en "--------------------------------------------------------------------------------\n";
  echo -en "-a : setup everything. Takes precedent over other flags. This is default.\n";
  echo -en "-v : setup vim.\n";
  echo -en "-z : setup zsh.\n";
  echo -en "-r : setup ruby.\n";
  echo -en "-g : setup git.\n";
  echo -en "-u 'username' : git config --global user.name 'username'. \n";
  echo -en "-e 'email' : git config --global user.email 'email'. \n";
  echo -en "-h : display this message.\n";
}

function setup-vim () {
  install-deps
  sudo yum install -y vim
  mv ~/.vimrc ~/.vimrc.orig
  ln -s ~/.vim/vimrc ~/.vimrc
  git submodule init
  git submodule update
  cd bundle/YouCompleteMe
  git submodule update --init --recursive
  cd ~/
  mkdir ycm_build
  cd ycm_build
  cmake -G "Unix Makefiles" . ~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp
  make ycm_support_libs
}

function setup-zsh () {
  mv ~/.bashrc ~/.bashrc.orig
  ln -s ~/.vim/bashrc ~/.bashrc
  touch ~/.local.rc
  mv ~/.zshrc ~/.zshrc.orig
  ln -s ~/.vim/zshrc ~/.zshrc
  REDHAT_VERSION=`cat /etc/redhat-release`
  ZSH_VERSION=`zsh --version`
  if [[ $REDHAT_VERSION == "Red Hat Enterprise Linux Server release 6"* ]]; then
    install-deps
    yum install -y ncurses-devel
    cd ~/
    git clone git://git.code.sf.net/p/zsh/code zsh-code
    cd zsh-code
    autoheader
    autoconf
    ./configure
    make
    sudo make install
    ln -s /usr/local/bin/zsh /bin/zsh
    rm -rf ~/zsh-code
    cd ~/.vim
  else
    yum install zsh 
  fi

  ~/.vim/setup.zsh
}

function setup-git () {
  if [[ $REDHAT_VERSION == "Red Hat Enterprise Linux Server release 6"* ]]; then
    install-deps
    yum remove -y git
    yum install -y curl-devel expat-devel gettext-devel openssl-devel zlib-devel perl-ExtUtils-MakeMaker
    cd /usr/src
    wget https://git-core.googlecode.com/files/git-1.8.5.3.tar.gz
    tar xzf git-1.8.5.3.tar.gz
    cd git-1.8.5.3
    make prefix=/usr/src/git all
    make prefix=/usr/src/git install
    echo "export PATH=$PATH:/usr/src/git/bin" >> ~/.local.rc
    source ~/.local.rc
  fi
  git config --global user.name $USERNAME
  git config --global user.email $EMAIL
  git config --global color.diff auto
  git config --global color.status auto
}

function install-deps () {
  DEPS_INSTALLED=false
  if !DEPS_INSTALLED; then
    sudo yum install -y python-devel cmake gcc-c++ autoconf make automake
  fi
  DEPS_INSTALLED=true
}

while getopts u:e:agvzrhs flag; do
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
    r) # setup ruby
      SETUP_RUBY=true
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
      echo "Invalid option: -$OPTARG";
      exit 1;
      ;;
    :)
      echo "Option -$OPTARG requires an argument."
      exit 1;
      ;;
  esac
done

if ($SETUP_GIT || $SETUP_ALL) && ([ -z "$USERNAME" ] || [ -z "$EMAIL" ]); then
  echo -en "\n"
  echo -en "Must provide -u 'username' and -e 'email' when setting up git!\n"
  echo -en "\n"
  usage;
  exit 1;
fi

if [ -z $SETUP_VIM ] && [ -z $SETUP_GIT ] && [ -z $SETUP_ZSH ]; then
  SETUP_ALL=true
fi

if [ $SETUP_VIM ] || [ $SETUP_ALL ]; then
  echo "Setting up vim..."
  setup-vim
fi

if [ $SETUP_GIT ] || [ $SETUP_ALL ]; then
  echo "Setting up git..."
  setup-git
fi

if [ $SETUP_ZSH ] || [ $SETUP_ALL ]; then
  echo "Setting up zsh..."
  setup-zsh
fi


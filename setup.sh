#!/bin/bash
USERNAME=$1
EMAIL=$2

# this was tested on vanilla rhel6/7 and fedora 21/22

#install dependencies
sudo yum install -y vim python-devel cmake gcc-c++ autoconf make automake

#symlinks
mv ~/.vimrc ~/.vimrc.orig
mv ~/.bashrc ~/.bashrc.orig
mv ~/.zshrc ~/.zshrc.orig
ln -s ~/.vim/vimrc ~/.vimrc
ln -s ~/.vim/bashrc ~/.bashrc
ln -s ~/.vim/zshrc ~/.zshrc
touch ~/.local.rc

#vim submodules
git submodule init
git submodule update
cd bundle/YouCompleteMe
git submodule update --init --recursive
cd ~/
mkdir ycm_build
cd ycm_build
cmake -G "Unix Makefiles" . ~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp
make ycm_support_libs

#zsh
REDHAT_VERSION=`cat /etc/redhat-release`
ZSH_VERSION=`zsh --version`
if [[ $REDHAT_VERSION == "Red Hat Enterprise Linux Server release 6"* ]]; then
  yum install ncurses-devel
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

#git
git config --global user.name $USERNAME
git config --global user.email $EMAIL
git config --global color.diff auto
git config --global color.status auto

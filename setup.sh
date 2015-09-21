#!/bin/bash

# this was tested on vanilla rhel6/7 and fedora 21/22

#install dependencies
sudo yum install -y vim python-devel cmake gcc-c++ zsh

#symlinks
mv ~/.vimrc ~/.vimrc.orig
mv ~/.bashrc ~/.bashrc.orig
ln -s ~/.vim/vimrc ~/.vimrc
ln -s ~/.vim/bashrc ~/.bashrc
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
~/.vim/setup.zsh

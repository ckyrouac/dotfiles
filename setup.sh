#!/bin/bash

#symlinks
ln -s ~/.vim/vimrc ~/.vimrc
ln -s ~/.vim/bashrc ~/.bashrc
touch ~/.local.rc

#vim submodules
git submodule init
git submodule update
cd bundle/YouCompleteMe
sudo yum install python-devel cmake
git submodule update --init --recursive
cd ~/
mkdir ycm_build
cd ycm_build
cmake -G "Unix Makefiles" . ~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp
make ycm_support_libs

#!/bin/bash
#compile vim
mkdir -p ~/dev/projects/third_party
cd ~/dev/projects/third_party
git clone https://github.com/vim/vim
cd vim

# install deps to compile vim
sudo yum install -y ruby ruby-devel lua lua-devel luajit \
    luajit-devel ctags git python python-devel \
    python3 python3-devel tcl-devel \
    perl perl-devel perl-ExtUtils-ParseXS \
    perl-ExtUtils-XSpp perl-ExtUtils-CBuilder \
    perl-ExtUtils-Embed redhat-rpm-config ncurses-devel cmake nodejs
sudo yum remove vim
sudo ln -s /usr/bin/xsubpp /usr/share/perl5/ExtUtils/xsubpp 

#build vim
CFLAGS+="-O -fPIC -Wformat" ./configure --enable-pythoninterp=yes --enable-python3interp=yes --enable-luainterp=yes --with-features=huge --with-luajit --enable-rubyinterp=yes --enable-perlinterp=yes --with-compiledby=ckyrouac --with-python-config-dir=/usr/lib64/python2.7/config --with-python3-config-dir=/usr/lib64/python3.4/config-3.4m --enable-fontset --enable-tclinterp --enable-multibyte --enable-fail-if-missing --with-x --enable-gui=auto
make
sudo make install

#setup vim config
cd ~/.vim
mv ~/.vimrc ~/.vimrc.orig
ln -s ~/.vim/vimrc ~/.vimrc

#setup vim plugins
git submodule init
git submodule update
cd bundle/tern_for_vim
npm install
sudo npm install -g jscs
sudo npm install -g jshint
sudo npm install -g eslint
cd bundle/YouCompleteMe
git submodule update --init --recursive
./install.py --clang-completer --tern-completer

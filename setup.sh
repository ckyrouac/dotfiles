#!/bin/bash
###############################################################################
# this was tested on vanilla rhel6/7 and fedora 21/22/23
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
  echo -en "-t : setup rxvt terminal.\n";
  echo -en "-d : setup devilspie2.\n";
  echo -en "-x : setup tmux.\n";
  echo -en "-c : setup google chrome.\n";
  echo -en "-u 'username' : git config --global user.name 'username'. \n";
  echo -en "-e 'email' : git config --global user.email 'email'. \n";
  echo -en "-h : display this message.\n";
}

function setup-vim () {
  install-deps

  #compile vim
  mkdir -p ~/dev/projects/third_party
  cd ~/dev/projects/third_party
  git clone https://github.com/vim/vim
  cd vim

  # install deps to compile vim
  if ([ -a /bin/yum ]); then
    sudo yum install -y ruby ruby-devel lua lua-devel luajit \
        luajit-devel ctags git python python-devel \
        python3 python3-devel tcl-devel \
        perl perl-devel perl-ExtUtils-ParseXS \
        perl-ExtUtils-XSpp perl-ExtUtils-CBuilder \
        perl-ExtUtils-Embed redhat-rpm-config ncurses-devel cmake nodejs
    sudo yum remove vim
  elif ([ -a /bin/apt ]); then
    sudo apt install -y ruby ruby-dev lua5.2-dev luajit libluajit-5.1-dev ctags git \
        python python3 python3-dev python-dev
  fi
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
    sudo yum install -y ncurses-devel
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
    sudo yum install -y zsh 
  fi

  ~/.vim/setup.zsh
  chsh -s /usr/bin/zsh
}

function setup-git () {
  if [[ $REDHAT_VERSION == "Red Hat Enterprise Linux Server release 6"* ]]; then
    install-deps
    sudo yum remove -y git
    sudo yum install -y curl-devel expat-devel gettext-devel openssl-devel zlib-devel perl-ExtUtils-MakeMaker
    cd /usr/src
    wget https://git-core.googlecode.com/files/git-1.8.5.3.tar.gz
    tar xzf git-1.8.5.3.tar.gz
    cd git-1.8.5.3
    make prefix=/usr/src/git all
    make prefix=/usr/src/git install
    echo "export PATH=$PATH:/usr/src/git/bin" >> ~/.local.rc
    source ~/.local.rc
  fi
  sudo yum -y install tig
  git config --global user.name $USERNAME
  git config --global user.email $EMAIL
  git config --global color.diff auto
  git config --global color.status auto
}

# tested on rhel7 only
function setup-ruby () {
  sudo yum install -y gcc-c++ patch readline readline-devel zlib \
    zlib-devel libyaml-devel libffi-devel openssl-devel make \
    bzip2 autoconf automake libtool bison iconv-devel
  gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
  gpg2 --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
  curl -sSL https://get.rvm.io | bash -s stable
  source /etc/profile.d/rvm.sh
  rvm reload
  rvm pkg install zlib
  rvm install 2.2.2 --autolibs=disabled
  rvm use 2.2.2 --default
  gem install git-up
  ruby --version
}

function install-deps () {
  DEPS_INSTALLED=false
  if ([ $DEPS_INSTALLED = false ]); then
    if ([ -a /bin/yum ]); then
      echo "Installing dependencies for yum based systems..."
      sudo yum install -y python-devel cmake gcc-c++ autoconf make automake node npm htop kernel-devel the_silver_searcher libXau-devel.x86_64 libxcb-devel.x86_64 libXaw-devel.x86_64 libXcm-devel.x86_64 libxdo-devel.x86_64 libXres-devel.x86_64 libxnm-devel.x86_64	
    elif ([ -a /bin/apt ]); then
      #TODO find equivelents for:
      #     - kernel-devel
      #     - libxcb-devel
      #     - libXcm-devel
      #     - libxnm-devel
      sudo apt install -y python-dev cmake g++ autoconf make automake node npm htop silversearcher-ag libXau-dev libxcb-dev libXaw7-dev libxdo-dev libXres-dev
    fi
  fi
  DEPS_INSTALLED=true
}

function setup-terminal () {
  sudo yum install -y rxvt-unicode-256color-ml.x86_64
  echo "Installing ubuntu-font-family..."
  cd /usr/share/fonts
  sudo wget http://font.ubuntu.com/download/ubuntu-font-family-0.83.zip
  sudo unzip ubuntu-font-family-0.83.zip
  sudo rm ubuntu-font-family-0.83.zip
  sudo cp ~/.vim/fonts/Ubuntu\ Mono\ derivative\ Powerline\ Plus\ Nerd\ File\ Types\ Mono.ttf /usr/share/fonts/ubuntu-font-family-0.83
  sudo fc-cache /usr/share/fonts
  echo "Done."
  ln -s ~/.vim/Xdefaults ~/.Xdefaults
  xrdb ~/.Xdefaults
}

function setup-devilspie2 () {
  sudo yum install glib2-devel lua-devel libwnck3-devel gtk3-devel
  mkdir ~/apps
  cd ~/apps
  if [ ! -d "./devilspie2"  ]; then
    git clone git://git.savannah.nongnu.org/devilspie2.git
  fi
  cd devilspie2
  make
  sudo make install

  mkdir ~/.config/devilspie2
  cp ~/.vim/devilspie2/main.lua ~/.config/devilspie2/main.lua
}

function setup-tmux () {
  sudo yum install tmux xclip
  ln -s ~/.vim/tmux.conf ~/.tmux.conf
  sudo pip install tmuxp
  #ln -s ~/.vim/tmuxp ~/.tmuxp
}

function setup-chrome () {
  cd /tmp 
  wget https://dl.google.com/linux/linux_signing_key.pub
  sudo rpm --import linux_signing_key.pub
  sudo cp ~/.vim/repos/google-chrome.repo /etc/yum.repos.d/google-chrome.repo
  sudo yum install google-chrome-stable
}

function setup-gnome () {
  sudo yum install xdotool wmctrl gnome-tweak-tool
  # setup ~/bin
  # import dconf settings
  # setup gnome-shortcuts
  #    ./gnome-settings/create-links.sh
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
    r) # setup ruby
      SETUP_RUBY=true
      ;;
    t) # setup rxvt terminal
      SETUP_TERMINAL=true
      ;;
    x) # setup tmux
      SETUP_TMUX=true
      ;;
    d) # setup devilspie2
      SETUP_DEVILSPIE2=true
      ;;
    c) # setup google chrome
      SETUP_CHROME=true
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

if ([ "$SETUP_GIT" = true ] || [ "$SETUP_ALL" = true ]) && ([ -z "$USERNAME" ] || [ -z "$EMAIL" ]); then
  echo -en "\n"
  echo -en "Must provide -u 'username' and -e 'email' when setting up git!\n"
  echo -en "\n"
  usage;
  exit 1;
fi

if ([ -z $SETUP_VIM ] && [ -z $SETUP_GIT ] && [ -z $SETUP_ZSH ] && [ -z $SETUP_RUBY ] && [ -z $SETUP_TERMINAL ] && [ -z $SETUP_DEVILSPIE2 ] && [ -z $SETUP_TMUX ] && [ -z $SETUP_CHROME ]); then
  SETUP_ALL=true
  sudo yum update;
fi

if ([ "$SETUP_VIM" = true ] || [ "$SETUP_ALL" = true ]); then
  echo "Setting up vim..."
  setup-vim
fi

if ([ "$SETUP_GIT" = true ] || [ "$SETUP_ALL" = true ]); then
  echo "Setting up git..."
  setup-git
fi

if ([ "$SETUP_ZSH" = true ] || [ "$SETUP_ALL" = true ]); then
  echo "Setting up zsh..."
  setup-zsh
fi

if ([ "$SETUP_RUBY" = true ] || [ "$SETUP_ALL" = true ]); then
  echo "Setting up ruby..."
  setup-ruby
fi

if ([ "$SETUP_TERMINAL" = true ] || [ "$SETUP_ALL" = true ]); then
  echo "Setting up rxvt terminal..."
  setup-terminal
fi

if ([ "$SETUP_DEVILSPIE2" = true ] || [ "$SETUP_ALL" = true ]); then
  echo "Setting up devilspie2..."
  setup-devilspie2
fi

if ([ "$SETUP_TMUX" = true ] || [ "$SETUP_ALL" = true ]); then
  echo "Setting up tmux..."
  setup-tmux
fi

if ([ "$SETUP_CHROME" = true ] || [ "$SETUP_ALL" = true ]); then
  echo "Setting up google chrome..."
  setup-chrome
fi

if ([ "$SETUP_GNOME" = true ] || [ "$SETUP_ALL" = true ]); then
  echo "Setting up gnome..."
  setup-gnome
fi

FROM quay.io/fedora/fedora-bootc:40

# ARG sshpubkey
ARG gituser
ARG gitemail
ARG user

COPY ./fonts/UbuntuMono /usr/share/fonts
COPY ./bootc/install.toml /usr/lib/bootc/install/00-install.toml

# root commands
RUN \
    if test -z "$user"; then echo "must provide user"; exit 1; fi; \
    if test -z "$gituser"; then echo "must provide gituser"; exit 1; fi; \
    if test -z "$gitemail"; then echo "must provide gitemail"; exit 1; fi; \

    # user
    groupadd -g 1000 $user && \
    useradd -u 1000 -g 1000 -G wheel $user && \
    chown -R $user: /home/$user && \

    # deps
    dnf -y install git fedora-workstation-repositories 'dnf-command(config-manager)' && \
    dnf config-manager --set-enabled google-chrome && \
    dnf install -y htop the_silver_searcher fd-find zsh util-linux-user trash-cli dejavu-fonts-all tmux xclip neovim tig make automake gcc gcc-c++ kernel-devel xorg-x11-proto-devel libX11-devel fontconfig-devel libXft-devel powerline python3-neovim keepassxc ripgrep bison gnome-extensions-app google-chrome-stable lldb rust-lldb tldr fzf gitui libstdc++-static seahorse sqlite-devel tk-devel shellcheck libpq-devel diff-so-fancy alacritty && \
    dnf groupinstall -y "Development Tools" "Development Libraries" && \
    dnf -y install @gnome-desktop && \
    dnf -y update && \
    dnf clean all && \

    # fonts
    fc-cache /usr/share/fonts

# user commands
USER 1000
WORKDIR /home/$user

RUN mkdir ~/.config && \

    # git
    git config --global user.name "$USERNAME" && \
    git config --global user.email "$EMAIL" && \
    git config --global color.diff auto && \
    git config --global color.status auto && \
    git config --global core.excludesFile "$HOME/dotfiles/gitignore" && \

    # diff-so-fancy
    git config --global core.pager "diff-so-fancy | less --tabs=4 -RF" && \
    git config --global interactive.diffFilter "diff-so-fancy --patch" && \
    git config --global color.ui true && \
    git config --global color.diff-highlight.oldNormal    "red bold" && \
    git config --global color.diff-highlight.oldHighlight "red bold 52" && \
    git config --global color.diff-highlight.newNormal    "green bold" && \
    git config --global color.diff-highlight.newHighlight "green bold 22" && \
    git config --global color.diff.meta       "11" && \
    git config --global color.diff.frag       "magenta bold" && \
    git config --global color.diff.func       "146 bold" && \
    git config --global color.diff.commit     "yellow bold" && \
    git config --global color.diff.old        "red bold" && \
    git config --global color.diff.new        "green bold" && \
    git config --global color.diff.whitespace "red reverse" && \

    git clone https://github.com/ckyrouac/dotfiles && \

    # neovim
    ln -s ~/dotfiles/nvim ~/.config/nvim && \

    # zsh
    rm ~/.bashrc && \
    ln -s ~/dotfiles/bashrc ~/.bashrc && \
    touch ~/.local.rc && \
    ln -s ~/dotfiles/zshrc ~/.zshrc && \
    ln -s ~/dotfiles/p10k.zsh ~/.p10k.zsh && \
    ~/dotfiles/setup.zsh && \

    # terminal (alacritty)
    ln -s ~/dotfiles/alacritty ~/.config/alacritty && \

    # tmux
    ln -s ~/dotfiles/tmux.conf ~/.tmux.conf && \
    mkdir -p ~/.tmux/plugins && \
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm && \
    ~/.tmux/plugins/tpm/scripts/install_plugins.sh && \

    tmux new-session -d -s terminal-dropdown && \
    tmux new-session -d -s terminal-devel && \
    rm -rf ~/.config/tmux-powerline && \

    ln -s ~/dotfiles/tmux/tmux-powerline ~/.config && \

    # gnome
    mkdir -p ~/.local/share && \
    rm -rf ~/.local/share/applications && \
    ln -s ~/dotfiles/applications ~/.local/share && \

    rm -rf ~/.local/share/gnome-shell/extensions && \
    ln -s ~/dotfiles/gnome/extensions ~/.local/share/gnome-shell && \

    mkdir -p ~/.config/run-or-raise && \
    ln -s ~/dotfiles/gnome/shortcuts.conf ~/.config/run-or-raise/shortcuts.conf && \

    # tig
    ln -s ~/dotfiles/.tigrc ~/.tigrc && \

    # gitui
    ln -s ~/dotfiles/gitui ~/.config && \

    # lazygit
    ln -s ~/dotfiles/lazygit ~/.config && \

    # go
    bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer) && \
    sed -i '$ d' /home/$user/.gvm/scripts/gvm-default && \
    source /home/$user/.gvm/scripts/gvm && \
    gvm install go1.4 -B && \
    gvm use go1.4 && \
    export GOROOT_BOOTSTRAP=$GOROOT && \
    gvm install go1.17.13 && \
    gvm use go1.17.13 && \
    export GOROOT_BOOTSTRAP=$GOROOT && \
    gvm install go1.21.5 && \
    gvm use go1.21.5 --default && \

    # rust
    curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf -o /tmp/rustup.sh && \
    chmod u+x /tmp/rustup.sh && \
    /tmp/rustup.sh -y && \
    . "$HOME/.cargo/env" && \
    git clone https://github.com/rust-lang/rust-analyzer.git /tmp/rust-analyzer && \
    cd /tmp/rust-analyzer && \
    cargo xtask install --server && \

    # python
    curl https://pyenv.run | bash && \
    ~/.pyenv/bin/pyenv install 3.12.1 && \
    ~/.pyenv/bin/pyenv global 3.12.1

USER 0
RUN chsh -s /usr/bin/zsh $user

WORKDIR /

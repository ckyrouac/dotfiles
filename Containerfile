FROM quay.io/fedora/fedora-bootc:40

# ARG sshpubkey
ARG user
ARG email

# deps
RUN dnf -y install git fedora-workstation-repositories 'dnf-command(config-manager)' && \
    dnf config-manager --set-enabled google-chrome && \
    dnf install -y htop the_silver_searcher fd-find zsh util-linux-user trash-cli dejavu-fonts-all tmux xclip neovim tig make automake gcc gcc-c++ kernel-devel xorg-x11-proto-devel libX11-devel fontconfig-devel libXft-devel powerline python3-neovim keepassxc ripgrep bison gnome-extensions-app google-chrome-stable lldb rust-lldb tldr fzf gitui libstdc++-static seahorse sqlite-devel tk-devel shellcheck libpq-devel diff-so-fancy alacritty && \
    dnf groupinstall -y "Development Tools" "Development Libraries" && \
    dnf -y install @gnome-desktop && \
    dnf -y update && \
    dnf clean all

COPY . /etc/dotfiles

# root commands
RUN if test -z "$user"; then echo "must provide user"; exit 1; fi; \
    if test -z "$email"; then echo "must provide email"; exit 1; fi; \

    # gnome
    # mkdir -p /usr/share/applications && \
    cp -r /etc/dotfiles/applications/* /usr/share/applications && \
    cp -r /etc/dotfiles/gnome/extensions/* /usr/share/gnome-shell/extensions && \

    # bootc
    cp /etc/dotfiles/bootc/install.toml /usr/lib/bootc/install/00-install.toml && \

    # shell
    cp /etc/dotfiles/bashrc /etc/bashrc && \
    cp /etc/dotfiles/zshrc /etc/zshrc && \
    cp /etc/dotfiles/zpreztorc /etc/zpreztorc && \
    cp /etc/dotfiles/p10k.zsh /etc/p10k.zsh && \
    cp /etc/dotfiles/fzf-key-bindings.zsh /etc/fzf-key-bindings.zsh && \

    # fonts
    cp -r /etc/dotfiles/fonts/UbuntuMono /usr/share/fonts && \

    # bootc
    cp /etc/dotfiles/bootc/install.toml /usr/lib/bootc/install/00-install.toml && \

    # neovim
    cp -r /etc/dotfiles/nvim /etc/xdg/nvim && \

    # git
    cp /etc/dotfiles/gitconfig /etc/gitconfig && \

    # tig
    cp /etc/dotfiles/.tigrc /etc/tigrc && \

    # lazygit
    cp -r /etc/dotfiles/lazygit /etc/lazygit && \

    # gitui
    cp -r /etc/dotfiles/gitui /etc/xdg/gitui && \

    # alacritty
    cp /etc/dotfiles/alacritty/alacritty.toml /etc/alacritty.toml && \

    # tmux
    cp /etc/dotfiles/tmux.conf /etc/tmux.conf && \
    cp -r /etc/dotfiles/tmux /etc/tmux && \

    # user
    groupadd -g 1000 $user && \
    useradd -u 1000 -g 1000 -G wheel $user && \
    chown -R $user: /home/$user && \

    # fonts
    fc-cache /usr/share/fonts && \

    # zprezto
    # used my fork of zprezto to substitute config location with /etc
    git clone --recursive https://github.com/ckyrouac/prezto.git "/etc/zprezto" && \

    # shell
    touch /home/chris/.zshrc && \
    chsh -s /usr/bin/zsh chris && \

    # git
    git config --system user.email "$email" && \

    # tmux
    export TMUX_PLUGIN_MANAGER_PATH=/etc/tmux/plugins && \
    mkdir -p /etc/tmux/plugins && \
    git clone https://github.com/tmux-plugins/tpm /etc/tmux/plugins/tpm && \
    /etc/tmux/plugins/tpm/scripts/install_plugins.sh && \

    # go
    rm -rf /usr/local/go && \
    wget https://go.dev/dl/go1.22.5.linux-amd64.tar.gz && \
    tar -xzf go1.22.5.linux-amd64.tar.gz -c /usr/local && \

    pwd


###################################################################

    # # gnome
    # mkdir -p ~/.config/run-or-raise && \
    # ln -s ~/dotfiles/gnome/shortcuts.conf ~/.config/run-or-raise/shortcuts.conf && \

    # # rust
    # curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf -o /tmp/rustup.sh && \
    # chmod u+x /tmp/rustup.sh && \
    # /tmp/rustup.sh -y && \
    # . "$HOME/.cargo/env" && \
    # git clone https://github.com/rust-lang/rust-analyzer.git /tmp/rust-analyzer && \
    # cd /tmp/rust-analyzer && \
    # cargo xtask install --server && \
    #
    # # python
    # curl https://pyenv.run | bash && \
    # ~/.pyenv/bin/pyenv install 3.12.1 && \
    # ~/.pyenv/bin/pyenv global 3.12.1

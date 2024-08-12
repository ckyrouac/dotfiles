FROM quay.io/fedora/fedora-bootc:40

# ARG sshpubkey
ARG email

# deps
RUN dnf -y install git fedora-workstation-repositories 'dnf-command(config-manager)' && \
    dnf config-manager --set-enabled google-chrome && \
    dnf install -y git plymouth htop the_silver_searcher fd-find zsh util-linux-user trash-cli dejavu-fonts-all tmux xclip neovim tig make automake gcc gcc-c++ kernel-devel xorg-x11-proto-devel libX11-devel fontconfig-devel libXft-devel powerline python3-neovim keepassxc ripgrep bison gnome-extensions-app google-chrome-stable lldb rust-lldb rust rust-analyzer cargo clippy tldr fzf gitui libstdc++-static seahorse sqlite-devel tk-devel shellcheck libpq-devel diff-so-fancy alacritty && \
    dnf groupinstall -y "Development Tools" "Development Libraries" && \
    dnf install -y xorg-x11-drv-nouveau golang && \
    dnf -y install @gnome-desktop && \
    dnf clean all && \
    dnf -y install libXScrnSaver libappindicator-gtk3 && \
    wget https://cdn.insynchq.com/builds/linux/3.9.3.60019/insync-3.9.3.60019-fc40.x86_64.rpm && \
    rpm -i insync-3.9.3.60019-fc40.x86_64.rpm && \
    wget https://downloads.slack-edge.com/desktop-releases/linux/x64/4.39.95/slack-4.39.95-0.1.el8.x86_64.rpm && \
    rpm -i slack-4.39.95-0.1.el8.x86_64.rpm

RUN rpm-ostree cliwrap install-to-root /


COPY . /etc/dotfiles

# root commands
RUN if test -z "$email"; then echo "must provide email"; exit 1; fi; \

    # gnome
    cp -r /etc/dotfiles/applications/* /usr/share/applications && \
    cp -r /etc/dotfiles/gnome/extensions/* /usr/share/gnome-shell/extensions && \
    cp /etc/dotfiles/gnome.backup /etc/dconf/db/local.d/01-my-gnome-settings && \
    # dbus-launch dconf load / < /etc/dotfiles/gnome.backup && \
    # mkdir -p ~/.config/run-or-raise && \
    # ln -s ~/dotfiles/gnome/shortcuts.conf ~/.config/run-or-raise/shortcuts.conf && \

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

    # fonts
    fc-cache /usr/share/fonts && \

    # zprezto
    # used my fork of zprezto to substitute config location with /etc
    git clone --recursive https://github.com/ckyrouac/prezto.git "/etc/zprezto" && \

    # git
    git config --system user.email "$email" && \

    # tmux
    export TMUX_PLUGIN_MANAGER_PATH=/etc/tmux/plugins && \
    mkdir -p /etc/tmux/plugins && \
    git clone https://github.com/tmux-plugins/tpm /etc/tmux/plugins/tpm && \
    /etc/tmux/plugins/tpm/scripts/install_plugins.sh

# RUN dnf update -y

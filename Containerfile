FROM quay.io/fedora/fedora-bootc:42

# email is for git config
ARG email

COPY ./fonts/UbuntuMono /usr/share/fonts
COPY ./fonts/JetBrainsMonoNerdFont /usr/share/fonts

# Split into two layers, foundational and extra to avoid rebuilding the foundational
# packages when updating the extra packages

# "foundational" layer that doesn't change frequently
RUN <<EOF
    set -euxo pipefail

    # rpmfusion
    dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

    # enable repos
    dnf -y install fedora-workstation-repositories 'dnf5-command(config-manager)'
    dnf config-manager setopt google-chrome.enabled=1

    # install groups
    # dnf -y group install development-tools c-development gnome-desktop cosmic-desktop system-tools sound-and-video
    dnf -y group install gnome-desktop
EOF

# "extra" layer that changes more frequently
RUN <<EOF
    set -euxo pipefail

    dnf install -y \
        firewalld \
        htop \
        the_silver_searcher \
        fd-find \
        zsh \
        util-linux-user \
        trash-cli \
        dejavu-fonts-all \
        tmux \
        xclip \
        neovim \
        tig \
        make \
        automake \
        gcc \
        gcc-c++ \
        kernel-devel \
        xorg-x11-proto-devel \
        libX11-devel \
        fontconfig-devel \
        libXft-devel \
        powerline \
        python3-neovim \
        keepassxc \
        ripgrep \
        bison \
        gnome-extensions-app \
        google-chrome-stable \
        lldb \
        rust-lldb \
        tldr \
        fzf \
        gitui \
        libstdc++-static \
        seahorse \
        sqlite-devel \
        tk-devel \
        shellcheck \
        libpq-devel \
        diff-so-fancy \
        alacritty \
        bash-completion \
        lm_sensors \
        virt-install \
        virt-manager \
        libXScrnSaver \
        libappindicator-gtk3

    curl -o insync.rpm https://cdn.insynchq.com/builds/linux/3.9.5.60024/insync-3.9.5.60024-fc42.x86_64.rpm
    rpm -i insync.rpm
    rm insync.rpm

    curl -o slack.rpm https://downloads.slack-edge.com/desktop-releases/linux/x64/4.43.51/slack-4.43.51-0.1.el8.x86_64.rpm
    rpm -i slack.rpm
    rm slack.rpm
EOF

COPY . /etc/dotfiles

# temp layer for stuff currently in setup.sh
RUN <<EOF
    if test -z "$email"; then echo "must provide email"; exit 1; fi;

    # gnome
    cp -r /etc/dotfiles/applications/* /usr/share/applications
    cp -r /etc/dotfiles/gnome/extensions/* /usr/share/gnome-shell/extensions
    cp /etc/dotfiles/gnome.backup /etc/dconf/db/local.d/01-my-gnome-settings
    # dbus-launch dconf load / < /etc/dotfiles/gnome.backup
    # mkdir -p ~/.config/run-or-raise
    # ln -s ~/dotfiles/gnome/shortcuts.conf ~/.config/run-or-raise/shortcuts.conf

    # bootc
    cp /etc/dotfiles/bootc/install.toml /usr/lib/bootc/install/00-install.toml

    # shell
    cp /etc/dotfiles/bashrc /etc/bashrc
    cp /etc/dotfiles/zshrc /etc/zshrc
    cp /etc/dotfiles/zpreztorc /etc/zpreztorc
    cp /etc/dotfiles/p10k.zsh /etc/p10k.zsh
    cp /etc/dotfiles/fzf-key-bindings.zsh /etc/fzf-key-bindings.zsh

    # fonts
    cp -r /etc/dotfiles/fonts/UbuntuMono /usr/share/fonts

    # bootc
    cp /etc/dotfiles/bootc/install.toml /usr/lib/bootc/install/00-install.toml

    # neovim
    cp -r /etc/dotfiles/nvim /etc/xdg/nvim

    # git
    cp /etc/dotfiles/gitconfig /etc/gitconfig

    # tig
    cp /etc/dotfiles/.tigrc /etc/tigrc

    # lazygit
    cp -r /etc/dotfiles/lazygit /etc/lazygit

    # gitui
    cp -r /etc/dotfiles/gitui /etc/xdg/gitui

    # alacritty
    cp /etc/dotfiles/alacritty/alacritty.toml /etc/alacritty.toml

    # tmux
    cp /etc/dotfiles/tmux.conf /etc/tmux.conf
    cp -r /etc/dotfiles/tmux /etc/tmux

    # fonts
    fc-cache /usr/share/fonts

    # zprezto
    # used my fork of zprezto to substitute config location with /etc
    git clone --recursive https://github.com/ckyrouac/prezto.git "/etc/zprezto"

    # git
    git config --system user.email "$email"

    # tmux
    export TMUX_PLUGIN_MANAGER_PATH=/etc/tmux/plugins
    mkdir -p /etc/tmux/plugins
    git clone https://github.com/tmux-plugins/tpm /etc/tmux/plugins/tpm
    /etc/tmux/plugins/tpm/scripts/install_plugins.sh
EOF

# machine specific layer
RUN <<EOF
    dnf -y install akmod-nvidia

    dnf clean all
EOF

# Final layer to run quick commands
RUN <<EOF
    set -euxo pipefail

    # fonts
    fc-cache /usr/share/fonts

    # services
    systemctl enable sshd lm_sensors libvirtd.socket
    systemctl set-default graphical.target
EOF

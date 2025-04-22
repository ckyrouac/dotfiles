FROM quay.io/fedora/fedora-bootc:42

COPY ./fonts/UbuntuMono /usr/share/fonts
COPY ./fonts/JetBrainsMonoNerdFont /usr/share/fonts

COPY ./bootc/etc /etc
COPY ./bootc/usr /usr
COPY ./bootc/extra-packages /

COPY . /etc/dotfiles

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

    dnf -y copr enable atim/lazygit
    dnf -y copr enable solopasha/hyprland

    cat /extra-packages | xargs dnf install -y

    # insync
    curl -o insync.rpm https://cdn.insynchq.com/builds/linux/3.9.5.60024/insync-3.9.5.60024-fc42.x86_64.rpm
    rpm -i insync.rpm
    rm insync.rpm

    # slack
    curl -o slack.rpm https://downloads.slack-edge.com/desktop-releases/linux/x64/4.43.51/slack-4.43.51-0.1.el8.x86_64.rpm
    rpm -i slack.rpm
    rm slack.rpm

    # keymapp
    curl -o keymapp.tar.gz https://oryx.nyc3.cdn.digitaloceanspaces.com/keymapp/keymapp-latest.tar.gz
    tar -xvf keymapp.tar.gz
    rm keymapp.tar.gz
    mv keymapp /usr/bin/keymapp
    mv icon.png /usr/share/icons/keymapp.png
EOF

# Final layer to run quick commands
RUN <<EOF
    set -euxo pipefail

    # fonts
    fc-cache /usr/share/fonts

    # services
    systemctl enable sshd lm_sensors libvirtd.socket hyprpaper.service
    systemctl set-default graphical.target

    systemctl disable bootc-fetch-apply-updates.timer
    systemctl disable bootc-fetch-apply-updates.service
EOF

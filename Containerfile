FROM quay.io/fedora/fedora-bootc:42

COPY ./fonts/UbuntuMono /usr/share/fonts
COPY ./fonts/JetBrainsMonoNerdFont /usr/share/fonts

COPY ./bootc/etc /etc
COPY ./bootc/usr /usr
COPY ./bootc/extra-packages /

COPY . /dotfiles

RUN <<EOF
    set -euxo pipefail

    # rpmfusion
    dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

    # enable repos
    dnf -y install fedora-workstation-repositories 'dnf5-command(config-manager)'
    dnf config-manager setopt google-chrome.enabled=1
    dnf copr enable -y erikreider/SwayNotificationCenter

    # install groups
    dnf -y group install gnome-desktop

    dnf -y copr enable atim/lazygit
    dnf -y copr enable solopasha/hyprland

    cat /extra-packages | xargs dnf install -y

    # hyprland plugins
    # hyprpm add https://github.com/KZDKM/Hyprspace
    # hyprpm enable Hyprspace

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

    # fonts
    fc-cache /usr/share/fonts

    # services
    systemctl enable sshd lm_sensors libvirtd.socket libvirtd.service
    systemctl set-default graphical.target

    # don't auto update
    rm /usr/lib/systemd/system/bootc-fetch-apply-updates.service
    rm /usr/lib/systemd/system/bootc-fetch-apply-updates.timer
    rm /usr/lib/systemd/system/default.target.wants/bootc-fetch-apply-updates.timer

    # dotfiles overlay
    systemctl enable ostree-state-overlay@dotfiles.service
EOF

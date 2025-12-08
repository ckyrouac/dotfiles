FROM quay.io/fedora/fedora-bootc:43

COPY ./fonts/UbuntuMono /usr/share/fonts
COPY ./fonts/JetBrainsMonoNerdFont /usr/share/fonts

COPY ./bootc/etc /etc
COPY ./bootc/usr /usr
COPY ./bootc/extra-packages /

COPY . /dotfiles

RUN dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

RUN dnf -y install fedora-workstation-repositories 'dnf5-command(config-manager)'
RUN dnf config-manager setopt google-chrome.enabled=1
RUN dnf copr enable -y erikreider/SwayNotificationCenter

# install groups
RUN dnf -y group install gnome-desktop

RUN dnf -y copr enable atim/lazygit
RUN dnf -y copr enable solopasha/hyprland

RUN cat /extra-packages | xargs dnf install -y

    # hyprland plugins
    # hyprpm add https://github.com/KZDKM/Hyprspace
    # hyprpm enable Hyprspace

    # insync
RUN curl -o insync.rpm https://cdn.insynchq.com/builds/linux/3.9.5.60024/insync-3.9.5.60024-fc42.x86_64.rpm
RUN rpm -i insync.rpm
RUN rm insync.rpm

    # slack
RUN curl -o slack.rpm https://downloads.slack-edge.com/desktop-releases/linux/x64/4.43.51/slack-4.43.51-0.1.el8.x86_64.rpm
RUN rpm -i slack.rpm
RUN rm slack.rpm

    # keymapp
RUN curl -o keymapp.tar.gz https://oryx.nyc3.cdn.digitaloceanspaces.com/keymapp/keymapp-latest.tar.gz
RUN tar -xvf keymapp.tar.gz
RUN rm keymapp.tar.gz
RUN mv keymapp /usr/bin/keymapp
RUN mv icon.png /usr/share/icons/keymapp.png

    # fonts
RUN fc-cache /usr/share/fonts

    # services
RUN systemctl enable sshd lm_sensors libvirtd.socket libvirtd.service
RUN systemctl set-default graphical.target

    # don't auto update
RUN rm /usr/lib/systemd/system/bootc-fetch-apply-updates.service
RUN rm /usr/lib/systemd/system/bootc-fetch-apply-updates.timer
RUN rm /usr/lib/systemd/system/default.target.wants/bootc-fetch-apply-updates.timer

    # dotfiles overlay
RUN systemctl enable ostree-state-overlay@dotfiles.service

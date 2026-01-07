# Build stage for bootc from main branch
FROM quay.io/fedora/fedora-bootc:43 AS bootc-builder
RUN dnf install -y git rust cargo dnf5-command\(builddep\) && dnf clean all
RUN git clone --depth 1 https://github.com/containers/bootc.git /bootc-src
RUN cd bootc-src && /bootc-src/ci/installdeps.sh
WORKDIR /bootc-src
ENV CARGO_HOME=/tmp/cargo
RUN cargo build --release

# Main stage
FROM quay.io/fedora/fedora-bootc:43

# Copy bootc binary built from main branch
COPY --from=bootc-builder /bootc-src/target/release/bootc /usr/bin/bootc

COPY ./fonts/UbuntuMono /usr/share/fonts
COPY ./fonts/JetBrainsMonoNerdFont /usr/share/fonts

COPY ./bootc/etc /etc
COPY ./bootc/usr /usr

COPY . /dotfiles

RUN <<EOF
    set -euxo pipefail
    dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
    dnf -y install fedora-workstation-repositories 'dnf5-command(config-manager)'
    dnf config-manager setopt google-chrome.enabled=1
    dnf -y group install gnome-desktop
    dnf clean all
    dnf -y copr enable atim/lazygit

    # Install extra-packages in batches of 5 to avoid RPM database corruption
    packages=()
    while IFS= read -r pkg; do
        if [ -n "$pkg" ]; then
            packages+=("$pkg")
            if [ ${#packages[@]} -eq 5 ]; then
                dnf install -y "${packages[@]}"
                dnf clean all
                packages=()
            fi
        fi
    done < /dotfiles/bootc/extra-packages
    if [ ${#packages[@]} -gt 0 ]; then
        dnf install -y "${packages[@]}"
        dnf clean all
    fi

    curl -o insync.rpm https://cdn.insynchq.com/builds/linux/3.9.5.60024/insync-3.9.5.60024-fc42.x86_64.rpm
    rpm -i insync.rpm
    rm insync.rpm
    curl -o slack.rpm https://downloads.slack-edge.com/desktop-releases/linux/x64/4.43.51/slack-4.43.51-0.1.el8.x86_64.rpm
    rpm -i slack.rpm
    rm slack.rpm
    curl -o keymapp.tar.gz https://oryx.nyc3.cdn.digitaloceanspaces.com/keymapp/keymapp-latest.tar.gz
    tar -xvf keymapp.tar.gz
    rm keymapp.tar.gz
    mv keymapp /usr/bin/keymapp
    mv icon.png /usr/share/icons/keymapp.png
    fc-cache /usr/share/fonts
    systemctl enable sshd lm_sensors libvirtd.socket libvirtd.service
    systemctl set-default graphical.target
    rm /usr/lib/systemd/system/bootc-fetch-apply-updates.service
    rm /usr/lib/systemd/system/bootc-fetch-apply-updates.timer
    rm /usr/lib/systemd/system/default.target.wants/bootc-fetch-apply-updates.timer
    systemctl enable ostree-state-overlay@dotfiles.service
    dnf clean all
EOF

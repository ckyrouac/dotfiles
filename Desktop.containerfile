FROM ghcr.io/ckyrouac/dotfiles/bootc-base:latest

RUN <<EOF
    dnf -y install kmod-nvidia
    akmods --force
    systemctl disable akmods.service
    systemctl disable akmods-shutdown.service
    rm /usr/lib/systemd/system/akmods.service
    rm /usr/lib/systemd/system/akmods-shutdown.service
    dnf clean all
EOF

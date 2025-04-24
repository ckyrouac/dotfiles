FROM ghcr.io/ckyrouac/dotfiles/bootc-base:latest

RUN <<EOF
    set -euxo pipefail

    dnf -y install kmod-nvidia
    akmods --akmod nvidia
    systemctl disable akmods.service
    systemctl disable akmods-shutdown.service
    rm /usr/lib/systemd/system/akmods.service
    rm /usr/lib/systemd/system/akmods-shutdown.service
    dnf clean all
EOF

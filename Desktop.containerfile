FROM ghcr.io/ckyrouac/dotfiles/bootc-base:latest

RUN <<EOF
    dnf -y install xorg-x11-drv-nvidia-cuda
    dnf clean all
EOF

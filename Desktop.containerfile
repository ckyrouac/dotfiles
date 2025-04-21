FROM ghcr.io/ckyrouac/dotfiles/bootc-base:latest

# machine specific layer
RUN <<EOF
    dnf -y install xorg-x11-drv-nvidia-cuda
    dnf -y install hyprpolkitagent

    dnf clean all
EOF

FROM ghcr.io/ckyrouac/dotfiles/bootc-base:latest

RUN <<EOF
    dnf -y install kmod-nvidia
    dnf clean all
EOF

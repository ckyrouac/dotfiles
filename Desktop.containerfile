FROM ghcr.io/ckyrouac/dotfiles/bootc-base:latest

RUN <<EOF
    dnf -y install akmod-nvidia
    dnf clean all
EOF

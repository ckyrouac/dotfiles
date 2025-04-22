FROM ghcr.io/ckyrouac/dotfiles/bootc-base:latest

RUN <<EOF
    dnf install -y akmod-nvidia
    dnf clean all
EOF

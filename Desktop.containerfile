FROM ghcr.io/ckyrouac/dotfiles/bootc-base:latest

RUN <<EOF
    dnf -y install kmod-nvidia
    akmods --force
    dnf clean all
EOF

FROM ghcr.io/ckyrouac/dotfiles/bootc-base:latest

RUN <<EOF
    dnf -y module install nvidia-driver
    dnf install -y nvidia-container-toolkit
    dnf clean all
EOF

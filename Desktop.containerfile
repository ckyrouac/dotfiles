FROM ghcr.io/ckyrouac/dotfiles/bootc-base:latest

RUN <<EOF
    set -euxo pipefail

    dnf -y module enable nvidia-driver
    dnf install -y nvidia-container-toolkit

    dnf clean all
EOF

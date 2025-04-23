FROM ghcr.io/ckyrouac/dotfiles/bootc-base:latest

RUN <<EOF
    set -euxo pipefail

    dnf -y module enable nvidia-driver
    dnf install -y cuda-toolkit nvidia-container-toolkit nvidia-driver

    dnf clean all
EOF

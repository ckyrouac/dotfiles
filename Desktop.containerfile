ARG BASE_IMAGE=ghcr.io/ckyrouac/dotfiles/bootc-base:latest
FROM ${BASE_IMAGE}

RUN <<EOF
    set -euxo pipefail
    dnf -y install kmod-nvidia kernel-devel xorg-x11-drv-nvidia-cuda
    KERNEL_VERSION=$(rpm -q "kernel" --queryformat '%{VERSION}-%{RELEASE}.%{ARCH}')
    akmods --force --kernels "$KERNEL_VERSION" --kmod "nvidia"
    systemctl disable akmods.service
    systemctl disable akmods-shutdown.service
    rm /usr/lib/systemd/system/akmods.service
    rm /usr/lib/systemd/system/akmods-shutdown.service
    dnf clean all
EOF

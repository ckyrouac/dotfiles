ARG BASE_IMAGE=ghcr.io/ckyrouac/dotfiles/bootc-base:latest
FROM ${BASE_IMAGE}

# Add OrcaSlicer as a logically bound container image
COPY ./bootc/usr/share/containers/systemd/orcaslicer.container /usr/share/containers/systemd/orcaslicer.container
RUN mkdir -p /usr/lib/bootc/bound-images.d && \
    ln -s /usr/share/containers/systemd/orcaslicer.container /usr/lib/bootc/bound-images.d/orcaslicer.container

# Add NFC Web as a logically bound container image
COPY ./bootc/usr/share/containers/systemd/nfc-web.container /usr/share/containers/systemd/nfc-web.container
RUN ln -s /usr/share/containers/systemd/nfc-web.container /usr/lib/bootc/bound-images.d/nfc-web.container

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

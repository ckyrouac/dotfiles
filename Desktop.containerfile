FROM ghcr.io/ckyrouac/dotfiles/bootc-base:latest

RUN <<EOF
    set -euxo pipefail

    curl -fsSL https://code-server.dev/install.sh | sh -s --

    dnf -y install kmod-nvidia kernel-devel
    KERNEL_VERSION=$(rpm -q "kernel" --queryformat '%{VERSION}-%{RELEASE}.%{ARCH}')
    akmods --force --kernels "$KERNEL_VERSION" --kmod "nvidia"
    systemctl disable akmods.service
    systemctl disable akmods-shutdown.service
    rm /usr/lib/systemd/system/akmods.service
    rm /usr/lib/systemd/system/akmods-shutdown.service
    dnf clean all
EOF

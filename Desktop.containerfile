FROM ghcr.io/ckyrouac/dotfiles/bootc-base:latest

RUN <<EOF
    dnf install -y kernel-devel-matched kernel-headers
    dnf config-manager addrepo -y --from-repofile=https://developer.download.nvidia.com/compute/cuda/repos/fedora41/x86_64/cuda-fedora41.repo
    dnf install -y nvidia-cuda
    dnf clean all
EOF

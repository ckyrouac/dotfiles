FROM ghcr.io/ckyrouac/dotfiles/bootc-base:latest

RUN dnf -y install iwlwifi-mvm-firmware iwlwifi-dvm-firmware && \
    dnf clean all

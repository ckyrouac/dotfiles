FROM ghcr.io/ckyrouac/dotfiles/bootc-base:latest

RUN <<EOF
    dnf -y install iwlwifi-mvm-firmware iwlwifi-dvm-firmware
    dnf clean all
EOF

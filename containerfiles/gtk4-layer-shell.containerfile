FROM quay.io/fedora/fedora-bootc:41

RUN <<EOF
    set -euxo pipefail

    dnf -y group install development-tools c-development
    dnf install -y libseat-devel libinput-devel libdrm-devel mesa-libgbm-devel libdisplay-info-devel hwdata-devel libuuid-devel re2-devel xcb-util-errors-devel xcb-util-devel xcb-util-wm-devel tomlplusplus-devel file-devel libseat-devel libinput-devel wayland-protocols-devel libdrm-devel mesa-libgbm-devel libdisplay-info-devel hwdata-devel git cmake pixman-devel cairo cairo-devel libjpeg-devel libwebp-devel libspng-devel GLC_lib vulkan-headers gtkglext-devel pugixml-devel libwayland-client wayland-devel libzip-devel librsvg2-devel libxkbcommon-devel qt6-qtwayland-devel mesa-libGLES-devel aquamarine-devel hyprcursor-devel hyprutils-devel hyprwayland-scanner-devel graphene-devel vala meson ninja gtk4-devel gobject-introspection-devel gtkdoc-scan golang
EOF

RUN <<EOF
    set -euxo pipefail

    git clone https://github.com/wmww/gtk4-layer-shell /tmp/gtk4-layer-shell
    cd /tmp/gtk4-layer-shell
    git checkout v1.0.4
    meson setup build
    ninja -C build
    ninja -C build install
    ldconfig
    echo "export LD_LIBRARY_PATH=/usr/local/lib64" >> /etc/profile.d/ld.sh
EOF

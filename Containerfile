FROM quay.io/fedora/fedora-bootc:42

COPY ./fonts/UbuntuMono /usr/share/fonts
COPY ./fonts/JetBrainsMonoNerdFont /usr/share/fonts

COPY ./bootc/etc /etc
COPY ./bootc/usr /usr
COPY ./bootc/extra-packages /

COPY . /etc/dotfiles

# build hyprland
RUN <<EOF
    set -euxo pipefail

    dnf -y group install development-tools c-development

    sudo dnf install -y libseat-devel libinput-devel wayland-protocols-devel libdrm-devel mesa-libgbm-devel libdisplay-info-devel hwdata-devel libuuid-devel re2-devel xcb-util-errors-devel xcb-util-devel xcb-util-wm-devel tomlplusplus-devel file-devel libseat-devel libinput-devel wayland-protocols-devel libdrm-devel mesa-libgbm-devel libdisplay-info-devel hwdata-devel git cmake pixman-devel cairo cairo-devel libjpeg-devel libwebp-devel libspng-devel GLC_lib vulkan-headers gtkglext-devel pugixml-devel libwayland-client wayland-devel libzip-devel librsvg2-devel libxkbcommon-devel qt6-qtwayland-devel

    git clone https://github.com/hyprwm/hyprutils.git
    cd hyprutils
    cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
    cmake --build ./build --config Release --target all -j`nproc 2>/dev/null || getconf NPROCESSORS_CONF`
    cmake --install build
    cd ../

    git clone https://github.com/hyprwm/hyprgraphics.git
    cd hyprgraphics
    cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
    cmake --build ./build --config Release --target all -j`nproc 2>/dev/null || getconf NPROCESSORS_CONF`
    cmake --install build
    cd ../

    git clone https://github.com/hyprwm/hyprwayland-scanner.git
    cd hyprwayland-scanner
    cmake -DCMAKE_INSTALL_PREFIX=/usr -B build
    cmake --build build -j `nproc`
    cmake --install build
    cd ../

    git clone https://github.com/hyprwm/aquamarine.git
    cd aquamarine
    cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
    cmake --build ./build --config Release --target all -j`nproc 2>/dev/null || getconf _NPROCESSORS_CONF`
    cd build
    make install
    cd ../../

    git clone https://github.com/hyprwm/hyprlang.git
    cd hyprlang
    cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
    cmake --build ./build --config Release --target hyprlang -j`nproc 2>/dev/null || getconf _NPROCESSORS_CONF`
    cmake --install ./build
    cd ../

    git clone https://github.com/hyprwm/hyprcursor
    cd hyprcursor
    cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
    cmake --build ./build --config Release --target all -j`nproc 2>/dev/null || getconf _NPROCESSORS_CONF`
    cmake --install build
    cd ../

    git clone https://github.com/hyprwm/hyprland-qtutils
    cd hyprland-qtutils
    cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
    cmake --build ./build --config Release --target all -j`nproc 2>/dev/null || getconf NPROCESSORS_CONF`
    cmake --install build
    cd ../

    git clone --recursive https://github.com/hyprwm/Hyprland
    cd Hyprland
    make all
    make install
    cd ../
EOF

RUN <<EOF
    set -euxo pipefail

    # rpmfusion
    dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

    # enable repos
    dnf -y install fedora-workstation-repositories 'dnf5-command(config-manager)'
    dnf config-manager setopt google-chrome.enabled=1
    # install groups
    # dnf -y group install development-tools c-development gnome-desktop cosmic-desktop system-tools sound-and-video
    dnf -y group install gnome-desktop

    dnf -y copr enable atim/lazygit
    dnf -y copr enable solopasha/hyprland

    cat /extra-packages | xargs dnf install -y

    # insync
    curl -o insync.rpm https://cdn.insynchq.com/builds/linux/3.9.5.60024/insync-3.9.5.60024-fc42.x86_64.rpm
    rpm -i insync.rpm
    rm insync.rpm

    # slack
    curl -o slack.rpm https://downloads.slack-edge.com/desktop-releases/linux/x64/4.43.51/slack-4.43.51-0.1.el8.x86_64.rpm
    rpm -i slack.rpm
    rm slack.rpm

    # keymapp
    curl -o keymapp.tar.gz https://oryx.nyc3.cdn.digitaloceanspaces.com/keymapp/keymapp-latest.tar.gz
    tar -xvf keymapp.tar.gz
    rm keymapp.tar.gz
    mv keymapp /usr/bin/keymapp
    mv icon.png /usr/share/icons/keymapp.png

    # fonts
    fc-cache /usr/share/fonts

    # services
    systemctl enable sshd lm_sensors libvirtd.socket
    systemctl set-default graphical.target

    # don't auto update
    rm /usr/lib/systemd/system/bootc-fetch-apply-updates.service
    rm /usr/lib/systemd/system/bootc-fetch-apply-updates.timer
    rm /usr/lib/systemd/system/default.target.wants/bootc-fetch-apply-updates.timer
EOF

#!/bin/bash
# Jacobs's Fedora Linux Setup Script
# For Fedora Workstation 41 Cinnamon Spin
# https://fedoraproject.org/spins/cinnamon/download
# version 1.2 beta

# variables
$INSTALL_DIR

# prints borders
repeat() {
    echo "================================================================================"
}

# prints borders for the end of a line
function end_line() {
    repeat
    echo ""
}

# startup
function startup() {
    INSTALL_DIR=$(pwd)
    echo "$INSTALL_DIR"
    sudo dnf install git -y
}

# sets configs
function set_configs() {
    echo "@@ setting configs @@"
    repeat
    echo "setting dnf configs"
    echo 'max_parallel_downloads=10' | sudo tee -a /etc/dnf/dnf.conf
    echo 'fastestmirror=true' | sudo tee -a /etc/dnf/dnf.conf
    echo 'defaultyes=true' | sudo tee -a /etc/dnf/dnf.conf
    echo "setting nano configs"
    cd ~ || exit
    touch .nanorc
    {
        echo 'set guidestripe 80'
        echo 'set linenumbers'
        echo 'set tabstospaces'
        echo 'set tabsize 4'
        echo 'set backup'
        echo 'set autoindent'
    } >>.nanorc
    cd "$INSTALL_DIR" || exit
    end_line
}

# updates software
function update_software() {
    echo "@@ updating software @@"
    repeat
    sudo dnf upgrade -y
    sudo flatpak update
    end_line
}

# adds wallpapers
function add_wallpapers() {
    echo "@@ adding wallpapers to Pictures directory @@"
    repeat
    WALLPAPER_DIR="${INSTALL_DIR}/FedoraConfigs-main/wallpapers"
    echo "adding wallpapers"
    cp -r "$WALLPAPER_DIR" ~/Pictures/
    end_line
}

# removes programs I never use
function remove_junk() {
    echo "@@ removing junk @@"
    repeat
    dnf remove hexchat -y
    dnf remove pidgin -y
    dnf remove thunderbird -y
    dnf remove transmission -y
    dnf remove xfburn -y
    dnf remove xawtv -y
    dnf autoremove -y
    end_line
}

# enables rpm fusions
function enable_rpmfusions() {
    echo "@@ enabling rpm fusions @@"
    repeat
    sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm -y
    sudo dnf install https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y
    update_software
    end_line
}

# enables flathub
function enable_flathub() {
    echo "@@ enabling flathub @@"
    repeat
    sudo dnf install flatpak -y
    sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    end_line
}

# installs vscode
function install_vscode() {
    echo "@@ installing vscode @@"
    repeat
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
    sudo dnf check-update
    sudo dnf install code -y
    end_line
}

# installs Prism Launcher (Minecraft)
function install_prism_launcher() {
    echo "@@ installing Prism Launcher (Minecraft) @@"
    repeat
    sudo dnf copr enable g3tchoo/prismlauncher -y
    sudo dnf install prismlauncher -y
    end_line
}

# install Microsoft True Type fonts
function install_true_type() {
    echo "@@ installing True Type fonts @@"
    repeat
    sudo dnf install xorg-x11-font-utils -y
    sudo rpm -i https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm
    end_line
}

# installs media codecs
function install_codecs() {
    echo "@@ installing codecs @@"
    repeat
    sudo dnf install gstreamer1-libav gstreamer1-plugins-bad-free -y
    sudo dnf install gstreamer1-plugins-bad-free gstreamer1-plugins-bad-free-extras -y
    sudo dnf install gstreamer1-plugins-bad-freeworld gstreamer1-plugins-bad-nonfree -y
    sudo dnf install gstreamer1-plugins-good gstreamer1-plugins-ugly lame-libs lame-libs -y
    sudo dnf group upgrade --with-optional Multimedia --allowerasing -y
    end_line
}

#installs chrome
function install_chrome() {
    echo "@@ installing google chrome @@"
    repeat
    sudo dnf install fedora-workstation-repositories -y
    sudo dnf config-manager --set-enabled google-chrome
    sudo dnf install google-chrome-stable -y
    end_line
}

# Nvidia drivers
# only install if you have an Nvidia gpu
function install_nvidia() {
    echo "@@ installing nvidia driver @@"
    repeat 80 '='
    echo
    sudo dnf install akmod-nvidia -y
    sudo dnf install xorg-x11-drv-nvidia-cuda -y
    end_line
}

# installs flatpaks
function install_flatpaks() {
    echo "@@ installing flatpaks @@"
    repeat
    update_software
    flatpak install com.github.tchx84.Flatseal -y
    flatpak install org.videolan.VLC -y
    flatpak install com.valvesoftware.SteamLink -y
    flatpak install org.prismlauncher.PrismLauncher -y
    flatpak install io.freetubeapp.FreeTube -y
    end_line
}

# software install
function install_software() {
    echo "@@ installing software @@"
    repeat
    update_software
    sudo dnf install python3 -y
    sudo dnf install java-latest-openjdk -y
    sudo dnf install file-roller -y
    sudo dnf install htop -y
    sudo dnf install qdirstat -y
    sudo dnf install gcc -y
    sudo dnf install gdb -y
    sudo dnf install cpplint -y
    sudo dnf install neofetch -y
    sudo dnf install yaru-icon-theme -y
    sudo dnf install p7zip -y
    sudo dnf install p7zip-plugins -y
    sudo dnf install gparted -y
    sudo dnf install pdfmod -y
    sudo dnf install libreoffice -y
    sudo dnf install yt-dlp -y
    sudo dnf install audacity -y
    sudo dnf install steam -y
    end_line
}

# update firmware
function update_firmware() {
    echo "@@ updating firmware @@"
    repeat
    sudo fwupdmgr get-devices
    sudo fwupdmgr refresh --force
    sudo fwupdmgr get-updates
    sudo fwupdmgr update
    end_line
}

function main() {
    startup
    set_configs
    update_software
    remove_junk
    add_wallpapers
    enable_rpmfusions
    enable_flathub
    install_vscode
    install_true_type
    install_codecs
    install_chrome
    install_software
    install_flatpaks
    #install_nvidia
    update_firmware
    echo "Please Restart the System"
}

main

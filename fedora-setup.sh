#!/bin/bash
# Jacobs's Fedora Setup Script
# For Fedora Workstation 39
# version 1.0

# varaibles
$INSTALL_DIR


# startup
function startup() {
    INSTALL_DIR = $pwd
}

# sets configs
function set_configs() {
    echo "setting configs"
    echo "setting dnf configs"
    echo 'max_parallel_downloads=10' | sudo tee -a /etc/dnf/dnf.conf
    echo 'fastestmirror=true' | sudo tee -a /etc/dnf/dnf.conf
    echo 'defaultyes=true' | sudo tee -a /etc/dnf/dnf.conf
    echo "setting nano configs"
    touch ~/.nanorc
    echo 'set guidestripe 80' | tee -a ~/.nanorc
    echo 'set linenumbers' | tee -a ~/.nanorc
    echo 'set tabstospaces' | tee -a ~/.nanorc
    echo 'set tabsize 4' | tee -a ~/.nanorc
    echo 'set backup' | tee -a ~/.nanorc
    echo 'set autoindent' | tee -a ~/.nanorc
    echo "setting vim configs"
    touch ~/.vimrc
    echo 'syntax on' | tee -a ~/.vimrc
    echo 'set ruler' | tee -a ~/.vimrc
    echo 'set autoindent' | tee -a ~/.vimrc
    echo 'set number' | tee -a ~/.vimrc
    echo 'set ignorecase' | tee -a ~/.vimrc
    echo 'color elflord' | tee -a ~/.vimrc
}

# updates software
function update_software() {
    echo "updating software"
    sudo dnf upgrade -y
    sudo flatpak update
}

# update firmware
function update_firmware() {
    echo "updateing firmware"
    sudo fwupdmgr get-devices
    sudo fwupdmgr refresh --force
    sudo fwupdmgr get-updates
    sudo fwupdmgr update
}

# adds wallpapers
function add_wallpapers() {
    cp -r ./wallpapers ~/pictures/
}

# sets terminal colors
# theme and script code from Gogh
# website: http://gogh-co.github.io/Gogh
# github: https://github.com/Gogh-Co/Gogh
function set_colors() {
    echo "setting terminal colors"
    mkdir -p "$HOME/src"
    cd "$HOME/src"
    git clone https://github.com/Gogh-Co/Gogh.git gogh
    cd gogh
    export TERMINAL=gnome-terminal
    cd installs
    ./powershell.sh
    cd $INSTALL_DIR
}

# removes Gnome Junk I never use
function remove_junk() {
    echo "removing Gnome Junk"
    dnf remove gnome-tour -y
    dnf remove gnome-maps -y
    dnf remove gnome-weather -y
    dnf remove gnome-calendar -y
    dnf remove gnome-clocks -y
    dnf remove gnome-contacts -y
    dnf remove cheese -y
    dnf autoremove -y
}

# enables rpm fusions
function enable_rpmfusions() {
    echo "enabling rpm fusions"
    sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
    sudo dnf install https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
    update_software()
}

# enables flathub
function enable_flathub() {
    echo "enabling flathub"
    sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    update_software()
}

# vscode install
function install_vscode() {
    echo "installing vscode"
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
    sudo dnf check-update
    sudo dnf install code
}

# Prism Launcher (Minecraft) install
function install_prism_launcher() {
    echo "installing Prism Launcher (Minecraft)"
    sudo dnf copr enable g3tchoo/prismlauncher
    sudo dnf install prismlauncher
}

# Microsoft True Type fonts isntall
function install_true_type() {
    echo"installing True Type fonsts"
    sudo rpm -i https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm
}

# install codecs
function install_codecs() {
    echo"installing codecs"
    update_software()
    sudo dnf install gstreamer1-libav gstreamer1-plugins-bad-free
    sudo dnf install gstreamer1-plugins-bad-free gstreamer1-plugins-bad-free-extras
    sudo dnf install gstreamer1-plugins-bad-freeworld gstreamer1-plugins-bad-nonfree
    sudo dnf install gstreamer1-plugins-good gstreamer1-plugins-ugly lame-libs lame-libs
    sudo dnf group upgrade --with-optional Multimedia
}

# Nvidia drivers
functions install_nvidia() {
    update_software()
    echo "installing nvidia driver"
    sudo dnf install akmod-nvidia -y

}

# software install
function install_software() {
    echo "installing software"
    update_software()
    sudo flatpak install webcord -y
    sudo dnf install google-chrome-stable -y
    sudo dnf install file-roller -y
    sudo dnf install btop -y
    sudo dnf install neofetch -y
    sudo dnf install p7zip -y
    sudo dnf install p7zip-plugins -y
    sudo dfn install gparted -y
    sudo dnf install pdfmod -y
    sudo dnf install libreoffice -y
    sudo dnf install vlc -y
    sudo dnf install mpv -y
    sudo dnf install gimp -y
    sudo dnf install inkscape -y
    sudo dnf install krita -y
    sudo dnf install openshot -y
    sudo dnf install handbrake -y
    sudo dnf install handbrake-gui -y
    sudo dnf install yt-dlp -y
    sudo dnf install obs-studio -y
    sudo dnf install audacity -y
    sudo dnf install qbittorrent -y
    sudo dnf install remmina -y
    sudo dnf install steam -y
    sudo dnf install lutris -y
    sudo dnf install wine -y
}

# Gnome settings
function gnome_settings() {
    gsettings set org.gnome.desktop.wm.preferences button-layout ":minimize,close"
    gsettings set org.gnome.mutter center-new-windows true
}

# Gnome settings for laptops
function laptop_settings() {
    gsettings set org.gnome.desktop.interface show-battery-percentage true
}

function main() {
    startup()
    set_configs()
    update_software()
    update_firmware()
    #remove_junk()
    add_wallpapers()
    set_colors()
    enable_rpmfusions()
    enable_flathub()
    install_vscode()
    install_prism_luancher()
    install_true_type()
    install_codecs()
    install_software()
    #gnome_settings()
    #laptop_settings()
    install_nvidia()
    echo "Please Restart the System"
}

main()

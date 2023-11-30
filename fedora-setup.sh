#!/bin/bash
# Jacobs's Fedora Setup Script
# For Fedora Workstation 39 Cinnamon Spin
# https://fedoraproject.org/spins/cinnamon/download
# version 1.0

# varaibles
$INSTALL_DIR

# repeats chars
# from https://www.cyberciti.biz/faq/repeat-a-character-in-bash-script-under-linux-unix/
repeat(){
	local start=1
	local end=${1:-80}
	local str="${2:-=}"
	local range=$(seq $start $end)
	for i in $range ; do echo -n "${str}"; done
}

function end_line() {
    repeat 80 '='; echo
    echo ""
}

# startup
function startup() {
    INSTALL_DIR=$(pwd)
    echo $INSTALL_DIR
    sudo dnf install git -y
}

# sets configs
function set_configs() {
    echo "@@ setting configs @@"
    repeat 80 '='; echo
    echo "setting dnf configs"
    echo 'max_parallel_downloads=10' | sudo tee -a /etc/dnf/dnf.conf
    echo 'fastestmirror=true' | sudo tee -a /etc/dnf/dnf.conf
    echo 'defaultyes=true' | sudo tee -a /etc/dnf/dnf.conf
    echo "setting nano configs"
    cd ~
    touch .nanorc
    echo 'set guidestripe 80' >> ~/.nanorc
    echo 'set linenumbers' >> ~/.nanorc
    echo 'set tabstospaces' >> ~/.nanorc
    echo 'set tabsize 4' >> ~/.nanorc
    echo 'set backup' >> ~/.nanorc
    echo 'set autoindent' >> ~/.nanorc
    echo "setting vim configs"
    touch .vimrc
    echo 'syntax on' >> ~/.vimrc
    echo 'set ruler' >> ~/.vimrc
    echo 'set autoindent' >> ~/.vimrc
    echo 'set number' >> ~/.vimrc
    echo 'set ignorecase' >> ~/.vimrc
    echo 'color elflord' >> ~/.vimrc
    cd $INSTALL_DIR
    end_line
}

# updates software
function update_software() {
    echo "@@ updating software @@"
    repeat 80 '='; echo
    sudo dnf upgrade -y
    sudo flatpak update
    end_line
}

# update firmware
function update_firmware() {
    echo "@@ updating firmware @@"
    repeat 80 '='; echo
    sudo fwupdmgr get-devices
    sudo fwupdmgr refresh --force
    sudo fwupdmgr get-updates
    sudo fwupdmgr update
    end_line
}

# adds wallpapers
function add_wallpapers() {
    echo "@@ adding wallpapers to Pictures directory @@"
    repeat 80 '='; echo
    WALLPAPER_DIR="${INSTALL_DIR}/FedoraConfigs-main/wallpapers"
    echo "adding wallpapers"
    cp -r $WALLPAPER_DIR ~/Pictures/
    end_line
}

# sets terminal colors
# currently not working
# theme and script code from Gogh
# website: http://gogh-co.github.io/Gogh
# github: https://github.com/Gogh-Co/Gogh
function set_colors() {
    echo "@@ setting terminal colors @@"
    repeat 80 '='; echo
    sudo dnf install dconf-cli -y
    sudo dnf install uuid-runtime -y
    mkdir -p "$HOME/src"
    cd "$HOME/src"
    git clone https://github.com/Gogh-Co/Gogh.git gogh
    cd gogh
    export TERMINAL=gnome-terminal
    cd installs
    ./powershell.sh
    cd $INSTALL_DIR
    end_line
}

# removes programs I never use
function remove_junk() {
    echo "@@ removing junk @@"
    repeat 80 '='; echo
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
    repeat 80 '='; echo
    sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm -y
    sudo dnf install https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y
    update_software
    end_line
}

# enables flathub
function enable_flathub() {
    echo "@@ enabling flathub @@"
    repeat 80 '='; echo
    sudo dnf install flatpak -y
    sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    end_line
}

# vscode install
function install_vscode() {
    echo "@@ installing vscode @@"
    repeat 80 '='; echo
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
    sudo dnf check-update
    sudo dnf install code -y
    end_line
}

# Prism Launcher (Minecraft) install
function install_prism_launcher() {
    echo "@@ installing Prism Launcher (Minecraft) @@"
    repeat 80 '='; echo
    sudo dnf copr enable g3tchoo/prismlauncher -y
    sudo dnf install prismlauncher -y
    end_line
}

# Microsoft True Type fonts isntall
function install_true_type() {
    echo "@@ installing True Type fonsts @@"
    repeat 80 '='; echo
    sudo dnf install xorg-x11-font-utils -y
    sudo rpm -i https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm
    end_line
}

# install codecs
function install_codecs() {
    echo "@@ installing codecs @@"
    repeat 80 '='; echo
    sudo dnf install gstreamer1-libav gstreamer1-plugins-bad-free -y
    sudo dnf install gstreamer1-plugins-bad-free gstreamer1-plugins-bad-free-extras -y
    sudo dnf install gstreamer1-plugins-bad-freeworld gstreamer1-plugins-bad-nonfree -y
    sudo dnf install gstreamer1-plugins-good gstreamer1-plugins-ugly lame-libs lame-libs -y
    sudo dnf group upgrade --with-optional Multimedia --allowerasing -y
    end_line
}

#install chrome
function install_chrome() {
    echo "@@ installing google chrome @@"
    repeat 80 '='; echo
    sudo dnf install fedora-workstation-repositories -y
    sudo dnf config-manager --set-enabled google-chrome
    sudo dnf install google-chrome-stable -y
    end_line
}

# Nvidia drivers
function install_nvidia() {
    echo "@@ installing nvidia driver @@"
    repeat 80 '='; echo
    sudo dnf install akmod-nvidia -y
    sudo dnf install xorg-x11-drv-nvidia-cuda -y
    end_line
}

# software install
function install_software() {
    echo "@@ installing software @@"
    repeat 80 '='; echo
    sudo dnf upgrade -y
    sudo flatpak install webcord -y
    sudo dnf install google-chrome-stable -y
    sudo dnf install file-roller -y
    sudo dnf install btop -y
    sudo dnf install neofetch -y
    sudo dnf install p7zip -y
    sudo dnf install p7zip-plugins -y
    sudo dnf install gparted -y
    sudo dnf install pdfmod -y
    sudo dnf install libreoffice -y
    sudo dnf install vlc -y
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
    sudo dnf install gnome-boxes -y
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
    install_prism_launcher
    install_true_type
    install_codecs
    #set_colors
    install_chrome
    install_software
    install_nvidia
    echo "Please Restart the System"
}

main

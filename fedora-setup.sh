#!/bin/bash
# Jacobs's Fedora Linux Setup Script
# For Fedora Workstation 42 XFCE Spin
# https://fedoraproject.org/spins/xfce
# version 1.3 beta

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
    RUN_DIR=$(pwd)
    echo "$RUN_DIR"
    case $RUN_DIR in
        *"FedoraConfigs-main" | *"FedoraConfigs")
            echo "correct directory detected running script"
        ;;
        *)
            echo "attempting directory change"
            cd FedoraConfigs-main || cd FedoraConfigs || echo "directory error! exiting script! open script from the FedoraConfigs directory" exit
            startup
        ;;
    esac
}

# sets configs
function set_configs() {
    echo "@@ Setting Configs @@"
    repeat
    echo "Setting DNF Configs"
    DNF_CONFIGS=('max_parallel_downloads=10' 'fastestmirror=true' 'defaultyes=true')
    for CONFIG in "${DNF_CONFIGS[@]}"; do
        if grep -Fxq "$CONFIG" ~/.nanorc; then
            echo "Config Already Exists"
        else
            echo "$CONFIG" | sudo tee -a /etc/dnf/dnf.conf
        fi
    done
    echo "Setting Nano Configs"
    NANO_CONFIGS=("set guidestripe 80"
        "set linenumbers"
        "set tabstospaces"
        "set tabsize 4"
        "set backup"
        "set autoindent"
        "set mouse")
    for CONFIG in "${NANO_CONFIGS[@]}"; do
        if grep -Fxq "$CONFIG" ~/.nanorc; then
            echo "Config Already Exists"
        else
            echo "$CONFIG" >>~/.nanorc
        fi
    done
    end_line
}

# updates software
function update_software() {
    echo "@@ Updating Software @@"
    repeat
    sudo dnf upgrade -y
    sudo flatpak update
    end_line
}

# enables rpm fusions
function enable_rpmfusions() {
    echo "@@ Enabling RPM Fusions @@"
    repeat
    sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm -y
    sudo dnf install https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y
    update_software
    end_line
}

# enables flathub
function enable_flathub() {
    echo "@@ Enabling Flathub @@"
    repeat
    sudo dnf install flatpak -y
    sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    end_line
}

# installs vscode
function install_vscode() {
    echo "@@ Installing VScode @@"
    repeat
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
    sudo dnf check-update
    sudo dnf install code -y
    end_line
}

# installs Prism Launcher (Minecraft)
# depreciated for flatpak
function install_prism_launcher() {
    echo "@@ Installing Prism Launcher (Minecraft) @@"
    repeat
    sudo dnf copr enable g3tchoo/prismlauncher -y
    sudo dnf install prismlauncher -y
    end_line
}

# install Microsoft True Type fonts
function install_true_type() {
    echo "@@ Installing True Type Fonts @@"
    repeat
    sudo dnf install xorg-x11-font-utils -y
    sudo rpm -i https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm
    end_line
}

# installs media codecs
function install_codecs() {
    echo "@@ Installing Codecs @@"
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
    echo "@@ Installing Google Chrome @@"
    repeat
    sudo dnf install fedora-workstation-repositories -y
    sudo dnf config-manager --set-enabled google-chrome
    sudo dnf install google-chrome-stable -y
    end_line
}


# installs Nvidia drivers
function install_nvidia() {
    echo "@@ Installing Nvidia Driver @@"
    repeat
    #TODO driver checking

    sudo dnf install akmod-nvidia -y
    sudo dnf install xorg-x11-drv-nvidia-cuda -y
    end_line
}

# installs zsh and oh-my-zsh
function install_zsh() {
    echo "@@ Installing zsh @@"
    repeat
    sudo dnf install zsh -y
    echo "@@ Installing oh-my-zsh @@"
    repeat
    if test -d ~/.oh-my-zsh; then
        echo "oh-my-zsh is Already installed"
    else
        echo "Installing oh-my-zsh"
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    fi
}

# TODO add xnviewmp?
# installs software from dnf and flatpak
function install_software() {
    echo "@@ Installing Software @@"
    repeat
    echo "Installing with DNF"
    PACKAGES=(python3 java-latest-openjdk htop qdirstat gcc gdb cpplint gparted libreoffice yt-dlp audacity steam git ncdu fastfetch openshot)
    for PACKAGE in "${PACKAGES[@]}"; do
        sudo dnf install "$PACKAGE" -y
    done
    echo "Installing with FLATPAK"
    FLATPAKS=(com.github.tchx84.Flatseal install org.videolan.VLC install org.prismlauncher.PrismLauncher com.discordapp.Discord fr.handbrake.ghb)
    for PAK in "${FLATPAKS[@]}"; do
        flatpak install "$PAK" -y
    done
    #sudo dnf install file-roller -y
    #sudo dnf install yaru-icon-theme -y
    #sudo dnf install p7zip -y
    #sudo dnf install p7zip-plugins -y
    #sudo dnf install pdfmod -y
    end_line
}

# installs my scripts
function install_scripts() {
    echo "@@ Installing Scripts @@"
    repeat
    if test -d ~/scripts; then
        echo "scripts already installed updating"
        rm -rf ~/scripts
    else
        echo "installing scripts"
    fi
    cp -r ./scripts ~/
    add_alias
    end_line
}

# adds alias's for my scripts
function add_alias() {
    # alias's update script
    if grep -Fxq 'alias update="sudo bash ~/scripts/update.sh"' ~/.zshrc; then
        echo "Already Exists"
    else
        echo 'alias update="sudo bash ~/scripts/update.sh"' >>~/.zshrc
    fi
    # alias's clean script
    if grep -Fxq 'alias clean="sudo bash ~/scripts/clean.sh"' ~/.zshrc; then
        echo "Already Exists"
    else
        echo 'alias clean="sudo bash ~/scripts/clean.sh"' >>~/.zshrc
    fi
}

# updates firmware
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
    enable_rpmfusions
    enable_flathub
    install_vscode
    install_true_type
    install_codecs
    install_chrome
    install_software
    #install_nvidia
    update_firmware
    echo "Please Restart the System"
}

main

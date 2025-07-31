#!/bin/bash
# Script that makes updating easier on Fedora Linux

echo "@@ Updating System Packages @@"
echo "================================================================================"
sudo dnf upgrade -y
echo "@@ Updating Flatpaks @@"
echo "================================================================================"
sudo flatpak update
echo "================================================================================"
echo "@@ Done @@"
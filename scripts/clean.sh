#!/bin/bash
# Script that makes system cleaning easier on Fedora Linux

echo "@@ Cleaning System Packages @@"
echo "================================================================================"
sudo dnf autoremove
echo "@@ Done @@"
# FedoraConfigs
FedoraConfigs is a bash script that automates the post install experience on Fedora Linux. This script changes a lot of the bad defaults Fedora ships with the distro. It also downloads programs for the user to use as well as adds personal configs to programs. Right now this script is still early in development and does not contain every feature I want it to but it is still very usable and makes the Fedora Linux out of box experience much better.
<br>
<br>
Right Now the script implements changes that I want but in the future I would like users to be able to select the changes they want and what packages they would like install. If you do not like the way something this script does right now feel free to fork and change things to your liking.
<br>
<br>
### Features:
- Faster DNF Configs
- Removal of Fedora Flatpaks
- Enables Flathub
- Custom configurations of applications
- Installation of easy update script
- Auto detects and installs Nvidia drivers if needed
- Installs media codecs
- Installs Google Chrome
- Installs VSCode
- Installs Prism Launcher
- Installs Steam, Discord, VLC player, & more
- Updates device firmware (if device supports fwupdmgr)
- & more to come soon

<br>
<br>
This will run on other desktop environments and possibly other distros but is only tested on [Fedora KDE](https://fedoraproject.org/kde/)
<br>
<br>
This is provided "as is" and there is no warranty or liability for damages

## Install & Run
To download enter the command:
```bash
curl -L http://github.com/JacobUSC/FedoraConfigs/archive/main.tar.gz | tar zxf -
```
To run the script:
```bash
sudo bash FedoraConfigs-main/fedora-setup.sh
```

## For Developers & Power Users
I keep active development of FedoraConfigs in the testing branch as I like to leave the main branch stable for those that want to contribute or want to have all of the latest features of the script. Please do not make pull requests changing user preference type things such as what packages are installed and what configs files are added, make a personal fork instead.
# Overview

script to install arch linux very quickly. By default it will install a setup with no desktop environment but you can also install one easily by answering a question.

*Approximate time for install* : 2-3 minutes

# Installation

- Boot the Arch linux iso
- Get the scripts from this repo
- Launch ./install.sh from the script folder and answer the questions.

  **Example:**
  
      source <(curl -s http://192.168.2.46:8001/bootstrap.sh)

      curl -L https://github.com/slayerizer/arch_installer/archive/master.zip --output scripts.zip
      bsdtar -x -f scripts.zip
      cd arch_installer-master
      chmod +x *.sh
      ./install.sh


## Current Requirements

- EFI support
- internet connection

#### Virtualbox note requirement:
- make sure the VM is EFI enabled. (Settings -> System -> Enable EFI)


## Current Features:

- NVME drive support
- custom font for install (easier for 4k laptop)
- generate real time mirror list and let you decide easily the one that you want.
- let you choose target drive
- change password
- select timezone
- add custom users + options for username, password and sudo privilege
- change locale and keyboard layout
- configure makepkg for multi-cores
- install XFCE (Optional) + detect video drivers
 

#### Success

- Virtual Box VM
- Thinkpad T580 (install via LAN port)

#### Stats

- Virtual Box VM with XFCE4 takes around 227MB of ram ~ use ~4GB disk space
- Virtual Box VM with  KDE  takes around 380MB of ram
- Virtual Box VM with GNOME takes around  of ram




TESTING: 
cd /;rm -Rf /install;source <(curl -s http://192.168.2.46:8001/bootstrap.sh);./install.sh

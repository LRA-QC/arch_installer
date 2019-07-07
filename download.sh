#!/bin/sh
curl -L https://github.com/slayerizer/arch_installer/archive/master.zip --output scripts.zip
pacman -Sy --noconfirm unzip
unzip scripts.zip
cd arch_installer-master
chmod +x *.sh
./install.sh

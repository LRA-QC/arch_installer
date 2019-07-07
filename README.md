# Overview

script to install arch linux very quickly. By default it will install a setup with no desktop environment but you can also install one easily by answering a question.

# Installation

- Boot the Arch linux iso
- Get the scripts from this repo
- Launch ./install.sh from the script folder and answer the questions.

example:

curl -L https://github.com/slayerizer/arch_installer/archive/master.zip --output scripts.zip
pacman -Sy --noconfirm unzip
unzip scripts.zip
cd arch_installer-master
chmod +x *.sh
./install.sh

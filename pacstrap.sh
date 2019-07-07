#!/bin/bash
echo "--[MOUNTING FILESYSTEM]--"

TARGET=$1
umount -R /mnt &>/dev/null
echo "- mount /"
mount ${TARGET}2 /mnt  &>/dev/null
mkdir /mnt/boot  
mount ${TARGET}1 /mnt/boot &>/dev/null
echo "- refreshing repositories"
pacman -Syy &>/dev/null
echo "- Installing base packages"
# pacstrap /mnt base base-devel pacman-contrib 
pacstrap /mnt base pacman-contrib &>/dev/null
echo "- Installing extra utilities"
pacstrap /mnt zip unzip vim nano mc nmon ncdu htop syslog-ng lsb-release bash-completion exfat-utils neofetch  &>/dev/null
echo "- Installing custom fonts"
pacstrap /mnt terminus-font &>/dev/null
echo "- Installing SSH and sudo"
pacstrap /mnt openssh sudo &>/dev/null
echo '- chroot to new install'
mkdir /mnt/scripts
cp *.sh /mnt/scripts &>/dev/null
cp font.txt /mnt/scripts &>/dev/null
arch-chroot /mnt /scripts/post-chroot.sh

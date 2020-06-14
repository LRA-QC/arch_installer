#!/bin/bash
set -x
figlet "FILESYSTEM PREP"

TARGET=$1
LUKS=$2
# umount -R /mnt &>/dev/null
#echo ".. mount /"
#echo "..TARGET: $TARGET"
#if [ "$LUKS" == "yes" ]; then
#  mount /dev/mapper/cryptroot /mnt;
#else
#  mount ${TARGET}2 /mnt;
#i
#STANDARD
#mkdir /mnt/boot  
#mount ${TARGET}1 /mnt/boot;
figlet "Packages"
echo "..refreshing repositories"
pacman -Syy &>/dev/null
echo "..Installing base packages"
# pacstrap /mnt base base-devel pacman-contrib 
pacstrap /mnt base pacman-contrib lvm2 mkinitcpio &>/dev/null
echo "..Installing extra utilities"
pacstrap /mnt zip unzip vim nano mc htop syslog-ng lsb-release neofetch  &>/dev/null
echo "..Installing custom fonts"
pacstrap /mnt terminus-font &>/dev/null
echo "..Installing SSH and sudo"
pacstrap /mnt openssh sudo &>/dev/null
figlet "CHROOT"
mkdir /mnt/scripts
cp *.sh /mnt/scripts &>/dev/null
cp font.txt /mnt/scripts &>/dev/null
cp /tmp/*.txt /mnt/scripts &>/dev/null
arch-chroot /mnt /scripts/post-chroot.sh

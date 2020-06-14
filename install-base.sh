#!/bin/sh
clear
set -x

TARGET=$(blkid|grep arch_os|awk -F: '{print $1}')
BOOT=$(cat /tmp/boot.txt)
echo "TARGET: ${TARGET} BOOT: ${BOOT}"

read -p "Press enter to continue"

# BOOT
echo "..Formatting boot"
mkfs.fat -F32 ${BOOT} &>/dev/null

# MNT

umount -r /mnt &>/dev/null
mount ${TARGET} /mnt

mkdir -p /mnt/boot /mnt/etc &>/dev/null
mount ${BOOT} /mnt/boot &>/dev/null
mkdir -p /mnt/boot/loader/entries &>/dev/null
cp /tmp/font.txt /mnt/etc/vconsole.conf &>/dev/null
genfstab -pU /mnt >> /mnt/etc/fstab


echo "..refreshing repositories"
pacman -Syy &>/dev/null
echo "..Installing base packages"
# pacstrap /mnt base base-devel pacman-contrib 
pacstrap /mnt base pacman-contrib mkinitcpio lvm2  &>/dev/null
echo "..Installing extra utilities"
pacstrap /mnt iproute2   dmidecode git curl vim nano mc htop syslog-ng lsb-release exfat-utils neofetch  &>/dev/null
echo "..Installing custom fonts"
pacstrap /mnt terminus-font &>/dev/null
echo "..Installing SSH and sudo"
pacstrap /mnt openssh sudo &>/dev/null
echo "..Installing microcodes (if pertinent )"
grep GenuineIntel /proc/cpuinfo &>/dev/null && pacstrap /mnt intel-ucode &>/dev/null && echo "...Intel microcode added"
grep AuthenticAMD /proc/cpuinfo &>/dev/null && pacstrap /mnt amd-ucode &>/dev/null && echo "...AMD microcode added"
echo "..Detecting virtualization platform ( if pertinent )"
hostnamectl|grep Virtualization|grep oracle && pacstrap /mnt virtualbox-guest-utils xf86-video-vmware &>/dev/null  && echo "...Virtualbox modules installed"
echo "..Copying scripts for later"
mkdir /mnt/scripts &>/dev/null
cp *.sh /mnt/scripts &>/dev/null
cp /tmp/font.txt /mnt/scripts &>/dev/null
cp /etc/pacman.d/mirrorlist /mnt/etc/pacman.d/ &>/dev/null

arch-chroot /mnt /scripts/post-chroot.sh

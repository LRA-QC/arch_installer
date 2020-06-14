#!/bin/sh 

#
echo "..Initialization.."
sed -e 's/#Color/Color/' /etc/pacman.conf >pacman.temp  #ENABLE COLOR IN PACMAN
cp pacman.temp /etc/pacman.conf &>/dev/null

cleanup
umount -R /mnt &>/dev/null
cryptsetup close cryptroot &>/dev/null

echo "..Update packages list.."
pacman -Sy $OPT &>/dev/null
echo "..Installing utilities required for install ( may take 1-2 minutes be patient ) "
pacman -S percol terminus-font $OPT &>/dev/null

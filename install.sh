#!/bin/bash
# THIS SCRIPT ASSUMES YOU HAVE AN INTERNET CONNECTION ALREADY AVAILABLE


function cleanup    #CLEANUP FILES
{
    echo "- Cleanup"
    \rm mirrorlist_* mirrorlist *.temp &>/dev/null
}

sed -e 's/#Color/Color/' /etc/pacman.conf >pacman.temp  #ENABLE COLOR IN PACMAN
cp pacman.temp /etc/pacman.conf &>/dev/null

cleanup
umount -R /mnt &>/dev/null
./select-font.sh
./select-mirror.sh
./select-disk.sh
cleanup
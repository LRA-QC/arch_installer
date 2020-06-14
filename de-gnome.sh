#!/bin/bash 
OPT="-S --noconfirm"

echo "--[Installing video drivers]--"
pacman -Rns virtualbox-guest-utils-nox &>/dev/null 
#BUMBLEBEE CHECK
RES=$(lspci|grep -e UHD -e NVIDIA|wc -l)
if [ "$RES"=="2" ]; then
  pacman -S bumblebee --noconfirm &>/dev/null
else
  lspci|grep -iq UHD&&pacman $OPT vulkan-intel &>/dev/null  #INTEL
  lspci|grep -iq NVIDIA&&pacman $OPT nvidia &>/dev/null #NVIDIA
  lspci|grep -iq innotek&&pacman $OPT virtualbox-guest-utils &>/dev/null #VIRTUALBOX
fi

echo "--[Installing XORG]--"
pacman $OPT xorg-server &>/dev/null 

echo "--[Installing GNOME]--"
pacman $OPT gnome &>/dev/null
pacman $OPT gnome-extra &>/dev/null


echo "--[Installing GDM]--"
pacman $OPT gdm &>/dev/null
systemctl enable gdm &>/dev/null


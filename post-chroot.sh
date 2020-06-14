#!/bin/sh
set -x
pacman -Syyu --noconfirm &>/dev/null
pacman -S figlet percol --noconfirm &>/dev/null
figlet "Packages"
echo "..firmware"
pacman -S linux linux-firmware --noconfirm &>/dev/null
echo "..Disabling netctl"
systemctl disable netctl &>/dev/null
pacman -Rns --noconfirm netctl  &>/dev/null
echo "..installing NetworkManager"
pacman -S networkmanager --noconfirm &>/dev/null
systemctl enable NetworkManager &>/dev/null
/scripts/select-locale.sh
/scripts/select-tz.sh
echo '..setting clock'
hwclock --systohc
figlet "Host"
read -p "- Enter a hostname for the machine : " NAME
echo '..Creating hosts and hostname'
echo $NAME > /etc/hostname

echo '127.0.0.1 localhost' >>/etc/hosts
echo '::1 localhost' >>/etc/hosts
echo "127.0.1.1 ${NAME}.local ${NAME}" >>/etc/hosts

figlet "Bootloader"
echo '--[Installing bootloader]--'

# echo 'font=ter-v24n' > /etc/vconsole.conf
echo 'HOOKS=(base udev autodetect modconf block consolefont keyboard keymap lvm2 encrypt resume filesystems)' >> /etc/mkinitcpio.conf


rootdrive=$(df /|tail -n 1|awk '{print $1}')
uuid=$(blkid $rootdrive|awk '{print $5}')

echo "ROOTDRIVE: $rootdrive"
echo "     UUID: $uuid"


echo '' > /boot/loader/loader.conf

echo 'timeout 3'>/boot/loader/loader.conf
echo 'default arch'>>/boot/loader/loader.conf
echo 'title ArchLinux'>/boot/loader/entries/arch.conf
echo 'linux /vmlinuz-linux'>>/boot/loader/entries/arch.conf
echo 'initrd /initramfs-linux.img'>>/boot/loader/entries/arch.conf

if [ -e /dev/mapper/cryptroot ]; then 
  TARGET=$(cryptsetup status cryptroot|grep device|awk '{print $2}')
  CRYPT="cryptdevice=${TARGET}:cryptroot"
else
  CRYPT=''
fi
echo "options ${CRYPT} root=\"LABEL=arch_os\" rw">>/boot/loader/entries/arch.conf
# echo "options cryptdevice=/dev/sda2:cryptroot root=/dev/mapper/cryptroot rw quiet">>/boot/loader/entries/arch.conf

mkinitcpio -p linux &>/dev/null
bootctl install &>/dev/null


figlet "Config"
echo '..Changing root password'
passwd root
echo '..improving MAKEFLAG for multicore CPU'
echo 'MAKEFLAGS="-j$(nproc)"' >> /etc/makepkg.conf
echo '..Enabling SSHD'
systemctl enable sshd &>/dev/null

##########
# TEMP
####
#exit
####

echo "------------------------------------------------"
while true; do
  read -p "Do you wish to create a user? [y/n] " ans
  case $ans in
    [Yy]* ) /scripts/createuser.sh; break;;
    [Nn]* ) exit;;
  esac
done
figlet "DESKTOP"
echo "1: XFCE"
echo "2: GNOME"
echo "3: CINNAMON"
echo "4: MATE"
echo "5: KDE"
echo "n: don't install any desktop environment"


while true; do
  read -p "Do you wish to install a Desktop environment? [1,n] : " ans
  case $ans in
     [1]* ) /scripts/de-xfce.sh; break;;
     [2]* ) /scripts/de-gnome.sh; break;;
     [5]* ) /scripts/de-kde.sh; break;;
    [Nn]* ) exit;;
  esac
done
echo "------------------------------------------------"
figlet "TERMINATED"
echo "type 'reboot' to restart your system"
exit

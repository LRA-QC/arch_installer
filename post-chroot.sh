#!/bin/bash
pacman -Syyu --noconfirm &>/dev/null
systemctl disable netctl &>/dev/null
pacman -Rns --noconfirm netctl  &>/dev/null
echo "- installing NetworkManager"
pacman -S networkmanager --noconfirm &>/dev/null
systemctl enable NetworkManager &>/dev/null
/scripts/select-tz.sh
echo '- setting clock'
hwclock --systohc
/scripts/select-locale.sh

read -p "- Enter a hostname for the machine : " NAME
echo '- Creating hosts and hostname'
echo $NAME > /etc/hostname

echo '127.0.0.1 localhost' >>/etc/hosts
echo '::1 localhost' >>/etc/hosts
echo "127.0.1.1 ${NAME}.local ${NAME}" >>/etc/hosts

echo '--[Installing bootloader]--'
mkinitcpio -p linux &>/dev/null
bootctl install &>/dev/null

rootdrive=$(df /|tail -n 1|awk '{print $1}')
uuid=$(blkid $rootdrive|awk '{print $5}')
echo 'timeout 3'>/boot/loader/loader.conf
echo 'default arch'>>/boot/loader/loader.conf
echo 'title ArchLinux'>/boot/loader/entries/arch.conf
echo 'linux /vmlinuz-linux'>>/boot/loader/entries/arch.conf
echo 'initrd /initramfs-linux.img'>>/boot/loader/entries/arch.conf
echo "options root=${uuid} rw">>/boot/loader/entries/arch.conf
echo '- Changing root password'
passwd root
echo '- improving MAKEFLAG for multicore CPU'
echo 'MAKEFLAGS="-j$(nproc)"' >> /etc/makepkg.conf
echo '- Enabling SSHD'
systemctl enable sshd &>/dev/null
echo "------------------------------------------------"
while true; do
  read -p "Do you wish to create a user? [y/n] " ans
  case $ans in
    [Yy]* ) /scripts/createuser.sh; break;;
    [Nn]* ) exit;;
  esac
done

echo "-[Desktop environment]---------------------"
echo "1: XFCE"
#echo "2: GNOME"
#echo "3: CINNAMON"
#echo "4: MATE"
#echo "5: "
echo "n: don't install any desktop environment"


while true; do
  read -p "Do you wish to install a Desktop environment? [1,n] : " ans
  case $ans in
     [1]* ) /scripts/de-xfce.sh; break;;
     [2]* ) /scripts/de-gnome.sh; break;;
    [Nn]* ) exit;;
  esac
done
echo "------------------------------------------------"
echo "type 'reboot' to restart your system"
exit

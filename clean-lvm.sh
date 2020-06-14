#!/bin/sh
set -x
umount -R /mnt 2>/dev/null
count=$(pvdisplay -c|grep "/dev/$1"|wc -l)

if [ $count -eq 0 ] ; then
   echo "no LVM to clean!"
else
  VG=$(pvdisplay -c|grep "/dev/$1"|awk -F: '{print $2}')
  echo "VG: [${VG}]"
  if [ -n VG ] ; then
    lvs|grep ${VG}|awk -F\  '{print $1}'|xargs -n1 -I{} -- lvremove -y {}
    vgremove -y -ff ${VG}
  fi
  drive=$(pvs|grep "/dev/sda"|awk '{print $1}')
  pvremove -y -f $drive
fi
wipefs -af /dev/$1

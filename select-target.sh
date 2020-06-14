#!/bin/sh

function get_drive
{
    lsblk -d -e 11 -e 7 -o name,tran -n|grep -v usb |percol --prompt "Select the disk"|awk '{print $1}'
}

function get_fs
{
    DISK=$1
    lsblk -fl -e 11 -e 7|grep -P "${DISK}[1-9,p]" |percol --prompt "Select the filesystem"|awk '{print $1}'
}

# this function should list all candidate partitions for install and try to exclude any usb drive
function get_part
{
# blkid|grep -v -e iso9660 -e squashfs -e sda1 -e ARCHISO|percol --prompt "Select target partition"|awk -F\: '{print $1}'
  lsblk -d -e 11 -e 7 -o name,tran -n|grep -v usb |awk '{print $1}' > /tmp/drives.lst
  lsblk -d -e 11 -e 7 -o name,tran -n|grep usb |awk '{print $1}' > /tmp/usbdrives.lst
  blkid|grep -v -e iso9660 -e squashfs -e sda1 -e ARCHISO > /tmp/fs.lst
  blkid|grep -f /tmp/drives.lst|grep -v -e LVM2 | awk -F\: '{print $1}' > /tmp/boot.lst
  grep -v -f /tmp/usbdrives.lst /tmp/fs.lst|grep -v LVM2 | percol --prompt "Select target partition"|awk -F\: '{print $1}'
}

function yesno
{
    echo -e "yes\nno"|percol --prompt "Is everything valid? "
}

#TARGET=$(get_part)

TARGET=$(blkid|grep arch_os|awk -F: '{print $1}')

echo "TARGET: $TARGET"
read -p "press ENTER"
ask=$(yesno)
if [ "$ask" == "yes" ]; then
    echo "${TARGET}" > /tmp/target.txt
else
    echo "..aborting"
    rm /tmp/target.txt
    rm /tmp/boot.lst
fi

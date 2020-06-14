#!/bin/sh
item=

function check_boot
{
    echo "check_boot"
}

# This function create a partition directly on the DISK
# I think it make sense to not have this anymore
# LVM makes more sense as you can expand/resize logical volumes easily
function configure_basic
{
    clear
    set -x
    TARGET=$1
    echo "Basic configuration: ${TARGET} "
    prep_disk
    echo "..Creating filesystem on standard drive, please wait a few seconds";
    mkfs.xfs /dev/${TARGET}2       &>/dev/null;
    xfs_admin -L arch_os /dev/${TARGET}2
    read -p "PRESS ENTER TO CONTINUE" whatever
#    mount /dev/${TARGET}2 /mnt

}
function configure_lvm
{
    clear
    TARGET=$1
    nvme=
    echo $1 > /tmp/disk.txt
    grep -i nvme /tmp/disk.txt && echo '1' >/tmp/nvme.txt &&  nvme=true
    if [ -z nvme ] ; then
        echo "/dev/${TARGET}p1" > /tmp/boot.txt 
        TARGET2="/dev/${TARGET}p2"
    else
        echo "/dev/${TARGET}1" > /tmp/boot.txt 
        TARGET2="/dev/${TARGET}2"
    fi
    echo "LVM configuration: ${TARGET}"
    size=$(lsblk|grep disk|grep ${TARGET}|awk '{print $4}')
    echo "Current disk size: ${size}"
    read -p "Enter size (in GB, no decimal) of the root logical volume (should be at least 10): " SIZE
    set -x
    prep_disk
    echo "..Creating LVM volume"
    pvcreate ${TARGET2} &>/dev/null && vgcreate vg_root ${TARGET2} && lvcreate -L ${SIZE}G vg_root -n lv_root && mkfs.xfs /dev/vg_root/lv_root && xfs_admin -L arch_os /dev/vg_root/lv_root 
    read -p "Press ENTER to continue"
}


function configure_crypt_lvm
{
    set -x
    TARGET=$1
    nvme=
    echo $1 > /tmp/disk.txt
    mkdir -p /run/cryptsetup
    grep -i nvme /tmp/disk.txt && echo '1' >/tmp/nvme.txt &&  nvme=true
    if [ -z nvme ] ; then
        echo "/dev/${TARGET}p1" > /tmp/boot.txt 
        TARGET2="/dev/${TARGET}p2"
    else
        echo "/dev/${TARGET}1" > /tmp/boot.txt 
        TARGET2="/dev/${TARGET}2"
    fi
    echo $TARGET2 > /tmp/partition.txt
    echo "Crypt configuration: ${TARGET}"

    size=$(lsblk|grep disk|grep ${TARGET}|awk '{print $4}')
    echo "Current disk size: ${size}"
    read -p "Enter size (in GB, no decimal) of the root logical volume (should be at least 10): " SIZE
    prep_disk
    echo "..Encrypting disk"
    cryptsetup -q -y -v luksFormat /dev/${TARGET}2;
    echo "..Mounting encrypted filesystem"
    cryptsetup open ${TARGET2} cryptroot && pvcreate /dev/mapper/cryptroot &>/dev/null && vgcreate vg_root /dev/mapper/cryptroot &>/dev/null && lvcreate -L ${SIZE}G vg_root -n lv_root && mkfs.xfs /dev/vg_root/lv_root && xfs_admin -L arch_os /dev/vg_root/lv_root 
    exit
    #echo "..Creating filesystem on LUKS drive";
}


#USED FOR ALL DISK CONFIGURATION TO NUKE AND INITIALIZE EFI PARTITION
function prep_disk
{   
    ./clean-lvm.sh ${TARGET}
    echo "Wiping disk"
    wipefs -f -a /dev/${TARGET} &>/dev/null
    dd if=/dev/zero of=/dev/${TARGET} bs=1M count=1024 &>/dev/null
    echo "Initializing disk"
    parted --script /dev/${TARGET} -- mklabel gpt \
    mkpart primary fat32 64d 512MiB \
    set 1 esp on \
    mkpart primary ext4 512MiB -1MiB &>/dev/null
    partprobe /dev/${TARGET} &>/dev/null
    hdparm -z /dev/${TARGET} &>/dev/null
}

function get_drive
{
    lsblk -d -e 11 -e 7 -o name,tran -n|grep -v usb |percol --prompt "Select the disk to work with, you will be asked to confirm"|awk '{print $1}'
}

function yesno
{
    echo -e "yes\nno"|percol --prompt "Wipe disk and configure? (y/n) ** ALL CONTENT WILL BE LOST **"
}

#SHOW MENU
while [ "$item" != "x" ]; 
do
    item=$(cat menu-disk.lst|percol --prompt "Select disk action, these are destructive operations, be careful"|awk -F\) '{print $1}')
    if [ "$item" == 'a' ]; then 
        TARGET=$(get_drive)
        ask=$(yesno)
        if [ "$ask" == "yes" ]; then
            configure_lvm ${TARGET}
        else
            echo "..aborting"
            sleep 4
            TARGET=
        fi
    fi
    if [ "$item" == 'b' ]; then 
        TARGET=$(get_drive)
        ask=$(yesno)
        if [ "$ask" == "yes" ]; then
            configure_crypt_lvm ${TARGET}
        else
            echo "..aborting"
            sleep 4
            TARGET=
        fi
    fi
#    if [ "$item" == 'ZZ' ]; then 
#        TARGET=$(get_drive)
#        ask=$(yesno)
#        if [ "$ask" == "yes" ]; then
#            configure_basic ${TARGET}
#        else
#            echo "..aborting"
#            TARGET=
#        fi
#        sleep 2
    #fi
done

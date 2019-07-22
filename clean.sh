
#clean drive
umount /dev/sda1 &>/dev/null
umount /dev/sda2 &>/dev/null
# dd if=/dev/zero of=/dev/sda bs=1024M count=512 &>/dev/null

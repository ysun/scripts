#/bin/bash

#set -x

cmd=$1
loopid_file=${0}.loopid

if [[ "$cmd" == "umount" ]]; then
    loop_dev=`cat $loopid_file`
    umount /mnt/boot/efi
    umount /mnt/
    losetup -d $loop_dev
    rm -rf $loopid_file
elif [[ "$cmd" == "chroot" ]]; then
    arch-chroot /mnt
elif [[ "$cmd" == "mount" ]]; then
    loop_dev=`losetup -f`
    echo ${loop_dev} > $loopid_file

    losetup -P $loop_dev ./ubuntu20.10_rootfs.img
    mount ${loop_dev}p3 /mnt/
    mount ${loop_dev}p1 /mnt/boot/efi
else
    printf "\
Usage:\n\
    ./mount_ubuntu20.04_rootfs.sh <command>\n\
    command:\n\
        mount:\n\
        umount:\n\
        chroot:\n"
fi

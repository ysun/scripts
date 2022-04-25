#!/bin/bash

#set -x
set -e

vmname=$1
[[ "$vmname" == "" ]] && vmname="rootfs.img"

vmsize=`echo $2 | tr -cd "[0-9]"`
[[ "$vmsize" == "" ]] && vmsize="10"

vmnamedir=${vmname}.dir

chroot-cmd()
{
    [[ "$1" != "" ]] && echo $1 | arch-chroot $vmnamedir
}

apt install -y gdisk debootstrap arch-install-scripts

dd if=/dev/zero of=$vmname bs=1M count=`expr 1024 \* $vmsize `
sgdisk -n 1:0:+1G -n 2:0:+1G -n 3:0: -t 1:ef00 -t 2:8200 -t 3:8300 $vmname -p

devnode=`losetup -f`
losetup -P ${devnode} $vmname

mkfs.vfat ${devnode}p1
mkswap ${devnode}p2 && swapon ${devnode}p2
mkfs.ext4 ${devnode}p3

mkdir $vmnamedir  &&  mount ${devnode}p3 $vmnamedir
mkdir -p ${vmnamedir}/boot/efi && mount ${devnode}p1 ${vmnamedir}/boot/efi

debootstrap --arch amd64 jammy $vmnamedir http://archive.ubuntu.com/ubuntu

release="jammy"

if [[ "$vmnamedir" == "" ]]; then
	exit 1
fi

printf "deb http://archive.ubuntu.com/ubuntu/ ${release} main restricted universe\ndeb http://security.ubuntu.com/ubuntu/ ${release}-security main restricted universe\ndeb http://archive.ubuntu.com/ubuntu/ ${release}-updates main restricted universe\n" > $vmnamedir/etc/apt/sources.list

printf "/dev/sda3  / ext4  rw,relatime     0 1 \n/dev/sda1  /boot/efi  vfat  rw,relatime,errors=remount-ro   0 2 \n/dev/sda2  none  swap  defaults   0 0\n" > $vmnamedir/etc/fstab

chroot-cmd "apt update"
chroot-cmd "apt-get install -y --no-install-recommends linux-generic linux-image-generic linux-headers-generic initramfs-tools linux-firmware efibootmgr tzdata grub-efi-amd64"

chroot-cmd "echo 'tzdata tzdata/Areas select Asia' | debconf-set-selections"
chroot-cmd "echo 'tzdata tzdata/Zones/Asia select Shanghai' | debconf-set-selections"
chroot-cmd "rm /etc/timezone"
chroot-cmd "rm /etc/localtime"
chroot-cmd "dpkg-reconfigure -f noninteractive tzdata"

chroot-cmd "echo 'locales locales/locales_to_be_generated multiselect zh_CN.UTF-8 UTF-8' | debconf-set-selections"
chroot-cmd "echo 'locales locales/locales_to_be_generated multiselect en_US.UTF-8 UTF-8' | debconf-set-selections"
chroot-cmd "echo 'locales locales/default_environment_locale select en_US.UTF-8 UTF-8' | debconf-set-selections"
chroot-cmd "rm '/etc/locale.gen'"
chroot-cmd "dpkg-reconfigure --frontend noninteractive locales"

chroot-cmd "passwd -d root"
chroot-cmd "grub-install"
chroot-cmd "grub-mkconfig -o /boot/grub/grub.cfg"

# umount /mnt/boot/efi
# umount /mnt/

# qemu-system-x86_64 -enable-kvm -bios ovmf/OVMF_CODE.fd  -m 4G -M q35 -smp 2 -hda ubuntu22.04.img
# qemu-system-x86_64 -enable-kvm -bios ovmf/OVMF_CODE.fd -vga none -nographic -m 4G -M q35 -smp 2 -hda ubuntu22.04.img

# Risize the Image!!!
# qemu-img resize $vmname +5G
# Or dd if=/dev/zero bs=1M of=$vmname conv=notrunc oflag=append count=5120

# sgdisk -d 3 -n 3:0: -t 3:8300 $vmname -p
# newsize=`sgsgdisk  -p $vmname  |grep 'last usable sector is'|grep -o -E '[^ ]*$'`
# sgdisk -d 3 -n 3:0:$newsize -t 3:8300 $vmname -p  //<--必须执行第二次
# OR 执行两次！：
#  sgdisk -d 3 -N 3 -t 3:8300 rootfs.img -p

# resize2fs ${devnode}p3
# Or
# (in vm) resize2fs /dev/sda3

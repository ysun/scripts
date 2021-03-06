#!/bin/bash

set -x

IP=$1
PORT=$2
[[ "$PORT" == "" ]] && PORT=22

DEPMOD=""
#[[ $IP == "" ]] && IP="sunyi-kr-skl-dom0"

git checkout Makefile
VERSION=`cat Makefile |grep "^EXTRAVERSION"`
branch=`git branch | grep '*' | awk -F ' ' '{print $2}'`
[[ "$branch" =~ '(' ]] && branch="" 

COMMIT_FLAG=`git log |head -n 1 |awk -F ' ' '{print $2}' | cut -b-6`
DATE=`date +%Y%m%d`
NEW_VERSION=${VERSION}_${branch}_${COMMIT_FLAG}_${DATE}
#if [[ "$tag" != "NULL" && "$tag" != "" ]]; then                       
#    NEW_VERSION=${VERSION}_${tag}                                     
#fi                                                                    
sed -in-place -e "s/${VERSION}/${NEW_VERSION}/g" Makefile             

make

echo "make modules_install..."
DEPMOD=`make modules_install | tail -n 1`
[[ $? != 0 ]] && exit 1

DEPMOD=${DEPMOD##* }
[[ $DEPMOD =~ [0-9]*[.][0-9]* ]] && DEPMOD_MAR=${BASH_REMATCH[0]}

echo "DEPMOD=${DEPMOD}"
echo "DEPMOD_MAR=${DEPMOD_MAR}"

echo "scp bzImage to /boot/..."
[[ $IP != "" ]] && scp -P $PORT arch/x86/boot/bzImage $IP:/boot/bzImage-${DEPMOD_MAR}
[[ $IP != "" ]] && [[ $? != 0 ]] && exit 1

echo "scp bzImage to /boot/efi/EFI/ubuntu/ ..."
[[ $IP != "" ]] && ssh $IP -p $PORT -C 'ls /boot/efi/EFI/' | grep ubuntu | xargs -I{} scp -P $PORT arch/x86/boot/bzImage $IP:/boot/efi/EFI/{}/bzImage-${DEPMOD_MAR}
[[ $IP != "" ]] && [[ $? != 0 ]] && exit 1

#echo "objdump vmlinux to /tmp/kernel-rb42.hex ..."
#objdump -Slz vmlinux > /tmp/kernel-rb42.hex
#[[ $? != 0 ]] && exit 1
#
cd /lib/modules

echo "mkinitramfs..."
#mkinitramfs -o initrd-4.2.0-rc8-vgt+.img -v 3.18.0-rc7-vgt+ > /dev/null
#mkinitramfs -o initrd-4.2.0-rc8-vgt+.img -v 4.2.0-rc8-vgt+ > /dev/null
mkinitramfs -o initrd-${DEPMOD_MAR} -v $DEPMOD > /dev/null
[[ $? != 0 ]] && exit 1

echo "tar cvf ${DEPMOD}.tar ..."
#tar cvf 4.2.0-rc8-vgt+.tar 3.18.0-rc7-vgt+ > /dev/null
#tar cvf 4.2.0-rc8-vgt+.tar 4.2.0-rc8-vgt+ > /dev/null
tar cvf ${DEPMOD}.tar $DEPMOD > /dev/null
[[ $? != 0 ]] && exit 1

echo "scp ${DEPMOD}.tar ..."
#scp 4.2.0-rc8-vgt+.tar $IP:/lib/modules/
[[ $IP != "" ]] && scp -P $PORT  ${DEPMOD}.tar $IP:/lib/modules/
[[ $IP != "" ]] && [[ $? != 0 ]] && exit 1

echo "scp initrd-${DEPMOD_MAR} to /boot/efi/EFI/ubuntu"
[[ $IP != "" ]] && ssh $IP -p $PORT -C 'ls /boot/efi/EFI/' | grep ubuntu | xargs -I{} scp -P $PORT initrd-${DEPMOD_MAR}  $IP:/boot/efi/EFI/{}/
[[ $IP != "" ]] && [[ $? != 0 ]] && exit 1

echo "initrd-${DEPMOD_MAR}  to /boot/"
[[ $IP != "" ]] && scp -P $PORT  initrd-${DEPMOD_MAR}  $IP:/boot/
[[ $IP != "" ]] && [[ $? != 0 ]] && exit 1

echo "tar xvf ${DEPMOD}.tar on test ..."
[[ $IP != "" ]] && ssh $IP -p $PORT -C "cd /lib/modules/; tar xvf ${DEPMOD}.tar > /dev/null"
[[ $IP != "" ]] && [[ $? != 0 ]] && exit 1

cd -

#/bin/bash

IP=$1
DEPMOD=""
[[ $IP == "" ]] && IP="sunyi-kr-skl-dom0"

git checkout Makefile
VERSION=`cat Makefile |grep "^EXTRAVERSION"`
branch=`git branch | grep '*' | awk -F ' ' '{print $2}'`
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
scp arch/x86/boot/bzImage $IP:/boot/bzImage-${DEPMOD_MAR}
[[ $? != 0 ]] && exit 1

echo "scp bzImage to /boot/efi/EFI/ubuntu/ ..."
ssh $IP -C 'ls /boot/efi/EFI/' | grep ubuntu | xargs -I{} scp arch/x86/boot/bzImage $IP:/boot/efi/EFI/{}/bzImage-${DEPMOD_MAR}
[[ $? != 0 ]] && exit 1

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
scp ${DEPMOD}.tar $IP:/lib/modules/
[[ $? != 0 ]] && exit 1

echo "scp initrd-${DEPMOD_MAR} to /boot/efi/EFI/ubuntu"
ssh $IP -C 'ls /boot/efi/EFI/' | grep ubuntu | xargs -I{} scp initrd-${DEPMOD_MAR}  $IP:/boot/efi/EFI/{}/
[[ $? != 0 ]] && exit 1

echo "initrd-${DEPMOD_MAR}  to /boot/"
scp initrd-${DEPMOD_MAR}  $IP:/boot/
[[ $? != 0 ]] && exit 1

echo "tar xvf ${DEPMOD}.tar on test ..."
ssh $IP -C "cd /lib/modules/; tar xvf ${DEPMOD}.tar > /dev/null"
[[ $? != 0 ]] && exit 1

cd -

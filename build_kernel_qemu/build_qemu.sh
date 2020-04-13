#!/bin/bash

set -x
build_home=/root/qemu-release
qemu_dir=qemu-master
RPMSOURCE_TAR=/root/rpmbuild/SOURCES/qemu-master.tar
release_tag=ww`date +%W`

RPMSOURCE=/root/rpmbuild/SOURCES/
RPMBUILD=/root/rpmbuild/BUILD/
RPMBUILDROOT=/root/rpmbuild/BUILDROOT/

# rm -rf $RPMBUILD/$qemu_dir
# rm -rf $RPMBUILDROOT/${qemu_dir}-${release_tag}.x86_64
rm -rf /root/rpmbuild/*
mkdir -p /root/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}

cd $build_home/$qemu_dir
#proxychains4 git fetch origin
git fetch origin
git reset --hard origin/master
git clean -xdf

release_tag=${release_tag}_`git log -1 --pretty=format:"%h"`

cd ..
tar cvf qemu-master.tar qemu-master
cp qemu-master.tar $RPMSOURCE

sed -i "s/^Release:.*/Release: ${release_tag}/g" qemu.spec
rpmbuild -ba qemu.spec

scp /root/rpmbuild/RPMS/x86_64/qemu-master-${release_tag}.x86_64.rpm 10.239.156.155:/home/KCloud/kernels/intel-next-kernel/
scp /root/rpmbuild/SRPMS/qemu-master-${release_tag}.src.rpm 10.239.156.155:/home/KCloud/kernels/intel-next-kernel/

# mv /root/rpmbuild/RPMS/x86_64/qemu-master-${release_tag}.x86_64.rpm .
# mv /root/rpmbuild/SRPMS/qemu-master-${release_tag}.src.rpm .

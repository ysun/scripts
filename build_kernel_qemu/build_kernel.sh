#!/bin/bash

set -x
build_home=/root/kernel-release
kernel_dir=intel-next-kernel/
release_tag=ww`date +%W`

cd $build_home/$kernel_dir

git fetch origin
git reset --hard origin/master
git clean -xdf

release_tag=${release_tag}_`git log -1 --pretty=format:"%h"`

cp ../config .config
make olddefconfig
echo $release_tag > .version

rm -rf /root/rpmbuild/

make rpm-pkg -j48

rpm_list=`ls /root/rpmbuild/RPMS/x86_64/ -rt | tail -3`

for r in $rpm_list; do
	scp /root/rpmbuild/RPMS/x86_64/$r 10.239.156.155:/home/KCloud/kernels/intel-next-kernel/
#	mv /root/rpmbuild/RPMS/x86_64/$r .
done

#!/bin/bash
SRC_KERNEL=/home/works/os.linux.intelnext.kernel/

docker build -f ./Dockerfile.build -t ubuntu:22.04 .

docker run -it --rm -v $SRC_KERNEL:/src ubuntu:22.04 bash -c 'make LOCALVERSION="" -j64 && make INSTALL_MOD_STRIP=1 modules_install && make install && make binrpm-pkg && mv /root/rpmbuild/RPMS/ .'

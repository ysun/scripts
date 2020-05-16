#!/bin/bash
make && make modules && make modules_install
cd /usr/lib/modules/5.7.0-rc5/

# Remove useless symbols, reduce initrd a lot! Or kernel will not boot up.
find . -name *.ko -exec strip --strip-unneeded {} +
cd -
make install

# Or 
make INSTALL_MOD_STRIP=1 modules_install && make install


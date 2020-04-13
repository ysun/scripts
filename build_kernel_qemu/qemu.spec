Name: qemu
Summary: Qemu
Version: master
Release: ww14_17e1e49814
License: GPL
Group: Qemu
Vendor: The Qemu Community
URL: http://www.qemu.org
Source: qemu-master.tar
BuildRoot: %_buildrootdir
Provides:  vmm-fast-restart
%define __spec_install_post /usr/lib/rpm/brp-compress || :
%define debug_package %{nil}

%description
Qemu

%prep
%setup -q

%build
./configure --target-list=x86_64-softmmu --enable-kvm --enable-vnc --enable-gtk --enable-sdl --enable-libpmem
make %{?_smp_mflags}

%install
mkdir -p $RPM_BUILD_ROOT/usr/local/bin
mkdir -p $RPM_BUILD_ROOT/usr/local/libexec
mkdir -p $RPM_BUILD_ROOT/usr/local/etc/qemu
mkdir -p $RPM_BUILD_ROOT/usr/local/share/qemu
mkdir -p $RPM_BUILD_ROOT/usr/local/share/qemu/keymaps
chmod 755 qemu-img qemu-nbd qemu-io
cp -r pc-bios/* $RPM_BUILD_ROOT/usr/local/share/qemu/
cp qemu-img $RPM_BUILD_ROOT/usr/local/bin/
cp qemu-nbd $RPM_BUILD_ROOT/usr/local/bin/
cp qemu-io $RPM_BUILD_ROOT/usr/local/bin/
cp x86_64-softmmu/qemu-system-x86_64 $RPM_BUILD_ROOT/usr/local/bin/
cp qemu-bridge-helper $RPM_BUILD_ROOT/usr/local/libexec/
#cp edk2/Build/OvmfX64/DEBUG_GCC5/FV/OVMF.fd $RPM_BUILD_ROOT/usr/local/share/qemu/
#cp build_info $RPM_BUILD_ROOT/usr/local/etc/qemu/

%post
export DMRAID=no 
rm -rf /usr/bin/qemu-system-x86_64
rm -rf /usr/bin/qemu-img
rm -rf /usr/bin/qemu-nbd
rm -rf /usr/bin/qemu-io

%preun

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr (-, root, root)
/usr/local/share/qemu/*
/usr/local/bin/*
/usr/local/libexec/*
/usr/local/etc/*

%postun


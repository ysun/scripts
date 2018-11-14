#!/bin/bash

cat <<EOF
Content-type: text/plain

EOF

#nohup ssh -t root@10.239.48.248 ssh root@192.168.199.166 -C DISPLAY=:0 qemu-system-x86_64 --enable-kvm -device ioh3420,id=root-port1,multifunction=on,chassis=1,bus=pcie.0 -device vfio-pci,host=00:11.5,bus=root-port1,romfile= -net nic,model=e1000,macaddr=00:11:22:33:44:55 -net tap,script=/etc/kvm/qemu-ifup -M q35 -no-host-reboot -cpu Skymeadow,pmu=on -m 0 -smp pcmcpu=on,pcmnuma=on -smbios host -hda /root/guest-images/ia32e_rhel7u3_kvm_test.qcow &
#nohup ssh -t root@10.239.48.248 ssh root@192.168.199.166 -C /root/create_guest_remote.sh &

#ssh -o "StrictHostKeyChecking no" -T root@10.239.48.248 ssh root@192.168.199.166 -C /root/create_guest_remote.sh

/usr/bin/expect <<EOD
spawn ssh -oStrictHostKeyChecking=no -T root@10.239.48.248 ssh root@192.168.199.166 -C /root/create_guest_remote.sh
expect "*password*"
send "ccd123\r" 
EOD

echo "guest is created!"

ls

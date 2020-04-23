#!/bin/bash

interface=$1

if [[ "$interface" == "" ]]; then
	echo "Please provide network interface"
	echo " e.g.  $0 eth0"
	exit 1
fi

ip link add br0 type bridge
ip link set dev br0 up
ip link set $interface master br0
dhclient br0

echo "Please run following command after guest created!"
echo "ip link set vmtap0 master br0 && ip link set vmtap0 up"

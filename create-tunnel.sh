#!/bin/bash

ip=$1
[[ "$ip" == "" ]] && ip='211.144.92.179'

ssh -f -N -R 2222:localhost:22 root@$ip

echo "ssh -f -N -R 2222:localhost:22 root@$ip"

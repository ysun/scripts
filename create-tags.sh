#!/bin/bash

target_dir=$1
[[ "$target_dir" == "" ]] && target_dir=./

if [[ $target_dir == "" ]]; then
	echo "A source code folder is required!!"
	exit 1
fi

cd $target_dir 
if [[ $? != 0 ]]; then
	echo "Not a avilable source code folder!!"
	exit 2
fi

ctags -R host_cmn acpi host pcidrv 

if [[ $? != 0 ]]; then
	echo "Error: generating ctags!"
	exit 3
fi

find `pwd` -name "*.h" -o -name "*.c" -o -name "*.hpp" -o -name "*.cpp"> cscope.files
sed -i '/wlan\/fwcommon/d' cscope.files
sed -i '/wlan\/package/d' cscope.files

#cscope -qbR -i cscope.files
cscope -Rbqu -i cscope.files

if [[ $? != 0 ]]; then
	echo "Error: generating cscope!"
	exit 4
fi

cd -

#!/bin/bash -e

func=$1
output=$2

[[ "$func" == "" ]] && exit 1
[[ "$output" == "" ]] && output=/out

GCDA=/sys/kernel/debug/gcov/src/
GCNO=/src

GCNOOUT="/out/gcno" 
GCDAOUT="/out/gcda" 

if [[ "$func" == "kernel" ]]; then
	make LOCALVERSION="" -j64
	make INSTALL_MOD_STRIP=1 modules_install
	make install
	make binrpm-pkg
	mv /root/rpmbuild/RPMS/ /out

	find $GCNO -type d -exec mkdir -p $GCNOOUT/\{\} \;
	find $GCNO -name '*.gcno' -exec sh -c 'cp -d $0 '$GCNOOUT'/$0' {} \;
	find $GCNO -name '*.c' -exec sh -c 'cp -d $0 '$GCNOOUT'/$0' {} \;
	find $GCNO -name '*.h' -exec sh -c 'cp -d $0 '$GCNOOUT'/$0' {} \;
	tar czf /out/gcno.tar -C $GCNOOUT/$GCNO .
fi

if [[ "$func" == "gcda" ]]; then
	find $GCDA -type d -exec mkdir -p $GCDAOUT/\{\} \;
	find $GCDA -name '*.gcda' -exec sh -c 'cat < $0 > '$GCDAOUT'/$0' {} \;
	mkdir -p $output
	tar czf $output/gcda.tar -C $GCDAOUT/$GCDA .
fi

if [[ "$func" == "lcov" ]]; then
	lcov -c -i -d /src -o /out/app_base.info
	genhtml /out/app_base.info --output-directory /out/genhtml --title "kernel code coverage" --show-details --legend
fi

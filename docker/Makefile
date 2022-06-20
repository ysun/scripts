# Intel Copyright © 2021, Intel Corporation.

SRC_KERNEL := /home/works/os.linux.intelnext.kernel/
SRC_GCOV := ./gcov

OUTPUT := $(PWD)

all: run

image:
	docker build -f ./Dockerfile.build -t ubuntu:22.04 .

kernel:
	docker run -it --rm -v $(SRC_KERNEL):/src -v $(OUTPUT):/out ubuntu:22.04 bash -c 'collect_gcov.sh kernel $(OUTPUT)'

gcda:
	./collect_gcov.sh gcda $(SRC_GCOV)

lcov:
	docker run -it --rm -v $(SRC_GCOV):/src -v $(OUTPUT):/out ubuntu:22.04 bash -c 'collect_gcov.sh lcov $(OUTPUT)'
	
debug:
	docker run -it --rm -v $(PWD):/src -v $(OUTPUT):/out ubuntu:22.04 bash

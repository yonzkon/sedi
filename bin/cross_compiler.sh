#!/bin/bash

# 0) - usage
usage()
{
	echo "USAGE: cross_compilers.sh [COMMAND]"
	echo "  (COMMAND) - linux_kernel_headers"
	echo "              binutils"
	echo "              gcc_compilers"
	echo "              glibc_headers_and_startupfiles"
	echo "              gcc_libgcc"
	echo "              glibc"
	echo "              gcc"
}

if [ -z "$1" ]; then
	usage
else
	COMMAND=$(tr [A-Z] [a-z] <<<$1)
fi

# 1) - environment
PREFIX=/tmp/cross
TARGET=arm-linux-gnueabi
BASE_DIR=$(pwd)

export PATH=$PREFIX/bin:$PATH
mkdir -p build-binutils
mkdir -p build-gcc
mkdir -p build-glibc

# 2) - main
linux_kernel_headers()
{
	cd $BASE_DIR/src/linux
	make ARCH=arm INSTALL_HDR_PATH=$PREFIX/$TARGET headers_install
	cd $BASE_DIR
}

binutils()
{
	cd $BASE_DIR/build-binutils
	../src/binutils/configure --prefix=$PREFIX --target=$TARGET --disable-multilib
	make -j4
	make install
	cd $BASE_DIR
}

gcc_compilers()
{
	cd $BASE_DIR/build-gcc
	../src/gcc/configure --prefix=$PREFIX --target=$TARGET --enable-languages=c,c++ --disable-multilib
	make -j4 all-gcc
	make install-gcc
	cd $BASE_DIR
}

glibc_headers_and_startupfiles()
{
	cd $BASE_DIR/build-glibc
	../glibc/configure --prefix=$PREFIX/$TARGET --build=$MACHTYPE --host=$TARGET --with-headers=$PREFIX/$TARGET/include --disable-multilib libc_cv_forced_unwind=yes
	make install-bootstrap-headers=yes install-headers
	make -j4 csu/subdir_lib
	install csu/crt1.o csu/crti.o csu/crtn.o $PREFIX/$TARGET/lib
	$TARGET-gcc -nostdlib -nostartfiles -shared -x c /dev/null -o $PREFIX/$TARGET/lib/libc.so
	touch $PREFIX/$TARGET/include/gnu/stubs.h
	cd $BASE_DIR
}

gcc_libgcc()
{
	cd $BASE_DIR/build-gcc
	make -j4 all-target-libgcc
	make install-target-libgcc
	cd $BASE_DIR
}

glibc()
{
	cd $BASE_DIR/build-glibc
	make -j4
	make install
	cd $BASE_DIR
}

gcc()
{
	cd $BASE_DIR/build-gcc
	make -j4
	make install
	cd $BASE_DIR
}

if [ "$COMMAND" == "linux_kernel_headers" ]; then
	linux_kernel_headers # 1
elif [ "$COMMAND" == "binutils" ]; then
	binutils # 2
elif [ "$COMMAND" == "gcc_compilers" ]; then
	gcc_compilers # 3
elif [ "$COMMAND" == "glibc_headers_and_startupfiles" ]; then
	glibc_headers_and_startupfiles # 4
elif [ "$COMMAND" == "gcc_libgcc" ]; then
	gcc_libgcc # 5
elif [ "$COMMAND" == "glibc" ]; then
	glibc # 6
elif [ "$COMMAND" == "gcc" ]; then
	gcc # 7
fi

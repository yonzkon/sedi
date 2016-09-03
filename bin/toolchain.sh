#!/bin/sh

usage()
{
	echo "Usage: toolchian.sh {COMMAND} [PREFIX, [SRC_DIR]]"
	echo ""
	echo "    {COMMAND} linux_kernel_headers"
	echo "              binutils"
	echo "              gcc_compilers"
	echo "              glibc_headers_and_startupfiles"
	echo "              gcc_libgcc"
	echo "              glibc"
	echo "              gcc"
	echo "              lib_install"
	echo "    [PREFIX]  where to install the toolchain [default: $(pwd)/_install]"
	echo "    [SRC_DIR] base directory which include the source files [default: $(pwd)/src]"
}

# usage
[ -z "$1" ] || [ "$1" == "--help" ] && usage && exit

# environment
SCRIPT_PATH=$0
SCRIPT_DIR=${SCRIPT_PATH%/*}
PWD=$(pwd)

if [ -z "$2" ]; then
	PREFIX=$(pwd)/_install
elif [ -z $(grep -e '^/' <<<$2) ]; then
	PREFIX=$(pwd)/$2
else
	PREFIX=$2
fi

if [ -z "$3" ]; then
	SRC_DIR=$(pwd)/src
elif [ -z $(grep -e '^/' <<<$3) ]; then
	SRC_DIR=$(pwd)/$3
else
	SRC_DIR=$3
fi

COMMAND=$(tr [A-Z] [a-z] <<<$1)
TARGET=arm-linux-gnueabi
JOBS=$(grep -c ^processor /proc/cpuinfo)

[[ $PATH =~ "$PREFIX/bin" ]] || export PATH=$PREFIX/bin:$PATH
mkdir -p $PREFIX
mkdir -p build-binutils
mkdir -p build-gcc
mkdir -p build-glibc

# main
linux_kernel_headers()
{
	cd $SRC_DIR/linux
	make ARCH=arm INSTALL_HDR_PATH=$PREFIX/$TARGET headers_install
	cd $PWD
}

binutils()
{
	cd build-binutils
	$SRC_DIR/binutils/configure --prefix=$PREFIX --target=$TARGET --disable-multilib
	make -j$JOBS
	make install
	cd ..
}

gcc_compilers()
{
	cd build-gcc
	$SRC_DIR/gcc/configure --prefix=$PREFIX --target=$TARGET --enable-languages=c,c++ --disable-multilib
	make -j$JOBS all-gcc
	make install-gcc
	cd ..
}

glibc_headers_and_startupfiles()
{
	cd build-glibc
	$SRC_DIR/glibc/configure --prefix=$PREFIX/$TARGET --build=$MACHTYPE --host=$TARGET --with-headers=$PREFIX/$TARGET/include --disable-multilib libc_cv_forced_unwind=yes
	make install-bootstrap-headers=yes install-headers
	make -j$JOBS csu/subdir_lib
	install csu/crt1.o csu/crti.o csu/crtn.o $PREFIX/$TARGET/lib
	$TARGET-gcc -nostdlib -nostartfiles -shared -x c /dev/null -o $PREFIX/$TARGET/lib/libc.so
	touch $PREFIX/$TARGET/include/gnu/stubs.h
	cd ..
}

gcc_libgcc()
{
	cd build-gcc
	make -j$JOBS all-target-libgcc
	make install-target-libgcc
	cd ..
}

glibc()
{
	cd build-glibc
	make -j$JOBS
	make install
	cd ..
}

gcc()
{
	cd build-gcc
	make -j$JOBS
	make install
	cd ..
}

lib_install()
{
	local fromlib=$PREFIX/$TARGET/lib/
	local tolib=$PREFIX/arm-lib/
	mkdir -p $tolib
	for item in libc libcrypt libdl libm libpthread libresolv libutil; do
		cp $fromlib/$item-*.so $tolib
		cp -d $fromlib/$item.so.[*0-9] $tolib
	done
	cp -d $fromlib/ld*.so* $tolib
}

echo "start build and install to $PREFIX"

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
elif [ "$COMMAND" == "lib_install" ]; then
	lib_install # 8
else
	usage && exit
fi

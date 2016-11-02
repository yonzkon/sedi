#!/bin/sh

usage()
{
	echo "Usage: toolchian.sh {ARCH} {COMMAND} [PREFIX, [SRC_DIR]]"
	echo ""
	echo "    {ARCH}    arm | x86 | ..."
	echo "    {COMMAND} binutils"
	echo "              linux_kernel_headers"
	echo "              gcc_compilers"
	echo "              glibc_headers_and_startupfiles"
	echo "              gcc_libgcc"
	echo "              glibc"
	echo "              gcc"
	echo "              glibc_install"
	echo "              glibc_install_simplify"
	echo "    [PREFIX]  where to install the toolchain [default: /opt/cross_\$ARCH]"
	echo "    [SRC_DIR] base directory which include the source files [default: $(pwd)/src]"
}

# usage
[ -z "$1" ] || [ "$1" == "--help" ] && usage && exit

# environment
PWD=$(pwd)
SCRIPT_PATH=$0
SCRIPT_DIR=${SCRIPT_PATH%/*}

ARCH=$1
COMMAND=$(tr [A-Z] [a-z] <<<$2)

if [ -z "$3" ]; then
	PREFIX=/opt/cross_$ARCH
elif [ -z $(grep -e '^/' <<<$3) ]; then
	PREFIX=$(pwd)/$3
else
	PREFIX=$3
fi

if [ -z "$4" ]; then
	SRC_DIR=$(pwd)/src
elif [ -z $(grep -e '^/' <<<$4) ]; then
	SRC_DIR=$(pwd)/$4
else
	SRC_DIR=$4
fi

TARGET=$ARCH-linux-gnueabi
JOBS=$(grep -c ^processor /proc/cpuinfo)

[[ $PATH =~ "$PREFIX/bin" ]] || export PATH=$PREFIX/bin:$PATH
mkdir -p $PREFIX
mkdir -p build-binutils
mkdir -p build-gcc
mkdir -p build-glibc
mkdir -p build-glibc_install

# main
binutils()
{
	cd build-binutils
	$SRC_DIR/binutils/configure --prefix=$PREFIX --target=$TARGET --disable-multilib
	make -j$JOBS
	make install
	cd ..
}

linux_kernel_headers()
{
	cd $SRC_DIR/linux
	make ARCH=$ARCH INSTALL_HDR_PATH=$PREFIX/$TARGET headers_install
	cd $PWD
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

glibc_install()
{
	cd build-glibc_install
	$SRC_DIR/glibc/configure --prefix=/ --build=$MACHTYPE --host=$TARGET --with-headers=$PREFIX/$TARGET/include --disable-multilib libc_cv_forced_unwind=yes
	make -j$JOBS
	make install install_root=$PREFIX/glibc_install
	cd ..
}

glibc_install_simplify()
{
	local fromlib=$PREFIX/glibc_install/lib
	local tolib=$PREFIX/glibc_install/lib_simplify/
	mkdir -p $tolib
	for item in libc libm libcrypt libdl libpthread libutil libresolv libnss_dns libreadline libncurses; do
		cp $fromlib/$item-*.so $tolib
		cp -d $fromlib/$item.so.[*0-9] $tolib
	done
	cp -d $fromlib/ld*.so* $tolib
}

echo "start build and install to $PREFIX"

if [ "$COMMAND" == "binutils" ]; then
	binutils # 1
elif [ "$COMMAND" == "linux_kernel_headers" ]; then
	linux_kernel_headers # 2
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
elif [ "$COMMAND" == "glibc_install" ]; then
	glibc_install # 8
elif [ "$COMMAND" == "glibc_install_simplify" ]; then
	glibc_install_simplify # 9
else
	usage && exit
fi

#!/bin/sh

usage()
{
	echo "Usage: toolchian.sh {COMMAND} [PREFIX]"
	echo ""
	echo "    {COMMAND} linux_kernel_headers"
	echo "              binutils"
	echo "              gcc_compilers"
	echo "              glibc_headers_and_startupfiles"
	echo "              gcc_libgcc"
	echo "              glibc"
	echo "              gcc"
	echo "              lib_install"
	echo "    [PREFIX]  where to install the toolchain [default: ./_install]"
}

# usage
[ -z "$1" ] || [ "$1" == "--help" ] && usage && exit

# environment
SCRIPT_PATH=$0
BASEDIR=${SCRIPT_PATH%/*}
cd $BASEDIR; [ ! -z "$2" ] && PREFIX=$(pwd)/$2 || PREFIX=$(pwd)/_install; cd -
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
	cd $BASEDIR/src/linux
	make ARCH=arm INSTALL_HDR_PATH=$PREFIX/$TARGET headers_install
	cd $BASEDIR
}

binutils()
{
	cd $BASEDIR/build-binutils
	../src/binutils/configure --prefix=$PREFIX --target=$TARGET --disable-multilib
	make -j$JOBS
	make install
	cd $BASEDIR
}

gcc_compilers()
{
	cd $BASEDIR/build-gcc
	../src/gcc/configure --prefix=$PREFIX --target=$TARGET --enable-languages=c,c++ --disable-multilib
	make -j$JOBS all-gcc
	make install-gcc
	cd $BASEDIR
}

glibc_headers_and_startupfiles()
{
	cd $BASEDIR/build-glibc
	../src/glibc/configure --prefix=$PREFIX/$TARGET --build=$MACHTYPE --host=$TARGET --with-headers=$PREFIX/$TARGET/include --disable-multilib libc_cv_forced_unwind=yes
	make install-bootstrap-headers=yes install-headers
	make -j$JOBS csu/subdir_lib
	install csu/crt1.o csu/crti.o csu/crtn.o $PREFIX/$TARGET/lib
	$TARGET-gcc -nostdlib -nostartfiles -shared -x c /dev/null -o $PREFIX/$TARGET/lib/libc.so
	touch $PREFIX/$TARGET/include/gnu/stubs.h
	cd $BASEDIR
}

gcc_libgcc()
{
	cd $BASEDIR/build-gcc
	make -j$JOBS all-target-libgcc
	make install-target-libgcc
	cd $BASEDIR
}

glibc()
{
	cd $BASEDIR/build-glibc
	make -j$JOBS
	make install
	cd $BASEDIR
}

gcc()
{
	cd $BASEDIR/build-gcc
	make -j$JOBS
	make install
	cd $BASEDIR
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

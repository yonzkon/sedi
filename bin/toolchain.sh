#!/bin/sh

usage()
{
	echo "Usage: toolchian.sh {ARCH} {COMMAND} [PREFIX, [WORKSPACE]]"
	echo ""
	echo "	{ARCH}	arm | x86 | ..."
	echo "	{COMMAND} binutils"
	echo "			  linux_kernel_headers"
	echo "			  gcc_compilers"
	echo "			  glibc_headers_and_startupfiles"
	echo "			  gcc_libgcc"
	echo "			  glibc"
	echo "			  gcc"
	echo "			  glibc_install"
	echo "			  glibc_install_simplify"
	echo "	[PREFIX]  where to install the toolchain [default: /opt/cross_\$ARCH]"
	echo "	[WORKSPACE] base directory which include the source files [default: $(pwd)]"
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
	WORKSPACE=$(pwd)
elif [ -z $(grep -e '^/' <<<$4) ]; then
	WORKSPACE=$(pwd)/$4
else
	WORKSPACE=$4
fi

TARGET=$ARCH-none-linux-gnueabi
JOBS=1
if [ -e "/proc/cpuinfo" ]; then
	JOBS=$(grep -c ^processor /proc/cpuinfo)
fi

[[ $PATH =~ "$PREFIX/bin" ]] || export PATH=$PREFIX/bin:$PATH
mkdir -p $PREFIX
mkdir -p $WORKSPACE/deps

# main
binutils()
{
	local NAME=binutils
	local VERSION=2.25.1
	local FULL=$NAME-$VERSION
	local COMPRESS=tar.bz2
	local TARBALL=$NAME-$VERSION.$COMPRESS
	local URI=http://mirrors.ustc.edu.cn/gnu/$NAME/$TARBALL

	if [ ! -e deps/$FULL ]; then
		echo "fetching $TARBALL..."
		curl $URI > deps/$TARBALL
		tar -xf deps/$TARBALL -C deps/
	fi

	mkdir -p deps/build-$NAME && cd deps/build-$NAME
	../$FULL/configure --prefix=$PREFIX --target=$TARGET --disable-multilib
	make -j$JOBS
	make install
	cd -
}

linux_kernel_headers()
{
	local NAME=linux
	local VERSION=3.19.3
	local FULL=$NAME-$VERSION
	local COMPRESS=tar.xz
	local TARBALL=$NAME-$VERSION.$COMPRESS
	local URI=http://mirrors.ustc.edu.cn/kernel.org/linux/kernel/v3.x/$TARBALL

	if [ ! -e deps/$FULL ]; then
		echo "fetching $TARBALL..."
		curl $URI > deps/$TARBALL
		tar -xf deps/$TARBALL -C deps/
	fi

	cd deps/$FULL
	make ARCH=$ARCH INSTALL_HDR_PATH=$PREFIX/$TARGET headers_install
	cd -
}

gcc_compilers()
{
	local NAME=gcc
	local VERSION=4.8.5
	local FULL=$NAME-$VERSION
	local COMPRESS=tar.bz2
	local TARBALL=$NAME-$VERSION.$COMPRESS
	local URI=http://mirrors.ustc.edu.cn/gnu/$NAME/$FULL/$TARBALL

	if [ ! -e deps/$FULL ]; then
		echo "fetching $TARBALL..."
		curl $URI > deps/$TARBALL
		tar -xf deps/$TARBALL -C deps/
	fi

	mkdir -p deps/build-$NAME && cd deps/build-$NAME
	../$FULL/configure --prefix=$PREFIX --target=$TARGET --enable-languages=c,c++ --disable-multilib
	make -j$JOBS all-gcc
	make install-gcc
	cd -
}

glibc_headers_and_startupfiles()
{
	local NAME=glibc
	local VERSION=2.22
	local FULL=$NAME-$VERSION
	local COMPRESS=tar.xz
	local TARBALL=$NAME-$VERSION.$COMPRESS
	local URI=http://mirrors.ustc.edu.cn/gnu/$NAME/$TARBALL

	if [ ! -e deps/$FULL ]; then
		echo "fetching $TARBALL..."
		curl $URI > deps/$TARBALL
		tar -xf deps/$TARBALL -C deps/
		ln -s $FULL deps/$NAME
	fi

	mkdir -p deps/build-$NAME && cd deps/build-$NAME
	../$FULL/configure --prefix=$PREFIX/$TARGET --build=$MACHTYPE --host=$TARGET --with-headers=$PREFIX/$TARGET/include --disable-multilib libc_cv_forced_unwind=yes
	make install-bootstrap-headers=yes install-headers
	make -j$JOBS csu/subdir_lib
	install csu/crt1.o csu/crti.o csu/crtn.o $PREFIX/$TARGET/lib
	$TARGET-gcc -nostdlib -nostartfiles -shared -x c /dev/null -o $PREFIX/$TARGET/lib/libc.so
	touch $PREFIX/$TARGET/include/gnu/stubs.h
	cd -
}

gcc_libgcc()
{
	cd deps/build-gcc
	make -j$JOBS all-target-libgcc
	make install-target-libgcc
	cd -
}

glibc()
{
	cd deps/build-glibc
	make -j$JOBS
	make install
	cd -
}

gcc()
{
	cd deps/build-gcc
	make -j$JOBS
	make install
	cd -
}

glibc_install()
{
	mkdir -p deps/build-glibc_install && cd deps/build-glibc_install
	../glibc/configure --prefix=/ --build=$MACHTYPE --host=$TARGET --with-headers=$PREFIX/$TARGET/include --disable-multilib libc_cv_forced_unwind=yes
	make -j$JOBS
	make install install_root=$PREFIX/glibc_install
	cd -
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

cd $WORKSPACE

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

cd $PWD

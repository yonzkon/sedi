#!/bin/sh

usage()
{
	echo "Usage: toolchian.sh {ARCH} {COMMAND} [PREFIX, [WORKSPACE]]"
	echo ""
	echo "  {ARCH}    arm | i686 | x86_64 | ..."
	echo "  {COMMAND} binutils"
	echo "            linux_kernel_headers"
	echo "            gcc_compilers"
	echo "            glibc_headers_and_startupfiles"
	echo "            gcc_libgcc"
	echo "            glibc"
	echo "            gcc"
	echo "            readline"
	echo "            ncurses"
	echo "            glibc_simplify"
	echo "            gdb"
	echo "  [PREFIX]  where to install the toolchain [default: /opt/cross_\$ARCH]"
	echo "  [WORKSPACE] base directory which include the source files [default: $(pwd)]"
}

# usage
[ -z "$1" ] || [ "$1" == "--help" ] && usage && exit

# environment
PWD=$(pwd)
SCRIPT_PATH=$0
SCRIPT_DIR=${SCRIPT_PATH%/*}

CFLAGS='-O2 -pipe -fomit-frame-pointer' #-fno-stack-protector
CXXFLAGS='-O2 -pipe -fomit-frame-pointer'

ARCH=$1
COMMAND=$(tr [A-Z] [a-z] <<<$2)

if [ -z "$3" ]; then
	PREFIX=/opt/cross-$ARCH
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

TARGET=$ARCH-unknown-linux-gnu
[ "$ARCH" == "arm" ] && TARGET+=eabi

case $(uname -s) in
Linux)
	JOBS=$(grep -c ^processor /proc/cpuinfo)
	;;
FreeBSD)
	JOBS=$(sysctl -n hw.ncpu)
	;;
Darwin)
	JOBS=$(sysctl -n machdep.cpu.core_count)
	ulimit -n 1024
	;;
*)
	JOBS=1
	;;
esac

# PATH & export PATH
# bash & '.' / source
[[ $PATH =~ "$PREFIX/bin" ]] || PATH=$PREFIX/bin:$PATH

# common funcs
tarball_fetch_and_extract()
{
	local URI=$1
	local TARBALL=$(sed -e 's/^.*\///g' <<<$URI)
	local FULL=$(sed -e 's/\.tar.*$//g' <<<$TARBALL)
	local NAME=$(sed -e 's/-.*$//g' <<<$FULL)

	if [ ! -e $TARBALL ]; then
		echo "fetching $TARBALL..."
		curl $URI -o $TARBALL
		if [ $? -ne 0 ]; then
			rm $TARBALL
			echo "failed to fetch $TARBALL...exit"
			exit
		fi
	fi

	if [ ! -e $FULL ]; then
		echo "extracting $TARBALL..."
		tar -xf $TARBALL
		ln -sf $FULL $NAME
	fi
}

# main
binutils()
{
	local NAME=binutils
	local URI=http://mirrors.ustc.edu.cn/gnu/$NAME/$NAME-2.27.tar.bz2

	tarball_fetch_and_extract $URI

	mkdir -p build-$NAME && cd build-$NAME
	../$NAME/configure --prefix=$PREFIX --target=$TARGET --disable-multilib
	make -j$JOBS
	make install
	mv $PREFIX/$TARGET/bin $PREFIX/$TARGET/bin-binutils
	cd -
}

linux_kernel_headers()
{
	local NAME=linux
	local URI=http://mirrors.ustc.edu.cn/kernel.org/linux/kernel/v4.x/$NAME-4.4.48.tar.xz

	tarball_fetch_and_extract $URI

	cd $NAME
	local INNER_ARCH=$ARCH
	[ "$ARCH" = i686 ] && INNER_ARCH=x86
	make ARCH=$INNER_ARCH INSTALL_HDR_PATH=$PREFIX/$TARGET headers_install
	cd -
}

gmp()
{
	local NAME=gmp
	local URI=http://mirrors.ustc.edu.cn/gnu/$NAME/$NAME-6.1.1.tar.xz

	tarball_fetch_and_extract $URI
}

mpfr()
{
	local NAME=mpfr
	local URI=http://mirrors.ustc.edu.cn/gnu/$NAME/$NAME-3.1.4.tar.xz

	tarball_fetch_and_extract $URI
}

mpc()
{
	local NAME=mpc
	local URI=http://mirrors.ustc.edu.cn/gnu/$NAME/$NAME-1.0.3.tar.gz

	tarball_fetch_and_extract $URI
}

isl()
{
	local NAME=isl
	local URI=http://isl.gforge.inria.fr/$NAME-0.14.tar.xz

	tarball_fetch_and_extract $URI
}

cloog()
{
	local NAME=cloog
	local URI=http://www.bastoul.net/cloog/pages/download/$NAME-0.18.4.tar.gz

	tarball_fetch_and_extract $URI
}

gcc_compilers()
{
	local NAME=gcc
	local URI=http://mirrors.ustc.edu.cn/gnu/$NAME/$NAME-4.9.4/$NAME-4.9.4.tar.bz2

	tarball_fetch_and_extract $URI

	# deps of gcc
	cd $NAME
	gmp
	mpfr
	mpc
	isl
	cloog
	cd -

	# build gcc
	mkdir -p build-$NAME && cd build-$NAME
	../$NAME/configure --prefix=$PREFIX --target=$TARGET --enable-languages=c,c++ --disable-multilib
	make -j$JOBS all-gcc
	make install-gcc
	cd -
}

glibc_headers_and_startupfiles()
{
	local NAME=glibc
	local URI=http://mirrors.ustc.edu.cn/gnu/$NAME/$NAME-2.24.tar.xz

	tarball_fetch_and_extract $URI

	mkdir -p build-$NAME && cd build-$NAME
	../$NAME/configure --prefix=$PREFIX/$TARGET --build=$MACHTYPE --host=$TARGET \
		--disable-multilib --with-headers=$PREFIX/$TARGET/include \
		libc_cv_forced_unwind=yes \
		libc_cv_ssp=no libc_cv_ssp_strong=no # libc_cv_ssp is to resolv __stack_chk_gurad for x86_64
	make install-bootstrap-headers=yes install-headers
	make -j$JOBS csu/subdir_lib
	install csu/crt1.o csu/crti.o csu/crtn.o $PREFIX/$TARGET/lib
	$TARGET-gcc -nostdlib -nostartfiles -shared -x c /dev/null -o $PREFIX/$TARGET/lib/libc.so
	touch $PREFIX/$TARGET/include/gnu/stubs.h
	cd -
}

gcc_libgcc()
{
	cd build-gcc
	make -j$JOBS all-target-libgcc
	make install-target-libgcc
	cd -
}

glibc()
{
	cd build-glibc
	make -j$JOBS
	make install
	cd -
}

gcc()
{
	cd build-gcc
	make -j$JOBS
	make install
	cd -
}

readline()
{
	local NAME=readline
	local URI=http://mirrors.ustc.edu.cn/gnu/$NAME/$NAME-6.3.tar.gz

	tarball_fetch_and_extract $URI

	mkdir -p build-readline && cd build-readline
	../readline/configure --prefix=$PREFIX/$TARGET --build=$MACHTYPE --host=$TARGET \
		bash_cv_wcwidth_broken=yes
	make -j$JOBS
	make install
	cd -
}

ncurses()
{
	local NAME=ncurses
	local URI=http://mirrors.ustc.edu.cn/gnu/$NAME/$NAME-6.0.tar.gz

	tarball_fetch_and_extract $URI

	mkdir -p build-ncurses && cd build-ncurses
	../ncurses/configure --prefix=$PREFIX/$TARGET --build=$MACHTYPE --host=$TARGET --with-shared
	make -j$JOBS
	make install
	cd -
}

glibc_simplify()
{
	local from=$PREFIX/$TARGET
	local to=$PREFIX/$TARGET/simplify

	# lib
	mkdir -p $to/lib
	for item in libc libm libcrypt libdl libpthread libutil libresolv libnss_dns; do
		cp -dp $from/lib/$item.* $to/lib
		cp -dp $from/lib/$item-* $to/lib
	done
	for item in ld- libreadline libncurses; do
		cp -dp $from/lib/$item* $to/lib
	done
	rm $to/lib/*.a

	# bin & sbin
	mkdir -p $to/bin $to/sbin
	cp -prd $from/bin $from/sbin $to

	# strip
	$TARGET-strip $to/lib/* $to/bin/* $to/sbin/* &>/dev/null
}

gdb()
{
	local NAME=gdb
	local URI=http://mirrors.ustc.edu.cn/gnu/$NAME/$NAME-7.10.1.tar.xz

	tarball_fetch_and_extract $URI

	mkdir -p build-gdb && cd build-gdb
	../gdb/configure --prefix=$PREFIX/$TARGET --build=$MACHTYPE --host=$TARGET
	make -j$JOBS
	make install
	cd -
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
elif [ "$COMMAND" == "readline" ]; then
	readline # 8
elif [ "$COMMAND" == "ncurses" ]; then
	ncurses # 9
elif [ "$COMMAND" == "glibc_simplify" ]; then
	glibc_simplify # 10
elif [ "$COMMAND" == "gdb" ]; then
	gdb # 11
else
	usage && exit
fi

cd $PWD

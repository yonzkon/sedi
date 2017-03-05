#!/bin/sh

usage()
{
	echo "Usage: toolchian.sh {ARCH} {COMMAND} [PREFIX, [WORKSPACE]]"
	echo ""
	echo "  {ARCH}    arm | x86 | x86_64 | ..."
	echo "  {COMMAND} binutils"
	echo "            linux_kernel_headers"
	echo "            gcc_compilers"
	echo "            glibc_headers_and_startupfiles"
	echo "            gcc_libgcc"
	echo "            glibc"
	echo "            gcc"
	echo "            host_glibc"
	echo "            host_readline"
	echo "            host_ncurses"
	echo "            host_glibc_simplify"
	echo "            host_gdb"
	echo "  [PREFIX]  where to install the toolchain [default: /opt/cross_\$ARCH]"
	echo "  [WORKSPACE] base directory which include the source files [default: $(pwd)]"
}

# usage
[ -z "$1" ] || [ "$1" == "--help" ] && usage && exit

# environment
PWD=$(pwd)
SCRIPT_PATH=$0
SCRIPT_DIR=${SCRIPT_PATH%/*}

CC=gcc
CFLAGS='-O2 -pipe -fomit-frame-pointer -fno-stack-protector'
CXX=g++
CXXFLAGS='-O2 -pipe -fomit-frame-pointer -fno-stack-protector'
#export CPLUS_INCLUDE_PATH=
#export LIBRARY_PATH=
#export C_INCLUDE_PATH=
#export LD_LIBRARY_PATH=

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

[[ $PATH =~ "$PREFIX/bin" ]] || export PATH=$PREFIX/bin:$PATH
mkdir -p $PREFIX

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
	cd -
}

linux_kernel_headers()
{
	local NAME=linux
	local URI=http://mirrors.ustc.edu.cn/kernel.org/linux/kernel/v4.x/$NAME-4.4.48.tar.xz

	tarball_fetch_and_extract $URI

	cd $NAME
	local INNER_ARCH=$ARCH
	[ "$ARCH" = x86_64 ] && INNER_ARCH=x86
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
	local URI=http://mirrors.ustc.edu.cn/gnu/$NAME/$NAME-4.8.5/$NAME-4.8.5.tar.bz2

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
	local URI=http://mirrors.ustc.edu.cn/gnu/$NAME/$NAME-2.21.tar.xz

	tarball_fetch_and_extract $URI

	mkdir -p build-$NAME && cd build-$NAME
	../$NAME/configure --prefix=$PREFIX/$TARGET --build=$MACHTYPE --host=$TARGET \
		--with-headers=$PREFIX/$TARGET/include --disable-multilib \
		libc_cv_forced_unwind=yes libc_cv_ssp=no # libc_cv_ssp is to resolv __stack_chk_gurad for x86_64
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

host_glibc()
{
	mkdir -p build-host_glibc && cd build-host_glibc
	../glibc/configure --prefix=/ --build=$MACHTYPE --host=$TARGET --with-headers=$PREFIX/$TARGET/include --disable-multilib libc_cv_forced_unwind=yes CFLAGS="$CFLAGS" CC="$CC"
	make -j$JOBS
	make install install_root=$PREFIX/host_glibc
	cd -
}

host_readline()
{
	local NAME=readline
	local URI=http://mirrors.ustc.edu.cn/gnu/$NAME/$NAME-6.3.tar.gz

	tarball_fetch_and_extract $URI

	mkdir -p build-host_readline && cd build-host_readline
	../readline/configure --prefix=$PREFIX/host_glibc --host=$TARGET
	make -j$JOBS
	make install
	cd -
}

host_ncurses()
{
	local NAME=ncurses
	local URI=http://mirrors.ustc.edu.cn/gnu/$NAME/$NAME-6.0.tar.gz

	tarball_fetch_and_extract $URI

	mkdir -p build-host_ncurses && cd build-host_ncurses
	../ncurses/configure --prefix=$PREFIX/host_glibc --host=$TARGET --with-shared
	make -j$JOBS
	make install
	cd -
}

host_glibc_simplify()
{
	local fromlib=$PREFIX/host_glibc/lib
	local tolib=$PREFIX/host_glibc/lib_simplify/
	mkdir -p $tolib
	for item in libc libm libcrypt libdl libpthread libutil libresolv libnss_dns; do
		cp -dp $fromlib/$item.* $tolib
		cp -dp $fromlib/$item-* $tolib
	done
	for item in ld libreadline libncurses; do
		cp -dp $fromlib/$item* $tolib
	done
	rm $tolib/*.a
}

host_gdb()
{
	local NAME=gdb
	local URI=http://mirrors.ustc.edu.cn/gnu/$NAME/$NAME-7.10.1.tar.xz

	tarball_fetch_and_extract $URI

	mkdir -p build-host_gdb && cd build-host_gdb
	../gdb/configure --prefix=$PREFIX/host_glibc --host=$TARGET
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
elif [ "$COMMAND" == "host_glibc" ]; then
	host_glibc # 8
elif [ "$COMMAND" == "host_readline" ]; then
	host_readline # 9
elif [ "$COMMAND" == "host_ncurses" ]; then
	host_ncurses # 10
elif [ "$COMMAND" == "host_glibc_simplify" ]; then
	host_glibc_simplify # 11
elif [ "$COMMAND" == "host_gdb" ]; then
	host_gdb # 12
else
	usage && exit
fi

cd $PWD

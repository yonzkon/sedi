# Maintainer: Anatol Pomozov <anatol.pomozov@gmail.com>

_target=arm-none-eabi
pkgname=$_target-newlib
pkgver=4.2.0.20211231
pkgrel=1
_upstream_ver=$pkgver
pkgdesc='A C standard library implementation intended for use on embedded systems (ARM bare metal)'
arch=(any)
url='https://www.sourceware.org/newlib/'
license=(BSD)
makedepends=($_target-gcc)
options=(!emptydirs !strip)
source=(https://sourceware.org/pub/newlib/newlib-$_upstream_ver.tar.gz)
sha256sums=('c3a0e8b63bc3bef1aeee4ca3906b53b3b86c8d139867607369cb2915ffc54435')

srcdir=$(pwd)
pkgdir=$(pwd)/pkg
mkdir -p $pkgdir

build() {
  rm -rf build-{newlib,nano}
  mkdir build-{newlib,nano}

  export CFLAGS_FOR_TARGET='-g -O2 -ffunction-sections -fdata-sections'
  cd "$srcdir"/build-newlib
  ../configure \
    --target=$_target \
    --prefix=/usr \
    --enable-newlib-io-long-long \
    --enable-newlib-io-c99-formats \
    --enable-newlib-register-fini \
    --enable-newlib-retargetable-locking \
    --disable-newlib-supplied-syscalls \
    --disable-nls
  make

  export CFLAGS_FOR_TARGET='-g -Os -ffunction-sections -fdata-sections'
  cd "$srcdir"/build-nano
  ../configure \
    --target=$_target \
    --prefix=/usr \
    --disable-newlib-supplied-syscalls \
    --enable-newlib-reent-small \
    --enable-newlib-retargetable-locking \
    --disable-newlib-fvwrite-in-streamio \
    --disable-newlib-fseek-optimization \
    --disable-newlib-wide-orient \
    --enable-newlib-nano-malloc \
    --disable-newlib-unbuf-stream-opt \
    --enable-lite-exit \
    --enable-newlib-global-atexit \
    --enable-newlib-nano-formatted-io \
    --disable-nls
  make
}

package() {
  cd "$srcdir"/build-nano
  make DESTDIR="$pkgdir" install -j1
  find "$pkgdir" -regex ".*/lib\(c\|g\|rdimon\)\.a" -exec rename .a _nano.a '{}' \;
  install -d "$pkgdir"/usr/$_target/include/newlib-nano
  install -m644 -t "$pkgdir"/usr/$_target/include/newlib-nano "$pkgdir"/usr/$_target/include/newlib.h

  cd "$srcdir"/build-newlib
  make DESTDIR="$pkgdir" install -j1

  find "$pkgdir"/usr/$_target/lib \( -name "*.a" -or -name "*.o" \) -exec $_target-objcopy -R .comment -R .note -R .debug_info -R .debug_aranges -R .debug_pubnames -R .debug_pubtypes -R .debug_abbrev -R .debug_line -R .debug_str -R .debug_ranges -R .debug_loc '{}' \;

  install -d "$pkgdir"/usr/share/licenses/$pkgname/
  install -m644 -t "$pkgdir"/usr/share/licenses/$pkgname/ "$srcdir"/COPYING*
}

package

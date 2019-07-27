#!/bin/sh

pacman -S git
git clone https://github.com/yonzkon/mss.git .git
ln -sf .mss/etc/.vimrc .
ln -sf .mss/etc/.vim .
ln -sf .mss/etc/.user-config .
ln -sf .mss/etc/.tmux.conf .
ln -sf .mss/etc/.gitconfig .
ln -sf .mss/etc/.gitignore .
ln -sf .mss/etc/.bash_profile .
ln -sf .mss/etc/.bash_profile .bashrc

pacman -S mingw-w64-i686-gcc
pacman -S mingw-w64-i686-gdb
pacman -S mingw-w64-i686-cmake
pacman -S mingw-w64-i686-make
pacman -S mingw-w64-i686-libtool
pacman -S mingw-w64-i686-zeromq
pacman -S mingw-w64-i686-dlfcn
pacman -S mingw-w64-i686-cmocka
pacman -S mingw-w64-i686-gtest
pacman -S mingw-w64-i686-nlohmann_json
alias make=mingw32-make

git clone https://github.com/deerlets/zebra.git
mkdir -p zebra/build/
cd zebra/build/
cmake .. -DBUILD_TESTS=on -DBUILD_DEBUG=on -DSPDNET_BUILD=on -DCMAKE_INSTALL_PREFIX=/mingw32  -G"Unix Makefiles" -DCMAKE_MAKE_PROGRAM=mingw32-make
cd -

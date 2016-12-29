#!/bin/sh

INCLUDE_PATH=/opt/local/include

sudo port install libelf
sudo curl https://opensource.apple.com/source/dtrace/dtrace-209/sys/elftypes.h -o $INCLUDE_PATH/elftypes.h
sudo curl https://opensource.apple.com/source/dtrace/dtrace-209/sys/elf.h -o $INCLUDE_PATH/elf.h
sudo cat elf_relocs.h >> $INCLUDE_PATH/elf.h

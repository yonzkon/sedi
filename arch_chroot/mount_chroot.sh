#!/bin/sh

mount -t proc proc proc
mount --rbind /dev dev
mount --rbind /sys sys
mount --make-slave dev
mount --make-slave sys
mount --rbind /tmp tmp
mount --make-slave tmp
mount -t tmpfs tmpfs var/cache # for arch's pacman
mount -t tmpfs tmpfs var/tmp   # for gentoo's emerge

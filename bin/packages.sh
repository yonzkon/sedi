#!/bin/bash

if [ -z "$2" ]; then
    usage && exit -1
fi

MANAGER=$(tr [A-Z] [a-z] <<<$1)
COMMAND=$(tr [A-Z] [a-z] <<<$2)
DESKTOP=cinnamon
[ -n "$3" ] && DESKTOP=$(tr [A-Z] [a-z] <<<$3)

case $MANAGER in
pacman)
    UPDATE="-Syu"
    INSTALL="-S --needed"
    ;;
yum)
    UPDATE="update -yx'kernel*'"
    INSTALL="install -y"
    ;;
*)
    usage && exit -1
    ;;
esac

usage()
{
    echo "Usage: {package.sh \$MANAGER \$COMMAND}"
    echo "Usage: \$MANAGER {pacman | yum}"
    echo "Usage: \$COMMAND {base | xorg}"
}

install_base()
{
    $MANAGER $UPDATE
    $MANAGER $INSTALL grub #efibootmgr
    $MANAGER $INSTALL lshw pciutils usbutils alsa-utils iputils net-tools iw wpa_supplicant
    $MANAGER $INSTALL vim git bash zsh sudo
    $MANAGER $INSTALL nmap tcpdump iptables iproute2 #netcat traceroute dnsutils
    $MANAGER $INSTALL openssh ntp
    $MANAGER $INSTALL gcc gdb make minicom
    #$MANAGER $INSTALL base-devel #autoconf automake bison fakeroot flex m4 pkg-config
    if [ "$MANAGER" = "pacman" ]; then
        $MANAGER $INSTALL linux-headers
    fi
}

install_xorg()
{
    if [ "$MANAGER" = "pacman" ]; then
        $MANAGER $INSTALL xorg-server xorg-xinit wqy-zenhei ttf-dejavu
        $MANAGER $INSTALL $DESKTOP
        $MANAGER $INSTALL emacs lilyterm wireshark-gtk qemu qemu-arch-extra
        $MANAGER $INSTALL fcitx fcitx-configtool fcitx-sunpinyin fcitx-gtk2 fcitx-gtk3 fcitx-qt5
        $MANAGER $INSTALL chromium evince mpv
    elif [ "$MANAGER" = "yum" ]; then
        $MANAGER -y groupinstall "X Window System"
        $MANAGER -y install wqy-zenhei-fonts
        $MANAGER -y -xNetworkManager* groupinstall gnome
        $MANAGER -y --enablerepo=RPMForge install ibus-pinyin evince firefox flash-plugin
    fi
}

# main
case $COMMAND in
base) install_base;;
xorg) install_xorg;;
*) usage && exit 1;;
esac

exit 0

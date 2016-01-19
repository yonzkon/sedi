#!/bin/bash

    # I) - Usage & Variable
usage()
{
    echo "Usage: {package.sh \$COMMAND \$MANAGER}"
    echo "Usage: \$COMMAND {base | devel | xorg}"
    echo "Usage: \$MANAGER {pacman | yum}"
}

if [ -z "$1" ]; then
    usage && exit -1
else
    COMMAND=$(tr [A-Z] [a-z] <<<$1);
    if [ -z "$2" ]; then
        MANAGER=pacman;
    else
        MANAGER=$(tr [A-Z] [a-z] <<<$2);
    fi
fi

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

    # II) - install packages
case $COMMAND in
base)
        # 0) - archlinux
    if [ "$MANAGER" = "pacman" ]; then
        $MANAGER $UPDATE
        $MANAGER $INSTALL grub #efibootmgr
        $MANAGER $INSTALL vim bash zsh pciutils usbutils iputils net-tools wpa_supplicant
        $MANAGER $INSTALL iptables iproute2 tcpdump nmap #netcat traceroute dnsutils
        $MANAGER $INSTALL openssh ntp
        # 1) - CentOS & Fedora
    elif [ "$MANAGER" = "yum" ]; then
        $MANAGER $UPDATE
        $MANAGER $INSTALL grub pciutils usbutils file openssl bc tree lvm2 ntp unzip
        $MANAGER $INSTALL vim ctags grep sed gawk diffutils patch
        $MANAGER $INSTALL net-tools wpa_supplicant tcpdump nmap netcat traceroute
    fi
    ;;
devel)
        # 0) - archlinux
    if [ "$MANAGER" = "pacman" ]; then
        $MANAGER $INSTALL linux-headers ctags make clang boost gcc gdb cgdb minicom perl python2
        $MANAGER $INSTALL git maven mariadb
        # 1) - CentOS & Fedora
    elif [ "$MANAGER" = "yum" ]; then
        $MANAGER $INSTALL make gcc gdb bison flex dialog minicom perl python2
        $MANAGER $INSTALL kernel-devel ncurses-devel bind-utils
    fi
    ;;
xorg)
        # 0) - archlinux
    if [ "$MANAGER" = "pacman" ]; then
        $MANAGER $INSTALL xorg-server xorg-xinit wqy-zenhei ttf-dejavu #xf86-video-intel xf86-video-nouveau
        $MANAGER $INSTALL cinnamon gvim lilyterm gnome-terminal gnome-mplayer mplayer #alsa-utils smplayer
        $MANAGER $INSTALL ibus-pinyin evince firefox flashplugin libvdpau
        #$MANAGER $INSTALL virtualbox wireshark-gtk eclipse-java netbeans
        # 1) - CentOS & Fedora
    elif [ "$MANAGER" = "yum" ]; then
        $MANAGER -y groupinstall "X Window System"
        $MANAGER -y install wqy-zenhei-fonts
        $MANAGER -y -xNetworkManager* groupinstall gnome
        $MANAGER -y --enablerepo=RPMForge install ibus-pinyin evince firefox flash-plugin
    fi
    ;;
*)
    usage && exit -1
    ;;
esac

exit 0

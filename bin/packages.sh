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
    echo "Usage: \$COMMAND {base | xorg | spider}"
}

install_base()
{
    $MANAGER $UPDATE
    # bootloader
    $MANAGER $INSTALL grub efibootmgr
    # utils
    $MANAGER $INSTALL binutils tree lshw pciutils usbutils alsa-utils
    # develop
    $MANAGER $INSTALL vim git bash zsh sudo tmux xclip
    $MANAGER $INSTALL base-devel autoconf automake bison fakeroot flex m4 pkg-config
    $MANAGER $INSTALL gcc gdb make cmake minicom lsof ltrace strace valgrind
    # performance
    $MANAGER $INSTALL procps-ng sysstat dstat iotop htop sysdig #vmstat mpstat pidstat sadf sar
    # network
    $MANAGER $INSTALL net-tools iputils iptables iproute2 # netcat ss
    $MANAGER $INSTALL nmap tcpdump traceroute dnsutils #iw wpa_supplicant
    # services
    $MANAGER $INSTALL openssh ntp openvpn shadowsocks-libev
    # something else
    if [ "$MANAGER" = "pacman" ]; then
        $MANAGER $INSTALL linux-headers archlinux-keyring
    fi
}

install_xorg()
{
    if [ "$MANAGER" = "pacman" ]; then
        $MANAGER $INSTALL xorg-server xorg-xinit wqy-zenhei ttf-dejavu
        $MANAGER $INSTALL $DESKTOP lightdm mesa-utils
        $MANAGER $INSTALL gnome-terminal terminator emacs global synapse chromium
        $MANAGER $INSTALL fcitx fcitx-configtool fcitx-sunpinyin fcitx-gtk2 fcitx-gtk3 fcitx-qt5
        $MANAGER $INSTALL wireshark-qt qemu qemu-arch-extra
        $MANAGER $INSTALL evince mpv
        $MANAGER $INSTALL remmina libvncserver freerdp spice-gtk x2goserver x2goclient
    elif [ "$MANAGER" = "yum" ]; then
        $MANAGER -y groupinstall "X Window System"
        $MANAGER -y install wqy-zenhei-fonts
        $MANAGER -y -xNetworkManager* groupinstall gnome
        $MANAGER -y --enablerepo=RPMForge install ibus-pinyin evince firefox flash-plugin
    fi
}

install_spider()
{
        $MANAGER $INSTALL nlohmann-json cmocka spdlog
        $MANAGER $INSTALL zeromq libwebsockets
        $MANAGER $INSTALL npm
}

# main
case $COMMAND in
base) install_base;;
xorg) install_xorg;;
spider) install_spider;;
*) usage && exit 1;;
esac

exit 0

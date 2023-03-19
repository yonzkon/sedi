#!/bin/bash

if [ -z "$2" ]; then
    usage && exit -1
fi

MANAGER=$(tr [A-Z] [a-z] <<<$1)
COMMAND=$(tr [A-Z] [a-z] <<<$2)
DESKTOP=xfce4
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
    $MANAGER $INSTALL binutils tree lshw pciutils usbutils alsa-utils f2fs-tools
    # develop
    $MANAGER $INSTALL vim git bash zsh sudo tmux xsel
    $MANAGER $INSTALL man-db man-pages
    $MANAGER $INSTALL base-devel autoconf automake bison fakeroot flex m4 pkg-config bc
    $MANAGER $INSTALL gcc clang gdb make cmake minicom lsof ltrace strace valgrind
    $MANAGER $INSTALL rustup go ruby
    #$MANAGER $INSTALL cmocka gtest spdlog nlohmann-json libyaml yaml-cpp
    # performance
    $MANAGER $INSTALL procps-ng sysstat dstat iotop htop sysdig
                    # vmstat mpstat pidstat sadf sar
    # network
    $MANAGER $INSTALL net-tools iproute2
    $MANAGER $INSTALL iptables
    $MANAGER $INSTALL nmap netcat tcpdump traceroute
    $MANAGER $INSTALL iputils inetutils dnsutils whois
                    # bind ss iw wpa_supplicant
    # services
    $MANAGER $INSTALL openssh dhcpcd ntp
    $MANAGER $INSTALL openvpn shadowsocks-libev
    # exploit
    $MANAGER $INSTALL metasploit exploitdb john nikto
                    # seclists wordlists
                    # gobuster dirb feroxbuster
                    # hash-identifier
    # something else
    if [ "$MANAGER" = "pacman" ]; then
        $MANAGER $INSTALL linux-headers archlinux-keyring
    fi
}

install_xorg()
{
    if [ "$MANAGER" = "pacman" ]; then
        # Xorg
        $MANAGER $INSTALL xorg-server xorg-xinit
        # Font
        $MANAGER $INSTALL wqy-zenhei ttf-dejavu adobe-source-code-pro-fonts
        # Desktop
        $MANAGER $INSTALL $DESKTOP mesa-utils # lightdm
        # Input chinese
        $MANAGER $INSTALL fcitx fcitx-configtool fcitx-googlepinyin fcitx-gtk2 fcitx-gtk3 fcitx-qt5
        # Base GUI apps
        $MANAGER $INSTALL terminator emacs global synapse chromium # google-chrome
        # Extra GUI apps
        $MANAGER $INSTALL evince flameshot mpv
        # Other GUI apps
        $MANAGER $INSTALL wireshark-qt
        #$MANAGER $INSTALL qemu qemu-arch-extra
        #$MANAGER $INSTALL remmina libvncserver freerdp spice-gtk x2goserver x2goclient
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

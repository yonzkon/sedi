#!/bin/bash
# Shell Script:    packages
# Auther & Email:  myk <xccmu@hotmail.com>
# Since From:      2013/11/20
# Last Change:     2014/6/12
# Version:         0.6
#   

    # I) - Set environment
export PATH=/sbin/:/bin/:/usr/sbin/:/usr/bin/:/usr/local/sbin/:/usr/local/bin/
export LANG=C

    # II) - Usage & Variable
usage()
{
    echo "Usage: {package.sh \$MANAGER \$COMMAND}"
    echo "Usage: \$MANAGER {pacstrap | pacman | yum}"
    echo "Usage: \$COMMAND {base | server_base | server_lapp | server_lamp | xorg}"
}

if test "$1" = "" || test "$2" = ""; then
    usage && exit -1
else
    MANAGER=$(tr [A-Z] [a-z] <<<"$1");
    COMMAND=$(tr [A-Z] [a-z] <<<"$2");
fi

case "$MANAGER" in
pacstrap)
    DISTRIBUTION="archlinux";
    UPDATE=""
    INSTALL="-i /mnt"
    ;;
pacman)
    DISTRIBUTION="archlinux";
    UPDATE="-Syu"
    INSTALL="-S"
    ;;
yum)
    DISTRIBUTION="CentOS";
    UPDATE="update -yx'kernel*'"
    INSTALL="install -y"
    ;;
*)
    usage && exit -1
    ;;
esac

    # III) - install packages
case "$COMMAND" in
base)
        # 0) - system setup
    #test -e /etc/localtime && rm -f /etc/localtime
    #ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
    #sed -i 's/^[^#].*$//g' /etc/locale.gen; echo "en_US.UTF-8 UTF-8" >>/etc/locale.gen && locale-gen
    #echo "LANG=en_US.UTF-8" >/etc/locale.conf
    #echo "${DISTRIBUTION}.mu" >/etc/hostname
    #echo "nameserver 114.114.114.114" >/etc/resolv.conf
        # 1) - archlinux
    if test "$MANAGER" = "pacstrap"; then
        $MANAGER $INSTALL filesystem
        $MANAGER $INSTALL acl attr pam shadow
        $MANAGER $INSTALL bash procps which sudo vi vim ctags clang cmake #grep sed gawk
        $MANAGER $INSTALL db man man-pages
        $MANAGER $INSTALL gcc make tar gzip bzip2 xz openssl bc #perl
        $MANAGER $INSTALL pacman 
    elif test "$MANAGER" = "pacman"; then
        $MANAGER $UPDATE
        $MANAGER $INSTALL pciutils usbutils diffutils patch iputils net-tools wpa_supplicant iptables iproute2
        $MANAGER $INSTALL systemd systemd-sysvcompat
        $MANAGER $INSTALL linux #linux-lts
        $MANAGER $INSTALL grub efibootmgr

        $MANAGER $INSTALL openssh dhcpcd ntp svn git postgresql mysql
        $MANAGER $INSTALL tcpdump nmap netcat traceroute dnsutils
        $MANAGER $INSTALL gdb bison flex dialog fakeroot minicom linux-headers #linux-lts-headers
        $MANAGER $INSTALL alsa-utils mplayer
        #$MANAGER -S linux-headers fakeroot dnsutils
    elif test "$MANAGER" = "yum"; then
        $MANAGER $UPDATE
        $MANAGER $INSTALL man grub file openssl bc tree pciutils usbutils ntfs-3g lvm2 sudo ntp unzip
        $MANAGER $INSTALL vim ctags grep sed gawk diffutils patch
        $MANAGER $INSTALL tcpdump nmap netcat traceroute net-tools wpa_supplicant
        $MANAGER $INSTALL make gcc gdb perl bison flex dialog minicom postgresql-libs
        $MANAGER $INSTALL kernel-devel ncurses-devel bind-utils
    fi
    ;;
server_base)
    $MANAGER $INSTALL openssh postgresql mysql svn git dhcp dhcpcd
        # server's service: openssh postgresql mysql svn(svnserve,svnserve,svnserve.conf,passwd,authz) git dhcp dhcpcd rpcbind(rpcbind,rpc-mountd) nfs-utils(nfsd,exports) hostadp
    if test "$MANAGER" = "pacman"; then
        systemctl start mysqld
    elif test "$MANAGER" = "yum"; then
        service mysql start
    fi
    mysql -hlocalhost -uroot mysql <<<"DELETE FROM user WHERE host != 'localhost' OR user = ''"
    mysql -hlocalhost -uroot mysql <<<"CREATE USER mu@localhost IDENTIFIED BY 'mu8291936'"
    mysql -hlocalhost -uroot mysql <<<"GRANT ALL ON *.* TO mu@localhost IDENTIFIED BY 'mu8291936'"
    mysql -hlocalhost -uroot mysql <<<"UPDATE user SET password = PASSWORD('mu8291936') WHERE user = 'root'"
    ;;
server_lamp)
        # 1) - archlinux
    if test "$MANAGER" = "pacman"; then
        $MANAGER $INSTALL php php-pgsql php-apache
        sed -i 's/;extension=pgsql.so/extension=pgsql.so/g' /etc/php/php.ini
        sed -i 's/;extension=mysql.so/extension=mysql.so/g' /etc/php/php.ini
        $MANAGER $INSTALL apache
        echo "LoadModule php5_module modules/libphp5.so" >>/etc/httpd/conf/httpd.conf
        echo "Include conf/extra/php5_module.conf" >>/etc/httpd/conf/httpd.conf
        echo "application/x-httpd-php php php5" >>/etc/httpd/conf/mime.types
    fi
        # 2) - CentOS
    ;;
xorg)
        # 1) - archlinux
    if test "$MANAGER" = "pacman"; then
        $MANAGER $INSTALL xorg-server xorg-xinit ttf-dejavu wqy-zenhei xf86-video-intel #xf86-video-nouveau
        $MANAGER $INSTALL cinnamon gnome-terminal
        $MANAGER $INSTALL ibus-pinyin evince firefox flashplugin
        #$MANAGER $INSTALL virtualbox
        # 2) - CentOS
    elif test "$MANAGER" = "yum"; then
        $MANAGER -y groupinstall "X Window System"
        $MANAGER -y install wqy-zenhei-fonts
        $MANAGER -y -xNetworkManager* groupinstall gnome-desktop3
        $MANAGER -y --enablerepo=RPMForge install ibus-pinyin evince firefox flash-plugin
   fi
    ;;
*)
    usage && exit -1
    ;;
esac

exit 0

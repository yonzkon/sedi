#!/bin/bash
# Shell Script:    history
# Auther & Email:  myk <xccmu@hotmail.com>
# Since From:      2014/2/9
# Last Change:     2014/2/9
# Version:         0.1
#   

    # I) - Set environment
export PATH=/sbin/:/bin/:/usr/sbin/:/usr/bin/:/usr/local/sbin/:/usr/local/bin/
export LANG=C

    # II) - echo historys
echo "\
# 1) - system
    useradd -umu -gmu -Gmu,wheel -Md/home/mu mu
    useradd -uguest -gmu -Gmu -md/home/guest guest
    grub-install --boot-directory=/home/linux/boot/ /dev/sda
    grub-install --target=x86_64-efi --efi-direcotry=/boot
    fdisk -l
    ln -s/home/linux/etc/.bash_profile .
    lvcreate -sl320 -nlvsslinux /dev/mapper/vglinux-lvlinux
    lvremove /dev/mapper/vglinux-lvsslinux\
    pacman -Syu
    pacman -Ss php |grep -A2 -B2 -ie'gre'
    pacman -Sc
    pacman -U broadcom-wl-6.30.223.141-3-x86_64.pkg.tar.xz 
    pacman -U uuid-1.6.2-11-x86_64.pkg.tar.xz 
    pacman -U postgresql-uuid-ossp-9.3.1-1-x86_64.pkg.tar.xz 
    makepkg
    tar -cjpv --exclude={linux/boot/*,linux/kernel_distribution/*} -f - linux/ |openssl des3 -salt -k 'sar' -out /home/backup/linux-$(date +%Y_%m_%d).tar.bz2
    openssl des3 -k sar -d -salt -in linux-2014_01_29.tar.bz2 |tar -xjvf -
    ntpdate time.windows.com
    ntpdate asia.pool.ntp.org
    nohup ./start &>/dev/null &
    nohup ./start 1>/dev/null 2>&1
# 2) - edit
    iconv -fgb2312 -tutf8 quintessence
    ctags -R --languages=c++ --c++-kinds=+px --fields=+aiKSz --extra=+q
    ctags -R --languages=c++ --langmap=c++:+.inl -h +.inl --c++-kinds=+px --fields=+aiKSz --extra=+q --exclude=lex.yy.cc --exclude=copy_lex.yy.cc
# 3) - network
    wpa_supplicant -Bi$1 -c/etc/wpa_supplicant/wpa_supplicant.conf
    ip address add 10.0.0.12/20 broadcast + dev $1
    ip link set $1 up
    ip route add default via 10.0.15.254 dev $1
    ifconfig eth0 192.168.1.12/24 up
    route add default gw 10.0.15.254
    route add -net 192.168.0.0/16 gw 10.0.15.254
    route add -net 172.16.0.0/12 gw 10.0.15.254
    route add -net 10.0.0.0/8 gw 10.0.15.254
    netstat -pnlt
    nmap -sP 10.10.10.0/20
    tcpdump -niwlp4s0 -X 'tcp port 21 and src host 192.168.1.24 and dst net 192.168'
# 4) - programming
    aclocal
    autoconf
    autoheader
    libtoolize --automake
    automake -a
    mkdir build && cd build && ../configure && make
    ./configure --enable-packver=20130807 --disable-renewal
# 5) - server_postgresql
    su -l postgres -c 'initdb --locale=utf8 -Eutf8 -D /var/lib/postgres/data/'
    sed -ie \"s/^#listen_addresses.*/listen_addresses = \'\*\'/g\" /var/lib/postgres/data/postgresql.conf
    sed -ie 's/127\.0\.0\.1\/32/10\.0\.0\.0\/8/g' /var/lib/postgres/data/pg_hba.conf
    systemctl enable postgres && systemctl start postgres
    psql -Upostgres -dpostgres #\? #\h #CREATE ROLE mu LOGIN CREATEDB PASSWORD = 'mu8291936';
    makepkg(uuid, postgresql-uuid-ossp) #CREATE EXTENSION "uuid-ossp";
# 6) - server_svnserve
    sed -ie 's/^SVNSERVE_ARGS=.*/SVNSERVE_ARGS=\"-r \/var\/lib\/svn\"/g' /etc/conf.d/svnserve
    svnadmin create /home/mu/svn/musar_server
    svn import /home/mu/src/musar_server/ svn://orimu.vicp.cc/musar_server/ --message 'Initialize 0.1'
    svn import /home/mu/src/musar_server/ file:///home/mu/svn/musar_server/ --message 'Initialize 0.1'
    svn checkout svn://orimu.vicp.cc/musar_server /home/mu/src/musar_server
    systemctl enable svnserve
    svnserve -dr/home/mu/svn
# 7) - server_nfsd
    systemctl enable rpcbind && systemctl start rpcbind
    systemctl enable rpc-mountd && systemctl start rpc-mountd
    systemctl enable nfsd && systemctl start nfsd
    echo '/home           10.0.0.0/8(rw,no_root_squash,subtree_check)' >> /etc/exports
    exportfs -r
    showmount -e localhost
    mount -tnfs localhost:/home /mnt
# 8) - server_hostapd
    cp /home/linux/etc/hostapd.conf /etc/hostapd/
    systemctl start hostapd
# 9) - server_dhcpd
    cp /home/linux/etc/dhcpd.conf /etc/
    systemctl start dhcpd4

    mysql -umu -p pg
"

exit 0

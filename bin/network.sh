#!/bin/bash
# Shell Script:    network
# Auther & Email:  myk <xccmu@hotmail.com>
# Since From:      2013/11/16
# Last Change:     2014/7/29
# Version:         0.4
#   

    # I) - Set environment
export PATH=/sbin/:/bin/:/usr/sbin/:/usr/bin/:/usr/local/sbin/:/usr/local/bin/
export LANG=C

    # II) - Usage & Variable
usage() {
    echo "Usage: {network.sh \$COMMAND ...}"
    echo "Usage: {network.sh \$client \$ADDR \$ROUTE \$DEV}"
    echo "Usage: {network.sh \$subnet \$SUBNET_NET \$SUBNET_ADDR \$SUBNET_DEV \$INTERNET_DEV}"
    echo "Usage: {network.sh \$bridge \$NAME \$DEV0...}"
    echo "Usage: \$COMMAND {client | subnet | bridge}"
    echo "Usage: \$ADDR {192.168.0.12/24}"
    echo "Usage: \$ROUTE {192.168.0.1}"
    echo "Usage: \$DEV {eth0... | wlan0...}"
    echo "Usage: \$NET {10.12.96.0/20}"
}

if test "$#" -lt "3"; then
    usage && exit -1
else
    MODE=$(tr [A-Z] [a-z] <<<"$1")
fi

    # III) - configure network
case "$MODE" in
client)
    #if test -z "$(ps -el |grep -iewpa)"; then
    #    echo "wpa_supplicant is ready!"
    #else
    #    echo echo "wpa_supplicant is running! kill it and try again..." & exit -1
    #fi
    ADDR="$2"
    ROUTE="$3"
    DEV="$4"
    #wpa_supplicant -BDnl80211,wext -i$DEV -c/etc/wpa_supplicant/wpa_supplicant.conf
    ip addr add $ADDR broadcast + dev $DEV
    ip link set dev $DEV up
    ip route add default via $ROUTE dev $DEV
;;
subnet)
    SUBNET_NET="$2"
    SUBNET_ADDR="$3"
    SUBNET_DEV="$4"
    INTERNET_DEV="$5"
    ip addr add $SUBNET_ADDR broadcast + dev $SUBNET_DEV
    ip link set dev $SUBNET_DEV up
    iptables -tnat -APOSTROUTING -s$SUBNET_NET -o$INTERNET_DEV -jMASQUERADE
    echo "1" >/proc/sys/net/ipv4/ip_forward
    #systemctl restart iptables
    #/home/munie/bin/iptables.sh filter $SUBNET_DEV $SUBNET_NET $INTERNET_DEV
    #/home/munie/bin/iptables.sh nat $SUBNET_DEV $SUBNET_NET $INTERNET_DEV
    #systemctl restart dhcpd4
;;
bridge)
    NAME="$2"
    brctl addbr $NAME
    while test -n "$3"; do
        #ifconfig $3 0.0.0.0 up
        brctl addif $NAME $3
        shift
    done
;;
*)
    usage && exit -1
;;
esac

exit 0

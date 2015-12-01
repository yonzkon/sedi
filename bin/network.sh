#!/bin/bash

    # I) - Usage & Variable
usage() {
    echo "Usage: {network.sh \$COMMAND ...}"
    echo "Usage: {network.sh \$wifi \$ADDR \$GATE \$CARD \$SSID \$PASS}"
    echo "Usage: {network.sh \$subnet \$ADDR \$NET \$CARD \$CARD_INTERNET}"
    echo "Usage: {network.sh \$bridge \$NAME \$DEV0...}"
    echo "Usage: \$COMMAND {wifi | subnet | bridge}"
    echo "Usage: \$ADDR {192.168.0.12/24}"
    echo "Usage: \$GATE {192.168.0.1}"
    echo "Usage: \$CARD {eth0 | wlan0}"
    echo "Usage: \$NET {10.12.96.0/20}"
}

if test $# -lt 3; then
    usage && exit -1
else
    COMMAND=$(tr [A-Z] [a-z] <<<$1)
fi

    # II) - configure network
    [ "$(id -u)" != 0 ] && echo "only root can execute this script..." && exit -1
case $COMMAND in
wifi)
    if test -n "$(ps -el |grep -iewpa)"; then
        echo echo "wpa_supplicant is running! kill it and try again..." & exit -1
    fi
    ADDR=$2
    GATE=$3
    CARD=$4
    SSID=$5
    PASS=$6
    CONF=/tmp/wpa_${CARD}.conf
    ip addr add  dev $CARD $ADDR broadcast +
    ip link set dev $CARD up
    ip route add default via $GATE
    wpa_passphrase $SSID $PASS > $CONF
    wpa_supplicant -BDwext -i$CARD -c$CONF
    #wpa_supplicant -B -i$CARD -c$CONF
    rm $CONF
;;
subnet)
    ADDR=$2
    NET=$3
    CARD=$4
    CARD_INTERNET=$5
    ip addr add $ADDR broadcast + dev $CARD
    ip link set dev $CARD up
    iptables -tnat -APOSTROUTING -s$NET -o$CARD_INTERNET -jMASQUERADE
    echo "1" >/proc/sys/net/ipv4/ip_forward
    #systemctl restart iptables
    #/home/munie/bin/iptables.sh filter $CARD $NET $CARD_INTERNET
    #/home/munie/bin/iptables.sh nat $CARD $NET $CARD_INTERNET
    #systemctl restart dhcpd4
;;
bridge)
    NAME=$2
    brctl addbr $NAME
    while [ -n "$3" ]; do
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
